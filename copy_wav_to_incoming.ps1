# Простой скрипт переноса WAV-файлов
$source = "C:\AUDIO_PROJECT\SOURCE"
$target = "$env:USERPROFILE\DeepSeek_Files\incoming"

# Создаем папку назначения
if (!(Test-Path $target)) { 
    mkdir $target | Out-Null 
}

# Копируем все WAV-файлы
Get-ChildItem -Path $source -Recurse -Filter "*.wav" | % {
    Copy-Item $_.FullName -Destination $target -Force
    Write-Host "Copied: $($_.Name)"
}

Write-Host "DONE! Files copied to: $target"