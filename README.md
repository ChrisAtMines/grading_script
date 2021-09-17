# Roster-Cloner
Allows for cloning assignments of roster via a JSON file

# Instructions

Install the CLI `jq` for your distribution, example for Debian based

```
sudo apt-get install jq
```
More instructions at https://stedolan.github.io/jq/download/

Then you can run the script using 

`./clone-all.sh <Assignment> </path/roster.json>`

If the script and roster.json are in the same directory you don't need to include it. An example for hw02

`./clone-all.sh hw02`
