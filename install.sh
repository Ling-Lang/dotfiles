#!/bin/bash

# --- 1. Helfer-Funktionen ---
echo_info() { echo -e "\033[34m[INFO]\033[0m $1"; }
echo_success() { echo -e "\033[32m[OK]\033[0m $1"; }
echo_warn() { echo -e "\033[33m[WARN]\033[0m $1"; }

# Funktion zum Backup existierender Dateien
backup_file() {
    local file="$1"
    if [ -e "$file" ] && [ ! -L "$file" ]; then
        # Nur backuppen, wenn es eine echte Datei ist (kein Symlink)
        # Wenn es schon ein Symlink ist, wird er von Stow meistens einfach überschrieben/angepasst
        local timestamp=$(date +%Y%m%d_%H%M%S)
        local backup_name="${file}.backup.${timestamp}"
        
        echo_warn "Datei $file existiert bereits und ist kein Symlink."
        echo_info "Erstelle Backup unter: $backup_name"
        mv "$file" "$backup_name"
    elif [ -L "$file" ]; then
        # Optional: Wenn ein falscher Symlink existiert, diesen entfernen, damit Stow sauber arbeiten kann
        echo_info "Entferne alten Symlink $file, um Konflikte zu vermeiden."
        rm "$file"
    fi
}

# --- 2. Oh My Zsh prüfen ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo_info "Oh My Zsh nicht gefunden. Installiere es..."
    # WICHTIG: --keep-zshrc verhindert, dass OMZ deine .zshrc sofort mit einem Template überschreibt
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
    echo_success "Oh My Zsh ist bereits installiert."
fi

# Pfad für Custom Plugins definieren
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# --- 3. Plugins installieren ---
install_zsh_plugin() {
    local name="$1"
    local repo="$2"
    local target="$ZSH_CUSTOM/plugins/$name"

    if [ ! -d "$target" ]; then
        echo_info "Installiere Plugin: $name..."
        git clone "$repo" "$target"
    else
        echo_success "Plugin '$name' ist bereits da."
    fi
}

install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

# --- Neovim Plugin Manager (vim-plug) ---
VIM_PLUG_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"

if [ ! -f "$VIM_PLUG_FILE" ]; then
    echo_info "Installiere vim-plug für Neovim..."
    curl -fLo "$VIM_PLUG_FILE" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
else
    echo_success "vim-plug ist bereits installiert."
fi

echo_info "Installiere tpm für tmux..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# --- 4. Dotfiles verlinken (Stow) ---
echo_info "Verlinke Dotfiles mit Stow..."

# Stelle sicher, dass wir im richtigen Ordner sind
cd "$(dirname "$0")"

# === NEU: Backup Logik vor dem Stowing ===
# Da Stow abbricht, wenn .zshrc eine echte Datei ist, verschieben wir sie vorher.
# Oh My Zsh erstellt oft eine Default .zshrc, die wir hier beiseite schaffen.
backup_file "$HOME/.zshrc"
# Falls du auch eine existierende .p10k.zsh oder tmux.conf hast, kannst du das hier auch machen:
# backup_file "$HOME/.tmux.conf" 

stow nvim
stow tmux
stow zsh

echo_info "Installiere Neovim Plugins..."
# Startet nvim headless, führt PlugInstall aus und beendet sich wieder
nvim --headless +PlugInstall +qall

echo_success "Installation abgeschlossen!"
exec zsh -l
