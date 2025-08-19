@echo off
setlocal enabledelayedexpansion

:: Цвета для вывода (поддерживается в Windows 10+)
set "GREEN=[92m"
set "YELLOW=[93m"
set "RED=[91m"
set "BLUE=[94m"
set "NC=[0m"

:: Функция для вывода заголовка
:print_header
echo %BLUE%================================%NC%
echo %BLUE%🚀 Никита Стешов (slesh)%NC%
echo %BLUE%   Portfolio Website%NC%
echo %BLUE%================================%NC%
goto :eof

:: Функция для проверки команды
:check_command
where %1 >nul 2>nul
if %errorlevel% neq 0 (
    echo %RED%❌ %1 не установлен!%NC%
    echo %YELLOW%Пожалуйста, установите %1 и попробуйте снова.%NC%
    exit /b 1
)
goto :eof

:: Функция остановки контейнера
:stop_container
echo %YELLOW%🛑 Остановка существующего контейнера...%NC%
docker-compose down >nul 2>&1
docker stop stesh-portfolio >nul 2>&1
docker rm stesh-portfolio >nul 2>&1
goto :eof

:: Функция очистки Docker образов
:cleanup_docker
echo %YELLOW%🧹 Очистка Docker образов...%NC%
docker image prune -f
docker system prune -f
goto :eof

:: Функция сборки и запуска
:build_and_run
echo %BLUE%🔨 Сборка Docker образа...%NC%
docker-compose build
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка сборки образа!%NC%
    exit /b 1
)
echo %GREEN%✅ Образ успешно собран!%NC%

echo %BLUE%🚀 Запуск контейнера...%NC%
docker-compose up -d
if %errorlevel% neq 0 (
    echo %RED%❌ Ошибка запуска контейнера!%NC%
    exit /b 1
)
echo %GREEN%✅ Контейнер успешно запущен!%NC%
goto :eof

:: Функция проверки статуса
:check_status
echo %BLUE%⏳ Проверка статуса...%NC%
timeout /t 5 /nobreak >nul

curl -s http://localhost:8080/health >nul 2>&1
if %errorlevel% equ 0 (
    echo %GREEN%✅ Сайт успешно запущен!%NC%
    echo %GREEN%🌐 Доступные адреса:%NC%
    echo %GREEN%   - http://localhost:80%NC%
    echo %GREEN%   - http://localhost:8080%NC%
    echo %GREEN%   - https://stesh.net ^(через Cloudflare^)%NC%
    echo %GREEN%❤️  Health check: http://localhost:8080/health%NC%
    
    :: Получаем IP адрес для локальной сети
    for /f "tokens=2 delims=:" %%i in ('ipconfig ^| findstr /i "IPv4"') do (
        set "ip=%%i"
        set "ip=!ip: =!"
        if defined ip (
            echo %GREEN%🌐 По IP адресу:%NC%
            echo %GREEN%   - http://!ip!:80%NC%
            echo %GREEN%   - http://!ip!:8080%NC%
            goto :status_done
        )
    )
    :status_done
    
    :: Проверяем доступность порта 80
    curl -s http://localhost:80/health >nul 2>&1
    if %errorlevel% equ 0 (
        echo %GREEN%🔓 Порт 80 доступен%NC%
    ) else (
        echo %YELLOW%⚠️  Порт 80 может быть недоступен в Docker на Windows%NC%
    )
) else (
    echo %YELLOW%⚠️  Сайт запускается... Попробуйте через несколько секунд.%NC%
)
goto :eof

:: Главная функция
call :print_header

echo %BLUE%🔍 Проверка зависимостей...%NC%
call :check_command docker
call :check_command docker-compose
call :check_command curl

echo %GREEN%✅ Все зависимости установлены!%NC%

:: Обработка аргументов
if "%1"=="" set "action=start"
if "%1"=="start" set "action=start"
if "%1"=="stop" set "action=stop"
if "%1"=="restart" set "action=restart"
if "%1"=="logs" set "action=logs"
if "%1"=="cleanup" set "action=cleanup"
if "%1"=="status" set "action=status"

if "%action%"=="start" (
    call :stop_container
    call :build_and_run
    call :check_status
) else if "%action%"=="stop" (
    echo %YELLOW%🛑 Остановка сайта...%NC%
    call :stop_container
    echo %GREEN%✅ Сайт остановлен!%NC%
) else if "%action%"=="restart" (
    echo %YELLOW%🔄 Перезапуск сайта...%NC%
    call :stop_container
    call :build_and_run
    call :check_status
) else if "%action%"=="logs" (
    echo %BLUE%📋 Показать логи контейнера...%NC%
    docker-compose logs -f
) else if "%action%"=="cleanup" (
    call :stop_container
    call :cleanup_docker
    echo %GREEN%✅ Очистка завершена!%NC%
) else if "%action%"=="status" (
    docker ps | findstr stesh-portfolio >nul
    if %errorlevel% equ 0 (
        echo %GREEN%✅ Контейнер запущен%NC%
        call :check_status
    ) else (
        echo %RED%❌ Контейнер не запущен%NC%
    )
) else (
    echo %YELLOW%Использование: %0 {start^|stop^|restart^|logs^|cleanup^|status}%NC%
    echo.
    echo %BLUE%Команды:%NC%
    echo   %GREEN%start%NC%    - Собрать и запустить сайт ^(по умолчанию^)
    echo   %GREEN%stop%NC%     - Остановить сайт
    echo   %GREEN%restart%NC%  - Перезапустить сайт
    echo   %GREEN%logs%NC%     - Показать логи
    echo   %GREEN%cleanup%NC%  - Очистить Docker образы
    echo   %GREEN%status%NC%   - Проверить статус
    exit /b 1
)

pause

