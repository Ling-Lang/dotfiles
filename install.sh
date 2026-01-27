#!/bin/bash

# --- 1. Helfer-Funktionen ---
echo_info() { echo -e "\033[34m[INFO]\033[0m $1"; }
echo_success() { echo -e "\033[32m[OK]\033[0m $1"; }
echo_warn() { echo -e "\033[33m[WARN]\033[0m $1"; }
echo_err() { echo -e "\033[31m[ERROR]\033[0m $1"; }

# Stelle sicher, dass wir im Dotfiles-Verzeichnis sind
cd "$(dirname "$0")"

# --- 2. Debian/Ubuntu Auto-Install ---
# Wir prüfen, ob 'apt-get' existiert. Wenn ja, sind wir wohl auf Debian/Ubuntu.
if command -v apt-get &> /dev/null; then
    echo_info "Debian/Ubuntu erkannt. Prüfe Pakete..."

    PACKAGES="git build-essential stow tmux vim wget"
    
    # Befehl zusammenbauen: Wenn wir nicht Root sind, 'sudo' davorhängen
    if [ "$EUID" -ne 0 ]; then
        # Prüfen ob sudo überhaupt installiert ist
        if ! command -v sudo &> /dev/null; then
            echo_err "Ich bin nicht Root und 'sudo' ist nicht installiert. Kann keine Pakete laden."
            echo_info "Bitte installiere manuell: apt install $PACKAGES"
            exit 1
        fi
        CMD="sudo apt-get"
    else
        CMD="apt-get"
    fi

    echo_info "Update Paketquellen..."
    $CMD update -y > /dev/null

    echo_info "Installiere: $PACKAGES"
    # DEBIAN_FRONTEND=noninteractive verhindert nervige Popups bei der Installation
    DEBIAN_FRONTEND=noninteractive $CMD install -y $PACKAGES

    if [ $? -eq 0 ]; then
        echo_success "Pakete erfolgreich installiert/aktualisiert."
    else
        echo_err "Fehler bei der Paketinstallation."
        exit 1
    fi
else
    echo_warn "Kein Debian/Ubuntu gefunden. Überspringe Paketinstallation."
    # Fallback: Prüfen ob stow wenigstens da ist, sonst macht der Rest keinen Sinn
    if ! command -v stow &> /dev/null; then
        echo_err "'stow' ist nicht installiert und ich kann es nicht automatisch laden."
        exit 1
    fi
fi

# --- 3. Backup-Logik ---
echo_info "Bereite Dotfiles vor..."

backup_if_exists() {
    local filename="$1"
    local target="$HOME/$filename"

    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo_warn "Konflikt gefunden: $target ist eine echte Datei."
        local backup_name="$target.backup.$(date +%Y%m%d_%H%M%S)"
        mv "$target" "$backup_name"
        echo_success "Backup erstellt: $backup_name"
    elif [ -L "$target" ]; then
        # Optional: Nur Loggen, nichts tun, Stow regelt das meistens
        : 
    fi
}

# Wichtige Dateien vorab checken
backup_if_exists ".bashrc"
backup_if_exists ".vimrc"
backup_if_exists ".profile"
backup_if_exists ".bash_aliases"
backup_if_exists ".tmux.conf"

# --- 4. Stow (Alles im aktuellen Branch) ---
echo_info "Führe Stow aus..."

# Loop durch alle Ordner im aktuellen Verzeichnis
for folder in */; do
    folder=${folder%/} # Slash am Ende entfernen
    
    # Ignorieren von .git Ordnern und dem Script selbst
    if [[ "$folder" == ".git" || "$folder" == ".github" ]]; then
        continue
    fi

    echo_info "Stowing Paket: $folder"
    # -R (Restow) ist wichtig, um Links zu aktualisieren/korrigieren
    stow -R "$folder"
done

echo_success "Installation abgeschlossen!"
echo_info "Tipp: Starte deine Shell neu oder tippe 'source ~/.bashrc'"
