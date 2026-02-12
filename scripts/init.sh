#!/usr/bin/env bash
set -euo pipefail

# ============================================
# init.sh — Projeyi sıfırdan ayağa kaldırır
# ============================================
# Kullanım: bash scripts/init.sh [proje-dizini]
# Varsayılan: bulunduğun dizin (.)

PROJECT_DIR="${1:-.}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATES_DIR="$(cd "$SCRIPT_DIR/../templates" && pwd)"

echo "==> Proje dizini: $PROJECT_DIR"

# --- 1. Template dosyaları kopyala (mevcut olanları ezme) ---
copy_if_missing() {
  local src="$1"
  local dest="$2"
  if [ -f "$dest" ]; then
    echo "    [SKIP] $dest zaten mevcut"
  else
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
    echo "    [COPY] $src -> $dest"
  fi
}

echo "==> Template dosyalar kopyalanıyor..."
copy_if_missing "$TEMPLATES_DIR/docker-compose.yml" "$PROJECT_DIR/docker-compose.yml"
copy_if_missing "$TEMPLATES_DIR/.env.example"       "$PROJECT_DIR/.env.example"
copy_if_missing "$TEMPLATES_DIR/biome.json"         "$PROJECT_DIR/biome.json"
copy_if_missing "$TEMPLATES_DIR/tsconfig.json"      "$PROJECT_DIR/tsconfig.json"
copy_if_missing "$TEMPLATES_DIR/drizzle/schema.ts"  "$PROJECT_DIR/drizzle/schema.ts"
copy_if_missing "$TEMPLATES_DIR/drizzle/seed.ts"    "$PROJECT_DIR/drizzle/seed.ts"
copy_if_missing "$TEMPLATES_DIR/drizzle.config.ts"  "$PROJECT_DIR/drizzle.config.ts"

# --- 2. .env dosyası oluştur (.env.example'dan) ---
if [ ! -f "$PROJECT_DIR/.env" ]; then
  cp "$PROJECT_DIR/.env.example" "$PROJECT_DIR/.env"
  echo "==> .env dosyası .env.example'dan oluşturuldu"
  echo "    [!] .env içindeki değerleri güncelleyin!"
else
  echo "==> .env zaten mevcut, atlanıyor"
fi

# --- 3. Bağımlılıkları kur ---
if [ -f "$PROJECT_DIR/package.json" ]; then
  echo "==> Bağımlılıklar kuruluyor (bun install)..."
  cd "$PROJECT_DIR" && bun install
else
  echo "==> [SKIP] package.json bulunamadı, bun install atlanıyor"
fi

# --- 4. PostgreSQL container'ı başlat ---
echo "==> PostgreSQL container başlatılıyor..."
cd "$PROJECT_DIR" && docker compose up -d

echo "==> Healthcheck bekleniyor..."
timeout=30
elapsed=0
until docker compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; do
  sleep 1
  elapsed=$((elapsed + 1))
  if [ "$elapsed" -ge "$timeout" ]; then
    echo "    [HATA] PostgreSQL $timeout saniyede hazır olmadı!"
    exit 1
  fi
done
echo "    PostgreSQL hazır (${elapsed}s)"

# --- 5. Drizzle schema push ---
if [ -f "$PROJECT_DIR/drizzle/schema.ts" ]; then
  echo "==> Drizzle schema push çalıştırılıyor..."
  cd "$PROJECT_DIR" && bunx drizzle-kit push
else
  echo "==> [SKIP] drizzle/schema.ts bulunamadı"
fi

echo ""
echo "============================================"
echo "  Proje hazır!"
echo "  bun dev ile geliştirmeye başlayabilirsiniz."
echo "============================================"
