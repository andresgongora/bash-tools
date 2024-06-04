#!/usr/bin/env bash

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
[ "$(type -t include)" != 'function' ]&&{ include(){ { [ -z "$_IR" ]&&_IR="$PWD"&&cd $(dirname "${BASH_SOURCE[0]}")&&include "$1"&&cd "$_IR"&&unset _IR;}||{ local d=$PWD&&cd "$(dirname "$PWD/$1")"&&. "$(basename "$1")"&&cd "$d";}||{ echo "Include failed $PWD->$1"&&exit 1;};};}

include "color.sh"






##==================================================================================================
##	COPNFIGURATION
##==================================================================================================

UIO_FC_DECO=$(getFormatCode -c none   -e bold)
UIO_FC_TEXT=$(getFormatCode -c none   -e none)
UIO_FC_HEAD=$(getFormatCode -c none   -e bold)
UIO_FC_SUCC=$(getFormatCode -c green  -e bold)
UIO_FC_INFO=$(getFormatCode -c blue   -e bold)
UIO_FC_WARN=$(getFormatCode -c yellow -e bold)
UIO_FC_CRIT=$(getFormatCode -c red    -e bold)
UIO_FC_ERRO=$(getFormatCode -c red    -e bold -e blink)
UIO_FC_PRMT=$(getFormatCode -c yellow -e bold)
UIO_FC_NONE=$(getFormatCode -c none   -e none)

UIO_SIGN_SUCC="OK"
UIO_SIGN_INFO="··"
UIO_SIGN_WARN="!!"
UIO_SIGN_CRIT="><"
UIO_SIGN_ERRO="><"
UIO_SIGN_PRMT="??"






##==================================================================================================
##	HELPER FUNCTIONS
##==================================================================================================

_printBase()
{
	local sign_fc=$1
	local sign=$2
	local text="${@:3}"

	if [ ! -z "$sign" ]; then
		printf "  ${UIO_FC_DECO}[${sign_fc}${sign}${UIO_FC_DECO}]"
	fi

	printf "\t${UIO_FC_TEXT}${text}"
	printf "${UIO_FC_NONE}\n"
}






##==================================================================================================
##	FUNCTIONS
##==================================================================================================



printHeader()   { _printBase "$UIO_FC_HEAD" "" "\n\t${UIO_FC_HEAD}$@\n"      ; }
printText()     { _printBase "$UIO_FC_TEXT" "" "$@"                          ; }
printSuccess()  { _printBase "$UIO_FC_SUCC" "$UIO_SIGN_SUCC" "$@"            ; }
printInfo()     { _printBase "$UIO_FC_INFO" "$UIO_SIGN_INFO" "$@"            ; }
printWarn()     { _printBase "$UIO_FC_WARN" "$UIO_SIGN_WARN" "$@"            ; }
printCrit()     { _printBase "$UIO_FC_CRIT" "$UIO_SIGN_CRIT" "$@"            ; }
printError()    { _printBase "$UIO_FC_ERRO" "$UIO_SIGN_ERRO" "$@"            ; }



promptUser()
{
	local text="$1"
	local options="$2"
	local valid_options="$3"
	local default_option="$4"
	local user_choice=


	## PROMPT USER
	printf "  ${UIO_FC_DECO}[${UIO_FC_PRMT}${UIO_SIGN_PRMT}${UIO_FC_DECO}]" > /dev/tty
	printf "\t${UIO_FC_TEXT}${text}" > /dev/tty
	if [ ! -z "$options" ]; then
		printf "\n\t${UIO_FC_NONE}${options}: " > /dev/tty
	else
		printf ": " > /dev/tty
	fi



	while [ -z "$user_choice" ]; do

		## READ USER INPUT
		## -n 1: read only 1 character
		## -s: do not echo
		local input=
		read -s -n 1 input


		## CHECK IF USER CHOICE IS VALID
		## - In no input (enter), but default options set, use that one
		## - If no valid options specified, return whatever
		## - If valid options specified, check input against them
		## - Else, do nothing and repeat the while loop
		if [ "$input" == "" ] && [ ! -z "$default_option" ]; then
			local user_choice="$default_option"
			echo "$user_choice" > /dev/tty

		elif  [ -z "$valid_options" ]; then
			local user_choice="$input"
			echo "$user_choice" > /dev/tty

		elif [ ! -z $(echo "$input" | sed -n '/['"$valid_options"']/p') ]; then
			local user_choice="$input"
			echo "$user_choice" > /dev/tty

		else
			echo "$user_choice is not a valid option." > /dev/tty
			printf "\t${UIO_FC_NONE}${options}: " > /dev/tty
		fi
	done


	## EXIT
	echo "$user_choice"
}






##==================================================================================================
##	TEST
##==================================================================================================

#printHeader "Hello"
#printText "Normal text"
#printSuccess "Menssage"
#printInfo "Menssage"
#printWarn "Menssage"
#printCrit "Menssage"
#printError "Menssage"

#var=$(promptUser "Please make a choice now about random stuff" "[h] Hug a koala, [j] jump from a bridge, [n] nothing" "jasd")  && echo "You chose: $var"


