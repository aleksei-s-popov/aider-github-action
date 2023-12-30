#!/bin/bash

# Set constants
WORKDIR="/tmp/repo"

# Get args
AIDER_ARGS=$1

# Get env vars
BRANCH_NAME=$(echo $FEATURE_REF | sed 's/refs\/heads\///g')

if [[ -z "$OPENAI_API_KEY" ]]; then
    echo "OPENAI_API_KEY env var is not set"
    exit 1
fi

# Workaround for writing files inside the container
cp -r $GITHUB_WORKSPACE $WORKDIR
# Switch to the repo directory
cd $WORKDIR

# Fix repo ownership issues
git config --global --add safe.directory $WORKDIR

# Set git config (For some reason setting this in the Dockerfile doesn't work!)
git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"
git config --global user.name "github-actions[bot]"

# Checkout feature branch
git fetch
git checkout $BRANCH_NAME

# Run aider command
eval "aider $AIDER_ARGS"

# Push changes
git push -u origin $BRANCH_NAME
