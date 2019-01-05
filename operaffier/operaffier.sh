#!/bin/bash
#
# OperaFFier v1.0
# This script can be used to patch Opera, so that it can play H.264 encoded videos (eg. on Twitter)
#
# Author: https://gitlab.com/Nesze
#
# Known issues:
# - In case the "chromium-codecs-ffmpeg-extra" installation finishes, but the patch fails,
#   try removing the package (with "apt-get remove chromium-codecs-ffmpeg-extra"),
#   and then run the script again to reinstall it.
#

# Checking for root permission
if [ "$EUID" -ne 0 ]; then
	echo "[ERROR] This script can only be executed as root"
	exit 1
fi

# Constants
CHROMIUM_PATH="/usr/lib/chromium-browser"
OPERA_PATH="/usr/lib/x86_64-linux-gnu/opera"

ORIGINAL_NAME="libffmpeg.so"
BACKUP_NAME="libffmpeg_backup.so"

function patch {
	# Checking for patch file
	if [ ! -f "$CHROMIUM_PATH/$ORIGINAL_NAME" ]; then
		printf "[INPUT] The patch requires the package \"chromium-codecs-ffmpeg-extra\" to be installed. Would you like to install it now? (y/n)\n> "
		read input
		if [ $input = "y" ]; then
			apt-get install chromium-codecs-ffmpeg-extra
			if [ $? -eq 0 ]; then
				echo "[INFO] Package installed successfully"
			else
				echo "[ERROR] An error happened during install, patch aborted"
				exit 1
			fi
		else
			echo "[INFO] Patch aborted"
			exit 1
		fi
	fi
	
	backup_created=false

	# Creating backup
	if [ -f "$OPERA_PATH/$ORIGINAL_NAME" ]; then
		input=""
		if [ -f "$OPERA_PATH/$BACKUP_NAME" ]; then
			printf "[INPUT] An existing backup was found, would you like to overwrite it with a new version? (y/n)\n> "
		else
			printf "[INPUT] Would you like to back up the current version? (y/n)\n> "
		fi
		read input
		if [ $input = "y" ]; then
			mv "$OPERA_PATH/$ORIGINAL_NAME" "$OPERA_PATH/$BACKUP_NAME"
			backup_created=true
			echo "[INFO] Backup created"
		else
			echo "[INFO] Skipping backup"
		fi
	else
		echo "[INFO] There is nothing to back up"
	fi

	# Patching
	echo "[INFO] Executing patch"
	cp "$CHROMIUM_PATH/$ORIGINAL_NAME" "$OPERA_PATH/$ORIGINAL"

	# Checking results
	if [ $? -eq 0 ]; then
		echo "[INFO] Patch succeeded"
	else
		if [ $backup_created = true ]; then
			echo "[ERROR] An error happened during patch, rolling back changes"
			rm "$OPERA_PATH/$ORIGINAL_NAME"
			mv "$OPERA_PATH/$BACKUP_NAME" "$OPERA_PATH/$ORIGINAL_NAME"
			if [ $? -eq 0 ]; then
				echo "[INFO] Changes rolled back successfully"
			else
				echo "[ERROR] Changes could not be rolled back"
			fi
		else
			echo "[ERROR] An error happened during patch"
		fi
	fi
}

function revert_patch {
	if [ ! -f "$OPERA_PATH/$BACKUP_NAME" ]; then
		echo "[ERROR] No backup found"
		exit 1
	else
		rm "$OPERA_PATH/$ORIGINAL_NAME"
		mv "$OPERA_PATH/$BACKUP_NAME" "$OPERA_PATH/$ORIGINAL_NAME"
		if [ $? -eq 0 ]; then
			echo "[INFO] Backup restored"
		else
			echo "[ERROR] Backup could not be restored"
		fi
	fi
}

printf "\n\t- OperaFFier v1.0 -\n\n"
printf "0 - Exit\n"
printf "1 - Execute patch\n"
printf "2 - Revert patch\n> "

read input
if [ $input = "0" ]; then
	exit 1
elif [ $input = "1" ]; then
	patch
elif [ $input = "2" ]; then
	revert_patch
else
	echo "[ERROR] Why"
fi

exit 0
