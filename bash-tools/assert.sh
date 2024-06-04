#!/usr/bin/env bash

##  +-----------------------------------+-----------------------------------+
##  |                                                                       |
##  | Copyright (c) 2020-2024, Andres Gongora <mail@andresgongora.com>.     |
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
##	DESCRIPTION:
##
##
##




##==================================================================================================
##	HELPERS
##==================================================================================================


##==================================================================================================
##
##






##==================================================================================================
##	FUNCTIONS
##==================================================================================================


##==================================================================================================
##
##
assert_is_set()
{
	local ok=0
	local assert_failed=98


	if [ -z ${1+x} ]; then
		echo "Assertion failed, variable not set."
		return $assert_failed
	else
		return $ok
	fi
}




##==================================================================================================
##
##
assert_not_empty()
{
	local ok=0
	local assert_failed=98
	local variable=$1


	if [ -z $variable ]; then
		echo "Assertion failed, variable empty. $message"
		return $assert_failed
	else
		return $ok
	fi
}




##==================================================================================================
##
##
assert_empty()
{
	local ok=0
	local assert_failed=98
	assert_is_set $1
	local variable=$1


	if [ -n $variable ]; then
		echo "Assertion failed, variable empty. $message"
		return $assert_failed
	else
		return $ok
	fi
}
