-- This is an example Hyprland config file.
-- Refer to the wiki for more information.
-- https://wiki.hyprland.org/Configuring/Configuring-Hyprland/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can split this configuration into multiple files
-- Create your files separately and then link them to this file like this:
-- require("myColors")


----------------
---- MONITORS --
----------------

-- See https://wiki.hyprland.org/Configuring/Monitors/
hl.monitor({
    output   = "",
    mode     = "5120x1440@240",
    position = "auto",
    scale    = 1,
    vrr      = 1,
})

-------------------
---- MY PROGRAMS --
-------------------

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "nautilus"
local menu        = "tofi-drun --drun-launch=true"


-----------------
---- AUTOSTART --
-----------------

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/unlock-keyring.sh")
    hl.exec_cmd("waybar")
    hl.exec_cmd("firefox")
    hl.exec_cmd("exec obsidian", { workspace = "special silent" })
    hl.exec_cmd("rambox")
    hl.exec_cmd("exec signal-desktop", { workspace = "special silent" })
    hl.exec_cmd(terminal)
    hl.exec_cmd("/usr/libexec/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("exec vivaldi --no-first-run --new-window 'https://meet.google.com/landing?authuser=1'", { workspace = "2 silent" })
    -- For Japanese input
    hl.exec_cmd("fcitx5")
    -- This should autostart, but it doesn't :'(
    hl.exec_cmd("systemctl start hypridle --user")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
end)

---------------------------
---- ENVIRONMENT VARIABLES
---------------------------

-- See https://wiki.hyprland.org/Configuring/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


---------------------
---- LOOK AND FEEL --
---------------------

-- Refer to https://wiki.hyprland.org/Configuring/Variables/

-- https://wiki.hyprland.org/Configuring/Variables/#general
hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,

        border_size = 1,

        -- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
        col = {
            active_border   = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        -- Set to true enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border        = true,
        extend_border_grab_area = 15,
        hover_icon_on_border    = true,

        -- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "master",
    },

    -- https://wiki.hyprland.org/Configuring/Variables/#decoration
    decoration = {
        rounding = 0,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        -- https://wiki.hyprland.org/Configuring/Variables/#blur
        blur = {
            enabled = true,
            size    = 3,
            passes  = 1,

            vibrancy = 0.1696,
        },
    },

    -- https://wiki.hyprland.org/Configuring/Variables/#animations
    animations = {
        enabled = true,
    },
})

-- Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows",     enabled = true, speed = 7,  bezier = "myBezier" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 7,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 6,  bezier = "default" })

-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
hl.config({
    master = {
        orientation = "center",
        -- Center window takes 50% of 5120 = 2560px (one 1440p screen),
        -- leaving 1280px (half a screen) for each side column.
        mfact = 0.5,
        -- Only go 3-column once there are 2+ side windows...
        slave_count_for_center_master = 2,
        -- ...with 2 windows total, fall back to a plain 50/50 left/right split.
        center_master_fallback = "left",
        -- New windows join the side columns instead of stealing the center.
        new_status     = "slave",
        smart_resizing = true,
    },
})

-- https://wiki.hyprland.org/Configuring/Variables/#misc
hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


-------------
---- INPUT --
-------------

-- https://wiki.hyprland.org/Configuring/Variables/#input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "colemak",
        kb_model   = "",
        kb_rules   = "",
        kb_options = "grp:alt_shift_toggle", -- e.g. Alt+Shift to switch if you ever add more layout

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

-- Example per-device config
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


--------------------
---- KEYBINDINGSS --
--------------------

-- See https://wiki.hypr.land/Hypr-Ecosystem/hyprlock/#keywords
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local fnKey   = "FN"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- Master layout: https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
-- Promote the focused window into the big center column
hl.bind(mainMod .. " + Return", hl.dsp.layout("swapwithmaster master"))
-- Widen / narrow the center column
hl.bind(mainMod .. " + minus", hl.dsp.layout("mfact -0.025"), { repeating = true })
hl.bind(mainMod .. " + equal", hl.dsp.layout("mfact +0.025"), { repeating = true })
-- Reset the center column to exactly half the screen
hl.bind(mainMod .. " + 0", hl.dsp.layout("mfact exact 0.5"))
-- Shuffle windows around the ring without changing focus
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.layout("swapnext"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.layout("swapprev"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))

-- Move active window to a workspace with mainMod + SHIFT + [0-9]
hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("special"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:special" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Hide taskbar on Super+B
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("killall -SIGUSR1 waybar"))

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("grimblast --freeze copysave area"), { locked = true })
-- Screencast
hl.bind("Insert", hl.dsp.exec_cmd([[pkill --signal SIGINT wf-recorder || wf-recorder -f ~/Videos/recording-$(date +%F_%T).mkv -g "$(slurp)"]]), { locked = true })

-- Volume control
-- Increase volume
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })

-- Lower volume
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })

-- Mute music
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- Play and pause
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- Next song
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Previous song
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
