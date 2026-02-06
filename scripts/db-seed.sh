#!/usr/bin/env bash
set -euo pipefail

# ============================================
# db-seed.sh — Prisma seed çalıştırır
# ============================================
# package.json'da prisma.seed tanımı gerektirir:
#   "prisma": { "seed": "bun prisma/seed.ts" }
#
# Kullanım: bash scripts/db-seed.sh

echo "==> Seed çalıştırılıyor..."
bunx prisma db seed

echo "==> Seed tamamlandı."
