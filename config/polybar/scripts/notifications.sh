#!/bin/bash

# Archivos de estado
STATE_FILE="$HOME/.cache/notifications_state"
HISTORY_FILE="$HOME/.cache/notifications_history"

# Inicializar si no existen
mkdir -p ~/.cache
touch "$HISTORY_FILE"
[ ! -f "$STATE_FILE" ] && echo "0" > "$STATE_FILE"

# Actualizar estado
update_state() {
    unread=$(dunstctl count waiting 2>/dev/null || echo 0)
    echo "$unread" > "$STATE_FILE"
}

# Mostrar historial de notificaciones
show_history() {
    # Obtener historial de notificaciones
    history=$(dunstctl history)
    
    # Formatear para rofi (appname: summary - body)
    formatted=$(echo "$history" | jq -r '.data[][] | 
        [.appname, .summary, .body] | join(": ") | gsub("[\\n\\t]"; " ")')
    
    # Mostrar en rofi con tema Gruvbox
    selected=$(echo "$formatted" | rofi -dmenu -i -p "Notifications" \
        -theme-str 'window {width: 60%;}' \
        -theme-str '* {background: #282828; foreground: #ebdbb2;}' \
        -theme-str 'listview {lines: 15;}' \
        -theme-str 'element {padding: 5px;}' \
        -theme-str 'element-text {background-color: inherit; text-color: inherit;}' \
        -theme-str 'element selected {background-color: #458588; text-color: #282828;}')
    
    # Si se selecciona una notificación, mostrarla
    if [ -n "$selected" ]; then
        id=$(echo "$selected" | awk -F': ' '{print $1}')
        dunstctl history-pop "$id"
    fi
}

# Manejar acciones
case "$1" in
    "update")
        update_state
        ;;
    "click")
        show_history
        ;;
    *)
        # Leer estado actual
        unread=$(cat "$STATE_FILE")
        echo " $unread"
        ;;
esac
