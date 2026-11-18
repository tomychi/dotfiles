import subprocess

from libqtile import widget
from libqtile.bar import Bar
from libqtile.config import Key, Screen
from libqtile.lazy import lazy

from settings.constants import colors, pterm


def create_bar() -> Bar:
    return Bar(
        [
            widget.CurrentScreen(
                active_text="▪",
                inactive_text="▪",
                active_color=colors["purple"],
                inactive_color=colors["gray"],
                padding=8,
            ),
            widget.GroupBox(
                active=colors["foreground"],          # groups with windows
                inactive=colors["gray"],              # empty groups
                highlight_method="block",
                rounded=True,
                this_current_screen_border=colors["purple"],
                this_screen_border=colors["gray"],
                other_current_screen_border=colors["gray"],
                other_screen_border=colors["background"],
                block_highlight_text_color=colors["background"],
                padding_x=9,
                padding_y=5,
                spacing=4,
                hide_unused=False,
                borderwidth=0,
                disable_drag=True,
            ),
            widget.Spacer(),
            widget.WindowName(
                foreground=colors["foreground"],
                max_chars=40,
                padding=8,
            ),
            widget.Spacer(),
            widget.Clock(
                format="󰥔 %d/%m %H:%M",
                foreground=colors["foreground"],
                padding=10,
                mouse_callbacks={"Button1": lazy.spawn("gsimplecal")},
            ),
            widget.Volume(
                fmt="󰕾 {}",
                foreground=colors["foreground"],
                get_volume_command="wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100) \"%\"}'",
                mouse_callbacks={
                    "Button4": lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"),
                    "Button5": lazy.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
                    "Button1": lazy.spawn("pavucontrol"),
                },
                padding=8,
            ),
            widget.Memory(
                format="\uf2db {MemUsed:.1f}G",
                measure_mem="G",
                foreground=colors["foreground"],
                padding=8,
                mouse_callbacks={
                    "Button1": lazy.spawn(f"{pterm} --class htop -e htop"),
                },
            ),
            widget.StatusNotifier(icon_size=18, padding=6),
        ],
        28,
        background=colors["background"],
        margin=[6, 12, 0, 12],
    )


def _get_num_monitors() -> int:
    """Count active monitors; fall back to 1 if xrandr is missing or fails."""
    try:
        output = subprocess.check_output(
            ["xrandr", "--listactivemonitors"], text=True, timeout=3
        )
        # First line looks like: "Monitors: 2"
        return max(1, int(output.splitlines()[0].split(":")[1]))
    except (OSError, subprocess.SubprocessError, ValueError, IndexError):
        return 1


screens: list[Screen] = [Screen(top=create_bar()) for _ in range(_get_num_monitors())]

bar_keys: list[Key] = []
