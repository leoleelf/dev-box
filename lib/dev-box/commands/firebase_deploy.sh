#!/bin/bash

GCP_SOURCE_PATH="~/source/github"

function firebase_deploy {
  while getopts "g:r:n:t:f:s:uc" opt; do
    case ${opt} in
      g )
        local gcpProjectName="${OPTARG}"
        ;;
      r )
        local repositoryPath="${OPTARG}"
        repositoryPathArray=(${repositoryPath//\// })
        local repositoryUserName=${repositoryPathArray[0]}
        local repositoryProjectName=${repositoryPathArray[1]}
        ;;
      n )
        local nodeConfig="${OPTARG}"
        ;;
      t )
        local toolVersion="${OPTARG}"
        ;;
      f )
        local functions="${OPTARG}"
        ;;
      s )
        GCP_SOURCE_PATH="${OPTARG}"
        ;;
      u )
        local isUpdateSourceMode=true
        ;;
      c )
        local isSourceClean=true
        ;;
      \? ) # Handle invalid options
        echo "Invalid option: -$OPTARG" >&2
        ;;
      : ) # Handle missing arguments
        echo "Option -$OPTARG requires an argument" >&2
        ;;
    esac
  done
  shift $((OPTIND -1))
  echo ${gcpProjectName}
  echo ${repositoryPath}
  echo ${repositoryUserName}
  echo ${repositoryProjectName}
  echo ${nodeVersion}
  echo ${toolVersion}
  echo ${isUpdateSourceMode}
  if [ "$isSourceClean" == true ]; then
    rm -rf "$GCP_SOURCE_PATH/$repositoryPath"
  fi
  if [ "$isUpdateSourceMode" == true ]; then
    if [ ! -d "$GCP_SOURCE_PATH/$repositoryPath" ]; then
      mkdir -p "$GCP_SOURCE_PATH/$repositoryPath"
      git clone -b master --single-branch https://github.com/$repositoryPath.git "$GCP_SOURCE_PATH/$repositoryPath"
    else
      cd "$GCP_SOURCE_PATH/$repositoryPath"
      git fetch origin
      git reset --hard origin/master
      cd ~
    fi
    exit 0
  fi
  if [ ! -d "$gcpProjectName" ]; then
    gcloud config set project $gcpProjectName
  fi
  cd "$GCP_SOURCE_PATH/$repositoryPath"
  pwd
  source ~/.bashrc
  if [ ! -z "$nodeConfig" ]; then
    if [ -z "${nodeConfig##*','*}" ]; then
      IFS=',' read -ra arr <<< "$nodeConfig"
      nodeVersion="${arr[0]}"
      export NVM_DIR="${arr[1]}"
    else
      nodeVersion="$nodeConfig"
      export NVM_DIR="/usr/local/nvm"
    fi
    source $NVM_DIR/nvm.sh
    nvm install "$nodeVersion"
    nvm use "$nodeVersion"
  fi
  node -v
  if [ -z "${repositoryProjectName##*'fron'*}" ] && [ -z "${repositoryProjectName##*'end'*}" ] ; then
    # Replace `npm ci` with `npm i` since GCP Shell may clear the node_modules files
    rm -rf node_modules
    HUSKY=0 npm i
    set -e

    if [ -z "${gcpProjectName##*'admin'}" ]; then
      npm run build -- -env=admin
    elif [ -z "${gcpProjectName##*'prod'}" ]; then
      npm run build -- -env=prod
    else
      npm run build -- -env=dev
    fi
    firebase use "$gcpProjectName"
    firebase deploy --only hosting
  fi
  echo "End."
  exit 1
}

firebase_deploy "$@"
