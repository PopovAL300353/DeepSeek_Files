<#
.SYNOPSIS
Точная синхронизация ПК → GitHub с сохранением имен файлов и папок
#>

# Настройки
$localPath = "C:\Users\keepe\DeepSeek_Files"
$repoPath = "C:\Users\keepe\DeepSeek_Files"
$backupDir = "C:\DeepSeek_Backups"

# 1. Создаем резервную копию
if (-not (Test-Path $backupDir)) { 
    New-Item -Path $backupDir -ItemType Directory -Force | Out-Null 
}
$backupFolder = "$backupDir\Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
Copy-Item -Path $repoPath -Destination $backupFolder -Recurse -Force
Write-Host "[✅] Резервная копия создана: $backupFolder" -ForegroundColor Cyan

# 2. Очищаем репозиторий (кроме .git и скрипта)
Set-Location $repoPath
Get-ChildItem -Path $repoPath -Force | 
    Where-Object { $_.Name -ne ".git" -and $_.Name -ne "sync_repo.ps1" } | 
    Remove-Item -Recurse -Force

# 3. Копируем с сохранением структуры
robocopy $localPath $repoPath /MIR /NJH /NJS /NDL /NP /NFL /XD ".git" "DeepSeek_Backups" /XF "sync_repo.ps1"
Write-Host "[🔄] Файлы скопированы с сохранением структуры" -ForegroundColor Green

# 4. Фиксируем изменения
git add --all
$commitMessage = "🔄 SYNC: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git -c "i18n.commitEncoding=UTF-8" commit -m $commitMessage

# 5. Отправляем в GitHub
git push origin main
Write-Host "[✅] Репозиторий обновлен! Имена сохранены." -ForegroundColor Green