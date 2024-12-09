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
    local required_dir="$1"
    
    # Get the current directory name
    local current_dir=$(basename "$PWD")
    
    # Check if the current directory matches the required directory
    if [[ "$current_dir" != "$required_dir" ]]; then
        echo "Error: You must run this script from the '$required_dir' directory."
        exit 1
    fi
}

