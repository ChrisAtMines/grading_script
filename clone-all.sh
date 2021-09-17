#!/bin/bash

ASSIGNMENT=$1
ROSTER=$2

echo $ASSIGNMENT
NUM_STUDENTS=$(jq length roster.json)

for (( i=0; i<$NUM_STUDENTS; i++ ))
do
    SECTION=$(jq -r .[$i].section roster.json)
    GIT_REPO_USER=$(jq -r .[$i].univ_username roster.json)
    STUDENT_NAME_FIRST=$(jq -r .[$i].name_first roster.json)
    STUDENT_NAME_LAST=$(jq -r .[$i].name_last roster.json)

    STUDENT_NAME=${STUDENT_NAME_FIRST// /_}_${STUDENT_NAME_LAST// /_}
    GIT_URL="https://github.com/mines-csci400/f21${SECTION}-user-${GIT_REPO_USER}-${ASSIGNMENT}"
    CLONE_DIR="sec_$SECTION/${STUDENT_NAME}/"
    echo "Grabbing $STUDENT_NAME_FIRST $STUDENT_NAME_LAST"
    git clone $GIT_URL $CLONE_DIR
done


