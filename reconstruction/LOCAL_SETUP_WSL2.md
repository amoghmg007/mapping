# Mystery Protocol — local LingBot-Map setup (Windows + WSL2)

This is the local-first route. No RunPod or Colab is required. It uses the official [Robbyant/LingBot-Map](https://github.com/Robbyant/lingbot-map) repository and balanced checkpoint.

## Before starting

- Windows 11 (recommended) with current NVIDIA drivers.
- Ubuntu 22.04 or 24.04 installed through WSL2.
- Free disk space for the Python environment, model weights, cached frames, and outputs.
- Your campus walkthrough video available on a Windows drive.

**GPU note:** The laptop RTX 5050 should be usable only if its NVIDIA driver exposes CUDA to WSL2. Do not assume it is working until nvidia-smi and the Python CUDA check both succeed. Fix the driver/runtime before downloading the full model.

## 1. Enable WSL2 (PowerShell as Administrator)

If WSL2 is not installed, run:

~~~powershell
wsl --install -d Ubuntu-22.04
~~~

Restart if Windows asks, open Ubuntu, and create your Linux username/password. In Ubuntu run:

~~~bash
nvidia-smi
~~~

If that command fails, update the NVIDIA Windows driver that supports CUDA on WSL and run wsl --update from PowerShell, then restart WSL with wsl --shutdown.

## 2. Run the setup script

From Ubuntu (WSL):

~~~bash
git clone https://github.com/amoghmg007/mapping.git
cd mapping
bash reconstruction/setup_local_wsl.sh
~~~

The script installs Python 3.10, PyTorch 2.8.0 + CUDA 12.8, LingBot-Map visualization/render dependencies, matching Kaolin, renderer extensions, and the official model checkpoint. The first install can take a while.

If Ubuntu cannot find Python 3.10 packages, use Ubuntu 22.04 or install Python 3.10 before continuing. Do not blindly substitute a different PyTorch version: the batch renderer's Kaolin wheel is version-specific.

## 3. Set your campus video path

For example, a video at C:\Users\YOUR_WINDOWS_USER\Videos\campus.mp4 is accessible in WSL at:

~~~text
/mnt/c/Users/YOUR_WINDOWS_USER/Videos/campus.mp4
~~~

Keep the actual video out of Git. Run the command below, replacing the example path with your real path. Start with a short representative clip before processing the whole walkthrough.

~~~bash
VIDEO_PATH=/mnt/c/Users/YOUR_WINDOWS_USER/Videos/campus.mp4 bash reconstruction/run_local_wsl.sh
~~~

The first run uses a smoke-test limit of 120 sampled frames. If that succeeds and the geometry looks useful, rerun the full video with FIRST_K=0:

~~~bash
VIDEO_PATH=/mnt/c/Users/YOUR_WINDOWS_USER/Videos/campus.mp4 FIRST_K=0 bash reconstruction/run_local_wsl.sh
~~~

## 4. Inspect output

Results are written to ~/mystery-protocol-reconstruction/output. Check batch_results.json and the terminal log; do not assume a GLB was created just because the process exits.

LingBot-Map estimates geometry and camera trajectory from what the camera sees. The result can contain drift, holes, floating geometry, and incomplete hidden surfaces. It is **not automatically a complete, accurately scaled or GPS-aligned campus model**.

Once a usable asset exists:
1. Inspect it in the included viewer.html.
2. If GLB export fails, preserve the saved predictions/logs and diagnose that exact error instead of rerunning the whole video.
3. Align the reconstruction to known campus reference points before using it for Mystery Protocol navigation/checkpoints.

Official upstream installation and renderer notes: [LingBot-Map README](https://github.com/Robbyant/lingbot-map#readme). The renderer uses a matching PyTorch/Kaolin combination and CUDA extensions, so setup is more involved than installing a normal Python package.
