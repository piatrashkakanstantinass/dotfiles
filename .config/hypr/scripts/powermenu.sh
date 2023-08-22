#!/usr/bin/sh

case "$(echo -e 'Shutdown' | wofi --show dmenu \)" in
        Shutdown) exec systemctl poweroff;;
        Restart) exec systemctl reboot;;
        Logout) kill -HUP $XDG_SESSION_PID;;
        Suspend) exec systemctl suspend;;
        Lock) exec systemctl --user start lock.target;;
esac