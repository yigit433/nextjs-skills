# Security Policy

## Desteklenen Sürümler

| Sürüm | Destek |
|--------|--------|
| 0.1.x  | Aktif  |

## Güvenlik Açığı Raporlama

Bir güvenlik açığı tespit ettiyseniz:

1. **Herkese açık issue AÇMAYIN.**
2. Sorunu doğrudan repo maintainer'larına bildirin.
3. Açığı mümkün olduğunca detaylı açıklayın:
   - Etkilenen skill/dosya
   - Yeniden üretme adımları
   - Potansiyel etki

## Genel Güvenlik Kuralları

Bu repo'daki skill'ler ve template'ler şu güvenlik kurallarına uyar:

- `.env` dosyaları **asla** commit edilmez.
- `.env.example` dosyalarında **gerçek secret bulunmaz**.
- Production veritabanı reset script'leri **çalışmayı reddeder**.
- Drizzle migration'ları prod ortamda yalnızca `drizzle-kit migrate` ile uygulanır.
- Auth secret'ları en az 32 karakter, rastgele üretilmiş olmalıdır.

## Bağımlılık Güvenliği

- Bağımlılıklar düzenli olarak güncellenmeli.
- `bun audit` ile bilinen güvenlik açıkları kontrol edilmeli.
