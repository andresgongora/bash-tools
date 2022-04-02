#!/bin/bash

##  +-----------------------------------+-----------------------------------+
##  |                                                                       |
##  | Copyright (c) 2019-2021, Andres Gongora <mail@andresgongora.com>.     |
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
##	DESCRIPTION
##	===========
##
##	Helper script that prints a warning and calls 'exit 1' if any command
##  name passed as an argument is not available on the system.
##
##
##
##	USAGE
##	=====
##
##	exitIfCommandsNotAvailable <command 1> <command 2> <command 3>
##



##==============================================================================
##	exitIfCommandsNotAvailable
##==============================================================================

exitIfCommandsNotAvailable() {
	local num_missing=0

	## Iterate over all commands to check
	for maybe_command in "$@"; do
		if [ -z $(command -v ${maybe_command}) ]; then
			echo "'${maybe_command}' not found."
			num_missing=$((num_missing+1))
		fi
	done

	## Abort if any package was missing
	if [ $num_missing -gt 0 ]; then
		echo "Aborting: $num_missing commands were missing. Please install needed packages."
		exit 1
	fi
}



##==============================================================================
##	DEBUG
##==============================================================================

## This should work
#exitIfCommandsNotAvailable nano # 1 command
#exitIfCommandsNotAvailable nano ssh # 2 commands


## This should fail
#exitIfCommandsNotAvailable random-command-name another-madeup-command
