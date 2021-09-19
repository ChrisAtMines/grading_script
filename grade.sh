#!/bin/bash

ASSIGNMENT=$1
if [ -z "$2" ]
then
	RSCDIR=grader_files
else
	RSCDIR=$2
fi

ROSTER=$RSCDIR/roster.json

echo $ASSIGNMENT
NUM_STUDENTS=$(jq length $ROSTER)

for (( i=0; i<$NUM_STUDENTS; i++ ))
do
	SECTION=$(jq -r .[$i].section $ROSTER)
	STUDENT_NAME_FIRST=$(jq -r .[$i].name_first $ROSTER)
	STUDENT_NAME_LAST=$(jq -r .[$i].name_last $ROSTER)
	STUDENT_NAME=${STUDENT_NAME_FIRST// /_}_${STUDENT_NAME_LAST}
	cd sec_$SECTION
	cd $STUDENT_NAME
	if [[  -f $ASSIGNMENT.ml ]]
	then
		echo
		make clean

		echo "Replacing Main.ml"
		cp main.ml old_main.ml
		rm main.ml
		cp ../../$RSCDIR/$ASSIGNMENT/new_main.ml main.ml

		echo "Appending Instructor Tests"
		cp $ASSIGNMENT.ml old_$ASSIGNMENT.ml
		cat ../../$RSCDIR/$ASSIGNMENT/instr_tests.ml >> $ASSIGNMENT.ml
		make $ASSIGNMENT

		echo "Restoring Original main.ml"
		rm main.ml
		cp old_main.ml main.ml
		rm old_main.ml

		echo "Restoring Original $ASSIGNMENT.ml"
		rm $ASSIGNMENT.ml
		cp old_$ASSIGNMENT.ml $ASSIGNMENT.ml
		rm old_$ASSIGNMENT.ml
	else
		echo "No Submission"
	fi
	cd ..
	cd ..
	echo "Student: $STUDENT_NAME"
	read -n 1 -p "Press any key to Continue"
	echo
done
