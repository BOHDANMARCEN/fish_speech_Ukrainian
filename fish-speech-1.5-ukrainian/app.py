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
