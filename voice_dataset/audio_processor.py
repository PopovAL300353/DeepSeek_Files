import os
import shutil
import csv
from datetime import datetime

def process_audio_files():
    # Настройки кодировки
    import sys
    sys.stdout.reconfigure(encoding='utf-8')
    
    # Создаем папки если их нет
    os.makedirs("audio/song/passionate", exist_ok=True)
    os.makedirs("audio/song/epic", exist_ok=True)
    os.makedirs("audio/prose/neutral", exist_ok=True)
    
    # Лог-файл с UTF-8
    with open("processing.log", "w", encoding="utf-8") as log_file:
        log_file.write(f"=== ЗАПУСК ОБРАБОТКИ {datetime.now()} ===\n")
    
    # Обработка файлов
    for filename in os.listdir("raw_audio"):
        if filename.endswith(".wav"):
            try:
                # Определяем категорию из имени файла
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
                
                # Генерируем новое имя (латиница + нумерация)
                base_name = "".join([c if c.isalnum() else "_" for c in clean_name.split(".")[0]])
                new_name = f"{base_name}_{len(os.listdir(f'audio/{category}')+1:03d}.wav"
                
                # Копируем файл в нужную папку
                shutil.copy2(
                    f"raw_audio/{filename}",
                    f"audio/{category}/{new_name}"
                )
                
                # Запись в лог
                with open("processing.log", "a", encoding="utf-8") as log_file:
                    log_file.write(f"[OK] {filename} -> {new_name}\n")
                    
            except Exception as e:
                with open("processing.log", "a", encoding="utf-8") as log_file:
                    log_file.write(f"[ERROR] {filename}: {str(e)}\n")
    
    # Генерация CSV
    generate_csv()

def generate_csv():
    with open("transcripts.csv", "w", encoding="utf-8", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["path", "text"])
        
        for root, _, files in os.walk("audio"):
            for file in files:
                if file.endswith(".wav"):
                    # Извлекаем текст из имени файла (пример)
                    text = file.split("_")[0].replace("_", " ")
                    writer.writerow([
                        os.path.join(root, file),
                        text
                    ])

if __name__ == "__main__":
    print("=== ЗАПУСК ПОЛНОЙ ОБРАБОТКИ ===")
    process_audio_files()
    print("=== ОБРАБОТКА ЗАВЕРШЕНА ===")