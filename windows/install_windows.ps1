# PowerShell installation script for Sweeta
Write-Host "====================================" -ForegroundColor Cyan
Write-Host "  Sweeta Installation" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check for Conda
try {
    $condaVersion = conda --version
    Write-Host "Conda detected: $condaVersion" -ForegroundColor Green
}
catch {
    Write-Host "Conda is not installed or is not in the PATH." -ForegroundColor Red
    Write-Host "Please install Miniconda or Anaconda before continuing." -ForegroundColor Red
    Write-Host "Download it from: https://docs.conda.io/en/latest/miniconda.html" -ForegroundColor Yellow
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host "Checking environment..."

# Check if environment exists
$envExists = conda env list | Select-String "py312aiwatermark"
if ($envExists) {
    Write-Host "The py312aiwatermark environment already exists." -ForegroundColor Yellow
    $recreate = Read-Host "Do you want to recreate it? (y/n)"
    if ($recreate -eq "y" -or $recreate -eq "Y") {
        Write-Host "Removing old environment..." -ForegroundColor Yellow
        conda env remove -n py312aiwatermark
    }
    else {
        Write-Host "Activating existing environment..." -ForegroundColor Green
        $activateEnv = $true
    }
}

if (-not $activateEnv) {
    Write-Host "Creating conda environment from environment.yml file..." -ForegroundColor Cyan
    conda env create -f environment.yml
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Error creating environment." -ForegroundColor Red
        Read-Host -Prompt "Press Enter to exit"
        exit 1
    }
}

Write-Host "Activating py312aiwatermark environment..." -ForegroundColor Cyan
# In PowerShell, we need to use a different approach
# to activate the environment within the script itself
$condaPath = (Get-Command conda).Source
$condaExe = Split-Path -Parent $condaPath
$activateScript = Join-Path $condaExe "..\..\shell\condabin\conda-hook.ps1"
. $activateScript
conda activate py312aiwatermark

Write-Host "Installing additional dependencies..." -ForegroundColor Cyan
pip install PyQt6 transformers opencv-python-headless "pydantic<2.0.0"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error installing dependencies." -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host "Installing compatible huggingface-hub version..." -ForegroundColor Cyan
pip install "huggingface-hub<0.20"
if ($LASTEXITCODE -ne 0) {
    Write-Host "Warning: Error installing huggingface-hub." -ForegroundColor Yellow
}

Write-Host "Installing iopaint..." -ForegroundColor Cyan
pip install iopaint
if ($LASTEXITCODE -ne 0) {
    Write-Host "Error installing iopaint." -ForegroundColor Red
    Read-Host -Prompt "Press Enter to exit"
    exit 1
}

Write-Host "Downloading LaMA model..." -ForegroundColor Cyan
iopaint download --model lama
if ($LASTEXITCODE -ne 0) {
    Write-Host "Warning: Error downloading LaMA model." -ForegroundColor Yellow
    Write-Host "You can retry later with the command: iopaint download --model lama" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "===============================" -ForegroundColor Green
Write-Host "  Installation complete!" -ForegroundColor Green
Write-Host "===============================" -ForegroundColor Green
Write-Host ""
Write-Host "To launch the application:" -ForegroundColor Cyan
Write-Host "1. Open a PowerShell command prompt" -ForegroundColor Cyan
Write-Host "2. Activate the environment: conda activate py312aiwatermark" -ForegroundColor Cyan
Write-Host "3. Launch the application: python remwmgui.py" -ForegroundColor Cyan
Write-Host ""

$launch = Read-Host "Do you want to launch the application now? (y/n)"
if ($launch -eq "y" -or $launch -eq "Y") {
    Write-Host "Launching application..." -ForegroundColor Green
    python remwmgui.py
}

Write-Host ""
Read-Host -Prompt "Press Enter to exit" 