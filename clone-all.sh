#!/bin/bash

ASSIGNMENT=${@: -1}
PULL=false
while getopts 'r:s:' flag; do
    case "${flag}" in
        r) ROSTER=${OPTARG} ;;
        s) SECTION_ARG=${OPTARG} ;;
        p) PULL=true ;;
    esac
done

echo "r: $ROSTER"
echo "s: $SECTION_ARG"
echo "p: $PULL"

if [ -z "$ROSTER" ]
then
    ROSTER=roster.json
fi

if [ -n "$SECTION_ARG" ]
then
    if [ $SECTION_ARG == "a" ]
    then
        jq '[.[] | select(.section == "a")]' roster.json > temp.json
    else
        jq '[.[] | select(.section == "b")]' roster.json > temp.json
    fi
    ROSTER=temp.json
    echo "Getting section $SECTION_ARG"
fi


NUM_STUDENTS=$(jq length $ROSTER)

for (( i=0; i<$NUM_STUDENTS; i++ ))
do
    if [ -z "$SECTION_ARG" ]
    then
        SECTION=$(jq -r .[$i].section $ROSTER)
    else
        SECTION=$SECTION_ARG
    fi
    
    GIT_REPO_USER=$(jq -r .[$i].univ_username $ROSTER)
    STUDENT_NAME_FIRST=$(jq -r .[$i].name_first $ROSTER)
    STUDENT_NAME_LAST=$(jq -r .[$i].name_last $ROSTER)

    STUDENT_NAME=${STUDENT_NAME_FIRST// /_}_${STUDENT_NAME_LAST// /_}
    GIT_URL="https://github.com/mines-csci400/f21${SECTION}-user-${GIT_REPO_USER}-${ASSIGNMENT}"
    CLONE_DIR="sec_$SECTION/${STUDENT_NAME}/${ASSIGNMENT}"
    echo "Grabbing $STUDENT_NAME_FIRST $STUDENT_NAME_LAST"
    if  $PULL
    then
	echo "pulling bc im broken :("
        cd $CLONE_DIR
        git pull 
        cd ../../..
    else
        git clone $GIT_URL $CLONE_DIR
    fi
done

if [ -e temp.json ]
then
    rm temp.json
fi
