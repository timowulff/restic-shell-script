#!/bin/bash

# USER CONFIGURATION:
resticuser=restic
srcdir=/Users/timowulff/Documents
backupvolume=Timo
backupdir=/Volumes/${backupvolume}/backup-restic

# See: http://blog.macromates.com/2006/keychain-access-from-shell/
# Parse output of 'security' and set RESTIC_PASSWORD:
export RESTIC_PASSWORD=$(security 2>&1 >/dev/null find-generic-password -ga restic |ruby -e 'print $1 if STDIN.gets =~ /^password: "(.*)"$/')

# Backups
restic -r ${backupdir} backup /Users/timowulff/
#restic -r ${backupdir} backup /Library/
restic -r ${backupdir} backup /Applications/
restic -r ${backupdir} snapshots

# Unmount $(backupvolume)
diskutil unmount /dev/$(diskutil list | grep ${backupvolume} | awk '{print $6}')

# Message
osascript -e beep
osascript -e 'tell app "System Events" to display dialog "Backup fertig - Festplatte unmounted!" buttons {"OK"} default button 1 with icon caution with title "Backup Toschiba"'
