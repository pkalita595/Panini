#!/bin/sh

exists()
{
  command -v "$1" >/dev/null 2>&1
}

if exists crestc; then
    echo Crestc is available
else
    echo Crestc is not available hence exiting
    exit
fi


#removing previous state
rm prev_choices
rm terms 1>&2 2>/dev/null

#compile using crest
crestc ./derive_grammar.c 1>&2 2>/dev/null

#running crest
run_crest ./derive_grammar 1000 -dfs 5

#running the crest until all the possible derivation coveraging paths are reached
prev_count=0
curr_count=$(wc terms | tr -s " " | sed 's/ /,/g' | cut -d ","  -f2)

while [ $prev_count -ne $curr_count  ]
do
	echo "prev_count : "$prev_count", curr_count : "$curr_count
	run_crest ./derive_grammar 1000 -dfs 5
	prev_count=$curr_count
	curr_count=$(wc terms | tr -s " " | sed 's/ /,/g' | cut -d ","  -f2)
done

#print the final output
cat terms | sort
