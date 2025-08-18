[Console]::OutputEncoding = [System.Text.Encoding]::UTF8  # Добавьте в начало скрипта

$source_dir = "C:\AUDIO_PROJECT\SOURCE\"
$incoming_dir = "C:\Users\keepe\DeepSeek_Files\incoming\"

# Создаем папку incoming (если нет)
if (-not (Test-Path $incoming_dir)) { 
    New-Item -Path $incoming_dir -ItemType Directory -Force
}

# Копируем с правильной кодировкой
Get-ChildItem -Path "$source_dir*\*.WAV" -Recurse | ForEach-Object {
    $target_path = Join-Path -Path $incoming_dir -ChildPath $_.Name
    Copy-Item -Path $_.FullName -Destination $target_path -Force
    Write-Host "[OK] Скопирован: $($_.Name)"  # Теперь русский текст будет корректным
}