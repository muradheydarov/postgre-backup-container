#!/bin/sh
DUMP_FILE_NAME="backupOn`date +%Y-%m-%d-%H-%M`.dump"
BACKUP_LIMIT=$BACKUP_LIMIT
if [ "$BACKUP_LIMIT" == "" ]; then
  echo "BACKUP_LIMIT not setted. Default BACKUP_LIMIT is 10"
  BACKUP_LIMIT=10
else
  echo "BACKUP_LIMIT setted to $BACKUP_LIMIT"
fi

echo "Creating dump: $DUMP_FILE_NAME"

cd pg_backup

pg_dump -C -w --format=c --blobs > $DUMP_FILE_NAME

if [ $? -ne 0 ]; then
  rm $DUMP_FILE_NAME
  echo "Back up not created, check db connection settings"
  exit 1
fi

FILES_TO_REMOVE=$(ls -t | sed -e "1,$BACKUP_LIMIT d")

if [ ! -z "$FILES_TO_REMOVE" -a "$FILES_TO_REMOVE" != " " ]; then
  ls -t | sed -e "1,$BACKUP_LIMIT d" | xargs rm -r 

  echo "Removed files: $FILES_TO_REMOVE"
fi

echo 'Successfully Backed Up'
exit 0
