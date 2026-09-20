#!/usr/bin/env bash
# Claude Code statusline, styled as an extension of the tmux-powerkit bar.
# Managed in ~/.dotfiles/claude — apply with `stow claude` from ~/.dotfiles.
# Needs Fira Code Nerd Font (set in alacritty.toml).
#
# Colours come from the tmux theme mytheme/dark, several read straight off the
# RUNNING tmux server rather than the theme file. Every block is a light green
# so the very dark green text stays legible on it:
#
#   model    session green #5aa469, as the live bar paints #S
#   dir      active-window lime #a7c957, the bar's signature colour
#   git      fresh leaf #7fc46a, or warning amber when the tree is dirty
#   context  spring teal, escalating to amber then berry
#   cost     pale sage
#
# Layout follows powerkit: transparent bar, rounded edge caps and normal
# separators between blocks. Each block is a single tone with its icon and
# label one space apart, the way powerkit draws the session block — splitting a
# block across two shades would force a full-width separator between an icon
# and its own text. Text is bold, as powerkit's session/active blocks are.

# ---- colours ---------------------------------------------------------------
# All text is dark green (#0b211d, the theme's "forest floor"), so every block
# needs a light background under it. Backgrounds are the theme's light greens,
# with amber/berry reserved for alert states — the same roles powerkit uses.
#
# The text is deliberately darker than the theme's own floor (#041210) and a
# touch more saturated, so it still reads green instead of collapsing to black:
# its green channel leads red/blue by 6, where #041210 leads by only 2.
# Darkening text on these light blocks only raises contrast — worst case is
# 5.84:1 on the berry alert, up from 5.05:1. The real limit is the other
# direction: lightening it toward #1d4038 drops berry to 3.43:1 and fails AA.
# Muted deliberately: each block is blended toward pine #16332c — 30% for the
# session block, 40% for the rest, 25% for the alert states so they stay a
# little more vivid than their surroundings. Contrast runs 3.2-5.3:1, below
# WCAG AA but chosen by preference over a brighter bar; the text is bold, which
# is what keeps it legible. Re-check these if the text is ever lightened again.
TEXT="#04170e"          # dark green, close to near-black

SESSION_BG="#468257"    # session green, muted 30%
ACTIVE_BG="#6d8d46"     # active-window lime, muted 40%
LEAF_BG="#558a51"       # fresh leaf, muted 40%
TEAL_BG="#42857a"       # spring teal, muted 40%
SAGE_BG="#7a917f"       # pale sage, muted 40%
WARN_BG="#a49852"       # warning amber, muted 25%
ERROR_BG="#ae5b52"      # error berry, muted 25%

# ---- glyphs (all verified present in FiraCodeNerdFont-Medium) --------------
CAP_L=$''   # rounded left edge   @powerkit_edge_separator_style rounded
CAP_R=$''   # rounded right edge
SEP=$''     # normal separator    @powerkit_separator_style normal
I_MODEL=$'\U000f06a9'
I_DIR=$''
I_GIT=$''
I_CTX=$''
I_COST=$''

input=$(cat)

# One field per line: mapfile splits on literal newlines, so empty fields keep
# their position (a tab-delimited `read` collapses them — tab is IFS whitespace).
mapfile -t f < <(
    printf '%s' "$input" | jq -r '
        (.workspace.current_dir // .cwd // ""),
        (.model.display_name // "?"),
        (.model.id // ""),
        (.transcript_path // ""),
        (.cost.total_cost_usd // 0)'
)
cwd=${f[0]}; model_name=${f[1]:-?}; model_id=${f[2]}
transcript=${f[3]}; cost=${f[4]:-0}

[ -z "$cwd" ] && cwd=$PWD
dir=${cwd/#$HOME/\~}

# ---- git -------------------------------------------------------------------
branch=""; dirty=""
if git -C "$cwd" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$cwd" symbolic-ref --quiet --short HEAD 2>/dev/null) ||
        branch=$(git -C "$cwd" rev-parse --short HEAD 2>/dev/null)
    [ -n "$(git -C "$cwd" status --porcelain 2>/dev/null)" ] && dirty="*"
fi

# ---- context window ----------------------------------------------------------
# Claude Code sends the real numbers directly on context_window in the
# statusline payload — context_window_size and a pre-computed used_percentage.
# Nothing here is guessed. An earlier version of this script inferred the
# window size (200k vs 1M) from a "[1m]" substring in model.id: that broke the
# moment a session switched to Sonnet 5, whose id carries no such marker even
# with a 1M window active, and silently showed ~95% where /context said 20%.
#
# Fallback (fmt_used only, no window/pct) covers callers that predate this
# field or don't set it — older CLI versions, or a hand-built test payload —
# by reading current_usage/the transcript directly instead of showing nothing.
fmt_tok() { awk -v u="$1" 'BEGIN{
    if      (u >= 999500) printf "%.1fm", u/1000000  # round-to-m before round-to-k can hit "1000k"
    else if (u >= 1000)   printf "%.0fk", u/1000
    else                  printf "%d", u
}'; }

ctx=""; have_pct=""; pct_r=0
win=$(printf '%s' "$input" | jq -r '.context_window.context_window_size // empty')
pct=$(printf '%s' "$input" | jq -r '.context_window.used_percentage // empty')
used=$(printf '%s' "$input" | jq -r '
    (.context_window.current_usage // {})
    | (.input_tokens // 0) + (.output_tokens // 0)
    + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0)' 2>/dev/null)
[ -n "$used" ] && [ "$used" = 0 ] && used=""

if [ -n "$win" ] && [ -n "$pct" ] && [ -n "$used" ]; then
    pct_r=$(awk -v p="$pct" 'BEGIN{printf "%d", p+0.5}')   # round, don't truncate
    ctx="$(fmt_tok "$used")/$(fmt_tok "$win") (${pct_r}%)"
    have_pct=1
elif [ -z "$used" ] && [ -f "$transcript" ]; then
    # Read the tail, not the whole file: `tac` slurps the entire transcript to
    # reverse it, which grows without bound over a session (at 544K that alone
    # measured 261ms, against a ~90ms budget for the whole repaint). `tail -n`
    # seeks from the end instead. The newest turn is effectively always in the
    # last few lines; fall back to a full scan only if it somehow isn't.
    find_usage() { grep -v '"isSidechain":true' | grep -m1 '"usage":'; }
    line=$(tail -n 60 "$transcript" 2>/dev/null | tac | find_usage)
    [ -z "$line" ] && line=$(tac "$transcript" 2>/dev/null | find_usage)
    if [ -n "$line" ]; then
        used=$(printf '%s' "$line" | jq -r '
            (.message.usage // {})
            | (.input_tokens // 0)
            + (.cache_creation_input_tokens // 0)
            + (.cache_read_input_tokens // 0)' 2>/dev/null)
    fi
fi

[ -z "$ctx" ] && [ -n "$used" ] && [ "$used" -gt 0 ] 2>/dev/null && ctx="$(fmt_tok "$used")"

# ---- USD -> PHP ------------------------------------------------------------
# The cost arrives in USD. Rates are cached for 12h and refreshed in a detached
# background job: this script runs on every statusline repaint, so a network
# call must never sit in the render path. A repaint always draws from whatever
# is already cached, even if stale, and the fresh value lands on a later one.
RATE_API="https://open.er-api.com/v6/latest/USD"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/claude-statusline"
RATE_FILE="$CACHE_DIR/usd-php"
RATE_TTL=43200          # 12h — this feed publishes daily
LOCK="$CACHE_DIR/.rate-lock"

rate=""; rate_at=0
[ -r "$RATE_FILE" ] && read -r rate rate_at < "$RATE_FILE" 2>/dev/null
printf -v now '%(%s)T' -1

if [ -z "$rate" ] || [ $(( now - ${rate_at:-0} )) -ge "$RATE_TTL" ]; then
    mkdir -p "$CACHE_DIR" 2>/dev/null
    # Clear a lock left behind by a refresh that was killed mid-flight.
    [ -d "$LOCK" ] && [ -z "$(find "$LOCK" -maxdepth 0 -mmin -5 2>/dev/null)" ] &&
        rmdir "$LOCK" 2>/dev/null
    if mkdir "$LOCK" 2>/dev/null; then
        (
            r=$(curl -fsS --max-time 10 "$RATE_API" 2>/dev/null |
                jq -r '.rates.PHP // empty' 2>/dev/null)
            case "$r" in
                ''|*[!0-9.]*) ;;   # unreachable, or not a bare number
                *) printf '%s %s\n' "$r" "$now" > "$RATE_FILE.tmp" &&
                   mv -f "$RATE_FILE.tmp" "$RATE_FILE" ;;
            esac
            rmdir "$LOCK" 2>/dev/null
        ) >/dev/null 2>&1 &
        disown 2>/dev/null
    fi
fi

# Group thousands without depending on locale.
if [ -n "$rate" ]; then
    cost_txt="₱$(awk -v c="$cost" -v r="$rate" 'BEGIN {
        s = sprintf("%.2f", c * r); split(s, p, ".")
        n = p[1]; g = ""
        while (length(n) > 3) { g = "," substr(n, length(n) - 2) g; n = substr(n, 1, length(n) - 3) }
        printf "%s%s.%s", n, g, p[2]
    }')"
    cost_icon=$I_COST
else
    cost_txt=$(printf '$%.2f' "$cost")   # no rate yet; show the source figure
    cost_icon=$I_USD
fi

# ---- collect segments ------------------------------------------------------
# Single tone per block, the way powerkit draws the session block: icon and
# label share one field, one space apart. Splitting them across two shades
# would force a full-width separator between an icon and its own text.
icons=(); bases=(); txts=()
seg() { icons+=("$1"); bases+=("$2"); txts+=("$3"); }

seg "$I_MODEL" "$SESSION_BG" "$model_name"
seg "$I_DIR"   "$ACTIVE_BG"  "$dir"

if [ -n "$branch" ]; then
    if [ -n "$dirty" ]; then seg "$I_GIT" "$WARN_BG" "${branch}${dirty}"
    else                     seg "$I_GIT" "$LEAF_BG" "$branch"
    fi
fi

if [ -n "$ctx" ]; then
    # Tiered colour only applies when have_pct is real (from
    # context_window.used_percentage) — the fallback (bare token count, no
    # known window) has nothing to threshold against, so it stays neutral.
    if   [ -z "$have_pct" ]; then    seg "$I_CTX" "$TEAL_BG"  "$ctx"
    elif [ "$pct_r" -ge 80 ]; then   seg "$I_CTX" "$ERROR_BG" "$ctx"
    elif [ "$pct_r" -ge 60 ]; then   seg "$I_CTX" "$WARN_BG"  "$ctx"
    else                             seg "$I_CTX" "$TEAL_BG"  "$ctx"
    fi
fi

seg "$cost_icon" "$SAGE_BG" "$cost_txt"

# ---- render ----------------------------------------------------------------
E=$'\e'
rgb() { local h=${1#\#}; printf '%d;%d;%d' "0x${h:0:2}" "0x${h:2:2}" "0x${h:4:2}"; }

# Caps sit on the terminal default background, preserving window opacity.
out="${E}[0m${E}[38;2;$(rgb "${bases[0]}")m${CAP_L}"

for i in "${!txts[@]}"; do
    [ "$i" -gt 0 ] &&
        out+="${E}[0m${E}[38;2;$(rgb "${bases[i-1]}");48;2;$(rgb "${bases[i]}")m${SEP}"
    out+="${E}[38;2;$(rgb "$TEXT");48;2;$(rgb "${bases[i]}");1m ${icons[i]} ${txts[i]} "
done

out+="${E}[0m${E}[38;2;$(rgb "${bases[-1]}")m${CAP_R}${E}[0m"
printf '%s' "$out"
