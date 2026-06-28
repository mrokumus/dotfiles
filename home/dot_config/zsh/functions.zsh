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

cachy() {
  local mac="34:5a:60:a3:40:48"
  local ip="192.168.1.10"     # reserved IP — used for the readiness probe
  local host="cachy"          # ssh_config alias — used for the connection
  local max_wait=90           # give up after this many seconds

  # --- dependency check: report, don't install ---
  if ! command -v wakeonlan >/dev/null 2>&1; then
    echo "cachy: wakeonlan not found." >&2
    echo "install wakeonlan via your package manager." >&2
    return 1
  fi

  if ! command -v nc >/dev/null 2>&1; then
    echo "cachy: nc (netcat) not found — needed for the readiness probe." >&2
    return 1
  fi

  # --- send the magic packet ---
  echo "⏻  waking $host ($mac)..."
  wakeonlan "$mac" >/dev/null || {
    echo "cachy: failed to send magic packet." >&2
    return 1
  }

  # --- wait until sshd is accepting connections (port probe, auth-independent) ---
  echo "waiting for $host to come up..."
  local waited=0
  until nc -z -w 2 "$ip" 22 >/dev/null 2>&1; do
    sleep 2
    waited=$((waited + 2))
    if [ "$waited" -ge "$max_wait" ]; then
      echo "cachy: $host didn't respond after ${max_wait}s — plugged in? WOL armed? same subnet?" >&2
      return 1
    fi
  done

  echo "$host is up — connecting."
  ssh "$host"
}
