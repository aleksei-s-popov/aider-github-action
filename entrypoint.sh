#!/bin/bash

# Set constants
WORKDIR="/tmp/repo"

# Get env vars
BRANCH_NAME=$(echo $FEATURE_REF | sed 's/refs\/heads\///g')

# Workaround for writing files inside the container
cp -r "${GITHUB_WORKSPACE}" "${WORKDIR}"
# Switch to the repo directory
cd "${WORKDIR}"

# Fix repo ownership issues
git config --global --add safe.directory "${WORKDIR}"

# Set git config (For some reason setting this in the Dockerfile doesn't work!)
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"

# Checkout feature branch
git fetch
git checkout $BRANCH_NAME

# Parse and execute each aider command from the JSON array
echo "$AIDER_MESSAGE_LIST" | jq -r '.[]' | while read -r command; do
    # Run aider command
    echo $command
    echo "aider --model $MODEL $AIDER_ARGS  --message $command"
    eval "aider --model $MODEL $AIDER_ARGS  --message $command"
done

# Push changes
git push -u origin $BRANCH_NAME
