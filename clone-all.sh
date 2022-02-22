#!/bin/bash

ASSIGNMENT=${@: -1}

while getopts 'r:p' flag; do
    case "${flag}" in
        r) ROSTER=${OPTARG} ;; 
        p) PULL=true ;;
    esac
done

if [ -z "$ROSTER" ]
then
    ROSTER=roster.json
fi


NUM_STUDENTS=$(jq length $ROSTER)

for (( i=0; i<$NUM_STUDENTS; i++ ))
do
#    SECTION=$(jq -r .[$i].section $ROSTER)
#   GIT_REPO_USER=$(jq -r .[$i].univ_username $ROSTER)
#   STUDENT_NAME_FIRST=$(jq -r .[$i].name_first $ROSTER)
#   STUDENT_NAME_LAST=$(jq -r .[$i].name_last $ROSTER)

    TEAM_NAME=$(jq -r .[$i].team_name $ROSTER)
    GIT_URL="git@github.com:mines-csci400/s22-team-${TEAM_NAME}"
    CLONE_DIR="repos/${TEAM_NAME}"
    echo "Grabbing $TEAM_NAME"
    if [ "$PULL" = true ]
    then
        cd $CLONE_DIR
	echo cleaning
	make clean
        echo pulling
        git pull 
        cd ../../
    else
        git clone $GIT_URL $CLONE_DIR -f
    fi
done

if [ -e temp.json ]
then
    rm temp.json
fi
