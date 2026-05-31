@echo off
set BASE_DIR=c:\Users\MY ASUS\kalkulator_vvip\web_app

mkdir "%BASE_DIR%" 2>nul
mkdir "%BASE_DIR%\pages" 2>nul
mkdir "%BASE_DIR%\css" 2>nul
mkdir "%BASE_DIR%\js" 2>nul
mkdir "%BASE_DIR%\js\calculator" 2>nul
mkdir "%BASE_DIR%\js\history" 2>nul
mkdir "%BASE_DIR%\js\currency" 2>nul
mkdir "%BASE_DIR%\js\unit" 2>nul
mkdir "%BASE_DIR%\js\payment" 2>nul
mkdir "%BASE_DIR%\js\vault" 2>nul
mkdir "%BASE_DIR%\data" 2>nul

type nul > "%BASE_DIR%\index.html"
type nul > "%BASE_DIR%\pages\calculator.html"
type nul > "%BASE_DIR%\pages\history.html"
type nul > "%BASE_DIR%\pages\currency.html"
type nul > "%BASE_DIR%\pages\unit.html"
type nul > "%BASE_DIR%\pages\vault.html"
type nul > "%BASE_DIR%\pages\payment.html"

type nul > "%BASE_DIR%\css\global.css"
type nul > "%BASE_DIR%\css\navbar.css"
type nul > "%BASE_DIR%\css\calculator.css"
type nul > "%BASE_DIR%\css\history.css"
type nul > "%BASE_DIR%\css\currency.css"
type nul > "%BASE_DIR%\css\unit.css"
type nul > "%BASE_DIR%\css\vault.css"
type nul > "%BASE_DIR%\css\payment.css"
type nul > "%BASE_DIR%\css\modal.css"
type nul > "%BASE_DIR%\css\animations.css"

type nul > "%BASE_DIR%\js\app.js"
type nul > "%BASE_DIR%\js\navbar.js"
type nul > "%BASE_DIR%\js\calculator\calculator.js"
type nul > "%BASE_DIR%\js\calculator\scientific.js"
type nul > "%BASE_DIR%\js\calculator\secretDetector.js"
type nul > "%BASE_DIR%\js\history\history.js"
type nul > "%BASE_DIR%\js\currency\currencyConverter.js"
type nul > "%BASE_DIR%\js\currency\currencyFetch.js"
type nul > "%BASE_DIR%\js\currency\currencyData.js"
type nul > "%BASE_DIR%\js\unit\unitConverter.js"
type nul > "%BASE_DIR%\js\unit\lengthConvert.js"
type nul > "%BASE_DIR%\js\unit\weightConvert.js"
type nul > "%BASE_DIR%\js\unit\tempConvert.js"
type nul > "%BASE_DIR%\js\unit\areaConvert.js"
type nul > "%BASE_DIR%\js\unit\volumeConvert.js"
type nul > "%BASE_DIR%\js\unit\timeConvert.js"
type nul > "%BASE_DIR%\js\payment\paymentModal.js"
type nul > "%BASE_DIR%\js\payment\danaRedirect.js"
type nul > "%BASE_DIR%\js\payment\vipStatus.js"
type nul > "%BASE_DIR%\js\vault\vault.js"
type nul > "%BASE_DIR%\js\vault\vaultDB.js"
type nul > "%BASE_DIR%\js\vault\addFilePicker.js"
type nul > "%BASE_DIR%\js\vault\fileViewer.js"

type nul > "%BASE_DIR%\data\currency_rates.json"

echo "WebApp Scaffolding Complete"
