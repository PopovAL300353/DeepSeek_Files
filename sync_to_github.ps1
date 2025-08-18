# Установка кодировки UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:GIT_INPUT_ENCODING = "UTF-8"
$env:GIT_OUTPUT_ENCODING = "UTF-8"

# Переход в корень репозитория
Set-Location -Path "C:\Users\keepe\DeepSeek_Files"

# Создание резервной копии
$backupFolder = "C:\Users\keepe\DeepSeek_Files_Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item -Path "C:\Users\keepe\DeepSeek_Files" -Destination $backupFolder -Recurse -Force
Write-Host "Резервная копия создана: $backupFolder" -ForegroundColor Yellow

# Очистка репозитория (кроме .git)
Get-ChildItem -Path "C:\Users\keepe\DeepSeek_Files" -Force | 
    Where-Object { $_.Name -ne ".git" } | 
    Remove-Item -Recurse -Force

# Копирование всех файлов
Copy-Item -Path "C:\Users\keepe\DeepSeek_Files\*" -Destination "C:\Users\keepe\DeepSeek_Files" -Recurse -Force

# Фиксация изменений
git add --all
$commitMessage = "ТОЧНАЯ КОПИЯ с ПК: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git -c "i18n.commitEncoding=UTF-8" commit -m $commitMessage

# Принудительная отправка
git push --force origin main
Write-Host "РЕПОЗИТОРИЙ УСПЕШНО ПЕРЕЗАПИСАН!" -ForegroundColor Green