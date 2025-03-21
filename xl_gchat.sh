#!/bin/bash
#    File Name: xl_gchat.sh
#      Created: 20250315
#      Purpose: Send google chat message via bash scripting
#  Main Author: Extreme Logic PH
#       Github: https://github.com/extremelogic-ph/xl_scripts

# Check if the Webhook URL environment variable is set
if [[ -z "$XL_GCHAT_WEBHOOK_URL" ]]; then
    echo "Error. A Google Chat webhook URL is required."
    echo "Please set the XL_GCHAT_WEBHOOK_URL environment variable and try again."
    exit 1
fi

# Function to display help
show_help() {
    echo "Usage: $0 --prompt \"Your message here\""
    echo "       $0 --file filename.txt"
    echo "Allowed parameters:"
    echo "  --prompt \"Message\"   Send a message with spaces enclosed in quotes."
    echo "  --file filename       Send a message from the contents of a file."
    exit 1
}

# Check arguments
if [[ $# -lt 2 ]]; then
    echo "Error: Missing parameters."
    show_help
fi

# Initialize variables
MODE=""
MESSAGE=""

# Parse arguments
case "$1" in
    --prompt)
        if [[ -z "$2" ]]; then
            echo "Error: Missing message for --prompt."
            show_help
        fi
        MODE="prompt"
        MESSAGE="$2"
        ;;
    --file)
        if [[ -z "$2" || ! -f "$2" ]]; then
            echo "Error: File not found or not specified."
            show_help
        fi
        MODE="file"
        MESSAGE=$(cat "$2")
        ;;
    *)
        echo "Error: Unknown parameter '$1'"
        show_help
        ;;
esac

# Prepare JSON payload
JSON_PAYLOAD=$(jq -n --arg text "$MESSAGE" '{text: $text}')

# Send the message and capture the HTTP status code
HTTP_RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: application/json" -d "$JSON_PAYLOAD" "$XL_GCHAT_WEBHOOK_URL")

# Check response code
if [[ "$HTTP_RESPONSE" -eq 200 ]]; then
    echo "Message sent successfully!"
else
    echo "Error. Failed to send message. HTTP Response Code: $HTTP_RESPONSE"
    exit 1
fi

