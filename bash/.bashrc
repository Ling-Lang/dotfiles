# ==============================================================================
# 1. INIT & INTERACTIVE CHECK
# ==============================================================================
# Wenn die Shell nicht interaktiv ist (z.B. scp oder sftp), nichts tun.
# Das verhindert Fehler bei Datentransfers.
[[ $- != *i* ]] && return

# ==============================================================================
# 2. HISTORY & SESSION SETTINGS
# ==============================================================================
# Keine Duplikate und keine Befehle, die mit Leerzeichen beginnen, speichern
HISTCONTROL=ignoreboth

# Endlose History (optional, aber sehr nützlich)
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend  # History anhängen statt überschreiben

# Checken der Fenstergröße nach jedem Befehl (verhindert Umbruch-Fehler)
shopt -s checkwinsize

# Standard-Editor festlegen (Wichtig für git, crontab, visudo)
export EDITOR='vim'
export VISUAL='vim'

# ==============================================================================
# 3. PROMPT & FARBEN (Das Wichtigste für Server!)
# ==============================================================================
# Farben definieren
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"
YELLOW="\[\033[0;33m\]"
BLUE="\[\033[0;34m\]"
RESET="\[\033[0m\]"

# Logik: Bin ich per SSH eingeloggt?
if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
    # SERVER-MODUS: Roter Hostname als Warnsignal
    HOST_COLOR="$RED"
else
    # LOKALER MODUS: Grüner Hostname
    HOST_COLOR="$GREEN"
fi

# Der Prompt Aufbau: [User@Host:Pfad]$
# \u = User, \h = Host, \w = Pfad
PS1="${RESET}[${YELLOW}\u${RESET}@${HOST_COLOR}\h${RESET}:${BLUE}\w${RESET}]\$ "

# Farb-Support für ls und grep aktivieren
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ==============================================================================
# 4. ALIASE (Quality of Life)
# ==============================================================================
# Bessere Listenansichten
alias ll='ls -lha'       # Liste, hidden, human-readable size
alias la='ls -A'         # Alles außer . und ..
alias l='ls -CF'

# Sicherheitsnetz: Nachfragen bei destruktiven Aktionen
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Schneller Zugriff auf Configs (Refresh mit 'reload')
alias reload='source ~/.bashrc'

# Server spezifisch: Einfacher Port-Check
alias ports='netstat -tulanp'

# ==============================================================================
# 5. NÜTZLICHE FUNKTIONEN
# ==============================================================================
# Erstellt einen Ordner und wechselt sofort hinein
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Zeigt Logfiles live an mit Syntax-Highlighting (braucht 'ccze' falls installiert, sonst normal)
logs() {
    if command -v ccze >/dev/null 2>&1; then
        tail -f "$1" | ccze
    else
        tail -f "$1"
    fi
}

# ==============================================================================
# 6. EXTERNE SOURCES (Für Stow-Struktur)
# ==============================================================================
# Lädt separate Dateien, falls sie existieren.
# Perfekt, wenn du z.B. eine .bash_aliases in deinem 'common' Ordner hast.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Optional: Server-spezifische Extras
if [ -f ~/.bash_server ]; then
    . ~/.bash_server
fi
