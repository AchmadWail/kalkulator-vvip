@echo off
set BASE_DIR=c:\Users\MY ASUS\kalkulator_vvip

del /f /q "%BASE_DIR%\lib\main.dart" 2>nul

mkdir "%BASE_DIR%\lib\core\theme" 2>nul
mkdir "%BASE_DIR%\lib\core\constants" 2>nul
mkdir "%BASE_DIR%\lib\core\router" 2>nul
mkdir "%BASE_DIR%\lib\features\calculator\screens" 2>nul
mkdir "%BASE_DIR%\lib\features\calculator\widgets" 2>nul
mkdir "%BASE_DIR%\lib\features\calculator\logic" 2>nul
mkdir "%BASE_DIR%\lib\features\calculator\providers" 2>nul
mkdir "%BASE_DIR%\lib\features\history\screens" 2>nul
mkdir "%BASE_DIR%\lib\features\history\widgets" 2>nul
mkdir "%BASE_DIR%\lib\features\history\models" 2>nul
mkdir "%BASE_DIR%\lib\features\history\providers" 2>nul
mkdir "%BASE_DIR%\lib\features\currency_converter\screens" 2>nul
mkdir "%BASE_DIR%\lib\features\currency_converter\widgets" 2>nul
mkdir "%BASE_DIR%\lib\features\currency_converter\models" 2>nul
mkdir "%BASE_DIR%\lib\features\currency_converter\services" 2>nul
mkdir "%BASE_DIR%\lib\features\currency_converter\providers" 2>nul
mkdir "%BASE_DIR%\lib\features\unit_converter\screens" 2>nul
mkdir "%BASE_DIR%\lib\features\unit_converter\widgets" 2>nul
mkdir "%BASE_DIR%\lib\features\unit_converter\models" 2>nul
mkdir "%BASE_DIR%\lib\features\unit_converter\converters" 2>nul
mkdir "%BASE_DIR%\lib\features\unit_converter\providers" 2>nul
mkdir "%BASE_DIR%\lib\features\info_modal\widgets" 2>nul
mkdir "%BASE_DIR%\lib\features\payment\screens" 2>nul
mkdir "%BASE_DIR%\lib\features\payment\services" 2>nul
mkdir "%BASE_DIR%\lib\features\payment\providers" 2>nul
mkdir "%BASE_DIR%\lib\features\vault\screens" 2>nul
mkdir "%BASE_DIR%\lib\features\vault\widgets" 2>nul
mkdir "%BASE_DIR%\lib\features\vault\models" 2>nul
mkdir "%BASE_DIR%\lib\features\vault\services" 2>nul
mkdir "%BASE_DIR%\lib\features\vault\providers" 2>nul
mkdir "%BASE_DIR%\lib\shared\widgets" 2>nul
mkdir "%BASE_DIR%\lib\shared\utils" 2>nul
mkdir "%BASE_DIR%\assets\icons" 2>nul
mkdir "%BASE_DIR%\assets\images" 2>nul
mkdir "%BASE_DIR%\assets\data" 2>nul
mkdir "%BASE_DIR%\test" 2>nul

type nul > "%BASE_DIR%\lib\main.dart"
type nul > "%BASE_DIR%\lib\app.dart"
type nul > "%BASE_DIR%\lib\core\theme\app_theme.dart"
type nul > "%BASE_DIR%\lib\core\theme\app_colors.dart"
type nul > "%BASE_DIR%\lib\core\constants\app_constants.dart"
type nul > "%BASE_DIR%\lib\core\constants\secret_codes.dart"
type nul > "%BASE_DIR%\lib\core\constants\currency_data.dart"
type nul > "%BASE_DIR%\lib\core\constants\unit_data.dart"
type nul > "%BASE_DIR%\lib\core\router\app_router.dart"
type nul > "%BASE_DIR%\lib\features\calculator\screens\calculator_screen.dart"
type nul > "%BASE_DIR%\lib\features\calculator\widgets\display_widget.dart"
type nul > "%BASE_DIR%\lib\features\calculator\widgets\keypad_widget.dart"
type nul > "%BASE_DIR%\lib\features\calculator\widgets\scientific_keypad.dart"
type nul > "%BASE_DIR%\lib\features\calculator\widgets\navbar_top.dart"
type nul > "%BASE_DIR%\lib\features\calculator\logic\calculator_logic.dart"
type nul > "%BASE_DIR%\lib\features\calculator\logic\secret_detector.dart"
type nul > "%BASE_DIR%\lib\features\calculator\providers\calculator_provider.dart"
type nul > "%BASE_DIR%\lib\features\history\screens\history_screen.dart"
type nul > "%BASE_DIR%\lib\features\history\widgets\history_item_widget.dart"
type nul > "%BASE_DIR%\lib\features\history\models\history_model.dart"
type nul > "%BASE_DIR%\lib\features\history\providers\history_provider.dart"
type nul > "%BASE_DIR%\lib\features\currency_converter\screens\currency_screen.dart"
type nul > "%BASE_DIR%\lib\features\currency_converter\widgets\currency_selector.dart"
type nul > "%BASE_DIR%\lib\features\currency_converter\widgets\rate_display.dart"
type nul > "%BASE_DIR%\lib\features\currency_converter\models\currency_model.dart"
type nul > "%BASE_DIR%\lib\features\currency_converter\services\currency_service.dart"
type nul > "%BASE_DIR%\lib\features\currency_converter\providers\currency_provider.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\screens\unit_screen.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\widgets\unit_tabs.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\widgets\unit_input.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\models\unit_model.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\converters\length_converter.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\converters\weight_converter.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\converters\temperature_converter.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\converters\area_converter.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\converters\volume_converter.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\converters\time_converter.dart"
type nul > "%BASE_DIR%\lib\features\unit_converter\providers\unit_provider.dart"
type nul > "%BASE_DIR%\lib\features\info_modal\widgets\info_modal_widget.dart"
type nul > "%BASE_DIR%\lib\features\payment\screens\payment_screen.dart"
type nul > "%BASE_DIR%\lib\features\payment\services\dana_service.dart"
type nul > "%BASE_DIR%\lib\features\payment\providers\payment_provider.dart"
type nul > "%BASE_DIR%\lib\features\vault\screens\vault_screen.dart"
type nul > "%BASE_DIR%\lib\features\vault\screens\folder_images_screen.dart"
type nul > "%BASE_DIR%\lib\features\vault\screens\folder_videos_screen.dart"
type nul > "%BASE_DIR%\lib\features\vault\screens\folder_documents_screen.dart"
type nul > "%BASE_DIR%\lib\features\vault\screens\folder_recordings_screen.dart"
type nul > "%BASE_DIR%\lib\features\vault\widgets\vault_folder_card.dart"
type nul > "%BASE_DIR%\lib\features\vault\widgets\add_file_button.dart"
type nul > "%BASE_DIR%\lib\features\vault\widgets\add_file_picker.dart"
type nul > "%BASE_DIR%\lib\features\vault\widgets\file_viewer.dart"
type nul > "%BASE_DIR%\lib\features\vault\models\vault_file_model.dart"
type nul > "%BASE_DIR%\lib\features\vault\services\vault_storage_service.dart"
type nul > "%BASE_DIR%\lib\features\vault\providers\vault_provider.dart"
type nul > "%BASE_DIR%\lib\shared\widgets\custom_button.dart"
type nul > "%BASE_DIR%\lib\shared\widgets\custom_modal.dart"
type nul > "%BASE_DIR%\lib\shared\widgets\loading_widget.dart"
type nul > "%BASE_DIR%\lib\shared\utils\format_number.dart"
type nul > "%BASE_DIR%\lib\shared\utils\vip_checker.dart"
type nul > "%BASE_DIR%\test\calculator_test.dart"
type nul > "%BASE_DIR%\test\converter_test.dart"
type nul > "%BASE_DIR%\test\secret_code_test.dart"
type nul > "%BASE_DIR%\assets\data\currency_rates.json"

echo "Scaffolding Complete"
