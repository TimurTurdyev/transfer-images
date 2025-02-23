#!/bin/bash

# Настройки
MAX_ATTEMPTS=10          # 0 = бесконечные попытки
RETRY_DELAY=10           # Задержка между попытками (в секундах)
RSYNC_CMD="rsync -avh --progress --partial --exclude='*.webp' /путь/к/папке/ user@server:/целевой/путь/"
LOG_FILE="transfer.log"  # Файл для записи логов

# Функция для выполнения синхронизации
run_sync() {
    echo "=== Запуск передачи данных ===" >> "$LOG_FILE"
    
    local attempt=1
    local success=0
    
    while [[ $success -ne 1 ]]; do
        echo -e "\n[$(date +%H:%M:%S)] Попытка #$attempt" >> "$LOG_FILE"
        
        # Выполняем команду и записываем вывод
        $RSYNC_CMD >> "$LOG_FILE" 2>&1
        
        if [[ $? -eq 0 ]]; then
            echo -e "\n[✓] Передача успешно завершена!" >> "$LOG_FILE"
            success=1
        else
            echo -e "\n[!] Ошибка передачи (попытка $attempt)" >> "$LOG_FILE"
            
            if [[ $MAX_ATTEMPTS -ne 0 && $attempt -ge $MAX_ATTEMPTS ]]; then
                echo "[!] Достигнуто максимальное число попыток ($MAX_ATTEMPTS)" >> "$LOG_FILE"
                exit 2
            fi
            
            echo "Повтор через $RETRY_DELAY сек..." >> "$LOG_FILE"
            sleep $RETRY_DELAY
            ((attempt++))
        fi
    done
}

# Запуск в фоновом режиме
run_sync & disown

echo "Скрипт запущен в фоновом режиме. Логи пишутся в: $LOG_FILE"
echo "Для просмотра логов используйте: tail -f $LOG_FILE"
