# xl_scripts

Just some simple scripts that I created to simplify some tasks. I only edit them as per need, so updates are not that active.

## xl_sync_git.sh

Updates all your local git repos using a single command. Directory structure should be like this:

```
main_project_directory
    project1
        .git
        README.txt
    project2
        .git
        hello.java
```

And you execute the script inside the *main_project_directory*.

Sample execution below

```
./xl_sync_git.sh
```
