#!/bin/sh
# Start the gnome-keyring secrets provider and unlock the login keyring once
# at session start. On Hyprland, GDM's PAM does not leave an unlocked keyring
# daemon in the session, so safeStorage-based apps (Wire, Signal, Element, ...)
# fail with "Encryption is not available" until the login keyring is unlocked.
#
# Touching the default collection forces the gcr-prompter unlock dialog to
# appear; entering your login password unlocks it for the whole session.
# The dummy item is removed immediately afterwards.

# Make sure D-Bus / Wayland env is visible to activated services.
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 2>/dev/null

# Start the secrets (+ssh) component if not already running.
gnome-keyring-daemon --start --components=secrets,ssh >/dev/null 2>&1

# Give the bus a moment to settle, then trigger an interactive unlock.
sleep 1
printf 'x' | secret-tool store --label='hypr-keyring-unlock' _hypr keyring-unlock >/dev/null 2>&1
secret-tool clear _hypr keyring-unlock >/dev/null 2>&1
