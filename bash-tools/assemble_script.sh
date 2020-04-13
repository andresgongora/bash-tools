#!/bin/bash

##  +-----------------------------------+-----------------------------------+
##  |                                                                       |
##  | Copyright (c) 2019-2020, Andres Gongora <mail@andresgongora.com>.     |
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
##
##	This script takes an input script, replaces all its dependencies
##	(includes), removes empty lines, and writes everything to a specified
##	output file.
##
##	This script contains two functions:
##	- include() 
##		is meant to be used by stripts that want to source other
##		script that may contain functions it needs.
##
##	- assembleScript()
##		takes an input script, and output script, and an optional
##		header string. It will parse the input script into the output
##		file, starting with the optional header. If any "include"
##		statement is found, the whole "included" script will also be
##		copied over to produce a self-contained output script.
##
##



##==============================================================================
##	FUNCTIONS
##==============================================================================



##------------------------------------------------------------------------------
## This function is meant to be copied over to any script you are working with.
## It takes one argument, the relative path (with respect to the script that
## calls it) to any other script that should be sourced. For example, if script
## A.sh wants the functions of script B.sh, then, the first lines of A.sh would
## look something like this:
##
##	include() { ··· }
##	include "B.sh"
##
include() { source "$( cd $( dirname "${BASH_SOURCE[0]}" ) >/dev/null 2>&1 && pwd )/$1" ; }






##------------------------------------------------------------------------------
## Arguments
## 1. input script
## 2. output script (will be overwritten)
## 3. optional header (a text string) to put at the beguining of the output file
##
assembleScript()
{

	## ---------------------------------------------------------------------
	## Copies the content from the input file to the output file, removing
	## any line that belongs to an "include statement".
	##
	copyFileContent()
	{
		local input_script=$1
		local output_script=$2

		if [ -f "$input_script" -a -f "$output_script" ]; then
			cat "$input_script" |\
				grep -v "$regex_include" |\
				grep -v "^[ \t]*include()" |\
				sed '/^[ \t]*$/d' >> "$output_script"
		else
			echo "installScript:copyFileContent failed"
			[ -f "$input_script" ] || echo "input script $input_script not found"
			[ -f "$output_script" ] || echo "output script $output_script not found"
			exit 1
		fi
	}



	##----------------------------------------------------------------------
	## Copies the content to the output file of any "included" file,
	## referenced in the input file. Works recursively.
	##
	copyIncludes()
	{
		local input_script=$1
		local output_script=$2
		local input_script_dir=$( dirname "$input_script" )

		[ $verbose == true ] && echo -e "\ncopyIncludes()"
		[ $verbose == true ] && echo "$input_script"
		[ $verbose == true ] && echo "$output_script"

		if [ -f "$input_script" -a -f "$output_script" ]; then

			## SEARCH FOR ALL DEPENDENCIES IN INPUT SCRIPT
			local includes=($(cat "$input_script" |\
				          grep "$regex_include" |\
				          sed -e 's/^[ \t]*include[ \t]//g;s/["'\'']//g' ))

			

			## COPY DEPENDENCIES OVER (IF ANY)
			[ $verbose == true ] && echo -e "${#includes[@]} includes:\n${includes[@]}"
			if [ ${#includes[@]} -ge 1 ]; then
				for dependency in "${includes[@]}"; do

					## HANDLE RECURSIVELY
					local dependency_file="$input_script_dir/$dependency"
					copyIncludes "$dependency_file" "$output_script"
					
					## COPY INTO OUTPUT FILE
					copyFileContent "$dependency_file" "$output_script"
				done
			fi

		else
			echo "installScript:copyIncludes failed"
			[ -f "$input_script" ] || echo "input script $input_script not found"
			[ -f "$output_script" ] || echo "output script $output_script not found"
			exit 1
		fi
	}



	##----------------------------------------------------------------------


	if [ "$#" -lt 2 ]; then
		echo "installScript: at least 2 arguments expected, $@" 
		return
	fi

	local input_script=$1
	local output_script=$2
	local script_header=$3

	local input_dir=$( dirname "$input_script" )
	local output_dir=$( dirname "$output_script" )
	local regex_include="^[ \t]*include[ \t]"
	local verbose=false


	[ $verbose == true ] && echo "$input_script -> $output_script"
	if [ -f "$input_script" ]; then
		
		## CREATE OUTPUT FILE AND WRITE HEADER (IF ANY)	
		[ -d "$output_dir" ] || mkdir -p "$output_dir"
		echo -e "#!/bin/bash\n" > "$output_script"
		[ -z "$script_header" ] || echo -e "$script_header" >> "$output_script"

		## PARSE INCLUDES, COPY SCRIPT, MAKE EXECUTABLE
		copyIncludes "$input_script" "$output_script"
		copyFileContent "$input_script" "$output_script"
		chmod +x "$output_script"

		## CREATE HOOK
		[ "$hook_script" == True ] && hookScript "$output_script"

	else
		echo "installScript: file not found $input_script" && exit 1
	fi
}






##==============================================================================
##	SCRIPT
##==============================================================================

#installScript "$@"

