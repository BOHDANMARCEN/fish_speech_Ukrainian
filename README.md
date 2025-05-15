# 🐟 Fish Speech 1.5 — Українська TTS

**Fish Speech 1.5** — це модель синтезу мовлення (Text-to-Speech), адаптована для української мови. Вона дозволяє перетворювати текст на натуральне звучання голосу за допомогою простого Gradio-інтерфейсу.

## 🌟 Можливості

* 🎙️ Синтез українського тексту в мовлення
* 💡 Простий веб-інтерфейс на базі Gradio
* 📆 Працює локально, без потреби в API

## 📁 Структура проєкту

```
fish-speech-1.5-ukrainian/
🔌📄 app.py               # Gradio-інтерфейс
🔌📄 model.pth            # Ваги TTS-моделі
🔌📄 tokenizer.tiktoken   # Токенізатор
🔌📄 config.json          # Конфігураційний файл
🔌📄 firefly-gan-*.pth    # Генератор ( якщо використовується )
```

## 🚀 Швидкий старт

### 1. Клонування репозиторію

```bash
git lfs install
git clone https://huggingface.co/skypro1111/fish-speech-1.5-ukrainian
cd fish-speech-1.5-ukrainian
git lfs pull
```

### 2. Встановлення залежностей

Рекомендується використовувати віртуальне середовище:

```bash
python -m venv venv
venv\Scripts\activate       # Windows
# або
source venv/bin/activate    # Linux/macOS

pip install --upgrade pip
pip install torch torchaudio transformers gradio protobuf
```

### 3. Запуск Gradio-інтерфейсу

```bash
python app.py
```

Після запуску відкриється веб-інтерфейс у браузері, де можна ввести текст українською мовою та прослухати результат.

## 🧠 Код `app.py`

```python
import gradio as gr
import torch
from fish_speech import FishSpeechModel
import tempfile

model = FishSpeechModel.load_from_checkpoint("model.pth")

def synthesize_speech(text):
    audio = model.synthesize(text)
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as fp:
        model.save_audio(audio, fp.name)
        return fp.name

iface = gr.Interface(
    fn=synthesize_speech,
    inputs=gr.Textbox(label="Введіть текст українською"),
    outputs=gr.Audio(label="Згенероване мовлення"),
    title="Fish Speech 1.5 — Українська TTS",
    description="Синтез мовлення українською мовою за допомогою FishSpeech."
)

iface.launch()
```

## ⚠️ Можливі проблеми

| Помилка                                                                  | Причина                          | Рішення                                                          |
| ------------------------------------------------------------------------ | -------------------------------- | ---------------------------------------------------------------- |
| `ImportError: cannot import name 'FishSpeechModel'`                      | Модуль `fish_speech` не знайдено | Перевірте структуру проєкту або реалізуйте відповідний клас      |
| `AttributeError: 'FishSpeechModel' object has no attribute 'synthesize'` | Інша назва функції               | Перевірте назву методу у вихідному коді                          |
| `.wav` не зберігається                                                   | Метод `save_audio` відсутній     | Використайте `torchaudio.save(...)` замість `model.save_audio()` |

## 🛠 ️ Автоінсталяція (Windows)

Є `.bat` скрипт, який:

* Встановлює всі залежності
* Клонує модель
* Створює Gradio-інтерфейс
* Створює ярлик запуску

🔗 [Докладніше в інструкції](#)

## 📄 Ліцензія

Цей проєкт призначений для дослідницьких та некомерційних цілей. Усі права на модель належа
