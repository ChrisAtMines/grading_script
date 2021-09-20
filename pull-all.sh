#!/bin/bash

ASSIGNMENT=$1

if [ -z "$2" ]
then 
    ROSTER=roster.json
else
    ROSTER=$2
fi

echo $ASSIGNMENT
NUM_STUDENTS=$(jq length $ROSTER)

for (( i=0; i<$NUM_STUDENTS; i++ ))
do
    SECTION=$(jq -r .[$i].section $ROSTER)
    GIT_REPO_USER=$(jq -r .[$i].univ_username $ROSTER)
    STUDENT_NAME_FIRST=$(jq -r .[$i].name_first $ROSTER)
    STUDENT_NAME_LAST=$(jq -r .[$i].name_last $ROSTER)
    echo $STUDENT_NAME_FIRST
    STUDENT_NAME=${STUDENT_NAME_FIRST// /_}_${STUDENT_NAME_LAST// /_}
    GIT_URL="https://github.com/mines-csci400/f21${SECTION}-user-${GIT_REPO_USER}-${ASSIGNMENT}"
    PULL_DIR="sec_$SECTION/${STUDENT_NAME}/"
    echo "Grabbing $STUDENT_NAME_FIRST $STUDENT_NAME_LAST"
    cd $PULL_DIR
    git pull $GIT_URL
    cd ../..
done


