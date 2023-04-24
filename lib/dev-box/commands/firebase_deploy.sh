#!/bin/bash

GCP_SOURCE_PATH="~/source/github"

function firebase_deploy {
  while getopts "g:r:n:t:f:s:u" opt; do
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
        local nodeVersion="${OPTARG}"
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
  source ~/.bashrc
  node -v
  echo "End."
  exit 1
}

firebase_deploy "$@"
