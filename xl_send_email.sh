#!/bin/bash
#      File Name: xl_send_email.sh
#        Created: 20260210
#        Purpose: Fixes HTML rendering and Subject Overrides
#    Main Author: Virgilio So

# 1. Initialize variables with Env Defaults
# We use := to set a default only if the Env Var is not already set
username="${XL_SEND_EMAIL_USER}"
password="${XL_SEND_EMAIL_PASS}"
recipient="${XL_SEND_EMAIL_RECIPIENT}"
subject="${XL_SEND_EMAIL_SUBJECT}"
cc_recipient="${XL_SEND_EMAIL_CC_RECIPIENT}"
email_body_file="${XL_SEND_EMAIL_BODY:-.xl_send_email_body}"
dry_run=false

# 2. Parse command line arguments for overrides
while [[ $# -gt 0 ]]; do
    case $1 in
        --body)             email_body_file="$2"; shift 2 ;;
        --send_email_user)  username="$2";        shift 2 ;;
        --send_email_pass)  password="$2";        shift 2 ;;
        --recipient)        recipient="$2";       shift 2 ;;
        --subject)          subject="$2";         shift 2 ;;
        --cc)               cc_recipient="$2";    shift 2 ;;
        --dry-run)          dry_run=true;         shift 1 ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# 3. Dynamic Date Replacement (CRITICAL: Do this AFTER flag parsing)
current_date=$(date +%Y%m%d)
subject="${subject//YYYYMMDD/$current_date}"

# 4. Validation
if [ -z "$username" ]; then echo "Error: User not set"; exit 1; fi
if [ -z "$password" ]; then echo "Error: Password not set"; exit 1; fi
if [ -z "$recipient" ]; then echo "Error: Recipient not set"; exit 1; fi
if [ -z "$subject" ]; then echo "Error: Subject not set"; exit 1; fi
if [ ! -f "$email_body_file" ]; then echo "Error: Body file '$email_body_file' not found"; exit 1; fi

# 5. Mask Password for Display
masked_pass="${password:0:2}********${password: -2}"

# 6. Prepare Content (Note the specific spacing for HTML compatibility)
body=$(cat "$email_body_file")

# Constructing the raw email string with explicit CRLF (line breaks)
# This ensures Gmail recognizes it as a valid HTML email.
email_data=$(printf "From: %s\r\nTo: %s\r\n" "$username" "$recipient")
if [ -n "$cc_recipient" ]; then
    email_data+="$(printf "Cc: %s\r\n" "$cc_recipient")"
fi
email_data+="$(printf "Subject: %s\r\n" "$subject")"
email_data+="$(printf "Content-Type: text/html; charset=\"UTF-8\"\r\n")"
email_data+="$(printf "\r\n%s" "$body")"

# 7. Summary Display
echo "--------------------------------------------------"
echo " SENDING EMAIL TO: $recipient"
echo " SUBJECT:          $subject"
echo "--------------------------------------------------"

if [ "$dry_run" = true ]; then
    echo -e "\n[DRY RUN] Raw Payload Check:"
    echo "$email_data"
    exit 0
fi

# 8. Execution
# Using --url "smtps://" for port 465 or "smtp://" with --ssl-reqd for 587
curl --silent --show-error --ssl-reqd \
  --url "smtp://smtp.gmail.com:587" \
  --user "$username:$password" \
  --mail-from "$username" \
  --mail-rcpt "$recipient" \
  $( [ -n "$cc_recipient" ] && echo "--mail-rcpt $cc_recipient" ) \
  --upload-file <(echo "$email_data")

if [ $? -eq 0 ]; then
    echo "SUCCESS: Email sent."
else
    echo "ERROR: Send failed."
fi
