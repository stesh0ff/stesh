# 🔒 Настройка Cloudflare для stesh.net

Инструкция по настройке Cloudflare для вашего сайта-портфолио.

## 📋 Пошаговая настройка

### 1. Добавление домена в Cloudflare

1. Зайдите на [cloudflare.com](https://cloudflare.com) и войдите в аккаунт
2. Нажмите "Add a Site"
3. Введите домен: `stesh.net`
4. Выберите бесплатный план (Free Plan)

### 2. Настройка DNS записей

Создайте следующие DNS записи:

| Type | Name | Content | Proxy Status |
|------|------|---------|--------------|
| A    | @    | `95.165.148.101` | 🟠 Proxied |
| A    | www  | `95.165.148.101` | 🟠 Proxied |

> **⚠️ Важно**: Включите проксирование (оранжевое облако) для защиты вашего IP адреса

### 3. Изменение Nameservers

1. Скопируйте nameservers из Cloudflare (например: `kate.ns.cloudflare.com`, `bob.ns.cloudflare.com`)
2. Обновите nameservers у вашего регистратора домена
3. Дождитесь активации (обычно до 24 часов)

### 4. Настройка SSL/TLS

В разделе **SSL/TLS**:

1. Выберите режим шифрования: **"Flexible"** или **"Full"**
   - **Flexible**: HTTP между Cloudflare и сервером (проще настроить)
   - **Full**: HTTPS между Cloudflare и сервером (более безопасно)

2. Включите **"Always Use HTTPS"** для автоматического перенаправления

### 5. Дополнительные настройки (рекомендуется)

#### Speed → Optimization:
- ✅ Auto Minify: CSS, HTML, JavaScript
- ✅ Brotli Compression

#### Caching → Configuration:
- Browser Cache TTL: **1 month**
- Caching Level: **Standard**

#### Security → Settings:
- Security Level: **Medium**
- Challenge Passage: **30 minutes**

## 🚀 Проверка настройки

После активации проверьте:

```bash
# Проверка доступности
curl -I https://stesh.net

# Проверка SSL сертификата
curl -vI https://stesh.net 2>&1 | grep -E "(SSL|TLS)"

# Проверка редиректа с HTTP на HTTPS
curl -I http://stesh.net
```

## 📊 Мониторинг

Cloudflare предоставляет аналитику:

- **Analytics** - статистика посещений
- **Speed** - время загрузки
- **Security** - заблокированные угрозы
- **Caching** - эффективность кэширования

## 🔧 Устранение неполадок

### Сайт недоступен после настройки

1. Проверьте статус активации домена в Cloudflare
2. Убедитесь, что ваш сервер запущен на портах 80 и 8080
3. Проверьте, что IP адрес в DNS записи корректный

### SSL ошибки

1. Попробуйте режим **"Flexible"** в SSL/TLS
2. Отключите **"Always Use HTTPS"** временно
3. Проверьте логи сервера на ошибки

### Медленная загрузка

1. Включите Brotli сжатие
2. Настройте Browser Cache TTL
3. Добавьте Page Rules для кэширования статических файлов

## 📝 Page Rules (опционально)

Создайте правило для кэширования:

**URL**: `stesh.net/*`
**Settings**:
- Cache Level: Cache Everything
- Edge Cache TTL: 1 month
- Browser Cache TTL: 1 month

## 🎯 Результат

После настройки ваш сайт будет:

- ✅ Доступен по HTTPS с валидным сертификатом
- ✅ Защищен от DDoS атак
- ✅ Ускорен через CDN
- ✅ Автоматически сжат для быстрой загрузки
- ✅ Кэширован для лучшей производительности

---

**Контакты для поддержки**: nikita.steshov@gmail.com
