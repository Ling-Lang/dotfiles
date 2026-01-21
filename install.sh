#!/bin/bash

# --- 1. Helfer-Funktionen ---
echo_info() { echo -e "\033[34m[INFO]\033[0m $1"; }
echo_success() { echo -e "\033[32m[OK]\033[0m $1"; }

# --- 2. Oh My Zsh prüfen ---
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo_info "Oh My Zsh nicht gefunden. Installiere es..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

# Deine Pluginsliste:
install_zsh_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
install_zsh_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"

# --- 4. Dotfiles verlinken (Stow) ---
echo_info "Verlinke Dotfiles mit Stow..."

# Stelle sicher, dass wir im richtigen Ordner sind
cd "$(dirname "$0")"

# Führe Stow für alle Pakete aus (ignorier das Script selbst und .git)
# Hier explizit deine Pakete nennen:
stow nvim
stow tmux
stow zsh

echo_success "Installation abgeschlossen! Bitte starte zsh neu."
