#!/usr/bin/env bash
set -euo pipefail
ROOT="${ROOT:-$HOME/mystery-protocol-reconstruction}"
REPO="$ROOT/lingbot-map"
ENV="$ROOT/.venv"
MODEL_PATH="${MODEL_PATH:-$ROOT/models/lingbot-map.pt}"
VIDEO_PATH="${VIDEO_PATH:-}"
OUTPUT_DIR="${OUTPUT_DIR:-$ROOT/output}"
FPS="${FPS:-2}"
WINDOW_SIZE="${WINDOW_SIZE:-128}"
OVERLAP_KEYFRAMES="${OVERLAP_KEYFRAMES:-8}"
FIRST_K="${FIRST_K:-120}"

if [ -z "$VIDEO_PATH" ] || [ ! -f "$VIDEO_PATH" ]; then
  echo "Set VIDEO_PATH to the actual campus video path accessible from WSL." >&2
  echo "Example: VIDEO_PATH=/mnt/c/Users/you/Videos/campus.mp4 bash reconstruction/run_local_wsl.sh" >&2
  exit 2
fi
if [ ! -s "$MODEL_PATH" ]; then
  echo "Model checkpoint missing: $MODEL_PATH" >&2
  echo "Run reconstruction/setup_local_wsl.sh first." >&2
  exit 2
fi
if [ ! -f "$REPO/demo_render/batch_demo.py" ]; then
  echo "Official LingBot-Map checkout missing: $REPO" >&2
  echo "Run reconstruction/setup_local_wsl.sh first." >&2
  exit 2
fi

source "$ENV/bin/activate"
mkdir -p "$OUTPUT_DIR"
cd "$REPO"
python - <<'PY'
import torch
print("CUDA available:", torch.cuda.is_available())
if not torch.cuda.is_available():
    raise SystemExit("CUDA is not visible in this WSL environment. Stop here; do not run inference on CPU.")
print("GPU:", torch.cuda.get_device_name(0))
print("VRAM (GiB):", round(torch.cuda.get_device_properties(0).total_memory / 1024**3, 2))
PY
ARGS=()
if [ "$FIRST_K" -gt 0 ]; then ARGS+=(--first_k "$FIRST_K"); fi
python demo_render/batch_demo.py \
  --video_path "$VIDEO_PATH" \
  --fps "$FPS" \
  --output_folder "$OUTPUT_DIR" \
  --model_path "$MODEL_PATH" \
  --mode windowed \
  --window_size "$WINDOW_SIZE" \
  --overlap_keyframes "$OVERLAP_KEYFRAMES" \
  --keyframe_interval 2 \
  --mask_sky \
  --use_sdpa \
  --save_glb \
  --no_render \
  "${ARGS[@]}"
echo "Files created under: $OUTPUT_DIR"
find "$OUTPUT_DIR" -maxdepth 3 -type f \( -name '*.glb' -o -name '*.npz' -o -name 'batch_results.json' \) -printf '%p (%s bytes)\n'
echo "If the short test is clean, rerun with FIRST_K=0 for the full video."
