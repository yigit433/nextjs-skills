#!/usr/bin/env bash
set -euo pipefail

# ============================================
# db-reset.sh — Veritabanını sıfırlar (DEV ONLY)
# ============================================
# Public schema'yı DROP edip yeniden oluşturur, Drizzle schema push yapar ve seed çalıştırır.
# Production ortamda ÇALIŞMAYI REDDEDER.
#
# Kullanım: bash scripts/db-reset.sh

NODE_ENV="${NODE_ENV:-development}"

# .env dosyasından değişkenleri yükle
if [ -f ".env" ]; then
  set -a
  source .env
  set +a
fi

DB_USER="${DB_USER:-postgres}"
DB_NAME="${DB_NAME:-nextjs_skills}"

# --- Prod koruması ---
if [ "$NODE_ENV" = "production" ]; then
  echo "============================================"
  echo "  [HATA] PRODUCTION ORTAMDA DB RESET YAPILAMAZ!"
  echo "  Bu script sadece development ortamı içindir."
  echo "============================================"
  exit 1
fi

# --- Onay iste ---
echo "==> Bu işlem veritabanındaki TÜM VERİYİ silecek."
echo "    Ortam: $NODE_ENV"
read -p "    Devam etmek istiyor musunuz? (y/N): " confirm

if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "    İptal edildi."
  exit 0
fi

echo "==> Veritabanı sıfırlanıyor..."
docker compose exec -T postgres psql -U "$DB_USER" -d "$DB_NAME" -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

echo "==> Drizzle schema push çalıştırılıyor..."
bunx drizzle-kit push

echo "==> Seed çalıştırılıyor..."
bun drizzle/seed.ts

echo ""
echo "==> Veritabanı sıfırlandı ve seed uygulandı."
