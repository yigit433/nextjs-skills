#!/usr/bin/env bash
set -euo pipefail

# ============================================
# db-reset.sh — Veritabanını sıfırlar (DEV ONLY)
# ============================================
# Tüm tabloları siler, migration'ları yeniden uygular ve seed çalıştırır.
# Production ortamda ÇALIŞMAYI REDDEDER.
#
# Kullanım: bash scripts/db-reset.sh

NODE_ENV="${NODE_ENV:-development}"

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
bunx prisma migrate reset --force

echo "==> Prisma client generate ediliyor..."
bunx prisma generate

echo ""
echo "==> Veritabanı sıfırlandı ve seed uygulandı."
