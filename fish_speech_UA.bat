@echo off
setlocal enabledelayedexpansion

:: === Налаштування ===
set "INSTALL_DIR=D:\FishSpeech"
set "REPO_URL=https://huggingface.co/skypro1111/fish-speech-1.5-ukrainian"
set "ENV_NAME=venv"

:: === Створення директорії ===
echo [✔] Створення директорії: %INSTALL_DIR%
mkdir %INSTALL_DIR%
cd /d %INSTALL_DIR%

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
echo [✔] Клонування FishSpeech...
git lfs install
git clone %REPO_URL%
cd fish-speech-1.5-ukrainian
git lfs pull

:: === Створення віртуального середовища ===
echo [✔] Створення віртуального середовища...
cd /d %INSTALL_DIR%
python -m venv %ENV_NAME%
call %ENV_NAME%\Scripts\activate.bat

:: === Встановлення залежностей ===
echo [✔] Встановлення залежностей...
pip install --upgrade pip
pip install torch torchaudio transformers protobuf gradio

:: === Створення файлу app.py ===
echo [✔] Створення Gradio інтерфейсу...
cd fish-speech-1.5-ukrainian

echo import gradio as gr> app.py
echo import torch>> app.py
echo from fish_speech import FishSpeechModel>> app.py
echo import tempfile>> app.py

echo model = FishSpeechModel.load_from_checkpoint("model.pth")>> app.py
echo.>> app.py
echo def synthesize_speech(text):>> app.py
echo     audio = model.synthesize(text)>> app.py
echo     with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as fp:>> app.py
echo         model.save_audio(audio, fp.name)>> app.py
echo         return fp.name>> app.py
echo.>> app.py
echo iface = gr.Interface(^>> app.py
echo     fn=synthesize_speech,^>> app.py
echo     inputs=gr.Textbox(label="Введіть текст українською"),^>> app.py
echo     outputs=gr.Audio(label="Згенероване мовлення"),^>> app.py
echo     title="Fish Speech 1.5 — Українська TTS",^>> app.py
echo     description="Синтез мовлення українською мовою за допомогою FishSpeech."^>> app.py
echo )>> app.py
echo iface.launch()>> app.py

:: === Створення ярлика запуску ===
echo [✔] Створення ярлика запуску...
cd /d %INSTALL_DIR%
echo @echo off> FishSpeech_Gradio_Launcher.bat
echo call %INSTALL_DIR%\%ENV_NAME%\Scripts\activate.bat>> FishSpeech_Gradio_Launcher.bat
echo cd fish-speech-1.5-ukrainian>> FishSpeech_Gradio_Launcher.bat
echo python app.py>> FishSpeech_Gradio_Launcher.bat

:: === Запуск інтерфейсу ===
echo [🚀] Запуск Gradio...
call FishSpeech_Gradio_Launcher.bat
