# Устанавливаем UTF-8 для консоли и Git
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:GIT_INPUT_ENCODING = "UTF-8"
$env:GIT_OUTPUT_ENCODING = "UTF-8"

# Пути и параметры
$repoPath = "C:\Users\keepe\DeepSeek_Files"
$backupPath = "$env:USERPROFILE\Desktop\GitBackup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Создаем резервную копию (сообщение выводим ДО копирования)
Write-Host "Создаем резервную копию на рабочем столе..." -ForegroundColor Yellow
Copy-Item -Path $repoPath -Destination $backupPath -Recurse -Force
Write-Host "Резервная копия создана: $backupPath" -ForegroundColor Green

# Синхронизация с Git
Set-Location $repoPath
git add .
git -c "i18n.commitEncoding=UTF-8" commit -m "Безопасное обновление: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git pull origin main
git push origin main

Write-Host "Синхронизация успешно завершена!" -ForegroundColor Green