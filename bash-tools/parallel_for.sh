#!/bin/sh

##  +-----------------------------------+-----------------------------------+
##  |                                                                       |
##  | Copyright (c) 2019-2024, Andres Gongora <mail@andresgongora.com>.     |
##  |                                                                       |
##  | This program is free software: you can redistribute it and/or modify  |
##  | it under the terms of the GNU General Public License as published by  |
##  | the Free Software Foundation, either version 3 of the License, or     |
##  | (at your option) any later version.                                   |
##  |                                                                       |
##  | This program is distributed in the hope that it will be useful,       |
##  | but WITHOUT ANY WARRANTY; without even the implied warranty of        |
##  | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         |
##  | GNU General Public License for more details.                          |
##  |                                                                       |
##  | You should have received a copy of the GNU General Public License     |
##  | along with this program. If not, see <http://www.gnu.org/licenses/>.  |
##  |                                                                       |
##  +-----------------------------------------------------------------------+


##
##
##
##
##
##
##



##==================================================================================================
##	DEPENDENCIES
##==================================================================================================


parallelFor() {
	local cmd=$1
	local argument_list=("${@:2:$#}")
	local max_num_threads=$(nproc) # Num max threads

	for argument in "${argument_list[@]}"; do
		## WAIT IF TO MANY JOBS ALREADY RUNNIGN
		if [ $(jobs -r -p | wc -l) -ge $max_num_threads ]; then
			wait -n # Wait only for first job
		fi

		## RUN COMMAND
		( "$cmd" $argument ) &
	done

	## WAIT FOR ALL JOBS TO FINISH
	wait
}



##==================================================================================================
##	TEST
##==================================================================================================


## 1 ARGUMENT
##
echo "Example with 1 argument per call"
echo "--------------------------------"
runTestJob() {
	echo "[$1] Starting job..."
	sleep $(( (RANDOM % 3) + 1))
	echo "[$1] Finished!"
}
param_list=$(echo {a..j})
parallelFor runTestJob $param_list
echo ""


## Multiple ARGUMENTS
## You can create an array of arguments, either directly as an array
## or by explicitly setting the value of each position as shown below.
## You may call a function or directly a command.
##
echo "Example with multiple arguments per call"
echo "----------------------------------------"
parallelFor runTestJob "${param_array[@]}"
runTestJob() {
	echo "[$1:$2]"
}
param_array[1]="one 1"
param_array[2]="two 2"
param_array[3]="three 3"
parallelFor runTestJob "${param_array[@]}"
##or
echo "----------------------------------------"
param_array=("one 1 a" "two 2 b" "three 3 c")
parallelFor echo "${param_array[@]}"



