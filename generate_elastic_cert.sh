#!/bin/bash

# Путь к elasticsearch-certutil (если он не в $PATH, укажите полный путь)
CERTUTIL_BIN="/usr/share/elasticsearch/bin/elasticsearch-certutil"

# Выходной файл
OUTPUT_FILE="elastic-certificates.p12"

# Папка, куда сохранить результат
OUTPUT_DIR="./certs"

# Проверка наличия certutil
if [ ! -x "$CERTUTIL_BIN" ]; then
    echo "elasticsearch-certutil не найден или не исполняемый: $CERTUTIL_BIN"
    exit 1
fi

# Создание папки
mkdir -p "$OUTPUT_DIR"

# Генерация p12 сертификата
"$CERTUTIL_BIN" cert --silent --out "$OUTPUT_DIR/$OUTPUT_FILE" --pass ""

# Проверка результата
if [ $? -eq 0 ]; then
    echo "✅ Сертификат успешно создан: $OUTPUT_DIR/$OUTPUT_FILE"
else
    echo "❌ Ошибка при создании сертификата"
    exit 2
fi
