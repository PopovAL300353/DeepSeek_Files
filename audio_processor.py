import os
from pathlib import Path
import csv

def main():
    print("=== Обработка аудиофайлов ===")
    print("Формат файлов: [Текст]_[Жанр]_[Эмоция].wav (пример: Привет_song_happy.wav)")

    # Папки
    incoming = Path("incoming")
    audio_dir = Path("audio")
    csv_file = Path("transcripts.csv")
    
    # Создаем папку audio (если её нет)
    audio_dir.mkdir(exist_ok=True)

    # Проверяем, существует ли CSV. Если нет — создаем с заголовком.
    if not csv_file.exists():
        with open(csv_file, "w", encoding="utf-8-sig", newline="") as f:
            writer = csv.writer(f, delimiter="|")
            writer.writerow(["Файл", "Текст", "Жанр", "Эмоция"])

    # Открываем CSV в режиме ДОЗАПИСИ ("a") с UTF-8-BOM
    with open(csv_file, "a", encoding="utf-8-sig", newline="") as csvfile:
        writer = csv.writer(csvfile, delimiter="|")

        # Обрабатываем каждый .wav файл
        for file in incoming.glob("*.wav"):
            try:
                # Разбираем имя файла
                name_parts = file.stem.split("_")
                if len(name_parts) != 3:
                    print(f"⚠ Ошибка: {file.name} — неправильное имя! Пропускаю...")
                    continue
                
                text, genre, emotion = name_parts
                genre = genre.lower()
                emotion = emotion.lower()

                # Создаем папки
                emotion_dir = audio_dir / genre / emotion
                emotion_dir.mkdir(parents=True, exist_ok=True)

                # Новое имя файла
                file_count = len(list(emotion_dir.glob("*.wav"))) + 1
                new_name = f"{text}_{file_count:03d}.wav"
                target_path = emotion_dir / new_name

                # Переносим файл и записываем в CSV
                file.rename(target_path)
                writer.writerow([new_name, text, genre, emotion])
                print(f"✓ Успешно: {file.name} → {target_path}")

            except Exception as e:
                print(f"❌ Ошибка в файле {file.name}: {str(e)}")

    print("\n✅ Готово! Проверь папку 'audio' и файл 'transcripts.csv'.")

if __name__ == "__main__":
    main()