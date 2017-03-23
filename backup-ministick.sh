#!/bin/bash

# USER CONFIGURATION:
resticuser=backup-ministick
backupvolume=MINISTICK
backupdir=/Volumes/${backupvolume}/restic-backup

# See: http://blog.macromates.com/2006/keychain-access-from-shell/
# Parse output of 'security' and set RESTIC_PASSWORD:
export RESTIC_PASSWORD=$(security 2>&1 >/dev/null find-generic-password -ga ${resticuser} |ruby -e 'print $1 if STDIN.gets =~ /^password: "(.*)"$/')

# Backups
restic -r ${backupdir} backup /Users/timowulff/projects
#restic -r ${backupdir} backup /Library/
restic -r ${backupdir} backup /Users/timowulff/Documents
restic -r ${backupdir} snapshots

# Unmount $(backupvolume)
# diskutil unmount /dev/$(diskutil list | grep ${backupvolume} | awk '{print $6}')

# Message

osascript -e beep
osascript -e 'tell app "System Events" to display dialog "Backup fertig!" buttons {"OK"} default button 1 with title "Backup Ministick" with icon file "Users:timowulff:projects:restic-script:10073512.icns"'
