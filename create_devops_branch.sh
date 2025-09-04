#!/bin/bash
#/usr/bin/env bash

work_item=$1
ORIGIN_BRANCH="main"
# NEW_BRANCH="$branch_type/$work_item"
AZURE_DEVOPS_PAT="<Devops_PAT>" #### Update this
authHeader=$(echo -n ":$AZURE_DEVOPS_PAT" | base64)


# Check if a parameter is provided
# if [ -z "$2" ]; then
#   echo "Error: No parameter provided. Please provide a work item ID as a parameter."
#   exit 1
# fi

getResponse=$(curl -X GET \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $authHeader" \
  https://dev.azure.com/{organisation}/{project}_apis/wit/workitems/$work_item?api-version=7.2-preview.3)

# branch_type=$(echo "$getResponse" | jq -r '.fields."System.WorkItemType"')
branch_type=$(echo "$getResponse" | jq -r '.fields."System.WorkItemType"' | awk '{print tolower($0)}')

if [ "$branch_type" == "user story" ];then
  branch_type="story"
fi

# workItemType=$(echo "$getResponse")
echo "Type: $branch_type"
NEW_BRANCH="$branch_type/$work_item"


# # Step 1: Create and switch to a new branch based on origin/main
git fetch origin $ORIGIN_BRANCH
git checkout -b "$NEW_BRANCH" origin/$ORIGIN_BRANCH
git pull origin $ORIGIN_BRANCH
git push --set-upstream origin "$NEW_BRANCH"

# Step 2: Commit all current changes
# git add .
# git commit -m "Fixinator Fixes for #$BUG_ID"

# Step 3: Push changes to the remote repository
# git push --set-upstream origin "$NEW_BRANCH"

# Step 4: Switch back to origin/main branch
# git checkout $ORIGIN_BRANCH

