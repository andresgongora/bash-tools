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



##==============================================================================
##
##	printBar(CURRENT, MAX, SIZE, COLOR, COLOR)
##
##	Prints a bar that is filled depending on the relation between
##	CURRENT and MAX.
##
##	Arguments:
##	1. CURRENT:       amount to display on the bar.
##	2. MAX:           amount that means that the bar should be printed
##	                  completely full.
##	3. SIZE:          length of the bar as number of characters.
##	4. BRACKET_COLOR: Color for the brackets. May be empty for not colored.
##	5. BAR_COLOR:	  Color for the bars. May be empty for not colored.
##
##	Optional:
##	6. BRACKET_CHAR_L: left bracket character. Defaults to '['
##	7. BRACKET_CHAR_R: left bracket character. Defaults to ']'
##	8. BAR_FILL_CHAR:  bar character. Defaults to '|'
##	8. BAR_EMPTY_CHAR: bar background. Defaults to ' '
##
printBar()
{
	## ARGUMENTS
	local current=$1
	local max=$2
	local size=$3
	local bracket_color=$4
	local bar_color=$5
	local bracket_char_l=${6:-'['}
	local bracket_char_r=${7:-']'}
	local bar_fill_char=${8:-'|'}
	local bar_empty_char=${9:-' '}


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
	printf "$bracket_color$bracket_char_l$bar_color"
	i=0
	while [ $i -lt $num_bars ]; do
		printf "$bar_fill_char"
		i=$[$i+1]
	done
	while [ $i -lt $size ]; do
		printf "$bar_empty_char"
		i=$[$i+1]
	done
	printf "$bracket_color$bracket_char_r$fc_none"
}
