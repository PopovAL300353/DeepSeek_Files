Start-Transcript -Path "sync.log" -Append -Encoding UTF8

Write-Host "=== Начало синхронизации с GitHub ===" -ForegroundColor Cyan

try {
    # Добавляем все изменения
    git add .
    Write-Host "Файлы добавлены в индекс Git" -ForegroundColor Green

    # Создаем коммит
    $commitMessage = "Автообновление: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $commitMessage
    Write-Host "Создан коммит: '$commitMessage'" -ForegroundColor Green

    # Получаем изменения с GitHub (если есть)
    git pull origin main --rebase

    # Отправляем изменения
    git push origin main
    Write-Host "Изменения успешно отправлены на GitHub" -ForegroundColor Green

} catch {
    Write-Host "Ошибка: $_" -ForegroundColor Red
} finally {
    Stop-Transcript
    Write-Host "`n=== Синхронизация завершена ===" -ForegroundColor Cyan
    Write-Host "Лог сохранен в sync.log" -ForegroundColor Cyan
}