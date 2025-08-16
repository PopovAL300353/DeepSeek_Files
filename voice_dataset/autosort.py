import os
import csv
import re
import subprocess

# Настройки
AUDIO_SOURCE = "raw_audio"
OUTPUT_DIR = "audio"
CSV_FILE = "transcripts.csv"
ENCODING = "utf-8-sig"

def parse_filename(filename):
    """Извлекает текст, жанр, эмоцию из имени файла"""
    try:
        name = re.sub(r"\.wav$", "", filename, flags=re.IGNORECASE)
        parts = name.split("_")
        
        # Текст фразы - все части до последних 3 элементов
        text = " ".join(parts[:-3])
        genre = parts[-3] if len(parts) >= 3 else "unknown"
        emotion = parts[-2] if len(parts) >= 2 else "neutral"
        number = parts[-1] if parts else "0"
        
        return text, genre, emotion, number
    except Exception as e:
        print(f"⚠️ Ошибка парсинга {filename}: {e}")
        return "[ошибка]", "unknown", "neutral", "0"

def git_sync():
    """Синхронизация с Git"""
    try:
        subprocess.run(["git", "add", "."], check=True)
        status = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True)
        if status.stdout.strip():
            subprocess.run(["git", "commit", "-m", "Автообновление: новые аудиофайлы"], check=True)
            subprocess.run(["git", "push"], check=True)
            print("✅ Изменения отправлены в GitHub")
    except subprocess.CalledProcessError as e:
        print(f"⚠️ Ошибка Git: {e.stderr}")

def main():
    print("=== СТАРТ ОБРАБОТКИ ===")
    
    # Создаем CSV, если его нет
    if not os.path.exists(CSV_FILE):
        with open(CSV_FILE, "w", encoding=ENCODING, newline="") as f:
            writer = csv.writer(f)
            writer.writerow(["file_path", "text", "genre", "emotion"])
    
    # Обработка файлов
    with open(CSV_FILE, "a", encoding=ENCODING, newline="") as csvfile:
        writer = csv.writer(csvfile)
        
        for filename in os.listdir(AUDIO_SOURCE):
            if not filename.lower().endswith(".wav"):
                continue
                
            text, genre, emotion, _ = parse_filename(filename)
            new_path = os.path.join(OUTPUT_DIR, genre, emotion, filename)
            os.makedirs(os.path.dirname(new_path), exist_ok=True)
            
            # Перемещаем файл
            os.rename(
                os.path.join(AUDIO_SOURCE, filename),
                new_path
            )
            
            # Записываем в CSV
            writer.writerow([new_path, text, genre, emotion])
            print(f"✅ Обработано: {filename} -> Текст: '{text}'")
    
    # Синхронизация с Git
    git_sync()
    print("=== ЗАВЕРШЕНО ===")

if __name__ == "__main__":
    main()