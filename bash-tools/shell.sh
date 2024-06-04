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
##
##
##
##
##
##



##==================================================================================================
##
##==================================================================================================

getShellName()
{
	local shell=$(grep $(id -un) /etc/passwd |\
	              awk -F: '{print $7}' |\
	              sed 's/.*\///')

	echo "$shell"
}




getUserRCFile()
{
	local user_shell=$(getShellName)

	case "$user_shell" in
		bash)		local rc_file="${HOME}/.bashrc" ;;
		zsh)		local rc_file="${HOME}/.zshrc" ;;
		*)		local rc_file="${HOME}/.bashrc"
	esac

	echo "$rc_file"
}






##==================================================================================================
##	TEST
##==================================================================================================

#getShellName




