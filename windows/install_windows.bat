@echo off
echo ==================================
echo  Sweeta Installation
echo ==================================
echo.

REM Check for Conda installation
where conda >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Conda is not installed or is not in the PATH.
    echo Please install Miniconda or Anaconda before continuing.
    echo Download it from: https://docs.conda.io/en/latest/miniconda.html
    pause
    exit /b 1
)

echo Conda detected. Checking environment...
echo.

REM Check if environment exists
conda env list | findstr /C:"py312aiwatermark" >nul
if %ERRORLEVEL% EQU 0 (
    echo The py312aiwatermark environment already exists.
    choice /C YN /M "Do you want to recreate it? (Y/N)"
    if %ERRORLEVEL% EQU 1 (
        echo Removing old environment...
        call conda env remove -n py312aiwatermark
    ) else (
        echo Activating existing environment...
        goto ACTIVATION
    )
)

echo Creating conda environment from environment.yml file...
call conda env create -f environment.yml
if %ERRORLEVEL% NEQ 0 (
    echo Error creating environment.
    pause
    exit /b 1
)

:ACTIVATION
echo Activating py312aiwatermark environment...
call conda activate py312aiwatermark
if %ERRORLEVEL% NEQ 0 (
    echo Error activating environment.
    pause
    exit /b 1
)

echo Installing additional dependencies...
pip install PyQt6 transformers opencv-python-headless "pydantic<2.0.0"
if %ERRORLEVEL% NEQ 0 (
    echo Error installing dependencies.
    pause
    exit /b 1
)

echo Installing compatible huggingface-hub version...
pip install "huggingface-hub<0.20"
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Error installing huggingface-hub.
)

echo Installing iopaint...
pip install iopaint
if %ERRORLEVEL% NEQ 0 (
    echo Error installing iopaint.
    pause
    exit /b 1
)

echo Downloading LaMA model...
iopaint download --model lama
if %ERRORLEVEL% NEQ 0 (
    echo Warning: Error downloading LaMA model.
    echo You can retry later with the command: iopaint download --model lama
)

echo.
echo ===============================
echo  Installation complete!
echo ===============================
echo.
echo To launch the application:
echo 1. Open a command prompt
echo 2. Activate the environment: conda activate py312aiwatermark
echo 3. Launch the application: python remwmgui.py
echo.

choice /C YN /M "Do you want to launch the application now? (Y/N)"
if %ERRORLEVEL% EQU 1 (
    echo Launching application...
    python remwmgui.py
)

echo.
pause 