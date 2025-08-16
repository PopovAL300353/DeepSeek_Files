import os
import shutil
import csv
from datetime import datetime

def process_audio_files():
    # РќР°СЃС‚СЂРѕР№РєРё РєРѕРґРёСЂРѕРІРєРё
    import sys
    sys.stdout.reconfigure(encoding='utf-8')
    
    # РЎРѕР·РґР°РµРј РїР°РїРєРё РµСЃР»Рё РёС… РЅРµС‚
    os.makedirs("audio/song/passionate", exist_ok=True)
    os.makedirs("audio/song/epic", exist_ok=True)
    os.makedirs("audio/prose/neutral", exist_ok=True)
    
    # Р›РѕРі-С„Р°Р№Р» СЃ UTF-8
    with open("processing.log", "w", encoding="utf-8") as log_file:
        log_file.write(f"=== Р—РђРџРЈРЎРљ РћР‘Р РђР‘РћРўРљР {datetime.now()} ===\n")
    
    # РћР±СЂР°Р±РѕС‚РєР° С„Р°Р№Р»РѕРІ
    for filename in os.listdir("raw_audio"):
        if filename.endswith(".wav"):
            try:
                # РћРїСЂРµРґРµР»СЏРµРј РєР°С‚РµРіРѕСЂРёСЋ РёР· РёРјРµРЅРё С„Р°Р№Р»Р°
                if "_song_passionate" in filename:
                    category = "song/passionate"
                    clean_name = filename.replace("_song_passionate", "")
                elif "_song_epic" in filename:
                    category = "song/epic"
                    clean_name = filename.replace("_song_epic", "")
                elif "_prose_neutral" in filename:
                    category = "prose/neutral"
                    clean_name = filename.replace("_prose_neutral", "")
                else:
                    continue
                
                # Р“РµРЅРµСЂРёСЂСѓРµРј РЅРѕРІРѕРµ РёРјСЏ (Р»Р°С‚РёРЅРёС†Р° + РЅСѓРјРµСЂР°С†РёСЏ)
                base_name = "".join([c if c.isalnum() else "_" for c in clean_name.split(".")[0]])
                new_name = f"{base_name}_{len(os.listdir(f'audio/{category}')+1:03d}.wav"
                
                # РљРѕРїРёСЂСѓРµРј С„Р°Р№Р» РІ РЅСѓР¶РЅСѓСЋ РїР°РїРєСѓ
                shutil.copy2(
                    f"raw_audio/{filename}",
                    f"audio/{category}/{new_name}"
                )
                
                # Р—Р°РїРёСЃСЊ РІ Р»РѕРі
                with open("processing.log", "a", encoding="utf-8") as log_file:
                    log_file.write(f"[OK] {filename} -> {new_name}\n")
                    
            except Exception as e:
                with open("processing.log", "a", encoding="utf-8") as log_file:
                    log_file.write(f"[ERROR] {filename}: {str(e)}\n")
    
    # Р“РµРЅРµСЂР°С†РёСЏ CSV
    generate_csv()

def generate_csv():
    with open("transcripts.csv", "w", encoding="utf-8", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["path", "text"])
        
        for root, _, files in os.walk("audio"):
            for file in files:
                if file.endswith(".wav"):
                    # РР·РІР»РµРєР°РµРј С‚РµРєСЃС‚ РёР· РёРјРµРЅРё С„Р°Р№Р»Р° (РїСЂРёРјРµСЂ)
                    text = file.split("_")[0].replace("_", " ")
                    writer.writerow([
                        os.path.join(root, file),
                        text
                    ])

if __name__ == "__main__":
    print("=== Р—РђРџРЈРЎРљ РџРћР›РќРћР™ РћР‘Р РђР‘РћРўРљР ===")
    process_audio_files()
    print("=== РћР‘Р РђР‘РћРўРљРђ Р—РђР’Р•Р РЁР•РќРђ ===")