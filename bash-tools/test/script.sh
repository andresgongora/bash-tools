#!/bin/bash

myfunction()
{


	echo "Hi, I am function..."
	local dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
	cd "$dir"

	echo "I am now in $PWD"
	ls

	echo "Bye"
	echo "${BASH_SOURCE[0]}"

	

	echo "$PRUEBA"
}
#(myfunction)


include() { 
	cd "$( dirname ${BASH_SOURCE[0]} )" && source "$1" ; 
}


include ../test/include.sh	
cachimba
