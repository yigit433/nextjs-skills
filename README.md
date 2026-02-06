# nextjs-skills

Open Agent Skills Ecosystem — Next.js, Bun, Prisma, Better Auth ve PostgreSQL stack'i için hazır skill paketleri.

## Stack

| Katman        | Teknoloji           |
| ------------- | ------------------- |
| Framework     | Next.js (App Router)|
| Runtime / PM  | Bun                 |
| Auth          | Better Auth         |
| ORM           | Prisma              |
| Database      | PostgreSQL (Docker)  |
| Styling       | Tailwind CSS        |
| Lint/Format   | Biome               |
| Language      | TypeScript          |

## Repo Yapısı

```
nextjs-skills/
├── skills/
│   ├── nextjs-bun-prisma-stack/    # Proje iskelet kurulumu
│   │   └── SKILL.md
│   ├── better-auth-setup/          # Better Auth entegrasyonu
│   │   └── SKILL.md
│   └── prisma-postgres-workflows/  # Prisma + PG workflow'ları
│       └── SKILL.md
├── templates/
│   ├── docker-compose.yml          # PostgreSQL 16 container
│   ├── .env.example                # Ortam değişkenleri (secret'sız)
│   ├── biome.json                  # Biome formatter + linter config
│   ├── tsconfig.json               # TypeScript strict config
│   └── prisma/
│       ├── schema.prisma           # Base Prisma schema
│       └── seed.ts                 # Örnek seed dosyası
├── scripts/
│   ├── init.sh                     # Proje bootstrap
│   ├── db-migrate.sh               # Dev/prod migration
│   ├── db-reset.sh                 # Dev-only DB reset
│   └── db-seed.sh                  # Prisma seed
├── .gitignore
├── CONTRIBUTING.md                 # Katkı rehberi
├── SECURITY.md                     # Güvenlik politikası
├── LICENSE                         # Apache-2.0
└── README.md
```

## Skill Formatı

Her skill klasörü en az bir `SKILL.md` dosyası içerir. Format:

```yaml
---
name: skill-adi
description: Kısa açıklama
version: "0.1.0"
license: Apache-2.0
tags: [...]
---
```

Markdown body: amaç, kullanım senaryosu, adımlar, DoD.

## Lisans

Apache-2.0 — detaylar için [LICENSE](./LICENSE) dosyasına bakın.
