#!/bin/bash
#      File Name: xl_common.sh
#        Created: 20241016
#        Purpose: Some common functions that we frequently use
#    Main Author: Virgilio "Jan" So
#            URL: https://github.com/extremelogic-ph/xl_scripts

# Name of the script without the path
XL_SCRIPT_NAME=$(basename "$0")

# Directory where we start to run the script 
XL_INITIAL_DIR=$(pwd)

# Function to check if the required number of parameters are provided
xl_require_params() {
    local param_count=$1
    local required_params=$2
    local sample_pattern=$3
    local sample_usage=$4

    # Check if the correct number of parameters are provided
    if [ "$param_count" -lt "$required_params" ]; then
        echo ""
        echo "Usage: ${XL_SCRIPT_NAME} ${sample_pattern}"
        echo ""
        echo "Sample Usage: ${XL_SCRIPT_NAME} ${sample_usage}"
        echo ""
        exit 1
    fi
}

# Function to check if a given string exists as a variable
xl_require_variable() {
    local var_name="$1"
    local message="$2"

    # Check if the environment variable is set (non-empty)
    if [ -z "${!var_name}" ]; then
        echo "Error: variable '$var_name' is not set. $message"
        exit 1
    fi
}

# Function to check if a required file exists
xl_require_file() {
    local file_path="$1"
    local message="$2"

    if [ ! -f "$file_path" ]; then
        echo "Error: File '$file_path' does not exist. $message"
        exit 1
    fi
}

# Function to check if a required directory exists
xl_require_dir() {
    local dir_path="$1"
    local message="$2"

    if [ ! -d "$dir_path" ]; then
        echo "Error: Directory '$dir_path' does not exist. $message"
        exit 1
    fi
}

# Function to require that we work on the desired directory
xl_require_cwd() {
    local required_dirs=("$@")  # Accept multiple directories as arguments
    
    # Get the current directory name
    local current_dir=$(basename "$PWD")
    
    # Flag to track if any directory matches
    local match_found=0
    
    # Loop through each provided directory and check if it matches the current directory
    for dir in "${required_dirs[@]}"; do
        if [[ "$current_dir" == "$dir" ]]; then
            match_found=1
            break  # No need to check further if a match is found
        fi
    done
    
    # If no match was found, exit with an error
    if [[ "$match_found" -eq 0 ]]; then
        echo "Error: You must run this script from one of the following directories: ${required_dirs[*]}."
        exit 1
    fi
}

# Function to make sure that the files are the same
xl_require_same_file() {
    local file1="$1"
    local file2="$2"

    # Check if both parameters are provided
    if [[ -z "$file1" || -z "$file2" ]]; then
        echo "Error: Both file arguments must be provided."
        exit 1
    fi

    # Check if both files exist and are regular files
    if [[ ! -f "$file1" ]]; then
        echo "Error: '$file1' is not a valid file or does not exist."
        exit 1
    fi

    if [[ ! -f "$file2" ]]; then
        echo "Error: '$file2' is not a valid file or does not exist."
        exit 1
    fi

    # Compare the files
    if ! cmp -s "$file1" "$file2"; then
        echo "Error: '$file1' and '$file2' are not the same."
        exit 1
    fi
}
