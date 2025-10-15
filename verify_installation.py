#!/usr/bin/env python3
"""
Sweeta Installation Verification Script
Checks if all dependencies are properly installed and configured.
"""

import sys
from pathlib import Path

def check_python_version():
    """Check if Python version is 3.12+"""
    print("🔍 Checking Python version...")
    version = sys.version_info
    if version.major == 3 and version.minor >= 12:
        print(f"✅ Python {version.major}.{version.minor}.{version.micro} - OK")
        return True
    else:
        print(f"❌ Python {version.major}.{version.minor}.{version.micro} - FAILED (Requires Python 3.12+)")
        return False

def check_imports():
    """Check if all required packages can be imported"""
    print("\n🔍 Checking required packages...")
    packages = {
        'torch': 'PyTorch',
        'torchvision': 'TorchVision',
        'cv2': 'OpenCV',
        'PIL': 'Pillow',
        'transformers': 'Transformers',
        'iopaint': 'IOPaint',
        'click': 'Click',
        'loguru': 'Loguru',
        'tqdm': 'TQDM',
        'numpy': 'NumPy',
        'pydantic': 'Pydantic',
        'PyQt6': 'PyQt6',
        'yaml': 'PyYAML',
        'psutil': 'PSUtil'
    }
    
    all_ok = True
    for module, name in packages.items():
        try:
            if module == 'cv2':
                import cv2
            elif module == 'PIL':
                from PIL import Image
            elif module == 'yaml':
                import yaml
            else:
                __import__(module)
            print(f"✅ {name} - OK")
        except ImportError as e:
            print(f"❌ {name} - FAILED: {e}")
            all_ok = False
    
    return all_ok

def check_pydantic_version():
    """Check if Pydantic version is < 2.0.0"""
    print("\n🔍 Checking Pydantic version...")
    try:
        import pydantic
        version = pydantic.VERSION
        major_version = int(version.split('.')[0])
        
        if major_version < 2:
            print(f"✅ Pydantic {version} - OK (< 2.0.0)")
            return True
        else:
            print(f"❌ Pydantic {version} - FAILED (Must be < 2.0.0)")
            print("   Fix: pip install 'pydantic<2.0.0'")
            return False
    except Exception as e:
        print(f"❌ Could not check Pydantic version: {e}")
        return False

def check_cuda():
    """Check CUDA availability"""
    print("\n🔍 Checking GPU/CUDA support...")
    try:
        import torch
        if torch.cuda.is_available():
            device_name = torch.cuda.get_device_name(0)
            cuda_version = torch.version.cuda
            device_count = torch.cuda.device_count()
            memory_gb = torch.cuda.get_device_properties(0).total_memory / (1024**3)
            
            print(f"✅ CUDA {cuda_version} - Available")
            print(f"   GPU: {device_name}")
            print(f"   Devices: {device_count}")
            print(f"   Memory: {memory_gb:.2f} GB")
            return True
        else:
            print("⚠️  CUDA - Not available (will use CPU, which is slower)")
            print("   To enable GPU: See TROUBLESHOOTING.md")
            return True  # Not a failure, just slower
    except Exception as e:
        print(f"❌ Could not check CUDA: {e}")
        return False

def check_lama_model():
    """Check if LaMA model is downloaded"""
    print("\n🔍 Checking LaMA model...")
    
    # Common paths where the model might be cached
    cache_paths = [
        Path.home() / ".cache" / "torch" / "hub" / "checkpoints" / "big-lama.pt",
        Path.home() / ".cache" / "huggingface" / "hub",
    ]
    
    model_found = False
    for cache_path in cache_paths:
        if cache_path.exists():
            if cache_path.is_file():
                size_mb = cache_path.stat().st_size / (1024**2)
                print(f"✅ LaMA model found at {cache_path}")
                print(f"   Size: {size_mb:.2f} MB")
                model_found = True
                break
            elif cache_path.is_dir():
                # Check if there are model files in the directory
                model_files = list(cache_path.glob("**/*lama*"))
                if model_files:
                    print(f"✅ LaMA model files found in {cache_path}")
                    model_found = True
                    break
    
    if not model_found:
        print("⚠️  LaMA model not found")
        print("   Download with: iopaint download --model lama")
        return False
    
    return True

def check_ffmpeg():
    """Check if FFmpeg is installed (for video processing)"""
    print("\n🔍 Checking FFmpeg (for video processing)...")
    import subprocess
    try:
        result = subprocess.run(
            ["ffmpeg", "-version"],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            # Extract version from first line
            version_line = result.stdout.split('\n')[0]
            print(f"✅ FFmpeg - OK")
            print(f"   {version_line}")
            return True
        else:
            print("❌ FFmpeg - Command failed")
            return False
    except FileNotFoundError:
        print("⚠️  FFmpeg - Not found (required for video audio preservation)")
        print("   Videos will be processed without audio")
        print("   Install: See TROUBLESHOOTING.md")
        return True  # Not critical, just a warning
    except Exception as e:
        print(f"⚠️  FFmpeg - Could not check: {e}")
        return True

def main():
    """Run all checks"""
    print("=" * 60)
    print("  Sweeta Installation Verification")
    print("=" * 60)
    
    results = []
    
    results.append(("Python Version", check_python_version()))
    results.append(("Package Imports", check_imports()))
    results.append(("Pydantic Version", check_pydantic_version()))
    results.append(("CUDA Support", check_cuda()))
    results.append(("LaMA Model", check_lama_model()))
    results.append(("FFmpeg", check_ffmpeg()))
    
    print("\n" + "=" * 60)
    print("  Summary")
    print("=" * 60)
    
    all_passed = True
    for name, result in results:
        status = "✅ PASS" if result else "❌ FAIL"
        print(f"{status} - {name}")
        if not result:
            all_passed = False
    
    print("=" * 60)
    
    if all_passed:
        print("\n🎉 All checks passed! Sweeta is ready to use.")
        print("\nTo launch the GUI:")
        print("  python remwmgui.py")
        print("\nFor CLI usage:")
        print("  python remwm.py --help")
        return 0
    else:
        print("\n⚠️  Some checks failed. Please fix the issues above.")
        print("\nFor help, see TROUBLESHOOTING.md")
        return 1

if __name__ == "__main__":
    sys.exit(main())
