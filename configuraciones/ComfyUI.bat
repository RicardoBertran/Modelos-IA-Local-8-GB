@echo off
setlocal
cd /d "%~dp0..\ComfyUI_windows_portable" 2>nul
if errorlevel 1 (
 echo No se encuentra ComfyUI_windows_portable. Revisa el README.
 pause
 exit /b 1
)
if not exist python_embeded\python.exe (
 echo Falta python_embeded\python.exe. Extrae el paquete portable completo.
 pause
 exit /b 1
)
.\python_embeded\python.exe -s ComfyUI\main.py --windows-standalone-build --listen 127.0.0.1 --port 8188 --auto-launch --reserve-vram 1 --disable-smart-memory --disable-partner-nodes --disable-dynamic-vram --disable-async-offload --lowvram
pause
