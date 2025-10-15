# Troubleshooting Guide for Sweeta

This document addresses common issues users encounter when installing and running Sweeta.

## Table of Contents
1. [Installation Issues](#installation-issues)
2. [Runtime Errors](#runtime-errors)
3. [GPU/CUDA Issues](#gpucuda-issues)
4. [Performance Issues](#performance-issues)

---

## Installation Issues

### Pydantic Version Compatibility Error

**Error Message:**
```
AttributeError: 'pydantic_core._pydantic_core.ValidationInfo' object has no attribute 'sd_seed'
```

**Cause:** IOPaint library requires Pydantic v1.x but Pydantic v2.x is installed by default.

**Solution:**
```bash
conda activate py312aiwatermark
pip install "pydantic<2.0.0"
```

**Prevention:** Use the provided installation scripts which automatically install the correct version.

---

### Hugging Face Hub Import Error

**Error Message:**
```
ImportError: cannot import name 'cached_download' from 'huggingface_hub'
```

**Cause:** Incompatible version of huggingface-hub.

**Solution:**
```bash
conda activate py312aiwatermark
pip install "huggingface-hub<0.20"
pip install --upgrade iopaint
```

---

### Conda Not Found

**Error Message:**
```
'conda' is not recognized as an internal or external command
```

**Solution:**
1. Verify Conda is installed: [Download Miniconda](https://docs.conda.io/en/latest/miniconda.html)
2. Add Conda to PATH:
   - **Windows:** Add `C:\Users\<YourUsername>\miniconda3\Scripts` to System PATH
   - **Linux/Mac:** Add to `~/.bashrc` or `~/.zshrc`:
     ```bash
     export PATH="$HOME/miniconda3/bin:$PATH"
     ```
3. Restart your terminal/command prompt

---

## Runtime Errors

### Video Processing Crashes

**Symptoms:** Application crashes when processing videos with error code 1.

**Common Causes:**
1. Pydantic version incompatibility (see above)
2. Missing FFmpeg for audio processing
3. Insufficient memory

**Solutions:**

1. **Fix Pydantic version:**
   ```bash
   pip install "pydantic<2.0.0"
   ```

2. **Install FFmpeg:**
   - **Windows:** Download from [ffmpeg.org](https://ffmpeg.org/download.html) and add to PATH
   - **Linux:** `sudo apt-get install ffmpeg` (Ubuntu/Debian)
   - **Mac:** `brew install ffmpeg`

3. **Verify FFmpeg installation:**
   ```bash
   ffmpeg -version
   ```

---

### LaMA Model Download Fails

**Error Message:**
```
Error downloading LaMA model
```

**Solutions:**
1. Check internet connection
2. Retry download manually:
   ```bash
   conda activate py312aiwatermark
   iopaint download --model lama
   ```
3. Check firewall/proxy settings
4. Try downloading from a different network

**Manual Download Location:**
The model is cached at: `~/.cache/torch/hub/checkpoints/big-lama.pt`

---

## GPU/CUDA Issues

### GPU Not Detected (Shows "Using device: cpu")

**Symptoms:** Despite having an NVIDIA GPU (e.g., RTX 3060 Ti), the application uses CPU.

**Diagnosis:**
```bash
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}'); print(f'CUDA version: {torch.version.cuda}')"
```

**Solutions:**

1. **Check NVIDIA drivers:**
   ```bash
   nvidia-smi
   ```
   If this fails, update your NVIDIA drivers.

2. **Reinstall PyTorch with CUDA support:**
   
   First, check your CUDA version with `nvidia-smi` (top right corner).
   
   Then uninstall current PyTorch:
   ```bash
   pip uninstall torch torchvision torchaudio
   ```
   
   For **CUDA 11.8**:
   ```bash
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
   ```
   
   For **CUDA 12.1**:
   ```bash
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
   ```
   
   For **CUDA 12.4**:
   ```bash
   pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124
   ```

3. **Verify CUDA is now available:**
   ```bash
   python -c "import torch; print(f'CUDA: {torch.cuda.is_available()}'); print(f'Device: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"CPU\"}')"
   ```

---

### FutureWarning: torch.cuda.amp.autocast deprecated

**Warning Message:**
```
FutureWarning: torch.cuda.amp.autocast(args...) is deprecated. Please use torch.amp.autocast('cuda', args...) instead.
```

**Impact:** This is just a warning from the IOPaint library. It does not affect functionality.

**Note:** This warning comes from the IOPaint dependency and will be fixed in future versions of IOPaint. You can safely ignore it.

---

## Performance Issues

### Slow Processing Speed

**Symptoms:** Very slow frame processing, especially on CPU.

**Solutions:**

1. **Enable GPU (see GPU/CUDA Issues above)**
   - GPU processing is 10-50x faster than CPU

2. **Reduce video resolution:**
   - Resize videos before processing
   - Use lower quality source videos for testing

3. **Adjust detection sensitivity:**
   - Use `--max-bbox-percent` with higher values for faster detection
   - Example: `--max-bbox-percent=15` (default is 10)

4. **Close other applications:**
   - Free up RAM and VRAM
   - Monitor resource usage in Task Manager/System Monitor

---

### Out of Memory Errors

**Error Message:**
```
CUDA out of memory
```

**Solutions:**

1. **Process smaller videos:**
   - Split long videos into shorter segments
   - Reduce video resolution

2. **Free VRAM:**
   - Close other GPU-intensive applications
   - Restart the application

3. **Process on CPU (slower but uses RAM instead):**
   - The application will automatically fall back to CPU if needed

---

## Additional Help

### Check System Information

Run this script to check your system configuration:

```python
import torch
import sys
import platform

print(f"Python version: {sys.version}")
print(f"Platform: {platform.platform()}")
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"CUDA version: {torch.version.cuda}")
    print(f"GPU: {torch.cuda.get_device_name(0)}")
    print(f"GPU Memory: {torch.cuda.get_device_properties(0).total_memory / 1024**3:.2f} GB")
```

### Getting Support

If none of these solutions work:

1. Check existing [GitHub Issues](https://github.com/Kuberwastaken/sweeta/issues)
2. Create a new issue with:
   - Full error message
   - System information (from script above)
   - Steps to reproduce
   - Screenshots if applicable

### Contact

- **Twitter/X:** [@Kuberwastaken](https://x.com/Kuberwastaken)
- **LinkedIn:** [Kuber Mehta](https://www.linkedin.com/in/kubermehta/)
- **Website:** [kuber.studio](https://kuber.studio/)

---

## Quick Fix Checklist

- [ ] Install correct Pydantic version: `pip install "pydantic<2.0.0"`
- [ ] Install correct Hugging Face Hub: `pip install "huggingface-hub<0.20"`
- [ ] Install PyTorch with CUDA support
- [ ] Install FFmpeg for video processing
- [ ] Download LaMA model: `iopaint download --model lama`
- [ ] Verify GPU is detected: `python -c "import torch; print(torch.cuda.is_available())"`
- [ ] Close other GPU applications to free VRAM
- [ ] Update NVIDIA drivers if using GPU

---

**Last Updated:** October 2025
