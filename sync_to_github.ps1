# sync_to_github.ps1 СЃ РїСЂР°РІРёР»СЊРЅРѕР№ РєРѕРґРёСЂРѕРІРєРѕР№
$env:GIT_REDIRECT_STDERR = '2>&1'  # РџРµСЂРµРЅР°РїСЂР°РІР»РµРЅРёРµ РѕС€РёР±РѕРє

try {
    cd C:\Users\keepe\DeepSeek_Files
    
    # РџСЂРѕРІРµСЂРєР° СЂРµРїРѕР·РёС‚РѕСЂРёСЏ
    if (-not (Test-Path .\.git)) {
        Write-Host "РћС€РёР±РєР°: РЎРЅР°С‡Р°Р»Р° РІС‹РїРѕР»РЅРёС‚Рµ git init" -ForegroundColor Red
        exit
    }

    # РљРѕРјРјРёС‚ СЃ РЅРѕСЂРјР°Р»СЊРЅРѕР№ РєРѕРґРёСЂРѕРІРєРѕР№
    $commitMsg = "Automatic update: $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    
    git add .
    git commit -m $commitMsg
    git push origin main
    
    Write-Host "Р¤Р°Р№Р»С‹ СѓСЃРїРµС€РЅРѕ РѕС‚РїСЂР°РІР»РµРЅС‹!" -ForegroundColor Green
}
catch {
    Write-Host "РћС€РёР±РєР°: $_" -ForegroundColor Red
}