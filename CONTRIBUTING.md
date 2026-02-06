# Contributing

Bu repo'ya katkıda bulunmak istiyorsanız aşağıdaki rehberi takip edin.

## Yeni Skill Ekleme

### 1. Klasör oluştur

```bash
mkdir skills/my-new-skill
```

Klasör adı **lowercase, kebab-case** olmalı.

### 2. SKILL.md oluştur

Her skill klasöründe bir `SKILL.md` dosyası **zorunludur**. Format:

```yaml
---
name: my-new-skill                # Klasör adıyla aynı
description: Kısa ve net açıklama
version: "0.1.0"
license: Apache-2.0
tags:
  - ilgili
  - etiketler
---
```

Markdown body şu bölümleri içermeli:

- **Amaç** — Skill ne yapar?
- **Ne Zaman Kullanılır** — Hangi senaryoda tercih edilir?
- **Ön Koşullar** — Bağımlılıklar neler?
- **Adımlar** — Numaralandırılmış, çalıştırılabilir adımlar.
- **DoD (Definition of Done)** — Doğrulama kontrol listesi.

### 3. Opsiyonel dosyalar

```
skills/my-new-skill/
├── SKILL.md           # Zorunlu
├── references/        # Opsiyonel: referans dokümanlar
├── assets/            # Opsiyonel: görseller, diyagramlar
└── scripts/           # Opsiyonel: yardımcı script'ler
```

### 4. README.md güncelle

Repo haritasına yeni skill klasörünü ekleyin.

## Mevcut Skill Güncelleme

- `version` alanını güncelleyin.
- Değişiklikleri SKILL.md body'sinde açıklayın.
- Breaking change varsa açıkça belirtin.

## Kod Standartları

- Formatter/Linter: Biome (`bun run check`)
- Dil: TypeScript (strict mode)
- Script'ler: Bash, `set -euo pipefail` ile başlamalı

## Pull Request Süreci

1. Fork yapın ve feature branch oluşturun.
2. Değişiklikleri yapın.
3. Tüm SKILL.md dosyalarının formatını doğrulayın.
4. PR açın, değişiklikleri açıklayın.

## Lisans

Katkılarınız Apache-2.0 lisansı altında kabul edilir.
