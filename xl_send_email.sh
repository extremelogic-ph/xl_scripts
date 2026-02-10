#!/bin/bash
#      File Name: xl_send_email.sh
#        Created: 20260210
#        Purpose: Sends a google email 
#    Main Author: Virgilio So
#   Contributors:

# Default email body file
email_body_file=".xl_send_email_body"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --body)
            email_body_file="$2"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            echo "Usage: $0 [--body <file>]"
            exit 1
            ;;
    esac
done

if [ -z "$XL_SEND_EMAIL_USER" ]; then
    echo "Error: XL_SEND_EMAIL_USER environment variable is not set. Eg. john.doe@gmail.com"
    exit 1
fi
if [ -z "$XL_SEND_EMAIL_PASS" ]; then
    echo "Error: XL_SEND_EMAIL_PASS environment variable is not set. Eg: johndoescretpass"
    exit 1
fi
if [ -z "$XL_SEND_EMAIL_RECIPIENT" ]; then
    echo "Error: XL_SEND_EMAIL_RECIPIENT environment variable is not set. Eg: jane.doe@gmail.com or jane.doe@gmail.com,bob@example.com"
    exit 1
fi
if [ -z "$XL_SEND_EMAIL_SUBJECT" ]; then
    echo "Error: XL_SEND_EMAIL_SUBJECT environment variable is not set. Eg: Monthly Report"
    exit 1
fi

# Check if email body file exists
if [ ! -f "$email_body_file" ]; then
    echo "Error: Email body file '$email_body_file' not found"
    exit 1
fi

subject="${XL_SEND_EMAIL_SUBJECT}"
body=$(cat "$email_body_file")
username="${XL_SEND_EMAIL_USER}" # Your full Gmail address
password="${XL_SEND_EMAIL_PASS}" # Your Gmail App Password or regular password
encoded_password=$password
smtp_server="smtp.gmail.com"
smtp_port="587" # Use 465 for SSL

# Prepare the email content with optional CC
if [ -n "$XL_SEND_EMAIL_CC_RECIPIENT" ]; then
    email_content=$(cat <<EOF
From: $username
To: $XL_SEND_EMAIL_RECIPIENT
Cc: $XL_SEND_EMAIL_CC_RECIPIENT
Subject: $subject
Content-Type: text/html

$body
EOF
)
else
    email_content=$(cat <<EOF
From: $username
To: $XL_SEND_EMAIL_RECIPIENT
Subject: $subject
Content-Type: text/html

$body
EOF
)
fi

# Build mail-rcpt arguments
mail_rcpt_args="--mail-rcpt $XL_SEND_EMAIL_RECIPIENT"

# Add CC recipients if set
if [ -n "$XL_SEND_EMAIL_CC_RECIPIENT" ]; then
    IFS=',' read -ra CC_ARRAY <<< "$XL_SEND_EMAIL_CC_RECIPIENT"
    for cc_email in "${CC_ARRAY[@]}"; do
        mail_rcpt_args="$mail_rcpt_args --mail-rcpt $cc_email"
    done
fi

# Send the email using curl
eval curl --ssl-reqd \
  --mail-from "$username" \
  $mail_rcpt_args \
  --url "smtp://$smtp_server:$smtp_port" \
  --user "$username:$password" \
  -T - <<< "$email_content"
