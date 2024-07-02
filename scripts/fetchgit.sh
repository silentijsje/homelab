#!/bin/bash

# Define an array of directories
directories=(
    "/home/gamer0308/github/homelab_pub"
)

# Iterate over each directory
for dir in "${directories[@]}"; do
    echo "Processing directory: $dir"
    cd "$dir" || exit

    # Fetch the remote repository
    echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Fetching remote repository..."
    git fetch

    # Set the upstream branch
    UPSTREAM=${1:-'@{u}'}

    # Get the local, remote, and base commit hashes
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")

    # Check if the local and remote branches are the same
    if [ "$LOCAL" = "$REMOTE" ]; then
        echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Up-to-date"
    elif [ "$LOCAL" = "$BASE" ]; then
        BUILD_VERSION=$(git rev-list HEAD)
        echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Changes detected, deploying new version $BUILD_VERSION"
        ./scripts/deploy.sh
    elif [ "$REMOTE" = "$BASE" ]; then
        echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Local changes detected, stashing..."
        git stash
        ./scripts/deploy.sh
    else
        echo "$(TZ='Europe/Amsterdam' date +%FT%T%z): Diverged"
    fi
done