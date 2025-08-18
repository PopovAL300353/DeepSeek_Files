<#
.SYNOPSIS
БЕЗОПАСНАЯ синхронизация без удаления исходных файлов
#>

# Настройки
$sourcePath = "C:\Users\keepe\DeepSeek_Files"  # Исходная папка (НЕ УДАЛЯЕТСЯ)
$repoPath = "C:\Users\keepe\DeepSeek_Files"    # Папка репозитория
$backupDir = "C:\DeepSeek_Backups"             # Для резервных копий

# 1. Создаем резервную копию репозитория
$backupFolder = "$backupDir\Backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -Path $backupFolder -ItemType Directory -Force | Out-Null
Copy-Item -Path "$repoPath\*" -Destination $backupFolder -Recurse -Force
Write-Host "[1] Резервная копия создана" -ForegroundColor Cyan

# 2. Получаем текущее состояние репозитория
Set-Location $repoPath
git fetch origin
git reset --hard origin/main

# 3. Копируем ТОЛЬКО новые/измененные файлы
robocopy $sourcePath $repoPath /MIR /XD ".git" /XF "sync_repo_safe.ps1" /NJH /NJS /NP /NDL /R:1 /W:1
Write-Host "[2] Файлы синхронизированы" -ForegroundColor Green

# 4. Фиксируем изменения
git add --all
git commit -m "Обновление: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
git pull --rebase origin main
git push origin main
Write-Host "[3] Репозиторий обновлен" -ForegroundColor Green