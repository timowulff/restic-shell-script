#!/bin/bash

# USER CONFIGURATION:
resticuser=restic
backupvolume=Timo
backupdir=/Volumes/${backupvolume}/backup-restic

# See: http://blog.macromates.com/2006/keychain-access-from-shell/
# Parse output of 'security' and set RESTIC_PASSWORD:
export RESTIC_PASSWORD=$(security 2>&1 >/dev/null find-generic-password -ga ${resticuser} |ruby -e 'print $1 if STDIN.gets =~ /^password: "(.*)"$/')

# Backups
restic -r ${backupdir} backup /Users/$USER/ --exclude ~/Documents/SHK
restic -r ${backupdir} backup /Applications/
restic -r ${backupdir} backup /Library/Mail/
restic -r ${backupdir} snapshots

# Unmount $(backupvolume)
# diskutil unmount /dev/$(diskutil list | grep ${backupvolume} | awk '{print $6}')

# Message
osascript -e beep
osascript -e 'tell app "System Events" to display dialog "Backup done - don't forget to unmount!" buttons {"OK"} default button 1 with icon caution with title "Backup Toschiba ohne Sticker"'
