#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${WORKSPACE:-/workspace}"
REPO_DIR="${LINGBOT_MAP_DIR:-$WORKSPACE/lingbot-map}"
MODEL_DIR="${MODEL_DIR:-$WORKSPACE/models}"
MODEL_PATH="${MODEL_PATH:-$MODEL_DIR/lingbot-map.pt}"

if ! command -v python >/dev/null 2>&1; then
  echo "Python is missing. Use a Linux GPU pod with Python 3.10 available." >&2
  exit 1
fi

mkdir -p "$WORKSPACE" "$MODEL_DIR" "$WORKSPACE/input" "$WORKSPACE/output"

if [ ! -d "$REPO_DIR/.git" ]; then
  git clone https://github.com/Robbyant/lingbot-map.git "$REPO_DIR"
else
  git -C "$REPO_DIR" pull --ff-only
fi

python -m pip install --upgrade pip
python -m pip install torch==2.8.0 torchvision==0.23.0 --index-url https://download.pytorch.org/whl/cu128
python -m pip install -e "$REPO_DIR[vis]"
python -m pip install --upgrade huggingface_hub

if [ ! -s "$MODEL_PATH" ]; then
  hf download robbyant/lingbot-map lingbot-map.pt --local-dir "$MODEL_DIR"
fi

if [ ! -s "$MODEL_PATH" ]; then
  echo "Checkpoint was not found at $MODEL_PATH. Check the official model repository's current filename." >&2
  exit 1
fi

python - <<'PY'
import torch
print("PyTorch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("GPU:", torch.cuda.get_device_name(0))
else:
    raise SystemExit("No CUDA GPU detected. Check that this pod has an NVIDIA GPU and a working CUDA runtime.")
PY

echo
echo "Setup complete."
echo "Upload your video to $WORKSPACE/input/campus.mov"
echo "Then run: VIDEO_PATH=$WORKSPACE/input/campus.mov bash reconstruction/run_cloud.sh"
