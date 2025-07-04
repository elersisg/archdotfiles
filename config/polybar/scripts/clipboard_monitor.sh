#!/bin/bash

# Inicializar último contenido
last_content=""

while true; do
    # Obtener contenido actual
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        current_content=$(wl-paste -n 2>/dev/null)
    else
        current_content=$(xclip -o -selection clipboard 2>/dev/null)
    fi
    
    # Si el contenido cambió y no está vacío
    if [ -n "$current_content" ] && [ "$current_content" != "$last_content" ]; then
        ~/.config/polybar/scripts/clipboard.sh add
        last_content="$current_content"
    fi
    
    sleep 1
done
