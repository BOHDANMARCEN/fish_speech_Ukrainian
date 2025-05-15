@echo off
setlocal enabledelayedexpansion

:: === Налаштування ===
set "INSTALL_DIR=%~dp0"
set "ENV_NAME=venv"

:: === Перевірка Python ===
where python >nul 2>nul || (
    echo [✘] Python не знайдено. Встановіть Python і перезапустіть скрипт.
    pause
    exit /b
)

:: === Перевірка Git ===
where git >nul 2>nul || (
    echo [✘] Git не знайдено. Встановіть Git і перезапустіть скрипт.
    pause
    exit /b
)

:: === Клонування репозиторію ===
cd /d %INSTALL_DIR%
git lfs install
git clone https://huggingface.co/skypro1111/fish-speech-1.5-ukrainian
cd fish-speech-1.5-ukrainian
git lfs pull

:: === Створення віртуального середовища ===
cd /d %INSTALL_DIR%
python -m venv %ENV_NAME%
call %ENV_NAME%\Scripts\activate.bat

:: === Встановлення залежностей ===
pip install --upgrade pip
pip install torch torchaudio transformers protobuf gradio

:: === Запуск інтерфейсу ===
cd fish-speech-1.5-ukrainian
python app.py
