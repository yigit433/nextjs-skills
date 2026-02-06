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

## Adımlar

> Detaylı adımlar ve template dosyalar sonraki iterasyonlarda eklenecektir.

1. `bun create next-app` ile proje oluştur.
2. Prisma init ve schema tanımla.
3. Tailwind CSS konfigüre et.
4. Biome konfigüre et.
5. Klasör yapısını standartlaştır.
6. Docker Compose ile PostgreSQL ayarla.

## DoD (Definition of Done)

- [ ] `bun dev` ile proje ayağa kalkıyor.
- [ ] Prisma client generate edilebiliyor.
- [ ] Tailwind sınıfları çalışıyor.
- [ ] `bun run check` (Biome) hatasız geçiyor.
- [ ] PostgreSQL container çalışıyor ve bağlantı başarılı.
