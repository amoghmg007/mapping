#!/usr/bin/env bash
set -euo pipefail
ROOT="${ROOT:-$HOME/mystery-protocol-reconstruction}"
REPO="$ROOT/lingbot-map"
ENV="$ROOT/.venv"
MODEL_DIR="$ROOT/models"
MODEL="$MODEL_DIR/lingbot-map.pt"

sudo apt-get update
sudo apt-get install -y git ffmpeg build-essential python3.10 python3.10-venv python3.10-dev
mkdir -p "$ROOT" "$MODEL_DIR"
if [ ! -d "$REPO/.git" ]; then
  git clone https://github.com/Robbyant/lingbot-map.git "$REPO"
else
  git -C "$REPO" pull --ff-only
fi
python3.10 -m venv "$ENV"
source "$ENV/bin/activate"
python -m pip install --upgrade pip setuptools wheel
python -m pip install torch==2.8.0 torchvision==0.23.0 --index-url https://download.pytorch.org/whl/cu128
cd "$REPO"
python -m pip install -e ".[vis,render]"
python -m pip install --index-url https://pypi.org/simple kaolin -f https://nvidia-kaolin.s3.us-east-2.amazonaws.com/torch-2.8.0_cu128.html
python -m pip install onnxruntime-gpu
cd "$REPO/demo_render/render_cuda_ext"
python setup.py build_ext --inplace
python -m pip install --upgrade huggingface_hub
hf download robbyant/lingbot-map lingbot-map.pt --local-dir "$MODEL_DIR"
python - <<'PY'
import torch
print("PyTorch:", torch.__version__)
print("CUDA runtime:", torch.version.cuda)
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("GPU:", torch.cuda.get_device_name(0))
else:
    raise SystemExit("CUDA is not visible inside WSL. Update the NVIDIA Windows driver and WSL, then verify nvidia-smi inside Ubuntu.")
PY
echo "Setup complete. Environment: $ENV"
echo "Model: $MODEL"
