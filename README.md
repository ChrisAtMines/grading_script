# Grading Script

appends instructor tests to assignments and runs them individually

## Requirements

Install the CLI `jq` for your distribution, example for Debian based

```bash
sudo apt-get install jq
```
More instructions at https://stedolan.github.io/jq/download/

## Usage

Run on the cmd line: 

```bash
./test.sh <Assignment> <file_directory>
```

<file_directory> should contain a roster.json and an <Assignment> directory with an instr_tests.ml and a new_main.ml

instr_tests.ml should contain any new test sets.

new_main.ml should be a copy of main with the names of all new test sets inserted.

the tool will clean build each project, append the new tests to the end of <Assignment>.ml, replace main, build and run the project, and revert the changes.

Now you can skip section with `-s` flag added to the end of the bash command.

```bash
./clone-all.sh <assignment>
```

use -p with clone-all.sh to pull the assignment from repos

-s "a" to only get results from section "a"

-r </path/roster.json> optional, use if not in same directory as script 
