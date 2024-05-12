#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Define an array with the names of the service files
service_files=("Chart-images.service" "Setups-emails.service" "Breakouts-emails.service" "premarketEmail.service")

# Function to check if a service is active
is_service_active() {
    local service_name="$1"
    systemctl is-active --quiet "$service_name"
}

# Function to display logs for a service file
display_logs() {
    local service_file="$1"
    if is_service_active "$service_file"; then
        local logs=$(journalctl -u "$service_file" --output=short-precise -n 20 | sed 's/^/| /') # Add pipe at the beginning of each line
        printf "%s\n" "$logs" # Print logs
    else
        echo "Service $service_file is not running."
    fi
}

# Function to display logs for all service files
display_all_logs() {
    clear
    # Print header
    printf "${YELLOW}| %-30s | %-100s |${NC}\n" "Service File" "Logs"
    printf "${YELLOW}|-----------------------------------------------------------------------------------------------|${NC}\n"
    # Loop through each service file
    for service_file in "${service_files[@]}"; do
        # Print service file name
        printf "${GREEN}| %-30s |${NC}\n" "$service_file"
        # Print logs for the corresponding service file
        display_logs "$service_file"
        printf "${YELLOW}|-----------------------------------------------------------------------------------------------|${NC}\n"
    done
}

# Function to continuously display logs
monitor_logs() {
    while true; do
        display_all_logs
        # Check for user input to exit
        read -t 5 -n 1 key # Wait for 5 seconds for user input
        if [[ $key == q ]]; then
            clear
            echo "Exiting..."
            break
        fi
    done
}

# Call the function to monitor logs
monitor_logs
