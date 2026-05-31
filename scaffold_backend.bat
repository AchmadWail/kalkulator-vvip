@echo off
set BASE_DIR=c:\Users\MY ASUS\kalkulator_vvip\backend

mkdir "%BASE_DIR%" 2>nul
mkdir "%BASE_DIR%\bin" 2>nul
mkdir "%BASE_DIR%\lib\api" 2>nul

type nul > "%BASE_DIR%\bin\server.dart"
type nul > "%BASE_DIR%\pubspec.yaml"

echo "Backend Scaffolding Complete"
