#!/bin/bash

# Verifică dacă scriptul rulează cu drepturile de administrator (root)
if [[ $EUID -ne 0 ]]; then
   echo "Acest script trebuie să fie rulat cu drepturile de administrator (root)." 
   exit 1
fi

# Directorul de bază pentru backup
backup_base="/run/media/thinkroot99/1E30-9B9C/ArchBKUP"
log_file="$backup_base/backup.log"

# Funcție pentru a înregistra în jurnal
log() {
    echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> "$log_file"
}

# Crează directorul pentru backup cu un timestamp
backup_directory="$backup_base/backup_$(date +'%Y-%m-%d_%H-%M-%S')"
mkdir -p "$backup_directory"

# Excluderi pentru rsync
rsync_exclusions=(
    --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"}
    --exclude={"/home/*/.cache/*","/home/*/.thumbnails/*","/home/*/.Trash/*"}
)

# Rulează rsync pentru a face backup
rsync -aAXv "${rsync_exclusions[@]}" "/" "$backup_directory"

# Înregistrează sfârșitul backup-ului și motivele
if [ -d "$backup_directory" ]; then
    log "Backup finalizat cu succes."
else
    log "Backupul nu a fost finalizat. Motiv: script oprit manual sau eroare la rsync."
fi

log "Backup finalizat!"
echo "Backup finalizat!" >> "$log_file"
exit 0
