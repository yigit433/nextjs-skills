#!/usr/bin/env bash
set -euo pipefail

# ============================================
# db-migrate.sh — Ortama göre Drizzle migration
# ============================================
# NODE_ENV=development (varsayılan): drizzle-kit generate + migrate
# NODE_ENV=production:               drizzle-kit migrate (sadece mevcut migration'ları uygular)
#
# Kullanım:
#   bash scripts/db-migrate.sh                      # dev: generate + migrate
#   NODE_ENV=production bash scripts/db-migrate.sh   # prod: sadece migrate
#   bash scripts/db-migrate.sh --name add-users      # dev: generate with name + migrate

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
  echo "==> Production migration (drizzle-kit migrate)..."
  echo "    Bu komut sadece mevcut migration'ları uygular."
  echo "    Yeni migration oluşturmaz."
  bunx drizzle-kit migrate
else
  echo "==> Development migration (drizzle-kit generate + migrate)..."
  if [ -n "$MIGRATION_NAME" ]; then
    echo "    Migration adı: $MIGRATION_NAME"
    bunx drizzle-kit generate --name "$MIGRATION_NAME"
  else
    bunx drizzle-kit generate
  fi
  bunx drizzle-kit migrate
fi

echo "==> Migration tamamlandı."
