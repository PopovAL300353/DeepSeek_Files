<#
.SYNOPSIS
Точная синхронизация папки C:\Users\keepe\DeepSeek_Files с GitHub-репозиторием.
#>

# Установка кодировки UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$env:GIT_INPUT_ENCODING = "UTF-8"
$env:GIT_OUTPUT_ENCODING = "UTF-8"

# Пути
$localPath = "C:\Users\keepe\DeepSeek_Files"  # Локальная папка
$backupDir = "C:\DeepSeek_Backups"            # Папка для резервных копий

# Создаем папку для бэкапов (если нет)
if (-not (Test-Path -Path $backupDir)) {
    New-Item -Path $backupDir -ItemType Directory -Force | Out-Null
}

# 1. Резервная копия (на всякий случай)
$backupFolder = "$backupDir\Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item -Path $localPath -Destination $backupFolder -Recurse -Force
Write-Host "[✅] Резервная копия создана: $backupFolder" -ForegroundColor Green

# 2. Переходим в репозиторий
Set-Location -Path $localPath

# 3. Очищаем репозиторий (кроме .git и этого скрипта)
Get-ChildItem -Path $localPath -Force | 
    Where-Object { $_.Name -ne ".git" -and $_.Name -ne "sync_repo.ps1" } | 
    Remove-Item -Recurse -Force

# 4. Копируем ВСЁ из локальной папки обратно (кроме .git и скрипта)
Get-ChildItem -Path $localPath | 
    Where-Object { $_.Name -ne ".git" -and $_.Name -ne "sync_repo.ps1" } | 
    Copy-Item -Destination $localPath -Recurse -Force -ErrorAction SilentlyContinue

# 5. Git: добавляем все изменения
git add --all

# 6. Коммит с текущей датой
$commitMessage = "🔄 AUTOSYNC: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git -c "i18n.commitEncoding=UTF-8" commit -m $commitMessage

# 7. Принудительная отправка в GitHub (--force)
git push --force origin main

Write-Host "[✅] Репозиторий полностью синхронизирован с ПК!" -ForegroundColor Green