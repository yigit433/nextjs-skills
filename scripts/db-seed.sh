#!/usr/bin/env bash
set -euo pipefail

# ============================================
# db-seed.sh — Drizzle seed çalıştırır
# ============================================
# drizzle/seed.ts dosyasını doğrudan bun ile çalıştırır.
#
# Kullanım: bash scripts/db-seed.sh

echo "==> Seed çalıştırılıyor..."
bun drizzle/seed.ts

echo "==> Seed tamamlandı."
