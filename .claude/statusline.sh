#!/usr/bin/env bash
# Claude Code status line.
# Left:  model + reasoning effort, flags, clickable issue link, vim mode.
# Right: usage — context window, session (5h) and week (7d) rate limits with reset time.
# Docs: https://code.claude.com/docs/en/statusline

input=$(cat)

IFS=$'\t' read -r model effort fast thinking vim cwd ctx ctx_size ctx_used five five_reset week week_reset < <(
  jq -r '[
    (.model.display_name // "?"),
    (.effort.level // "-"),
    (.fast_mode // false),
    (.thinking.enabled // false),
    (.vim.mode // "-"),
    (.workspace.current_dir // .cwd // "-"),
    (.context_window.used_percentage // "-"),
    (.context_window.context_window_size // "-"),
    ((.context_window.current_usage // {})
       | ((.input_tokens // 0) + (.cache_creation_input_tokens // 0) + (.cache_read_input_tokens // 0))
       | if . > 0 then . else "-" end),
    (.rate_limits.five_hour.used_percentage // "-"),
    (.rate_limits.five_hour.resets_at // "-"),
    (.rate_limits.seven_day.used_percentage // "-"),
    (.rate_limits.seven_day.resets_at // "-")
  ] | @tsv' 2>/dev/null <<<"$input"
)

# Fall back cleanly if stdin was empty or not valid JSON.
[ -z "$model" ] && model="?"
[ -z "$effort" ] && effort="-"

RESET=$'\033[0m'; DIM=$'\033[2m'; BOLD=$'\033[1m'
CYAN=$'\033[36m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'
MAGENTA=$'\033[35m'; RED=$'\033[31m'; ORANGE=$'\033[38;5;208m'

# Context-window thresholds (% of the window). Quality tends to degrade well
# before the window is full, so warn early and flag danger before auto-compact.
CTX_WARN=50     # orange: getting close
CTX_DANGER=70   # red: danger zone

# Columns kept free at the right edge. Claude Code indents the status line by
# two columns and truncates a line that reaches the last one, so 4 lands the
# text one or two cells from the edge. Raise it if the line still gets cut off.
RIGHT_MARGIN=4

# OSC 8 hyperlink: osc8 <url> <text>
osc8() { printf '\033]8;;%s\a%s\033]8;;\a' "$1" "$2"; }

# Visible width of a string: strip ANSI CSI sequences and OSC 8 links, then
# count terminal cells. East-Asian wide/fullwidth glyphs take 2 cells; the
# ambiguous ones used here (·, │, ↻) render as 1 cell in this terminal.
vlen() {
  python3 - "$1" <<'PYEOF'
import re, sys, unicodedata as u
s = sys.argv[1]
s = re.sub(r'\x1b\[[0-9;]*[A-Za-z]', '', s)
s = re.sub(r'\x1b\]8;;[^\x07]*\x07', '', s)
w = 0
for c in s:
    if u.combining(c):
        continue
    if u.east_asian_width(c) in ('W', 'F'):
        w += 2
    else:
        w += 1
print(w)
PYEOF
}

# Colour for a 0-100 percentage: green < 50, yellow < 80, red otherwise.
pct_color() {
  local p=${1%%.*}
  if   [ "$p" -ge 80 ] 2>/dev/null; then printf '%s' "$RED"
  elif [ "$p" -ge 50 ] 2>/dev/null; then printf '%s' "$YELLOW"
  else printf '%s' "$GREEN"; fi
}

# Colour for context usage: green, orange from CTX_WARN, red from CTX_DANGER.
ctx_color() {
  local p=${1%%.*}
  if   [ "$p" -ge "$CTX_DANGER" ] 2>/dev/null; then printf '%s' "$RED$BOLD"
  elif [ "$p" -ge "$CTX_WARN" ]   2>/dev/null; then printf '%s' "$ORANGE"
  else printf '%s' "$GREEN"; fi
}

# Human token count: 1234 -> 1k, 123456 -> 123k, 1000000 -> 1M
htok() {
  local n=${1%%.*}
  if   [ "$n" -ge 1000000 ] 2>/dev/null; then awk -v n="$n" 'BEGIN{printf "%.1fM", n/1000000}' | sed 's/\.0M/M/'
  elif [ "$n" -ge 1000 ]    2>/dev/null; then printf '%dk' $(( n / 1000 ))
  else printf '%s' "$n"; fi
}

# Reset moment from an epoch: "14:32" when it is today, else "28/09 14:32".
reset_at() {
  local now="$(date +%s)"
  [ "$1" -le "$now" ] 2>/dev/null && { printf 'now'; return; }
  if [ "$(date -d "@$1" +%Y%m%d)" = "$(date +%Y%m%d)" ]; then
    date -d "@$1" +%H:%M
  else
    date -d "@$1" '+%d/%m %H:%M'
  fi
}

case "$effort" in
  low)    EC=$GREEN ;;
  medium) EC=$YELLOW ;;
  high)   EC=$MAGENTA ;;
  xhigh)  EC=$RED ;;
  max)    EC=$RED$BOLD ;;
  *)      EC=$DIM ;;
esac

sep="${DIM} · ${RESET}"

# ---------------------------------------------------------------- left side
left="${CYAN}${BOLD}${model}${RESET}"

if [ "$effort" = "-" ]; then
  left="${left}${sep}${DIM}effort n/a${RESET}"
else
  left="${left}${sep}${EC}${effort} effort${RESET}"
fi

[ "$fast" = "true" ]     && left="${left}${sep}${YELLOW}fast${RESET}"
[ "$thinking" = "true" ] && left="${left}${sep}${DIM}thinking${RESET}"

# Issue link, derived from a "<number>-slug" branch name
if [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)
  issue=$(printf '%s' "$branch" | grep -oE '^[0-9]+' || true)
  if [ -n "$issue" ]; then
    remote=$(git -C "$cwd" remote get-url origin 2>/dev/null)
    # git@host:group/project.git  ->  https://host/group/project
    base=$(printf '%s' "$remote" \
      | sed -E 's#^git@([^:]+):#https://\1/#; s#^ssh://git@([^/]+)/#https://\1/#; s#\.git$##')
    if [ -n "$base" ]; then
      link=$(osc8 "${base}/-/issues/${issue}" "#${issue}")
      left="${left}${sep}${GREEN}${link}${RESET}"
    else
      left="${left}${sep}${GREEN}#${issue}${RESET}"
    fi
  fi
fi

[ -n "$vim" ] && [ "$vim" != "-" ] && left="${left}${sep}${DIM}${vim}${RESET}"

# --------------------------------------------------------------- right side
right=""
rsep="${DIM} │ ${RESET}"
add_right() { right="${right:+${right}${rsep}}$1"; }

if [ "$ctx" != "-" ] && [ -n "$ctx" ]; then
  cc=$(ctx_color "$ctx")
  # Used tokens: prefer the exact count, else derive from the percentage.
  if [ "$ctx_used" = "-" ] && [ "$ctx_size" != "-" ]; then
    ctx_used=$(awk -v p="$ctx" -v s="$ctx_size" 'BEGIN{printf "%d", p*s/100}')
  fi
  if [ "$ctx_used" != "-" ] && [ "$ctx_size" != "-" ]; then
    add_right "${DIM}ctx ${RESET}${cc}$(htok "$ctx_used")${RESET}${DIM}/$(htok "$ctx_size")${RESET} ${cc}${ctx%%.*}%${RESET}"
  else
    add_right "${DIM}ctx ${RESET}${cc}${ctx%%.*}%${RESET}"
  fi
fi
# Rate limits, labelled like /usage: "session" is the rolling 5h window,
# "week" the 7-day one. "↻ <time>" is the moment the window resets.
if [ "$five" != "-" ] && [ -n "$five" ]; then
  s="${DIM}session ${RESET}$(pct_color "$five")${five%%.*}%${RESET}"
  [ "$five_reset" != "-" ] && s="${s}${DIM} ↻ $(reset_at "$five_reset")${RESET}"
  add_right "$s"
fi
if [ "$week" != "-" ] && [ -n "$week" ]; then
  s="${DIM}week ${RESET}$(pct_color "$week")${week%%.*}%${RESET}"
  [ "$week_reset" != "-" ] && s="${s}${DIM} ↻ $(reset_at "$week_reset")${RESET}"
  add_right "$s"
fi

# ------------------------------------------------------------------ layout
cols=${COLUMNS:-0}
if [ -n "$right" ] && [ "$cols" -gt 0 ] 2>/dev/null; then
  gap=$(( cols - RIGHT_MARGIN - $(vlen "$left") - $(vlen "$right") ))
  if [ "$gap" -ge 2 ]; then
    printf '%s%*s%s\n' "$left" "$gap" "" "$right"
  else
    # Too narrow to right-align: fall back to a plain separator.
    printf '%s%s%s\n' "$left" "$sep" "$right"
  fi
elif [ -n "$right" ]; then
  printf '%s%s%s\n' "$left" "$sep" "$right"
else
  printf '%s\n' "$left"
fi
