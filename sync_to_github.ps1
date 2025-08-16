# Простой скрипт для отправки файлов в GitHub
cd C:\Users\keepe\DeepSeek_Files

# Проверяем, что это Git-репозиторий
if (-not (Test-Path .\.git)) {
    Write-Host "Ошибка: Это не Git-репозиторий. Сначала выполните:"
    Write-Host "1. git init"
    Write-Host "2. git remote add origin https://github.com/PopovAL300353/DeepSeek_Files.git"
    exit
}

# Добавляем и отправляем файлы
git add .
git commit -m "Автоматическое обновление: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin main

Write-Host "Файлы успешно отправлены в GitHub!"