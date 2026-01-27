# ~/.profile: executed by the command interpreter for login shells.

# Wenn wir Bash nutzen, lade die .bashrc
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# Pfad erweitern (optional, aber gut für eigene Scripte/Binaries)
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi
