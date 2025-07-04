#!/bin/bash

# Archivo para almacenar el historial
CLIP_FILE="$HOME/.cache/clip_history.txt"
mkdir -p ~/.cache
touch "$CLIP_FILE"

# Función para agregar al historial
add_to_history() {
    # Obtener contenido actual del clipboard
    if [ "$XDG_SESSION_TYPE" = "x11" ]; then
        content=$(wl-paste -n 2>/dev/null)
    else
        content=$(xclip -o -selection clipboard 2>/dev/null)
    fi
    
    # Solo agregar si hay contenido y es diferente al último
    if [ -n "$content" ]; then
        last=$(tail -n1 "$CLIP_FILE" 2>/dev/null)
        if [ "$content" != "$last" ]; then
            echo "$content" >> "$CLIP_FILE"
            # Mantener solo los últimos 50 items
            tail -n 50 "$CLIP_FILE" > "$CLIP_FILE.tmp"
            mv "$CLIP_FILE.tmp" "$CLIP_FILE"
        fi
    fi
}

# Función para mostrar el historial
show_history() {
    # Mostrar en orden inverso (más recientes primero) con tema Gruvbox
    selected=$(tac "$CLIP_FILE" | rofi -dmenu -i -p "Clipboard" \
        -theme-str 'window {width: 60%;}' \
        -theme-str '* {background: #282828; foreground: #ebdbb2;}' \
        -theme-str 'listview {lines: 10;}' \
        -theme-str 'element {padding: 5px;}' \
        -theme-str 'element-text {background-color: inherit; text-color: inherit;}' \
        -theme-str 'element selected {background-color: #458588; text-color: #282828;}')
    
    if [ -n "$selected" ]; then
        # Copiar al clipboard
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            wl-copy "$selected"
        else
            echo "$selected" | xclip -selection clipboard
        fi
    fi
}

# Función para obtener conteo
get_count() {
    count=$(wc -l < "$CLIP_FILE" 2>/dev/null)
    echo -n "${count:-0}"  # -n elimina salto de línea
}

# Manejar acciones
case "$1" in
    "add")
        add_to_history
        ;;
    "show")
        show_history
        ;;
    "count")
        get_count
        ;;
    *)
        get_count
        ;;
esac
