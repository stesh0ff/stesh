#!/bin/bash

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода заголовка
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}🚀 Никита Стешов (slesh)${NC}"
    echo -e "${BLUE}   Portfolio Website${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Функция для проверки команды
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo -e "${RED}❌ $1 не установлен!${NC}"
        echo -e "${YELLOW}Пожалуйста, установите $1 и попробуйте снова.${NC}"
        exit 1
    fi
}

# Функция остановки контейнера
stop_container() {
    echo -e "${YELLOW}🛑 Остановка существующего контейнера...${NC}"
    docker-compose down 2>/dev/null || true
    docker stop stesh-portfolio 2>/dev/null || true
    docker rm stesh-portfolio 2>/dev/null || true
}

# Функция очистки Docker образов
cleanup_docker() {
    echo -e "${YELLOW}🧹 Очистка Docker образов...${NC}"
    docker image prune -f
    docker system prune -f
}

# Функция сборки и запуска
build_and_run() {
    echo -e "${BLUE}🔨 Сборка Docker образа...${NC}"
    if docker-compose build; then
        echo -e "${GREEN}✅ Образ успешно собран!${NC}"
    else
        echo -e "${RED}❌ Ошибка сборки образа!${NC}"
        exit 1
    fi

    echo -e "${BLUE}🚀 Запуск контейнера...${NC}"
    if docker-compose up -d; then
        echo -e "${GREEN}✅ Контейнер успешно запущен!${NC}"
    else
        echo -e "${RED}❌ Ошибка запуска контейнера!${NC}"
        exit 1
    fi
}

# Функция проверки статуса
check_status() {
    echo -e "${BLUE}⏳ Проверка статуса...${NC}"
    sleep 5
    
    if curl -s http://localhost:8080/health > /dev/null; then
        echo -e "${GREEN}✅ Сайт успешно запущен!${NC}"
        echo -e "${GREEN}🌐 Доступные адреса:${NC}"
        echo -e "${GREEN}   - http://localhost:80${NC}"
        echo -e "${GREEN}   - http://localhost:8080${NC}"
        echo -e "${GREEN}   - https://stesh.net (через Cloudflare)${NC}"
        echo -e "${GREEN}❤️  Health check: http://localhost:8080/health${NC}"
        
        # Получаем IP адрес для локальной сети
        LOCAL_IP=$(hostname -I | awk '{print $1}' 2>/dev/null || ip route get 1 | awk '{print $7; exit}' 2>/dev/null || echo "localhost")
        if [ "$LOCAL_IP" != "localhost" ]; then
            echo -e "${GREEN}🌐 По IP адресу:${NC}"
            echo -e "${GREEN}   - http://${LOCAL_IP}:80${NC}"
            echo -e "${GREEN}   - http://${LOCAL_IP}:8080${NC}"
        fi
        
        # Проверяем доступность порта 80
        if curl -s http://localhost:80/health > /dev/null; then
            echo -e "${GREEN}🔓 Порт 80 доступен${NC}"
        else
            echo -e "${YELLOW}⚠️  Порт 80 может потребовать sudo права${NC}"
        fi
    else
        echo -e "${YELLOW}⚠️  Сайт запускается... Попробуйте через несколько секунд.${NC}"
    fi
}

# Функция показа логов
show_logs() {
    echo -e "${BLUE}📋 Показать логи контейнера...${NC}"
    docker-compose logs -f
}

# Главная функция
main() {
    print_header
    
    echo -e "${BLUE}🔍 Проверка зависимостей...${NC}"
    check_command docker
    check_command docker-compose
    check_command curl
    
    echo -e "${GREEN}✅ Все зависимости установлены!${NC}"
    
    # Обработка аргументов
    case "${1:-start}" in
        "start")
            stop_container
            build_and_run
            check_status
            ;;
        "stop")
            echo -e "${YELLOW}🛑 Остановка сайта...${NC}"
            stop_container
            echo -e "${GREEN}✅ Сайт остановлен!${NC}"
            ;;
        "restart")
            echo -e "${YELLOW}🔄 Перезапуск сайта...${NC}"
            stop_container
            build_and_run
            check_status
            ;;
        "logs")
            show_logs
            ;;
        "cleanup")
            stop_container
            cleanup_docker
            echo -e "${GREEN}✅ Очистка завершена!${NC}"
            ;;
        "status")
            if docker ps | grep stesh-portfolio > /dev/null; then
                echo -e "${GREEN}✅ Контейнер запущен${NC}"
                check_status
            else
                echo -e "${RED}❌ Контейнер не запущен${NC}"
            fi
            ;;
        *)
            echo -e "${YELLOW}Использование: $0 {start|stop|restart|logs|cleanup|status}${NC}"
            echo ""
            echo -e "${BLUE}Команды:${NC}"
            echo -e "  ${GREEN}start${NC}    - Собрать и запустить сайт (по умолчанию)"
            echo -e "  ${GREEN}stop${NC}     - Остановить сайт"
            echo -e "  ${GREEN}restart${NC}  - Перезапустить сайт"
            echo -e "  ${GREEN}logs${NC}     - Показать логи"
            echo -e "  ${GREEN}cleanup${NC}  - Очистить Docker образы"
            echo -e "  ${GREEN}status${NC}   - Проверить статус"
            exit 1
            ;;
    esac
}

# Обработка сигналов для graceful shutdown
trap 'echo -e "\n${YELLOW}Прерывание... До свидания!${NC}"; exit 0' INT TERM

# Запуск основной функции
main "$@"

