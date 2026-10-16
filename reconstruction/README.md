# Mystery Protocol — real campus reconstruction

This workflow uses the official [Robbyant/LingBot-Map](https://github.com/Robbyant/lingbot-map) model on a cloud GPU to reconstruct geometry from the Brindavan College campus walkthrough video. It produces a GLB asset that can be inspected in the included viewer.

## Important distinction

The current game map's OSM buildings are map-footprint extrusions. LingBot-Map reconstructs geometry from the actual camera video; it does **not** automatically produce a survey-grade, georeferenced campus map. First inspect the reconstruction, then align it to known campus reference points before using GPS checkpoints in the same world. Do not replace the game map with an unaligned model.

## 1. Cloud GPU setup

Create a Linux GPU pod with a CUDA-capable NVIDIA GPU and enough VRAM for the model. Persistent storage is recommended. Upload the campus video to the pod, for example:

`/workspace/input/campus.mov`

From the root of this repository, run the setup script:

```bash
bash reconstruction/setup_cloud.sh
```

The script clones the official model repository and downloads the balanced checkpoint from its official Hugging Face repository. Model weights and video stay on the pod and are not committed to GitHub.

## 2. Run the campus video

```bash
VIDEO_PATH=/workspace/input/campus.mov bash reconstruction/run_cloud.sh
```

Defaults are intentionally conservative: 2 sampled frames/second, windowed inference, sky masking, and GLB export without the optional offline fly-through renderer. You can adjust sampling and output paths:

```bash
VIDEO_PATH=/workspace/input/campus.mov FPS=3 OUTPUT_DIR=/workspace/output bash reconstruction/run_cloud.sh
```

Expected output is a GLB under `/workspace/output`, along with inference metadata. A long or shaky video may still need shorter segments and manual cleanup. The model can reconstruct only what is visible; it cannot infer unseen interiors or exact building dimensions.

## 3. Preview the GLB

Copy the generated GLB to `reconstruction/campus-reconstruction.glb` and serve this repository over HTTP (not `file://`). Open `reconstruction/viewer.html`. The viewer loads the GLB, frames it automatically, and supports orbit, pan, and zoom.

Do not commit large generated model files to the repository. For deployment, host the GLB as a release asset or object-storage file and point the viewer at that URL.

## 4. Before connecting it to gameplay

1. Check for drift, duplicated surfaces, missing facades, and moving people/vehicles.
2. Capture or mark at least three non-collinear known campus reference points.
3. Estimate scale, rotation, and translation between the reconstruction and the campus coordinate frame.
4. Validate the transform against additional points before placing QR checkpoints.
5. Keep GPS checkpoints disabled until the alignment error is acceptable.

For the official model's full options and licensing, consult the upstream [LingBot-Map README](https://github.com/Robbyant/lingbot-map#readme).
