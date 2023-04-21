#!/bin/bash

GCP_SOURCE_PATH="~/source/github"

function firebase_deploy {
  local firebaseProjectName=$1
  local repositoryPath=$2
  local nodeVersion=$3
  local toolVersion=$4
  repositoryPathArray=(${repositoryPath//\// })
  local repositoryUserName=${repositoryPathArray[0]}
  local repositoryProjectName=${repositoryPathArray[1]}
  echo ${firebaseProjectName}
  echo ${repositoryPath}
  echo ${repositoryUserName}
  echo ${repositoryProjectName}
  echo ${nodeVersion}
  echo ${toolVersion}
  source ~/.bashrc
  node -v
  echo "End."
  exit 1
}

firebase_deploy "$@"
