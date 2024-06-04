#!/usr/bin/env bash

##  +-----------------------------------+-----------------------------------+
##  |                                                                       |
##  | Copyright (c) 2019-2023, Andres Gongora <mail@andresgongora.com>.     |
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
##	This script takes a path name and shortens it.
##	- home is replaced by ~
##	- last folder in apth is never truncated
##
##
##	REFERENCES
##
##	Original source: WOLFMAN'S color bash promt
##	https://wiki.chakralinux.org/index.php?title=Color_Bash_Prompt#Wolfman.27s
##



##==================================================================================================
##	FUNCTIONS
##==================================================================================================

##------------------------------------------------------------------------------
##
shortenPath()
{
	## GET PARAMETERS
	local path=$1
	local max_length=$2
	local default_max_length=25
	local trunc_symbol=${3:-"…"}


    ## CHECK PARAMETERS AND INIT
	if   [ -z "$path" ]; then
		echo ""
		exit
	elif [ -z "$max_length" ]; then
		local max_length=$default_max_length
	fi


	## CLEANUP PATH
	## Replace HOME with ~ for the current user, similar to sed.
	local path=${path/#$HOME/\~}


	## GET PRINT LENGHT
	## - Get curred directory (last folder in path) to get its length (num characters).
	## - Determine the actual max length we will use to truncate, choosing between either
    ##   $max_length, set by the usert, or the length of the current dir,
    ##   depending on which is greater. This ensures that even if we set a
    ##   relatively  low $max_length value, the name of the current dir will not
    ##   be truncated. Store in $print_length
	local dir=${path##*/}
	local dir_length=${#dir}
	local path_length=${#path}
	local print_length=$(( ( max_length < dir_length ) ? dir_length : max_length )) #


    ## TRUNCATE PATH TO
	## - If $path_length > $print_lenght
	##	- Truncate the path to max_length
	##	- Clean off path fragments before first '/' (included)
    ##  - Check if the bit we have removed would have landed at home
    ##    - If at home, prepend '~' to the clean path
	##	  - Else, prepend the "trunc_symbol" to the clean path
	if [ $path_length -gt $print_length ]; then
		local offset=$(( $path_length - $print_length ))
		local truncated_path=${path:$offset}
		local clean_path="/${truncated_path#*/}"
        local removed_path=${path%%"$clean_path"}

        if [ "$removed_path" == "~" ]; then
            local short_path="~${clean_path}"
        else
		    local short_path=${trunc_symbol}${clean_path}
        fi
	else
		local short_path=$path
	fi


	## RETURN FINAL PATH
	echo $short_path
}






##==================================================================================================
##	DEBUG
##==================================================================================================

#PATH1="/home/andy/my/imaginary/file/path"
#echo "$PATH1"
#echo "50: $(shortenPath "$PATH1" 50)"
#echo "25: $(shortenPath "$PATH1" 25)"
#echo "24: $(shortenPath "$PATH1" 24)"
#echo "23: $(shortenPath "$PATH1" 23)"
#echo "22: $(shortenPath "$PATH1" 22)"
#echo "10: $(shortenPath "$PATH1" 10)"
