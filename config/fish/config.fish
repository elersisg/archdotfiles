if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -U fish_greeting
if not set -q GNOME_KEYRING_CONTROL
    for line in (gnome-keyring-daemon --start | string split \n)
        set key (string split "=" -- $line)[1]
        set val (string split "=" -- $line)[2]
        set -gx $key $val
    end
end
