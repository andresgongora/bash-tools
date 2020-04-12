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
##
##



##==============================================================================
##	FUNCTIONS
##==============================================================================



##------------------------------------------------------------------------------
##
##	
hookScript()
{
	local script="$1"
	local script_name=$(basename "$script")
		
	local hook=$(printf '%s'\
	"\n"\
	"##-----------------------------------------------------\n"\
	"## ${script_name}\n"\
	"if [ -f ${script} ]; then\n"\
	"\tsource ${script}\n"\
	"fi")

	## ADD TO RC FILE
	include() { source "$( cd $( dirname "${BASH_SOURCE[0]}" ) >/dev/null 2>&1 && pwd )/$1" ; }
	include 'edit_text_file.sh'
	include 'shell.sh'
	local user_shell=$(getShellName)
	editTextFile $(getUserRCFile) append "$hook"
}



