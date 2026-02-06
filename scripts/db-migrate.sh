#!/usr/bin/env bash
set -euo pipefail

# ============================================
# db-migrate.sh — Ortama göre Prisma migration
# ============================================
# NODE_ENV=development (varsayılan): prisma migrate dev
# NODE_ENV=production:               prisma migrate deploy
#
# Kullanım:
#   bash scripts/db-migrate.sh                  # dev migrate
#   NODE_ENV=production bash scripts/db-migrate.sh  # prod deploy
#   bash scripts/db-migrate.sh --name add-users # dev + migration adı

NODE_ENV="${NODE_ENV:-development}"
MIGRATION_NAME=""

# Argümanları parse et
while [[ $# -gt 0 ]]; do
  case $1 in
    --name)
      MIGRATION_NAME="$2"
      shift 2
      ;;
    *)
      echo "[HATA] Bilinmeyen argüman: $1"
      exit 1
      ;;
  esac
done

echo "==> Ortam: $NODE_ENV"

if [ "$NODE_ENV" = "production" ]; then
  echo "==> Production migration (prisma migrate deploy)..."
  echo "    Bu komut sadece mevcut migration'ları uygular."
  echo "    Yeni migration oluşturmaz."
  bunx prisma migrate deploy
else
  echo "==> Development migration (prisma migrate dev)..."
  if [ -n "$MIGRATION_NAME" ]; then
    echo "    Migration adı: $MIGRATION_NAME"
    bunx prisma migrate dev --name "$MIGRATION_NAME"
  else
    bunx prisma migrate dev
  fi
fi

echo "==> Prisma client generate ediliyor..."
bunx prisma generate

echo "==> Migration tamamlandı."
