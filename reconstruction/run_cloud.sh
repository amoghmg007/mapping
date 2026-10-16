#!/usr/bin/env bash
set -euo pipefail

WORKSPACE="${WORKSPACE:-/workspace}"
LINGBOT_MAP_DIR="${LINGBOT_MAP_DIR:-$WORKSPACE/lingbot-map}"
MODEL_PATH="${MODEL_PATH:-$WORKSPACE/models/lingbot-map.pt}"
VIDEO_PATH="${VIDEO_PATH:-$WORKSPACE/input/campus.mov}"
OUTPUT_DIR="${OUTPUT_DIR:-$WORKSPACE/output}"
FPS="${FPS:-2}"
WINDOW_SIZE="${WINDOW_SIZE:-128}"
OVERLAP_KEYFRAMES="${OVERLAP_KEYFRAMES:-8}"

if [ ! -f "$VIDEO_PATH" ]; then
  echo "Video not found: $VIDEO_PATH" >&2
  echo "Upload the campus walkthrough video to the pod, then set VIDEO_PATH." >&2
  exit 2
fi
if [ ! -s "$MODEL_PATH" ]; then
  echo "Model checkpoint not found: $MODEL_PATH" >&2
  echo "Run reconstruction/setup_cloud.sh first." >&2
  exit 2
fi
if [ ! -f "$LINGBOT_MAP_DIR/demo_render/batch_demo.py" ]; then
  echo "Official LingBot-Map checkout not found at $LINGBOT_MAP_DIR" >&2
  echo "Run reconstruction/setup_cloud.sh first." >&2
  exit 2
fi

mkdir -p "$OUTPUT_DIR"
cd "$LINGBOT_MAP_DIR"

# Use the official offline pipeline's GLB export. --no_render skips the
# optional CUDA-heavy fly-through renderer; --save_glb retains the geometry.
# SDPA avoids making FlashInfer a hard setup requirement.
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
  --no_render

echo
echo "Reconstruction run finished. Inspect the output directory:"
find "$OUTPUT_DIR" -maxdepth 2 -type f \( -name '*.glb' -o -name 'batch_results.json' \) -printf '%p (%s bytes)\n'
echo "If the GLB is usable, copy it to reconstruction/campus-reconstruction.glb for local preview."
