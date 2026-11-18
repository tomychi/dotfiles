function update --description "Safe full Arch update (repo + AUR) with cleanup and health checks"
    for tool in checkupdates yay paccache
        if not type -q $tool
            echo "missing tool: $tool (install pacman-contrib / yay)"
            return 1
        end
    end

    echo "==> Arch news (read it before big updates)"
    yay -Pw

    echo "==> Pending repo updates"
    checkupdates

    echo "==> Updating official repos + AUR (never run 'pacman -Sy' alone)"
    yay -Syu $argv
    or return 1

    echo "==> Cleaning package cache (keeping the last 2 versions)"
    sudo paccache -rk2
    sudo paccache -ruk0

    set -l orphans (pacman -Qdtq)
    if test (count $orphans) -gt 0
        echo "==> Orphaned packages (review before removing):"
        printf '  %s\n' $orphans
        echo "    Remove with: sudo pacman -Rns (pacman -Qdtq)"
    end

    set -l pacnew (find /etc \( -name '*.pacnew' -o -name '*.pacsave' \) 2>/dev/null)
    if test (count $pacnew) -gt 0
        echo "==> Config files to merge (run 'sudo pacdiff'):"
        printf '  %s\n' $pacnew
    end

    set -l failed (systemctl --failed --no-legend --plain)
    if test (count $failed) -gt 0
        echo "==> Failed systemd units:"
        printf '  %s\n' $failed
    end

    if not test -d /usr/lib/modules/(uname -r)
        echo "==> Kernel was updated: reboot required"
    end
end
