#!/bin/bash

TAB=20

sumfile=/dev/shm/$$.sum

echo 0 > $sumfile

increment() {
	v=$(cat $sumfile)
	echo $(($v + 1)) > $sumfile
}

result() {
	return $(cat $sumfile)
}

check() {
	str="Checking $1"
	echo -n "$str"

	for i in $(seq ${#str} 1 $TAB); do
		echo -n " "
	done

	f=$(which $1)
	if test $? != 0; then
		echo -e "[\033[31mFAILURE\033[0m]"
		increment
	else
		echo -e "[\033[32mSUCCESS\033[0m] ($f)"
	fi
}

echo "Checking dependancies for ThroughYou."
echo

sort depends.list Pensieve/depends.list | uniq | while read d; do
	check $d
done
echo

result
if test $? = 0; then
	echo "Overall success!"
	exit 0
else
	echo "Overfall failure!"
	exit 1
fi
