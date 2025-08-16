# sync_to_github.ps1 - автоматическая синхронизация с GitHub
# Кодировка: UTF-8 без BOM

# Переходим в папку репозитория
Set-Location -Path "C:\Users\keepe\DeepSeek_Files"

try {
    # Проверяем, что это Git-репозиторий
    if (-not (Test-Path -Path ".\.git")) {
        Write-Host "Ошибка: Это не Git-репозиторий." -ForegroundColor Red
        Write-Host "Сначала выполните:"
        Write-Host "1. git init"
        Write-Host "2. git remote add origin https://github.com/PopovAL300353/DeepSeek_Files.git"
        exit 1
    }

    # Добавляем все изменения
    git add .

    # Создаем коммит с текущей датой
    $commitMessage = "Автоматическое обновление: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    git commit -m $commitMessage

    # Отправляем изменения
    git push origin main

    Write-Host "Файлы успешно отправлены в GitHub!" -ForegroundColor Green
}
catch {
    Write-Host "Ошибка при выполнении скрипта: $_" -ForegroundColor Red
    exit 1
}