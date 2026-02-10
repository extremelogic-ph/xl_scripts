# xl_scripts

A collection of simple, need-based scripts by Extreme Logic Ph.

## 1. xl_sync_git.sh
- **Purpose:** Updates all local git repos in the main project directory.
- **Usage:** Execute `./xl_sync_git.sh` within the `main_project_directory`.

```bash
cd main_project_directory
./xl_sync_git.sh
```

- **Directory Structure:**

```
main_project_directory
    project1
        .git
        README.txt
    project2
        .git
        hello.java
```

## 2. xl_goto.sh
- **Created:** 20150610
- **Author:** Extreme Logic PH
- **Purpose:** Quick directory change based on a configuration file.
- **Usage:** `. xl_goto.sh <choose a number>`
    - Displays a list of directory options from `xl_goto.cfg` when executed with no arguments.
    - Each line in `xl_goto.cfg`: `<number>,<description>,<directory path>`
    - Changes to the selected directory based on user input.
### Sample Configuration (xl_goto.cfg)

```
1,Description for Directory 1,/path/to/directory1
2,Description for Directory 2,/path/to/directory2
```

### Sample Execution

```
. xl_goto.sh 1
```

Changes the current directory to the one corresponding to choice `1` in the configuration file.

## 3. xl_wait_port.sh
- **Created:** 20150801
- **Author:** Extreme Logic Ph
- **Purpose:** Waits for a specified port to go up or down.
- **Usage:** `./xl_wait_port.sh [port] [ up | down ]`
    - Waits until the specified port is either up or down.
    - Displays a warning message if the process takes some time.
### Sample Execution

```
./xl_wait_port.sh 12004 up
```

Waits for port 12004 to go up and prints a message when the port is up.

## 4. xl_backup.sh
- **Created:** 20150213
- **Author:** Extreme Logic
- **Purpose:** Backs up a file or folder to a specified backup folder and archives it.
- **Usage:** `./xl_backup.sh [file or folder to backup]`
    - Checks if the specified backup folder exists, creates one if it does not.
    - Backs up the specified file or directory into a new folder within the backup folder, named with the current timestamp.
    - Archives the backup into a `.tar.gz` file.
    - Supports backing up multiple files and folders specified as separate arguments.
### Sample Execution

```
./xl_backup.sh /path/to/file /path/to/folder
```

Backs up and archives the specified file and folder into the backup directory.

## 5. xl_gchat.sh
- **Created:** 20250315
- **Author:** Extreme Logic
- **Purpose:** Send google chat message via bash scripting
- **Usage:** `./xl_backup.sh [--prompt <message> | --file <file>]`

### Sample Execution

```
./xl_gchat.sh --prompt "This is a meesage"
./xl_gchat.sh --file ./file_containing_the_message.txt
```

Sends a google chat message using a webhook. Need to setup XL_GCHAT_WEB_HOOK environment variable

## 6. xl_send_email.sh
- **Created:** 20260210
- **Author:** Virgilio So
- **Purpose:** Sends a google email

### Sample Execution

```
./xl_send_email.sh 
./xl_send_email.sh --body ./body.txt
```

## Contact Information
- **Email:** support@extremelogic.ph
