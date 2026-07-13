gnb () {
   if [ $# -eq 0 ]; then
        echo "Usage: gnb <branch name>"
        return 1
    fi

    local branch_name="$1"

    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        git branch -D "$branch_name"
    fi

    git branch -m "$branch_name"
}

# clipboard helper: macOS, Wayland (Hyprland), X11
_clip() {
  if   command -v pbcopy  >/dev/null 2>&1; then pbcopy
  elif command -v wl-copy >/dev/null 2>&1; then wl-copy
  elif command -v xclip   >/dev/null 2>&1; then xclip -selection clipboard
  elif command -v xsel    >/dev/null 2>&1; then xsel --clipboard --input
  else echo "no clipboard tool found (pbcopy/wl-copy/xclip/xsel)" >&2; return 1
  fi
}

# dump every text file under a dir to the clipboard, path-headed
copytree() {
  local dir="${1:-.}" out="" file display count=0

  dir="$(cd "$dir" 2>/dev/null && pwd)" || { echo "copytree: no such directory: $1" >&2; return 1; }

  while IFS= read -r -d '' file; do
    # skip non-empty binary files; keep text + empty files
    if [ -s "$file" ] && [ "$(file -b --mime-encoding "$file")" = binary ]; then
      continue
    fi
    display="${file/#$HOME/\~}"
    out+="${display}"$'\n\n'
    out+="$(cat "$file")"$'\n\n'
    out+="EOF"$'\n\n'
    count=$((count + 1))
  done < <(find "$dir" \
      -type d \( -name .git -o -name node_modules -o -name vendor \
                 -o -name .next -o -name dist -o -name build \) -prune -o \
      -type f -print0)

  printf '%s' "$out" | _clip && echo "copytree: copied $count files to clipboard" >&2
}
