# ������� ������ �������� WAV-������
$source = "C:\AUDIO_PROJECT\SOURCE"
$target = "$env:USERPROFILE\DeepSeek_Files\incoming"

# ������� ����� ����������
if (!(Test-Path $target)) { 
    mkdir $target | Out-Null 
}

# �������� ��� WAV-�����
Get-ChildItem -Path $source -Recurse -Filter "*.wav" | % {
    Copy-Item $_.FullName -Destination $target -Force
    Write-Host "Copied: $($_.Name)"
}

Write-Host "DONE! Files copied to: $target"