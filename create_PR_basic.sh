#!/bin/bash
############################################################
# Help                                                     #
############################################################


# Function to display the help message
show_help() {
  echo "Create a PR branch"
  echo "Usage: $0 [-h] [WORK_ITEM] [REPO_TYPE] [CLIENT]"
  echo ""
  echo "  -h             Display this help message."
  echo "  WORK_ITEM      Work Item number."
  echo "  REPO_TYPE      Repo Type from list ['db','FR', 'portal', 'api']"
  echo "  CLIENT         Client for PR tag, CORE"
  echo ""
  echo "Example create_PR_basic.sh 62454 'FR' 'Purple_Client'"
}


# checks if you have actually done commits to PR
check_has_commits() {
  local current_branch=$1

  commits_ahead=$(git rev-list --count "$current_branch".."origin/main")
  commits_behind=$(git rev-list --count "origin/main".."$current_branch")

  if [ "$commits_ahead" -eq 0 ] && [ "$commits_behind" -eq 0 ]; then
    echo "Branch '$current_branch' has no commits, please make commits and re-run this script"
    exit 1
  else
    echo "The current branch '$current_branch' has new commits compared to the main branch."
  fi
}


# 1. create PR for SQL ⚙️
# 2. get pull request 1d form SQL to add to coldfusion PR
# 3. create coldfusion PR 

# Check for help option
if [ "$1" == "-h" ]; then
  show_help
  exit 0
fi

# Check if exactly 3 arguments are passed
if [[ "$#" -ne 3 ]]; then
  echo "Error: No parameter provided. Please provide a bug ID as a parameter." >&2
  show_help
  exit 1
fi


WORK_ITEM=$1
REPO_TYPE=$2
CLIENT=$3
ORIGIN_BRANCH="main"
AZURE_DEVOPS_PAT="<TOKEN_HERE>" #### Update this
# REPO_TYPES array
REPO_TYPES=("db" "FR" "portal" "api")

authHeader=$(echo -n ":$AZURE_DEVOPS_PAT" | base64)

# Function to check if an REPO_TYPE is in the array
is_in_array() {
  local arg="$REPO_TYPE"
  local found=0
  for element in "${REPO_TYPES[@]}"; do
    if [[ "$element" == "$arg" ]]; then
      found=1
      break
    fi
  done
  echo "$found"
}

# Call the function and check argv for REPO_TYPE is in REPO_TYPES array
if [[ $(is_in_array "$REPO_TYPE") -eq 1 ]]; then
  echo "$REPO_TYPE valid REPO TYPE."
else
  echo "$REPO_TYPE is not a valid REPO TYPE."
  show_help
  exit 1
fi


if [ "$REPO_TYPE" == "db" ];then
  cd <db_path>
  NEW_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  PR_TITLE="🐬#$WORK_ITEM <Insert Title Here>"
  PR_DESCRIPTION="<PR_Description_template>
"

  check_has_commits "$NEW_BRANCH"
  echo "Creating a SQL pull request in Azure DevOps..."
  git push --set-upstream origin "$NEW_BRANCH"

  pullRequestResponse=$(curl -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $authHeader" \
    -d '{
      "sourceRefName": "refs/heads/'"$NEW_BRANCH"'",
      "targetRefName": "refs/heads/'"$ORIGIN_BRANCH"'",
      "title": "'"$PR_TITLE"'",
      "description": "'"$PR_DESCRIPTION"'",
      "reviewers": [
        {
          "id": "<AZURE_ID_FOR_USER>"
        },
        {
          "id": "<AZURE_ID_FOR_USER>"
        }
      ],
      "workItemRefs": [
        {
          "id": '$WORK_ITEM'
        }
      ],
      "labels": [
        {
          "name": "Client: '$CLIENT'"
        }
      ]
    }' \
    https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests?api-version=7.1-preview.1)
elif [ "$REPO_TYPE" == "portal" ];then
  cd <Local_git_folder_location>
  NEW_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  check_has_commits "$NEW_BRANCH"
  PR_TITLE="🎨 #$WORK_ITEM <Insert Title Here>"
  PR_DESCRIPTION="<PR_Description_template>
  "

  pullRequestResponse=$(curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $authHeader" \
  -d '{
    "sourceRefName": "refs/heads/'"$NEW_BRANCH"'",
    "targetRefName": "refs/heads/'"$ORIGIN_BRANCH"'",
    "title": "'"$PR_TITLE"'",
    "description": "'"$PR_DESCRIPTION"'",
    "reviewers": [
      {
        "id": "<AZURE_ID_FOR_USER>"
      },
      {
        "id": "<AZURE_ID_FOR_USER>"
      }
    ],
    "workItemRefs": [
      {
        "id": '$WORK_ITEM'
      }
    ],
    "labels": [
      {
        "name": "Client: '$CLIENT'"
      }
    ]
  }' \
  https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests?api-version=7.1-preview.1)

elif [ "$REPO_TYPE" == "api" ];then
  cd <local_git_folder_location>
  NEW_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  check_has_commits "$NEW_BRANCH"
  PR_TITLE="⛓️ #$WORK_ITEM <Insert Title Here>"
  PR_DESCRIPTION="<PR_Description_template>
"

  pullRequestResponse=$(curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $authHeader" \
  -d '{
    "sourceRefName": "refs/heads/'"$NEW_BRANCH"'",
    "targetRefName": "refs/heads/'"$ORIGIN_BRANCH"'",
    "title": "'"$PR_TITLE"'",
    "description": "'"$PR_DESCRIPTION"'",
    "reviewers": [
      {
        "id": "<AZURE_ID_FOR_USER>"
      },
      {
        "id": "<AZURE_ID_FOR_USER>"
      }
    ],
    "workItemRefs": [
      {
        "id": '$WORK_ITEM'
      }
    ],
    "labels": [
      {
        "name": "Client: '$CLIENT'"
      }
    ]
  }' \
  https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests?api-version=7.1-preview.1)
else
  cd <local_git_folder_location>
  NEW_BRANCH=$(git rev-parse --abbrev-ref HEAD)
  check_has_commits "$NEW_BRANCH"
  PR_TITLE="#$WORK_ITEM <Insert Title Here>"
  PR_DESCRIPTION="<PR_Description_template>
  "

  pullRequestResponse=$(curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Basic $authHeader" \
  -d '{
    "sourceRefName": "refs/heads/'"$NEW_BRANCH"'",
    "targetRefName": "refs/heads/'"$ORIGIN_BRANCH"'",
    "title": "'"$PR_TITLE"'",
    "description": "'"$PR_DESCRIPTION"'",
    "reviewers": [
      {
        "id": "<AZURE_ID_FOR_USER>"
      },
      {
        "id": "<AZURE_ID_FOR_USER>"
      }
    ],
    "workItemRefs": [
      {
        "id": '$WORK_ITEM'
      }
    ],
    "labels": [
      {
        "name": "Client: '$CLIENT'"
      }
    ]
  }' \
  https://dev.azure.com/{organization}/{project}/_apis/git/repositories/{repositoryId}/pullrequests?api-version=7.1-preview.1)
fi


# Extract the pull request ID and URL from the response
pullRequestId=$(echo "$pullRequestResponse" | jq -r '.pullRequestId')
# pullRequestUrl=$(echo "$pullRequestResponse" | jq -r '.url')

# echo "Pull Request created with ID: $pullRequestId"
# echo $pullRequestResponse

# Update state
curl -X PATCH \
  -H "Content-Type: application/json-patch+json" \
  -H "Authorization: Basic $authHeader" \
  -d '[
    {
      "op": "add",
      "path": "/fields/System.State",
      "value": "Code Validation"
    }
  ]' \
  https://dev.azure.com/{organisation}/{project}/_apis/wit/workitems/$WORK_ITEM?api-version=7.0

  echo ""
  echo "Pull Request created with ID: $pullRequestId"
