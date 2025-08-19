# 🚀 Никита Стешов (slesh) - Portfolio Website

Красивый одностраничный сайт-портфолио с современным дизайном и интерактивными элементами, оптимизированный для запуска на Raspberry Pi.

## 🌟 Особенности

### 🎨 **Современный UI/UX дизайн**
- 📱 **Pixel-perfect адаптивность** - идеально выглядит на всех устройствах (мобильные, планшеты, десктоп)
- 🎯 **CSS Custom Properties** - современная система дизайна с переменными
- 🌈 **Цветовая схема** - красный для МТС Digital ASOC, оранжевый для МТС Hotels, зеленый для Cloud.ru
- 📐 **CSS Grid & Flexbox** - современная раскладка страниц

### ✨ **Интерактивность и анимации**
- 🎭 **Микроинтеракции** - ripple эффекты, hover анимации, плавные переходы
- ⌨️ **Typing эффект** - живой эффект печатания для псевдонима
- 🌊 **Stagger анимации** - элементы появляются с задержкой для лучшего визуального эффекта
- 🎯 **Click-to-copy** - клик по контактам для копирования с тактильной обратной связью
- 📱 **Haptic feedback** - вибрация на мобильных устройствах

### ⚡ **Производительность**
- 🚀 **Intersection Observer API** - ленивая загрузка анимаций
- 🎨 **CSS Hardware Acceleration** - плавные анимации через GPU
- 📊 **Performance monitoring** - отслеживание времени загрузки
- 🔄 **requestAnimationFrame** - оптимизированные scroll эффекты
- 📦 **Resource preloading** - предзагрузка критических ресурсов

### 🛠 **Технические особенности**
- 🐳 **Docker контейнеризация** - простой деплой
- 🔧 **Запуск одной командой** - готовое решение под ключ
- 🌐 **Multi-port support** - порты 80 и 8080
- ♿ **Accessibility** - поддержка screen readers и keyboard navigation
- 🎨 **Modern CSS** - использование новейших CSS возможностей

## 🚀 Быстрый запуск

### Способ 1: Автоматический скрипт (Рекомендуется)

```bash
# Сделать скрипт исполняемым
chmod +x start.sh

# Запустить сайт
./start.sh
```

### Способ 2: Makefile

```bash
# Показать все доступные команды
make help

# Запустить через Docker Compose
make compose-up

# Проверить статус
make status
```

### Способ 3: Docker Compose

```bash
# Запустить
docker-compose up -d

# Остановить
docker-compose down
```

## 📋 Требования

- Docker
- Docker Compose
- Make (опционально)
- curl (для проверки статуса)

### Установка на Raspberry Pi

```bash
# Обновить систему
sudo apt update && sudo apt upgrade -y

# Установить Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Установить Docker Compose
sudo apt install docker-compose-plugin -y

# Перезагрузиться или выйти и войти снова
sudo reboot
```

## 🌐 Доступ к сайту

После запуска сайт будет доступен по адресам:

### 🏠 Локально:
- **Порт 80**: http://localhost:80
- **Порт 8080**: http://localhost:8080

### 🌍 По IP адресу:
- http://[IP_АДРЕС]:80
- http://[IP_АДРЕС]:8080

### 🔒 Через Cloudflare (рекомендуется):
- **HTTPS**: https://stesh.net
- **HTTP**: http://stesh.net

> **Примечание**: Cloudflare автоматически обрабатывает SSL/TLS и перенаправляет трафик на ваш сервер через порты 80/8080.

## 🛠 Управление

### Команды start.sh

```bash
./start.sh start    # Запустить сайт (по умолчанию)
./start.sh stop     # Остановить сайт
./start.sh restart  # Перезапустить сайт
./start.sh logs     # Показать логи
./start.sh status   # Проверить статус
./start.sh cleanup  # Очистить Docker образы
```

### Команды Makefile

```bash
make help           # Показать справку
make compose-up     # Запустить через docker-compose
make compose-down   # Остановить
make logs          # Показать логи
make status        # Проверить статус
make dev           # Запустить в режиме разработки
```

## 🔧 Конфигурация

### Переменные окружения

- `PORT` - основной порт для запуска (по умолчанию 8080)
- `ENABLE_PORT_80` - включить порт 80 (по умолчанию true в Docker)

### Конфигурация портов

Сервер автоматически запускается на нескольких портах:

- **Порт 8080** - основной порт
- **Порт 80** - стандартный HTTP порт (если доступен)

Для отключения порта 80 установите переменную окружения:
```bash
export ENABLE_PORT_80=false
```

### Настройка домена

Для доступа по домену stesh.net:

1. **Базовая настройка без Cloudflare:**
   - Настройте A-запись в DNS на IP адрес вашего Raspberry Pi
   - Убедитесь, что порты 80 и 8080 открыты в роутере

2. **Настройка с Cloudflare (рекомендуется):**
   - Добавьте домен в Cloudflare
   - Создайте A-запись: `@` → `IP_АДРЕС_RASPBERRY_PI`
   - Включите проксирование Cloudflare (оранжевое облако)
   - В настройках SSL/TLS выберите "Flexible" или "Full"
   - Откройте порты 80 и 8080 на вашем сервере
   
3. **Преимущества Cloudflare:**
   - ✅ Бесплатный SSL сертификат
   - ✅ DDoS защита
   - ✅ CDN для ускорения загрузки
   - ✅ Кэширование статических файлов
   - ✅ Автоматическое сжатие

## 📁 Структура проекта

```
stesh-portfolio/
├── index.html              # Современная HTML страница с мета-тегами
├── style.css               # Modern CSS с переменными и Grid
├── sw.js                   # Service Worker для PWA
├── main.go                 # Go веб-сервер (multi-port)
├── go.mod                  # Go модуль
├── Dockerfile              # Оптимизированный Docker образ
├── docker-compose.yml      # Docker Compose с портами 80/8080
├── start.sh               # Скрипт запуска (Linux/macOS)
├── start.bat              # Скрипт запуска (Windows)
├── Makefile               # Make команды
├── README.md              # Основная документация
├── MODERN_FEATURES.md     # Документация современных возможностей
├── CLOUDFLARE_SETUP.md    # Инструкция по настройке Cloudflare
└── .gitignore             # Git ignore файл
```

## 🎨 Технологии

### **Frontend (Modern Stack)**
- **HTML5** - семантическая разметка с метатегами для SEO
- **Modern CSS** - CSS Custom Properties, Grid, Flexbox, современные анимации
- **Vanilla JavaScript (ES6+)** - классы, async/await, современные API
- **Web APIs**: Intersection Observer, Clipboard API, Vibration API
- **Typography**: Inter font family для отличной читаемости
- **Icons**: Font Awesome 6.0

### **Backend** 
- **Go 1.22+** - современные возможности языка
- **Gorilla Mux** - HTTP роутер
- **Multi-port support** - одновременная работа на портах 80 и 8080
- **Graceful shutdown** - корректная остановка сервисов

### **Инфраструктура**
- **Docker & Docker Compose** - контейнеризация
- **Cloudflare Ready** - оптимизация для CDN
- **Raspberry Pi Optimized** - легковесное решение

### **Performance & UX**
- **CSS Hardware Acceleration** - анимации через GPU
- **Resource Preloading** - быстрая загрузка
- **Lazy Loading** - экономия трафика
- **Modern JavaScript** - оптимизированный код без лишних библиотек

## 🔍 Мониторинг

- **Health Check**: http://localhost:8080/health
- **Логи**: `docker-compose logs -f` или `./start.sh logs`
- **Статус**: `./start.sh status` или `make status`

## 🛡 Безопасность

- Контейнер запускается от имени непривилегированного пользователя
- Статические файлы с защитой от directory traversal
- Health check для мониторинга

## 🐛 Устранение неполадок

### Сайт не запускается

```bash
# Проверить статус Docker
sudo systemctl status docker

# Проверить логи
./start.sh logs

# Перезапустить
./start.sh restart
```

### Порт занят

```bash
# Найти процессы на портах 80 и 8080
sudo netstat -tulpn | grep -E ":80|:8080"

# Остановить существующий контейнер
./start.sh stop

# Для порта 80 может потребоваться остановить другие веб-серверы
sudo systemctl stop nginx    # Если установлен nginx
sudo systemctl stop apache2  # Если установлен apache
```

### Проблемы с портом 80

Порт 80 может потребовать особых привилегий:

```bash
# На Raspberry Pi для Docker может потребоваться sudo
sudo docker-compose up -d

# Или запустить только на порту 8080
export ENABLE_PORT_80=false
./start.sh start
```

### Проблемы с разрешениями

```bash
# Добавить пользователя в группу docker
sudo usermod -aG docker $USER

# Выйти и войти снова или выполнить
newgrp docker
```

## 📞 Поддержка

При возникновении проблем проверьте:

1. Установлен ли Docker и Docker Compose
2. Доступен ли порт 8080
3. Достаточно ли места на диске
4. Логи контейнера через `./start.sh logs`

---

**Автор**: Стешов Никита (slesh • ./stesh)  
**Сайт**: stesh.net  
**Telegram**: @sleshstesh  
**Позиция**: Golang Developer  
**Специализация**: Высоконагруженные системы, микросервисы, оптимизация производительности

