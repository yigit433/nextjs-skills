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

## Ön Koşullar

- `nextjs-bun-prisma-stack` skill'i uygulanmış olmalı (veya eşdeğer bir Next.js + Prisma projesi mevcut).
- PostgreSQL çalışır durumda.

## Auth Stratejisi Kararı

**Session-based auth** tercih ediliyor:

1. **Revoke kolaylığı** — JWT'de token süresi dolana kadar iptal zor, session anında silinebilir.
2. **Better Auth varsayılanı** — Kütüphanenin birincil ve en iyi test edilmiş yolu.
3. **Server component uyumu** — Next.js App Router'da server component'lerden session'a erişmek doğal.

## Adımlar

### 1. Paketleri kur

```bash
bun add better-auth
```

### 2. Auth config oluştur — `src/lib/auth.ts`

```typescript
import { betterAuth } from "better-auth";
import { prismaAdapter } from "better-auth/adapters/prisma";
import { prisma } from "./prisma";

export const auth = betterAuth({
  database: prismaAdapter(prisma, {
    provider: "postgresql",
  }),
  emailAndPassword: {
    enabled: true,
  },
  session: {
    expiresIn: 60 * 60 * 24 * 7, // 7 gün
    updateAge: 60 * 60 * 24,      // 1 günde bir yenile
  },
});
```

### 3. Auth client oluştur — `src/lib/auth-client.ts`

```typescript
import { createAuthClient } from "better-auth/react";

export const authClient = createAuthClient({
  baseURL: process.env.NEXT_PUBLIC_APP_URL,
});

export const {
  signIn,
  signUp,
  signOut,
  useSession,
} = authClient;
```

### 4. API route handler — `src/app/api/auth/[...all]/route.ts`

```typescript
import { auth } from "@/lib/auth";
import { toNextJsHandler } from "better-auth/next-js";

export const { GET, POST } = toNextJsHandler(auth);
```

### 5. Prisma schema'ya auth tablolarını ekle

Better Auth CLI ile schema'yı generate et:

```bash
bunx @better-auth/cli generate --output ./prisma/schema.prisma
```

Veya tabloları manuel ekle (`prisma/schema.prisma`):

```prisma
model User {
  id            String    @id @default(cuid())
  name          String
  email         String    @unique
  emailVerified Boolean   @default(false)
  image         String?
  createdAt     DateTime  @default(now()) @map("created_at")
  updatedAt     DateTime  @updatedAt @map("updated_at")
  sessions      Session[]
  accounts      Account[]

  @@map("users")
}

model Session {
  id        String   @id @default(cuid())
  expiresAt DateTime @map("expires_at")
  token     String   @unique
  ipAddress String?  @map("ip_address")
  userAgent String?  @map("user_agent")
  userId    String   @map("user_id")
  user      User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@map("sessions")
}

model Account {
  id                    String  @id @default(cuid())
  accountId             String  @map("account_id")
  providerId            String  @map("provider_id")
  userId                String  @map("user_id")
  user                  User    @relation(fields: [userId], references: [id], onDelete: Cascade)
  accessToken           String? @map("access_token")
  refreshToken          String? @map("refresh_token")
  idToken               String? @map("id_token")
  accessTokenExpiresAt  DateTime? @map("access_token_expires_at")
  refreshTokenExpiresAt DateTime? @map("refresh_token_expires_at")
  scope                 String?
  password              String?
  createdAt             DateTime @default(now()) @map("created_at")
  updatedAt             DateTime @updatedAt @map("updated_at")

  @@map("accounts")
}

model Verification {
  id         String   @id @default(cuid())
  identifier String
  value      String
  expiresAt  DateTime @map("expires_at")
  createdAt  DateTime @default(now()) @map("created_at")
  updatedAt  DateTime @updatedAt @map("updated_at")

  @@map("verifications")
}
```

Migration çalıştır:

```bash
bunx prisma migrate dev --name add-auth-tables
```

### 6. Middleware — `src/middleware.ts`

```typescript
import { auth } from "@/lib/auth";
import { headers } from "next/headers";
import { NextRequest, NextResponse } from "next/server";

const protectedRoutes = ["/dashboard"];
const authRoutes = ["/sign-in", "/sign-up"];

export async function middleware(request: NextRequest) {
  const session = await auth.api.getSession({
    headers: await headers(),
  });

  const { pathname } = request.nextUrl;

  // Korumalı route — session yoksa sign-in'e yönlendir
  if (protectedRoutes.some((route) => pathname.startsWith(route))) {
    if (!session) {
      return NextResponse.redirect(new URL("/sign-in", request.url));
    }
  }

  // Auth route — session varsa dashboard'a yönlendir
  if (authRoutes.some((route) => pathname.startsWith(route))) {
    if (session) {
      return NextResponse.redirect(new URL("/dashboard", request.url));
    }
  }

  return NextResponse.next();
}

export const config = {
  matcher: ["/dashboard/:path*", "/sign-in", "/sign-up"],
};
```

### 7. Ortam değişkenleri

`.env` dosyasına ekle:

```env
BETTER_AUTH_SECRET=generate_a_random_secret_here
BETTER_AUTH_URL=http://localhost:3000
```

Secret üretmek için:

```bash
openssl rand -base64 32
```

### 8. Doğrulama

```bash
bunx prisma migrate dev          # Auth tabloları oluştu mu?
bun dev                           # Proje hatasız çalışıyor mu?
curl -s http://localhost:3000/api/auth/ok  # Auth endpoint yanıt veriyor mu?
```

## DoD (Definition of Done)

- [ ] Email/password ile kayıt ve giriş çalışıyor.
- [ ] Session oluşturuluyor ve doğrulanıyor.
- [ ] Korumalı route'lara yetkisiz erişim engellenmiş.
- [ ] Prisma migration auth tabloları için başarılı.
- [ ] `BETTER_AUTH_SECRET` `.env.example`'da placeholder olarak mevcut.
