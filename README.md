<div align="center">

# Sweeta

### Remove Watermarks from SORA 2 Video Generations

[![License](https://img.shields.io/badge/License-Apache%202.0-pink.svg)](LICENSE)
[![Python](https://img.shields.io/badge/Python-3.12-pink.svg)](https://www.python.org/)
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/Kuberwastaken/sweeta/blob/main/colab_file/Sweeta_Colab.ipynb)

<img width="1280" height="720" alt="image" src="https://github.com/user-attachments/assets/8347f5f1-49e3-47d7-a3f7-b5f3e390ee5b" />

</div>

## About

SORA 2 is a State-of-the-art model by OpenAI and for the past few days, being on platforms like Instagram and Twitter, I've noticed how many non-technical people just assume the video is real despite the watermark.

Think what would happen if there was no watermark?
This is the reason that this project exists. It's not to abuse the great initiative by OpenAI to put logos onto every generation (though temporarily there's also an easy way to bypass that which I wouldn't cover), it's to hopefully encourage them to be harsher and more obvious with it in some form.

Sweeta is an AI-powered watermark removal tool specifically designed for SORA 2 video generations. It Uses advanced inpainting models (LaMA) and intelligent detection algorithms, it can seamlessly remove watermarks while (mostly) preserving the original image quality.

---
### Recommended Specs:
- **OS**: Windows 11, macOS 12+, or Ubuntu 20.04+
- **RAM**: 16GB or more
- **Storage**: 10GB free space
- **GPU**: NVIDIA GPU with 4GB+ VRAM (or Apple Silicon for macOS)
- **CPU**: Multi-core processor (Intel i5/AMD Ryzen 5/Apple M1 or better)

---

## Installation

### Prerequisites

1. **Python & Conda**: Install [Miniconda](https://docs.conda.io/en/latest/miniconda.html) (recommended) or Anaconda

### Windows

#### Quick Install (Recommended)

1. Open Command Prompt or PowerShell as administrator
2. Navigate to the project folder
3. Run the installation script:
   ```cmd
   cd path\to\Sweeta
   windows\install_windows.bat
   ```
   
   Or for PowerShell:
   ```powershell
   powershell -ExecutionPolicy Bypass -File windows\install_windows.ps1
   ```

4. Follow the on-screen instructions

#### Manual Installation

```powershell
# Create the conda environment
conda env create -f environment.yml

# Activate the environment
conda activate py312aiwatermark

# Install additional dependencies (including required version pins)
pip install PyQt6 transformers iopaint opencv-python-headless "pydantic<2.0.0"

# Download the LaMA model
iopaint download --model lama
```

**Alternative: Using requirements.txt**
```powershell
conda create -n py312aiwatermark python=3.12
conda activate py312aiwatermark
pip install -r requirements.txt
iopaint download --model lama
```

### Linux

```bash
# Navigate to the project directory
cd /path/to/Sweeta

# Run the setup script
bash unix/setup.sh

# Or manually:
conda env create -f environment.yml
conda activate py312aiwatermark
pip install PyQt6 transformers iopaint opencv-python-headless "pydantic<2.0.0"
iopaint download --model lama
```

**Alternative: Using requirements.txt**
```bash
conda create -n py312aiwatermark python=3.12
conda activate py312aiwatermark
pip install -r requirements.txt
iopaint download --model lama
```

### Colab

Access the Colab notebook from [here](https://colab.research.google.com/github/Kuberwastaken/sweeta/blob/main/colab_file/Sweeta_Colab.ipynb) and follow the instructions.

---

## Usage

### Launching the Application

#### GUI Mode (Recommended)

1. Activate the conda environment:
   ```bash
   conda activate py312aiwatermark
   ```

2. Launch the GUI application:
   ```bash
   python remwmgui.py
   ```

(would be happy to prepare a hugging face port for Spaces too, which would technically be better but would require community GPU access)

#### Command Line Mode

```bash
conda activate py312aiwatermark
python remwm.py <input_path> <output_path> [options]
```

**Example:**
```bash
python remwm.py input_video.mp4 output_video.mp4 --max-bbox-percent 15 --force-format MP4 --transparent --overwrite
```

**Available options:**
- `--max-bbox-percent`: Detection sensitivity (default: 10.0)
- `--force-format`: Output format (PNG, WEBP, JPG, MP4, AVI)
- `--transparent`: Make watermark areas transparent
- `--overwrite`: Overwrite existing files

### Configuration Edit

Refer #ui.yml.example

**Configuration Options**
   - **Input Path**: Select your source file or folder
   - **Output Path**: Choose where to save processed files
   - **Overwrite Files**: Enable to replace existing output files
   - **Transparent Watermarks**: Make watermark areas transparent (PNG only)
   - **Max BBox Percent**: Adjust detection sensitivity (1-100%)
   - **Output Format**: Choose PNG, WEBP, JPG, or keep original format

## 🔧 Troubleshooting

For detailed troubleshooting steps, see **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)**.

### Common Issues

#### AttributeError: 'ValidationInfo' object has no attribute 'sd_seed'
**Solution**: This is a Pydantic version incompatibility issue. The installation scripts now automatically install the correct version. If you installed manually, run:
```bash
pip install "pydantic<2.0.0"
```

#### ImportError: cannot import name 'cached_download' from 'huggingface_hub'
**Solution**: This is a version compatibility issue. The installation scripts now automatically install the correct version. If you installed manually, run:
```bash
pip install "huggingface-hub<0.20"
pip install --upgrade iopaint
```

#### GPU Not Detected (Shows "Using device: cpu")
**Solution**: Install PyTorch with CUDA support. First, uninstall existing PyTorch:
```bash
pip uninstall torch torchvision torchaudio
```
Then reinstall with CUDA support (for CUDA 11.8):
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
```
Or for CUDA 12.1:
```bash
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
```
Verify CUDA is available:
```bash
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
```

#### "Conda is not recognized as an internal or external command"
**Solution**: Ensure Conda is properly installed and added to your system PATH environment variable.

#### Dependency Installation Failures
**Solution**: Try installing dependencies individually:
```bash
pip install PyQt6
pip install transformers
pip install iopaint
pip install opencv-python-headless
pip install "pydantic<2.0.0"
```

#### Application Won't Start
**Solution**: Verify the environment is activated:
```bash
conda activate py312aiwatermark
python --version  # Should show Python 3.12.x
```

#### LaMA Model Download Issues
**Solution**: Ensure stable internet connection and retry:
```bash
iopaint download --model lama
```

#### CUDA/GPU Issues (Legacy)
**Solution**: Install PyTorch with CUDA support:
```bash
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu118
```

If you run into any issues or have something to say, reach out! I'd be happy to talk :)
[Twitter](https://x.com/Kuberwastaken), [LinkedIn](https://www.linkedin.com/in/kubermehta/)

---

I (tired to) microblog the development process in #journal.md but uh, read it at your own risk lol
Will put out a blog or something similiar too.

---

## 📄 License & Disclaimer

### License

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.
Thanks to D-Ogi for the WatermarkRemover-AI model which was heavily modified for this project.

### ⚠️ Important Disclaimer

**THIS SOFTWARE IS PROVIDED FOR EDUCATIONAL AND RESEARCH PURPOSES ONLY.**
**Use this tool responsibly and ethically.**

---

<div align="center">

Made with <3 by [Kuber Mehta](https://kuber.studio/)

Star this repo if you found it cool

</div>
