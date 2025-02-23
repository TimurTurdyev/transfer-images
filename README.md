# transfer-images
Transfer a folder with pictures between servers

`bash
# Просмотр логов в реальном времени:
tail -f transfer.log

# Поиск ошибок:
grep '\[!\]' transfer.log

chmod +x images_bg_transfer_sync.sh

pgrep -f "images_bg_transfer_sync.sh"

kill -9 <PID>
`
