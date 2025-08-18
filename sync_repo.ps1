# Установка кодировки UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:GIT_INPUT_ENCODING = "UTF-8"
$env:GIT_OUTPUT_ENCODING = "UTF-8"

# Переход в папку репозитория
cd "C:\Users\keepe\DeepSeek_Files"

# 1. Проверка изменений
$changes = git status --porcelain
if (-not $changes) {
    Write-Host "Нет изменений для синхронизации." -ForegroundColor Yellow
    exit
}

# 2. Добавление только новых/измененных файлов
git add --all

# 3. Коммит с текущей датой
$commitMessage = "Автосинхронизация: $(Get-Date -Format 'dd.MM.yyyy HH:mm')"
git commit -m $commitMessage

# 4. Отправка на GitHub (БЕЗ --force!)
git push origin main

Write-Host "Синхронизация успешно завершена!" -ForegroundColor Green