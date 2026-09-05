#!/usr/bin/env bash
# =============================================================================
# Theme: MyTheme
# Variant: Light
# Description: Daylight counterpart of the dark forest palette - birch paper
#              background with the same moss / pine / canopy accent hues,
#              darkened for contrast on light surfaces.
# =============================================================================

declare -gA THEME_COLORS=(
    # =========================================================================
    # CORE (terminal background - used for transparent mode separators)
    # =========================================================================
    [background]="#f2f6ed"               # bg0 - birch paper

    # =========================================================================
    # STATUS BAR
    # =========================================================================
    [statusbar-bg]="#e3ecdd"             # bg1
    [statusbar-fg]="#33493c"             # fg - deep pine ink

    # =========================================================================
    # SESSION (status-left)
    # =========================================================================
    [session-bg]="#3f7d4f"               # green (primary)
    [session-fg]="#f2f6ed"               # bg0
    [session-prefix-bg]="#c26a1f"        # autumn orange
    [session-copy-bg]="#2f8f84"          # spring teal
    [session-search-bg]="#b3892a"        # amber
    [session-command-bg]="#7a5aa8"       # thistle

    # =========================================================================
    # WINDOW (active)
    # =========================================================================
    [window-active-base]="#6d8f1f"       # sunlit leaf (olive)
    [window-active-style]="bold"

    # =========================================================================
    # WINDOW (inactive)
    # =========================================================================
    [window-inactive-base]="#d3e0ca"     # bg2
    [window-inactive-style]="none"

    # =========================================================================
    # WINDOW STATE (activity, bell, zoomed)
    # =========================================================================
    [window-activity-style]="italics"
    [window-bell-style]="bold"
    [window-zoomed-bg]="#2f8f84"         # spring teal

    # =========================================================================
    # PANE
    # =========================================================================
    [pane-border-active]="#3f7d4f"       # green (primary)
    [pane-border-inactive]="#cadcc1"     # bg3

    # =========================================================================
    # STATUS COLORS (health/state-based for plugins)
    # =========================================================================
    [ok-base]="#7e9a83"                  # grey-green
    [good-base]="#4a8f3f"                # fresh leaf
    [info-base]="#2f8f84"                # spring teal
    [warning-base]="#b3892a"             # amber
    [error-base]="#c4483f"               # berry red
    [disabled-base]="#94a892"            # lichen grey-green
    [neutral-base]="#6c8474"             # damp bark

    # =========================================================================
    # MESSAGE COLORS
    # =========================================================================
    [message-bg]="#e3ecdd"               # bg1
    [message-fg]="#33493c"               # fg

    # =========================================================================
    # SELECTION & SEARCH
    # =========================================================================
    [selection-bg]="#cfe3c8"             # pale moss
    [selection-fg]="#26382c"             # deep pine ink
    [search-match-bg]="#b3892a"          # amber
    [search-match-fg]="#f2f6ed"          # bg0

    # =========================================================================
    # POPUP & MENU
    # =========================================================================
    [popup-bg]="#e3ecdd"                 # Popup background
    [popup-fg]="#33493c"                 # Popup foreground
    [popup-border]="#3f7d4f"             # Popup border
    [menu-bg]="#e3ecdd"                  # Menu background
    [menu-fg]="#33493c"                  # Menu foreground
    [menu-selected-bg]="#3f7d4f"         # Menu selected background
    [menu-selected-fg]="#f2f6ed"         # Menu selected foreground
    [menu-border]="#3f7d4f"              # Menu border
)

export THEME_COLORS
