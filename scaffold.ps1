$base = "c:\Users\MY ASUS\kalkulator_vvip"
Remove-Item -Path "$base\lib\main.dart" -Force -ErrorAction SilentlyContinue

$dirs = @(
    "lib/core/theme",
    "lib/core/constants",
    "lib/core/router",
    "lib/features/calculator/screens",
    "lib/features/calculator/widgets",
    "lib/features/calculator/logic",
    "lib/features/calculator/providers",
    "lib/features/history/screens",
    "lib/features/history/widgets",
    "lib/features/history/models",
    "lib/features/history/providers",
    "lib/features/currency_converter/screens",
    "lib/features/currency_converter/widgets",
    "lib/features/currency_converter/models",
    "lib/features/currency_converter/services",
    "lib/features/currency_converter/providers",
    "lib/features/unit_converter/screens",
    "lib/features/unit_converter/widgets",
    "lib/features/unit_converter/models",
    "lib/features/unit_converter/converters",
    "lib/features/unit_converter/providers",
    "lib/features/info_modal/widgets",
    "lib/features/payment/screens",
    "lib/features/payment/services",
    "lib/features/payment/providers",
    "lib/features/vault/screens",
    "lib/features/vault/widgets",
    "lib/features/vault/models",
    "lib/features/vault/services",
    "lib/features/vault/providers",
    "lib/shared/widgets",
    "lib/shared/utils",
    "assets/icons",
    "assets/images",
    "assets/data",
    "test"
)

foreach ($d in $dirs) {
    $dirPath = "$base\$d"
    if (-not (Test-Path -Path $dirPath)) {
        New-Item -ItemType Directory -Force -Path $dirPath | Out-Null
    }
}

$files = @(
    "lib/main.dart",
    "lib/app.dart",
    "lib/core/theme/app_theme.dart",
    "lib/core/theme/app_colors.dart",
    "lib/core/constants/app_constants.dart",
    "lib/core/constants/secret_codes.dart",
    "lib/core/constants/currency_data.dart",
    "lib/core/constants/unit_data.dart",
    "lib/core/router/app_router.dart",
    "lib/features/calculator/screens/calculator_screen.dart",
    "lib/features/calculator/widgets/display_widget.dart",
    "lib/features/calculator/widgets/keypad_widget.dart",
    "lib/features/calculator/widgets/scientific_keypad.dart",
    "lib/features/calculator/widgets/navbar_top.dart",
    "lib/features/calculator/logic/calculator_logic.dart",
    "lib/features/calculator/logic/secret_detector.dart",
    "lib/features/calculator/providers/calculator_provider.dart",
    "lib/features/history/screens/history_screen.dart",
    "lib/features/history/widgets/history_item_widget.dart",
    "lib/features/history/models/history_model.dart",
    "lib/features/history/providers/history_provider.dart",
    "lib/features/currency_converter/screens/currency_screen.dart",
    "lib/features/currency_converter/widgets/currency_selector.dart",
    "lib/features/currency_converter/widgets/rate_display.dart",
    "lib/features/currency_converter/models/currency_model.dart",
    "lib/features/currency_converter/services/currency_service.dart",
    "lib/features/currency_converter/providers/currency_provider.dart",
    "lib/features/unit_converter/screens/unit_screen.dart",
    "lib/features/unit_converter/widgets/unit_tabs.dart",
    "lib/features/unit_converter/widgets/unit_input.dart",
    "lib/features/unit_converter/models/unit_model.dart",
    "lib/features/unit_converter/converters/length_converter.dart",
    "lib/features/unit_converter/converters/weight_converter.dart",
    "lib/features/unit_converter/converters/temperature_converter.dart",
    "lib/features/unit_converter/converters/area_converter.dart",
    "lib/features/unit_converter/converters/volume_converter.dart",
    "lib/features/unit_converter/converters/time_converter.dart",
    "lib/features/unit_converter/providers/unit_provider.dart",
    "lib/features/info_modal/widgets/info_modal_widget.dart",
    "lib/features/payment/screens/payment_screen.dart",
    "lib/features/payment/services/dana_service.dart",
    "lib/features/payment/providers/payment_provider.dart",
    "lib/features/vault/screens/vault_screen.dart",
    "lib/features/vault/screens/folder_images_screen.dart",
    "lib/features/vault/screens/folder_videos_screen.dart",
    "lib/features/vault/screens/folder_documents_screen.dart",
    "lib/features/vault/screens/folder_recordings_screen.dart",
    "lib/features/vault/widgets/vault_folder_card.dart",
    "lib/features/vault/widgets/add_file_button.dart",
    "lib/features/vault/widgets/add_file_picker.dart",
    "lib/features/vault/widgets/file_viewer.dart",
    "lib/features/vault/models/vault_file_model.dart",
    "lib/features/vault/services/vault_storage_service.dart",
    "lib/features/vault/providers/vault_provider.dart",
    "lib/shared/widgets/custom_button.dart",
    "lib/shared/widgets/custom_modal.dart",
    "lib/shared/widgets/loading_widget.dart",
    "lib/shared/utils/format_number.dart",
    "lib/shared/utils/vip_checker.dart",
    "test/calculator_test.dart",
    "test/converter_test.dart",
    "test/secret_code_test.dart",
    "assets/data/currency_rates.json"
)

foreach ($f in $files) {
    $filePath = "$base\$f"
    if (-not (Test-Path -Path $filePath)) {
        New-Item -ItemType File -Force -Path $filePath | Out-Null
    }
}
Write-Host "Scaffolding Complete"
