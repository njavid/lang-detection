import os
from fastapi import FastAPI

app = FastAPI()

# Verify Kaldi environment is loaded
@app.get("/kaldi-path")
def get_kaldi_path():
    kaldi_root = os.getenv("KALDI_ROOT")
    if not kaldi_root:
        return {"error": "KALDI_ROOT is not set"}
    return {"kaldi_root": kaldi_root}

@app.get("/")
def read_root():
    return {"message": "FastAPI with Kaldi is running!"}
