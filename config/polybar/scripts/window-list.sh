#!/bin/bash

# Colores Gruvbox
ACTIVE_BG="#fe8019"    # Naranja
ACTIVE_FG="#1d2021"    # Negro
RESET="%{F- B-}"

# Iconos por clase de aplicación
get_icon() {
    case "$1" in
        # Terminales
        Alacritty|kitty|XTerm|urxvt|st-256color) echo "" ;;
        
        # Navegadores
        firefox|Firefox|Navigator) echo "" ;;
        Brave-browser|brave|Brave) echo "" ;;
        google-chrome|Google-chrome|chromium) echo "" ;;
        
        # Editores de código
        code|Code|vscodium|VSCodium) echo "" ;;
        jetbrains-idea|jetbrains-pycharm|jetbrains-clion) echo "" ;;
        sublime_text|Sublime_text) echo "" ;;
        geany|Geany) echo "" ;;
        
        # Comunicación
        TelegramDesktop|telegramdesktop) echo "" ;;
        discord|Discord) echo "" ;;
        thunderbird|Thunderbird) echo "" ;;
        signal|Signal) echo "" ;;
        zoom|Zoom) echo "" ;;
        
        # Multimedia
        Spotify|spotify) echo "" ;;
        vlc|Vlc) echo "" ;;
        obs|com.obsproject.Studio) echo "" ;;
        mpv) echo "" ;;
        audacity|Audacity) echo "" ;;
        
        # Utilidades
        thunar|Nautilus|nemo|org.gnome.Nautilus|dolphin) echo "" ;;
        gimp|Gimp) echo "" ;;
        libreoffice-writer|libreoffice-calc|libreoffice-impress) echo "" ;;
        onlyoffice-desktopeditors) echo "" ;;
        evince|org.gnome.Evince|atril) echo "" ;;
        qbittorrent|qbittorrent|transmission-gtk) echo "" ;;
        arandr|XRandr) echo "" ;;
        gnome-system-monitor|ksysguard) echo "" ;;
        
        # Juegos y gráficos
        steam|Steam) echo "" ;;
        lutris|Lutris) echo "" ;;
        blender|Blender) echo "" ;;
        krita|Krita) echo "" ;;
        minecraft-launcher|com.mojang.Minecraft) echo "" ;;
        
        # Otros
        obsidian|Obsidian) echo "" ;;
        zotero|Zotero) echo "" ;;
        calibre|Calibre) echo "" ;;
        virtualbox|VirtualBox) echo "" ;;
        wireshark|Wireshark) echo "" ;;
        
        *) echo "" ;;  # Icono genérico
    esac
}

# Función para acortar rutas largas
shorten_path() {
    local path="$1"
    # Acortar solo si es una ruta de sistema
    if [[ "$path" == *"/"* ]]; then
        # Mantener los últimos 2 directorios
        echo "$path" | awk -F/ '{
            if (NF > 4) {
                print "..." $(NF-1) "/" $NF
            } else {
                print
            }
        }'
    else
        echo "$path"
    fi
}

# Obtener ID de ventana activa con manejo de errores
active_win_id=$(xdotool getactivewindow 2>/dev/null)

# Si no hay ventana activa, salir
if [ -z "$active_win_id" ]; then
    exit 0
fi

# Obtener clase y título de la ventana activa con manejo de errores
class=$(xprop -id $active_win_id WM_CLASS 2>/dev/null | awk -F '"' '{print $4}')
title=$(xdotool getwindowname $active_win_id 2>/dev/null)

# Si no se pudo obtener el título, usar un valor por defecto
if [ -z "$title" ]; then
    title="Active Window"
fi

# Procesar título según la aplicación
case "$class" in
    Alacritty|kitty|XTerm|urxvt|st-256color)
        # Para terminales: mostrar solo la ruta actual
        title=$(echo "$title" | sed 's/^.*: //')
        title=$(shorten_path "$title")
        ;;
    firefox|Firefox|Navigator|Brave-browser|brave|google-chrome|chromium)
        # Para navegadores: eliminar el nombre del navegador del título
        title=$(echo "$title" | sed -e 's/ - Mozilla Firefox$//' -e 's/ - Brave$//' -e 's/ - Google Chrome$//' -e 's/ - Chromium$//')
        ;;
    code|Code|vscodium|VSCodium)
        # Para VS Code: eliminar el nombre de la aplicación
        title=$(echo "$title" | sed 's/^[^-]*- //')
        ;;
    jetbrains-*)
        # Para JetBrains: eliminar el nombre del IDE
        title=$(echo "$title" | sed 's/ - [^-]*$//')
        ;;
    nautilus|Nautilus|thunar|dolphin|nemo)
        # Para gestores de archivos: mostrar solo el último directorio
        title=$(basename "$title")
        ;;
esac

# Limitar longitud máxima del título (80 caracteres)
if [ ${#title} -gt 80 ]; then
    title="${title:0:77}..."
fi

# Obtener icono
icon=$(get_icon "$class")

# Formatear salida
echo "%{F#ebdbb2} $icon $title $RESET"

