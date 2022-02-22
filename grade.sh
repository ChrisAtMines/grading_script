#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

SECTION_SKIP=false
INSTRUCTOR_TESTS=true
DUE_DATE_UNIX=$(date -d 2022-02-12 +%s)
DUE_DATE=$(date -d 2022-02-12 +"%a %b %d %H:%R")
DUE_DATE_GIT="2022-02-12 00:00"

ASSIGNMENT=$1
if [ -z "$2" ]~
then
	RSCDIR=".config"
else
	RSCDIR=$2
fi

if [[ $* == *-i* ]]
then
	INSTRUCTOR_TESTS=false
fi

ROSTER=$RSCDIR/roster.json

echo $ASSIGNMENT
NUM_STUDENTS=$(jq length $ROSTER)

for (( i=0; i<$NUM_STUDENTS; i++ ))
do
	TEAM_NAME=$(jq -r .[$i].team_name $ROSTER)
	echo -e "Team: ${RED}$TEAM_NAME${NC}"
	cd repos
	cd $TEAM_NAME	
	if [[  -f src/$ASSIGNMENT.ml ]]
	then
		echo
		echo -e "${RED}Cleaning${NC}"
		make clean
		echo -e "${RED}Checking out latest valid commit${NC}"
		git checkout `git rev-list -n 1 --before="${DUE_DATE_GIT}" master`
		if [ $INSTRUCTOR_TESTS != false ]
		then
			echo -e "${RED}Adding Instructor Tests...${NC}"
			echo "Replacing Main"
			cp src/${ASSIGNMENT}_main.ml old_main.ml
			rm src/${ASSIGNMENT}_main.ml
			cp ../../$RSCDIR/$ASSIGNMENT/new_main.ml src/${ASSIGNMENT}_main.ml

			echo "Appending Instructor Tests"
			cp src/$ASSIGNMENT.ml old_lab.ml
			cat ../../$RSCDIR/$ASSIGNMENT/instr_tests.ml >> src/$ASSIGNMENT.ml

			echo -e "${RED}Making...${NC}"
			make $ASSIGNMENT
			echo -e "${RED}Running...${NC}"	
 			./$ASSIGNMENT > .results
			cat .results
			PASSED=$(grep "pass test" .results | wc -l)
			FAILED=$(grep "FAIL test" .results | wc -l)
			echo "${PASSED} passed tests"
			echo "${FAILED} failed tests"

			echo -e "${RED}Restoring Original Files...${NC}"
			echo "Restoring Original ${ASSIGNMENT}_main.ml"
			rm src/${ASSIGNMENT}_main.ml
			cp old_main.ml src/${ASSIGNMENT}_main.ml
			rm old_main.ml

			echo "Restoring Original $ASSIGNMENT.ml"
			rm src/$ASSIGNMENT.ml
			cp old_lab.ml src/$ASSIGNMENT.ml
			rm old_lab.ml
			#nvim $ASSIGNMENT.ml
		else
			echo -e "${RED}Making...${NC}"
			make 
			echo -e "${RED}Running...${NC}"
			./$ASSIGNMENT > .results
			cat .results
			PASSED=$(grep "pass test" .results | wc -l)
			FAILED=$(grep "FAIL test" .results | wc -l)
			echo "${PASSED} passed tests"
			echo "${FAILED} failed tests"
		fi
	else
		echo -e "${RED}No Submission${NC}"
	fi	
	
	TURN_IN_DATE=$(git log -1 --date=unix --format=%cd)
	echo -e "${RED}Students: ${NC}"
	cat AUTHORS
	if [[ "$TURN_IN_DATE" > "$DUE_DATE_UNIX" ]]
	then
		DAYS_LATE=$(( ($TURN_IN_DATE - $DUE_DATE_UNIX)/86400 + 1))
		echo -e "${RED}Date of commit: $(git log -1 --format=%cd)\nDue:            $DUE_DATE${NC}"
		echo -e "${RED}Days Late: $DAYS_LATE${NC}"
	fi
	echo -e "${RED}Cleaning${NC}"
	make clean
	echo -e "${RED}Reverting to master${NC}"
	git checkout master
	cd ../..

	read -n 1 -p "Press any key to Continue" RETRY_STUDENT
	echo
	if [[ $RETRY_STUDENT = "r" ]]
	then 
		i=$((i - 1))
	fi
done
