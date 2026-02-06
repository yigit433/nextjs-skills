---
name: better-auth-setup
description: Better Auth kütüphanesini Next.js App Router projesine entegre eder. Session yönetimi, email/password ve OAuth desteği sağlar.
version: "0.1.0"
license: Apache-2.0
tags:
  - better-auth
  - authentication
  - session
  - nextjs
  - prisma
---

# better-auth-setup

## Amaç

Better Auth kütüphanesini mevcut Next.js + Prisma projesine entegre eder. Email/password authentication, session yönetimi ve opsiyonel OAuth provider desteği sunar.

## Ne Zaman Kullanılır

- Projeye authentication eklenecekse.
- Better Auth tercih ediliyorsa (lightweight, framework-agnostic, Prisma adapter desteği).
- Session-based auth stratejisi isteniyorsa.

## Adımlar

> Detaylı adımlar ve template dosyalar sonraki iterasyonlarda eklenecektir.

1. `better-auth` ve adapter paketlerini kur.
2. Auth config dosyasını oluştur (`lib/auth.ts`).
3. Prisma schema'ya auth tablolarını ekle.
4. API route handler'ları tanımla.
5. Client-side auth hook'ları konfigüre et.
6. Middleware ile korumalı route'ları belirle.

## DoD (Definition of Done)

- [ ] Email/password ile kayıt ve giriş çalışıyor.
- [ ] Session oluşturuluyor ve doğrulanıyor.
- [ ] Korumalı route'lara yetkisiz erişim engellenmiş.
- [ ] Prisma migration auth tabloları için başarılı.
