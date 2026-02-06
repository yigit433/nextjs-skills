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

## Adımlar

> Detaylı adımlar ve template dosyalar sonraki iterasyonlarda eklenecektir.

1. Docker Compose ile PostgreSQL tanımla.
2. `.env.example` ile bağlantı bilgilerini belirle.
3. `prisma/schema.prisma` base config.
4. Dev workflow script'leri: migrate dev, seed, reset.
5. Prod workflow: migrate deploy, backup policy.
6. CI/CD entegrasyon notları.

## DoD (Definition of Done)

- [ ] `docker compose up -d` ile PostgreSQL ayağa kalkıyor.
- [ ] `prisma migrate dev` hatasız çalışıyor.
- [ ] Seed script veritabanını dolduruyor.
- [ ] `prisma migrate deploy` prod için çalışıyor.
- [ ] Dev/prod ortam ayrımı `.env` ile sağlanmış.
