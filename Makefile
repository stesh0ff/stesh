# Makefile для проекта stesh-portfolio
# Автор: Стешов Никита (slesh)

.PHONY: help build run stop clean dev docker-build docker-run docker-stop logs status

# Переменные
BINARY_NAME=stesh-portfolio
DOCKER_IMAGE=stesh-portfolio:latest
CONTAINER_NAME=stesh-portfolio
PRIMARY_PORT=8080
HTTP_PORT=80

# Цвета для вывода
GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m # No Color

help: ## Показать справку
	@echo "$(GREEN)Доступные команды:$(NC)"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}'

build: ## Собрать Go приложение
	@echo "$(YELLOW)🔨 Сборка приложения...$(NC)"
	@go mod tidy
	@CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o $(BINARY_NAME) .
	@echo "$(GREEN)✅ Приложение собрано!$(NC)"

run: build ## Запустить приложение локально
	@echo "$(YELLOW)🚀 Запуск приложения...$(NC)"
	@./$(BINARY_NAME) &
	@echo "$(GREEN)✅ Приложение запущено на http://localhost:$(PRIMARY_PORT)$(NC)"

dev: ## Запустить в режиме разработки
	@echo "$(YELLOW)🔧 Запуск в режиме разработки...$(NC)"
	@go run main.go

stop: ## Остановить локальное приложение
	@echo "$(YELLOW)🛑 Остановка приложения...$(NC)"
	@pkill -f $(BINARY_NAME) || true
	@echo "$(GREEN)✅ Приложение остановлено!$(NC)"

clean: ## Удалить собранные файлы
	@echo "$(YELLOW)🧹 Очистка...$(NC)"
	@rm -f $(BINARY_NAME)
	@go clean
	@echo "$(GREEN)✅ Очистка завершена!$(NC)"

docker-build: ## Собрать Docker образ
	@echo "$(YELLOW)🔨 Сборка Docker образа...$(NC)"
	@docker build -t $(DOCKER_IMAGE) .
	@echo "$(GREEN)✅ Docker образ собран!$(NC)"

docker-run: docker-stop ## Запустить в Docker контейнере
	@echo "$(YELLOW)🚀 Запуск Docker контейнера...$(NC)"
	@docker run -d --name $(CONTAINER_NAME) -p $(HTTP_PORT):$(HTTP_PORT) -p $(PRIMARY_PORT):$(PRIMARY_PORT) $(DOCKER_IMAGE)
	@sleep 3
	@echo "$(GREEN)✅ Контейнер запущен на:$(NC)"
	@echo "$(GREEN)   - http://localhost:$(HTTP_PORT)$(NC)"
	@echo "$(GREEN)   - http://localhost:$(PRIMARY_PORT)$(NC)"

docker-stop: ## Остановить Docker контейнер
	@echo "$(YELLOW)🛑 Остановка Docker контейнера...$(NC)"
	@docker stop $(CONTAINER_NAME) 2>/dev/null || true
	@docker rm $(CONTAINER_NAME) 2>/dev/null || true
	@echo "$(GREEN)✅ Контейнер остановлен!$(NC)"

compose-up: ## Запустить через docker-compose
	@echo "$(YELLOW)🚀 Запуск через docker-compose...$(NC)"
	@chmod +x start.sh
	@./start.sh start

compose-down: ## Остановить docker-compose
	@echo "$(YELLOW)🛑 Остановка docker-compose...$(NC)"
	@docker-compose down
	@echo "$(GREEN)✅ Сервисы остановлены!$(NC)"

logs: ## Показать логи контейнера
	@docker logs -f $(CONTAINER_NAME) 2>/dev/null || docker-compose logs -f

status: ## Проверить статус
	@echo "$(YELLOW)📊 Проверка статуса...$(NC)"
	@if docker ps | grep $(CONTAINER_NAME) > /dev/null; then \
		echo "$(GREEN)✅ Docker контейнер запущен$(NC)"; \
		echo "$(GREEN)🌐 Доступные адреса:$(NC)"; \
		echo "$(GREEN)   - http://localhost:$(HTTP_PORT)$(NC)"; \
		echo "$(GREEN)   - http://localhost:$(PRIMARY_PORT)$(NC)"; \
		curl -s http://localhost:$(PRIMARY_PORT)/health | jq . 2>/dev/null || echo "Health check OK"; \
	elif pgrep -f $(BINARY_NAME) > /dev/null; then \
		echo "$(GREEN)✅ Локальное приложение запущено$(NC)"; \
	else \
		echo "$(RED)❌ Приложение не запущено$(NC)"; \
	fi

test: ## Запустить тесты
	@echo "$(YELLOW)🧪 Запуск тестов...$(NC)"
	@go test -v ./...
	@echo "$(GREEN)✅ Тесты завершены!$(NC)"

deps: ## Установить зависимости
	@echo "$(YELLOW)📦 Установка зависимостей...$(NC)"
	@go mod download
	@go mod tidy
	@echo "$(GREEN)✅ Зависимости установлены!$(NC)"

# Значение по умолчанию
.DEFAULT_GOAL := help

