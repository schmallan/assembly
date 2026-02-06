@echo off
cls
nasm -f win64 -o %1.o %1.asm
gcc %1.o -o %1.exe "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64\kernel32.lib" 
rem "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64\Gdi32.Lib"
rem "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.26100.0\um\x64\kernel32.lib"

%1.exe

echo ;
echo  ________________________
echo ^| ^exit code: %errorlevel%
echo ^|