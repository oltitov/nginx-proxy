#!/usr/bin/env bash
PROJECTS_DIR=/projects/*
BACKUPS_DIR=/backups

for f in $PROJECTS_DIR; do
  if [ -f "$f/Makefile" ] && grep -Fxq "backup:" "$f/Makefile"; then
    cd $f;
    make backup;
    backupFile=$(ls -t | head -1);
    mv $backupFile "$BACKUPS_DIR/$backupFile";
    echo "finished: $backupFile";
  fi
done
