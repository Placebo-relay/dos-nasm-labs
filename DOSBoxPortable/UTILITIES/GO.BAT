@echo off
nasm %1.asm -f bin -o %1.com
if exist %1.com %1.com