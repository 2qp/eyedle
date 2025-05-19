#!/bin/bash

#  eyedle.sh
#  eyedle
#  Created by 2qp on 2025-04-21.

LOGGING_ENABLED=false
LOGFILE="$HOME/Library/Logs/eyedle/sh.log"

#
# if [ "$LOGGING_ENABLED" = true ]; then
# 	LOG_DIR=$(dirname "$LOGFILE")
# 	mkdir -p "$LOG_DIR"
# fi

PIPE="/tmp/eyedle.pipe"
USER_PRE_NOTIFY_SCRIPTS_DIR="$HOME/documents/eyedle/pre"
USER_POST_NOTIFY_SCRIPTS_DIR="$HOME/documents/eyedle/post"
TARGET_OUTPUT="skip"
APP_PATH="$1"
BUNDLE_ID="$2"
NOTIFY_TIME=$3
PID=$$
DISPATCH_URL="eyedle://dispatch?pid=$PID"
OVERLAY_URL="eyedle://overlay"

CANCELLED=0 # Flag to indicate cancellation

# LOGGER
log_message() {
	if [ "$LOGGING_ENABLED" = true ]; then
		echo "$(date "+%Y-%m-%d %H:%M:%S") [$1] $2" >>"$LOGFILE"
	fi
}

# Log the start of the script
log_message "DEBUG" "Starting script..."
#log_message "DEBUG" "Received app path: $1"
#log_message "DEBUG" "Received bundle id: $2"
#log_message "DEBUG" "Received PID: $PID"
#log_message "DEBUG" "Received NOTIFY_TIME: $NOTIFY_TIME"

# check system idle time
check_system_state() {
	# Get idle time in nanoseconds (time since the last user activity)
	IDLE_TIME=$(ioreg -c IOHIDSystem | grep -i "IdleTime" | awk '{print $NF}')

	# Convert idle time from nanoseconds to seconds
	IDLE_TIME_SECONDS=$((IDLE_TIME / 1000000000))

	# threshold for idle time in seconds
	IDLE_THRESHOLD=300 # 5 minutes in seconds

	#
	log_message "DEBUG" "Idle Time in seconds = $IDLE_TIME_SECONDS"

	# If the idle time is greater than the threshold, the system is considered idle
	if [ "$IDLE_TIME_SECONDS" -gt "$IDLE_THRESHOLD" ]; then
		#
		return 1
	fi

	# if the system is asleep using pmset
	#
	POWER_STATE=$(pmset -g | awk '/^ +sleep / {if ($2 == 0) printf "0"; else if ($2 > 0) printf "2"; else printf "1"}')

	if [ "$POWER_STATE" -eq 1 ]; then

		return 1
	fi

	return 0
}

#
execute_and_check() {
	script="$1"

	# if script is an AppleScript (.applescript or .scpt)
	if [[ "$script" == *.applescript || "$script" == *.scpt ]]; then
		#
		output=$(osascript "$script")

	# if script is a shell script (typically .sh or no extension)
	elif [[ "$script" == *.sh || "$script" == * ]]; then
		#
		output=$(bash "$script")

	# if script is a Python script (.py)
	#    elif [[ "$script" == *.py ]]; then
	#        echo "Executing Python script: $script"
	#        python3 "$script"

	else
		log_message "DEBUG" "Unsupported script type: $script"
		return 1 # Unsupported type
	fi

	#
	if [[ "$output" == *"$TARGET_OUTPUT"* ]]; then
		log_message "DEBUG" "Target output found in script $script!"

		exit 0
	else
		log_message "DEBUG" "No matching output in script $script."
	fi
}

# mmm or parallelly?
process_scripts() {
	local script_dir="$1"
	local log_file="$2"

	for script in "$script_dir"/*; do
		if [ -f "$script" ]; then

			execute_and_check "$script"

		fi
	done
}

handle_cancel() {
	log_message "DEBUG" "SIGNAL CAPTURED | handle_cancel"
	CANCELLED=1                 #
	kill $sleep_pid 2>/dev/null # Kill the background sleep process
	exit 0
}

pre_notify_pipe() {

	# Set up a signal handler for SIGUSR1
	trap 'handle_cancel' SIGUSR1

	process_scripts "$USER_PRE_NOTIFY_SCRIPTS_DIR" "$LOGFILE"

	return 0

}

post_notify_pipe() {

	# Run sleep in the background
	sleep $NOTIFY_TIME &
	sleep_pid=$!

	# Wait for the sleep process to complete or be interrupted by a signal
	wait $sleep_pid

	if [ "$CANCELLED" != "0" ]; then

		log_message "DEBUG" "isCANCEL $CANCELLED Task cancelled by app | about to exit ..."
		exit 0
	else
		log_message "DEBUG" "No signal received. Continuing script..."

		process_scripts "$USER_POST_NOTIFY_SCRIPTS_DIR" "$LOGFILE"

	#

	fi

	#
	return 0

}

dispatch_notification() {

	log_message "DEBUG" "Running dispatch_notification task..."

	open -a "$APP_PATH" "$DISPATCH_URL" >>"$LOGFILE" 2>&1

	log_message "DEBUG" "Dispatched a notification"

	return 0
}

should_run() {
	check_system_state
	if [ $? -ne 0 ]; then
		return 1
	fi

	return 0
}

run_task() {
	log_message "DEBUG" "Running task..."
	open -a "$APP_PATH" "$OVERLAY_URL" >>"$LOGFILE" 2>&1
	log_message "DEBUG" "Task executed \n"
}

if should_run; then
	pre_notify_pipe
	dispatch_notification
	post_notify_pipe
	run_task
else
	log_message "DEBUG" "Skipping run due to condition..."
fi
