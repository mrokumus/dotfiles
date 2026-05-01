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
