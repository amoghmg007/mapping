# Mystery Protocol — real 3D campus reconstruction

Local-first workflow for reconstructing Brindavan College of Engineering from a campus walkthrough video using the official [Robbyant/LingBot-Map](https://github.com/Robbyant/lingbot-map) model. It aims to produce a GLB for inspection in the included viewer.

## Start here: local Windows laptop with WSL2

Follow [LOCAL_SETUP_WSL2.md](LOCAL_SETUP_WSL2.md). The scripts are committed:
- `setup_local_wsl.sh`: installs a compatible Python/CUDA environment and downloads the official checkpoint.
- `run_local_wsl.sh`: runs a conservative 120-frame smoke test before attempting the full walkthrough.
- `viewer.html`: previews the resulting GLB with orbit, pan, and zoom.

No paid cloud GPU is required for this path. GPU visibility in WSL2 must be verified first with `nvidia-smi` and PyTorch's CUDA check. Keep model weights, the campus video, and generated outputs outside Git.

## Alternative: cloud GPU

If local GPU memory or dependencies block reconstruction, use the optional cloud scripts:
1. Provision a Linux NVIDIA GPU pod with persistent storage.
2. Upload the video as `/workspace/input/campus.mov`.
3. Run `bash reconstruction/setup_cloud.sh`.
4. Run `VIDEO_PATH=/workspace/input/campus.mov bash reconstruction/run_cloud.sh`.

## Important limitations

LingBot-Map estimates geometry and camera trajectory from what the camera sees. It may produce drift, holes, floating surfaces, or incomplete facades; it cannot infer hidden interiors or guarantee exact dimensions. Its output is **not automatically a survey-grade or GPS-aligned campus map**.

Before using the reconstruction for GPS checkpoints:
1. Inspect the geometry and camera trajectory.
2. Mark at least three non-collinear known campus reference points.
3. Estimate scale, rotation, and translation into the campus coordinate frame.
4. Validate alignment against additional points.
5. Keep GPS-based gameplay checkpoints disabled until alignment error is acceptable.

Do not commit large GLB/NPZ outputs, model weights, or private video footage to the repository. For deployment, host the GLB as a release asset or object-storage file and configure the viewer to load that URL.

Official upstream installation and licensing notes: [LingBot-Map README](https://github.com/Robbyant/lingbot-map#readme).
