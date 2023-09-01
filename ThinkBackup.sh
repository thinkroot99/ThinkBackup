#!/bin/bash

# Verifică dacă scriptul rulează cu drepturile de administrator (root)
if [[ $EUID -ne 0 ]]; then
   echo "Acest script trebuie să fie rulat cu drepturile de administrator (root)." 
   exit 1
fi

# Verifică dacă rsync este instalat; dacă nu, îl instalează automat
if ! command -v rsync &> /dev/null; then
    echo "Utilitarul rsync nu este instalat. Se va încerca instalarea automată."
    pacman -S --noconfirm rsync
fi

# Destinația backup-ului (schimbă în funcție de locația dispozitivului tău de stocare)
backup_destination="/mnt/backup"

# Directoriile de pe sistemul de operare pe care vrei să le incluzi în backup
source_directories=(
    "/etc"
    "/home"
    "/var"
    # Adaugă aici alte directoare pe care vrei să le incluzi
)

# Execută backup-ul utilizând rsync
rsync_options="-aAXv --delete --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"}"

echo "Începerea backup-ului..."
for dir in "${source_directories[@]}"; do
    echo "Backup director: $dir"
    rsync $rsync_options "$dir" "$backup_destination"
done

echo "Backup finalizat!"

