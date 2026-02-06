---
name: nextjs-bun-prisma-stack
description: Next.js App Router + Bun + Prisma + Tailwind CSS + Biome ile production-ready proje iskeleti kurar.
version: "0.1.0"
license: Apache-2.0
tags:
  - nextjs
  - bun
  - prisma
  - tailwind
  - biome
  - typescript
  - scaffold
---

# nextjs-bun-prisma-stack

## Amaç

Sıfırdan bir Next.js (App Router) projesi oluşturur. Bun runtime/package manager, Prisma ORM, Tailwind CSS ve Biome formatter/linter ile tam entegre, production-ready bir iskelet sağlar.

## Ne Zaman Kullanılır

- Yeni bir full-stack Next.js projesi başlatılacaksa.
- Bun + Prisma + Tailwind + Biome standart stack'i isteniyorsa.
- Tutarlı bir proje yapısına ihtiyaç varsa.

## Ön Koşullar

- Bun >= 1.0 kurulu
- Docker ve Docker Compose kurulu
- Node.js >= 18 (Next.js uyumluluk)

## Sağlanan Template Dosyalar

| Dosya | Açıklama |
|-------|----------|
| `templates/docker-compose.yml` | PostgreSQL 16 container |
| `templates/.env.example` | Ortam değişkenleri |
| `templates/biome.json` | Biome formatter + linter |
| `templates/tsconfig.json` | TypeScript strict config |
| `templates/prisma/schema.prisma` | Base Prisma schema |
| `templates/prisma/seed.ts` | Örnek seed dosyası |

## Adımlar

### 1. Next.js projesi oluştur

```bash
bun create next-app@latest my-app --typescript --tailwind --eslint=false --app --src-dir --import-alias "@/*"
cd my-app
```

> ESLint devre dışı çünkü Biome kullanılacak.

### 2. ESLint'i kaldır, Biome'u kur

```bash
bun remove eslint eslint-config-next
bun add -d @biomejs/biome
```

`templates/biome.json` dosyasını proje kök dizinine kopyala:

```bash
cp ../templates/biome.json ./biome.json
```

`package.json`'a script'leri ekle:

```json
{
  "scripts": {
    "check": "biome check .",
    "check:fix": "biome check --write .",
    "format": "biome format --write ."
  }
}
```

### 3. Prisma kur ve konfigüre et

```bash
bun add prisma @prisma/client
bunx prisma init
```

Oluşan `prisma/schema.prisma` dosyasını `templates/prisma/schema.prisma` ile değiştir veya üzerine yaz. Seed dosyasını kopyala:

```bash
cp ../templates/prisma/schema.prisma ./prisma/schema.prisma
cp ../templates/prisma/seed.ts ./prisma/seed.ts
```

`package.json`'a seed config ekle:

```json
{
  "prisma": {
    "seed": "bun prisma/seed.ts"
  }
}
```

### 4. Docker Compose ile PostgreSQL ayarla

```bash
cp ../templates/docker-compose.yml ./docker-compose.yml
cp ../templates/.env.example ./.env.example
cp .env.example .env
```

`.env` dosyasındaki değerleri düzenle, ardından:

```bash
docker compose up -d
```

### 5. İlk migration

```bash
bunx prisma migrate dev --name init
bunx prisma generate
```

### 6. Proje yapısını standartlaştır

```
src/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── api/
├── components/
├── lib/
│   └── prisma.ts          # PrismaClient singleton
├── types/
└── styles/
```

`src/lib/prisma.ts` — Prisma singleton:

```typescript
import { PrismaClient } from "@prisma/client";

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined;
};

export const prisma = globalForPrisma.prisma ?? new PrismaClient();

if (process.env.NODE_ENV !== "production") {
  globalForPrisma.prisma = prisma;
}
```

### 7. Doğrulama

```bash
bun dev              # Proje çalışıyor mu?
bun run check        # Biome hatasız mı?
bunx prisma studio   # DB bağlantısı çalışıyor mu?
```

## DoD (Definition of Done)

- [ ] `bun dev` ile proje ayağa kalkıyor.
- [ ] Prisma client generate edilebiliyor.
- [ ] Tailwind sınıfları çalışıyor.
- [ ] `bun run check` (Biome) hatasız geçiyor.
- [ ] PostgreSQL container çalışıyor ve bağlantı başarılı.
- [ ] Proje yapısı standartlaştırılmış (`src/lib`, `src/components`, vb.).
