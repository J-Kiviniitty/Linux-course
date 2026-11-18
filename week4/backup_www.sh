#!/usr/bin/env bash

TIMESTAMP=$(date +%Y%m%d-%H%M%S)

REMOTE_HOST="128.214.252.249"
REMOTE_USER="backupuser"

BACKUP_DIR="/srv/backups/www/$TIMESTAMP"

rsync -av \
    -e "ssh -i /home/ubuntu/.ssh/backup_key" \
    /var/www/html/ \
    ${REMOTE_USER}@${REMOTE_HOST}:${BACKUP_DIR}/

if [ $? -eq 0 ]; then
    echo "$(date) SUCCESS" >> /home/ubuntu/week4/backup.log
else
    echo "$(date) FAILED" >> /home/ubuntu/week4/backup.log
fi
