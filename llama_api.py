import os
from fastapi import FastAPI, HTTPException
from llama_cpp import Llama

# Automatically find the first .gguf model in the models/ folder
MODEL_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models")
gguf_models = [f for f in os.listdir(MODEL_DIR) if f.endswith(".gguf")]

if not gguf_models:
    raise FileNotFoundError(f"No .gguf model found in {MODEL_DIR}")

MODEL_PATH = os.path.join(MODEL_DIR, gguf_models[0])

llm = Llama(model_path=MODEL_PATH)

app = FastAPI()

@app.get("/")
def read_root():
    return {"message": f"LlamaCPP API is running with model {gguf_models[0]}"}

@app.get("/generate")
def generate(prompt: str):
    try:
        output = llm(prompt, max_tokens=100)
        return {"prompt": prompt, "output": output['choices'][0]['text']}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
