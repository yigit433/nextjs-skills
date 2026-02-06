---
name: prisma-postgres-workflows
description: Prisma + PostgreSQL için migration, seed, reset ve dev/prod workflow'larını tanımlar.
version: "0.1.0"
license: Apache-2.0
tags:
  - prisma
  - postgresql
  - migration
  - database
  - workflow
  - docker
---

# prisma-postgres-workflows

## Amaç

Prisma ORM ve PostgreSQL ile çalışırken migration, seed, reset ve ortam ayrımı (dev/prod) için standart workflow'lar ve script'ler sağlar.

## Ne Zaman Kullanılır

- Prisma + PostgreSQL kullanan bir projede veritabanı yönetim süreçleri standartlaştırılacaksa.
- Dev ortamında hızlı reset/seed, prod ortamında güvenli migration politikası gerekiyorsa.
- Docker Compose ile tekrarlanabilir DB ortamı isteniyorsa.

## Sağlanan Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `templates/docker-compose.yml` | PostgreSQL 16 container (healthcheck, named volume) |
| `templates/.env.example` | Ortam değişkenleri (DATABASE_URL dahil) |
| `templates/prisma/schema.prisma` | Base Prisma schema (datasource + generator + örnek model) |
| `templates/prisma/seed.ts` | Örnek seed dosyası (upsert pattern) |
| `scripts/init.sh` | Projeyi sıfırdan ayağa kaldırır |
| `scripts/db-migrate.sh` | Ortama göre migrate dev / migrate deploy |
| `scripts/db-reset.sh` | Dev-only DB reset (prod'da reddeder) |
| `scripts/db-seed.sh` | Prisma seed çalıştırır |

## Adımlar

1. **PostgreSQL başlat**: `docker compose up -d` veya `bash scripts/init.sh`
2. **Ortam değişkenlerini ayarla**: `.env.example` dosyasını `.env` olarak kopyala, değerleri güncelle.
3. **Schema tanımla**: `prisma/schema.prisma` dosyasını projeye göre düzenle.
4. **Dev migration**: `bash scripts/db-migrate.sh --name init`
5. **Seed**: `bash scripts/db-seed.sh`
6. **Prod deploy**: `NODE_ENV=production bash scripts/db-migrate.sh`

## Dev vs Prod Politikası

| İşlem | Dev | Prod |
|-------|-----|------|
| `migrate dev` | Yeni migration oluşturur | Kullanılmaz |
| `migrate deploy` | Opsiyonel | Tek yol |
| `db reset` | Serbest | **Engellendi** |
| `db seed` | Serbest | Manuel karar |

## DoD (Definition of Done)

- [ ] `docker compose up -d` ile PostgreSQL ayağa kalkıyor.
- [ ] `prisma migrate dev` hatasız çalışıyor.
- [ ] Seed script veritabanını dolduruyor.
- [ ] `prisma migrate deploy` prod için çalışıyor.
- [ ] Dev/prod ortam ayrımı `.env` ile sağlanmış.
