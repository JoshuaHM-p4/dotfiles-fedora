#!/usr/bin/env bash
# =============================================================================
# Theme: MyTheme
# Variant: Dark
# Description: Deep forest greens tuned to the Fedora shell / Alacritty palette
#              (background #061917). Moss, pine and canopy tones with autumn
#              accents for prefix / warning states.
# =============================================================================

declare -gA THEME_COLORS=(
    # =========================================================================
    # CORE (terminal background - used for transparent mode separators)
    # =========================================================================
    [background]="#061917"               # matches Alacritty colors.primary.background

    # =========================================================================
    # STATUS BAR
    # =========================================================================
    [statusbar-bg]="#0b211d"             # bg1 - forest floor
    [statusbar-fg]="#bcd0b6"             # fg  - pale sage

    # =========================================================================
    # SESSION (status-left)
    # =========================================================================
    [session-bg]="#5aa469"               # green (primary)
    [session-fg]="#041210"               # bg0 - near black green
    [session-prefix-bg]="#d98e48"        # autumn orange
    [session-copy-bg]="#5fbcae"          # spring teal
    [session-search-bg]="#d4b95e"        # amber
    [session-command-bg]="#a98cc4"       # thistle

    # =========================================================================
    # WINDOW (active)
    # =========================================================================
    [window-active-base]="#a7c957"       # sunlit leaf (olive-lime)
    [window-active-style]="bold"

    # =========================================================================
    # WINDOW (inactive)
    # =========================================================================
    [window-inactive-base]="#16332c"     # bg2 - pine shade
    [window-inactive-style]="none"

    # =========================================================================
    # WINDOW STATE (activity, bell, zoomed)
    # =========================================================================
    [window-activity-style]="italics"
    [window-bell-style]="bold"
    [window-zoomed-bg]="#5fbcae"         # spring teal

    # =========================================================================
    # PANE
    # =========================================================================
    [pane-border-active]="#5aa469"       # green (primary)
    [pane-border-inactive]="#16332c"     # bg2

    # =========================================================================
    # STATUS COLORS (health/state-based for plugins)
    # =========================================================================
    [ok-base]="#1d4038"                  # bg3 - deep moss
    [good-base]="#7fc46a"                # fresh leaf
    [info-base]="#5fbcae"                # spring teal
    [warning-base]="#d4b95e"             # amber
    [error-base]="#e0685f"               # berry red
    [disabled-base]="#5a7566"            # lichen grey-green
    [neutral-base]="#3b5c4f"             # damp bark

    # =========================================================================
    # MESSAGE COLORS
    # =========================================================================
    [message-bg]="#0b211d"               # bg1
    [message-fg]="#bcd0b6"               # fg

    # =========================================================================
    # SELECTION & SEARCH
    # =========================================================================
    [selection-bg]="#1d4038"             # deep moss
    [selection-fg]="#d7e8d0"             # bright sage
    [search-match-bg]="#d4b95e"          # amber
    [search-match-fg]="#041210"          # bg0

    # =========================================================================
    # POPUP & MENU
    # =========================================================================
    [popup-bg]="#0b211d"                 # Popup background
    [popup-fg]="#bcd0b6"                 # Popup foreground
    [popup-border]="#5aa469"             # Popup border
    [menu-bg]="#0b211d"                  # Menu background
    [menu-fg]="#bcd0b6"                  # Menu foreground
    [menu-selected-bg]="#5aa469"         # Menu selected background
    [menu-selected-fg]="#041210"         # Menu selected foreground
    [menu-border]="#5aa469"              # Menu border
)

export THEME_COLORS
