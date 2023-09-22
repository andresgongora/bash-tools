#!/bin/bash

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



##==============================================================================
##	printBar
##	Prints a bar that is filled depending on the relation between
##	CURRENT and MAX. Example: [|||||    ]
##
##
##	Arguments:
##	1. CURRENT:       amount to display on the bar.
##	2. MAX:           amount that means that the bar should be printed
##	                  completely full.
##	3. SIZE:          length of the bar as number of characters.
##
##
##	Optional arguments:
##	4. BRACKET_CHAR_L: left bracket character. Defaults to '['. Use '$' to omit.
##	5. BAR_FILL_CHAR:  bar character. Defaults to '|'.
##	6. BAR_EMPTY_CHAR: bar background. Defaults to ' '.
##	7. BRACKET_CHAR_R: left bracket character. Defaults to ']'. Use '$' to omit.
##
printBar()
{
	## ARGUMENTS
	local current=$1
	local max=$2
	local size=$3
	local bracket_char_l=${4:-'['}
	local bar_fill_char=${5:-'|'}
	local bar_empty_char=${6:-' '}
	local bracket_char_r=${7:-']'}


         ## CHECK IF EMPTY CHARACTER REQUESTED
         if [[ "$bracket_char_l" == *"$"* ]]; then
                  local bracket_char_l=""
                  local size=$((size + 1))
         fi

         if [[ "$bracket_char_r" == *"$"* ]]; then
                  local bracket_char_r=""
                  local size=$((size + 1))
         fi


	## COMPUTE VARIABLES
	## Clamp to maximum
	local num_bars=$(bc <<< "$size * $current / $max")
	if [ $num_bars -gt $size ]; then
		num_bars=$size
	fi


	## PRINT BAR
	## - Opening bracket
	## - Fill bars
	## - Remaining empty background
	## - Closing bracket
	printf "$bracket_char_l"
	i=0
	while [ $i -lt $num_bars ]; do
		printf "$bar_fill_char"
		i=$[$i+1]
	done
	while [ $i -lt $size ]; do
		printf "$bar_empty_char"
		i=$[$i+1]
	done
	printf "$bracket_char_r"
}
