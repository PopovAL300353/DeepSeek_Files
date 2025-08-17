# Включаем логирование (записываем все действия в файл)
Start-Transcript -Path "sync.log" -Append

Write-Host "=== Начало синхронизации с GitHub ===" -ForegroundColor Cyan

try {
    # Проверяем, есть ли изменения
    $changes = git status --porcelain
    if (-not $changes) {
        Write-Host "Нет изменений для коммита." -ForegroundColor Yellow
        exit
    }

    # Добавляем все файлы
    git add .
    Write-Host "Файлы добавлены в индекс Git" -ForegroundColor Green

    # Создаем коммит с текущей датой
    $commitMessage = "Автообновление: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    git commit -m $commitMessage
    Write-Host "Создан коммит: '$commitMessage'" -ForegroundColor Green

    # Отправляем изменения
    git push origin main
    Write-Host "Изменения отправлены на GitHub" -ForegroundColor Green

} catch {
    Write-Host "Ошибка: $_" -ForegroundColor Red
} finally {
    Stop-Transcript
    Write-Host "`n=== Синхронизация завершена ===" -ForegroundColor Cyan
    Write-Host "Лог сохранен в sync.log" -ForegroundColor Cyan
}