# 🚀 Никита Стешов (slesh) - Portfolio Website

Красивый одностраничный сайт-портфолио с современным дизайном и интерактивными элементами, оптимизированный для запуска на Raspberry Pi.

## 🌟 Особенности

- 📱 **Адаптивный дизайн** - отлично выглядит на всех устройствах
- 🎨 **Цветовая схема** - красный для МТС Digital ASOC, оранжевый для МТС Hotels, зеленый для Cloud.ru
- ✨ **Интерактивные элементы** - анимации, typing эффект, hover эффекты
- 🎯 **Click-to-copy функциональность** - клик по контактам для копирования
- ⚡ **Высокая производительность** - оптимизированный Go сервер
- 🐳 **Docker контейнеризация** - простой деплой
- 🔧 **Запуск одной командой** - готовое решение под ключ
- 🌊 **Плавные анимации** - параллакс эффекты и современные переходы

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
├── index.html          # Основная HTML страница
├── style.css           # CSS стили
├── main.go            # Go веб-сервер
├── go.mod             # Go модуль
├── Dockerfile         # Docker образ
├── docker-compose.yml # Docker Compose конфигурация
├── start.sh           # Скрипт запуска
├── Makefile          # Make команды
└── README.md         # Документация
```

## 🎨 Технологии

- **Frontend**: HTML5, CSS3, JavaScript
- **Backend**: Go 1.22+
- **Контейнеризация**: Docker, Docker Compose
- **Веб-сервер**: Gorilla Mux
- **Стили**: Modern CSS с градиентами и анимациями

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

**Автор**: Никита Стешов (slesh • ./stesh)  
**Сайт**: stesh.net  
**Позиция**: Senior Golang Developer  
**Специализация**: Высоконагруженные системы, микросервисы, оптимизация производительности

