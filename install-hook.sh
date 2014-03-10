#!/bin/bash

HELPMSG="Usage: install-hook.sh <git repostitory>"
HOOKSCRIPT="`pwd`/git-jira-hook"

install() {
    if [ ! -f $HOOKSCRIPT ]; then
        echo "ERROR: Could not find the hook script to install." >&2
        exit 5
    fi
    if [ ! -d $1 ]; then
        echo "ERROR: The specified git directory doesn't exist." >&2
        exit 2
    elif [ ! -d "$1/hooks" ]; then
        echo "ERROR: Could not find the hooks directory." >&2
        exit 3
    fi

    #Save the current directory so we can change back to it when we're done
    PWD="`pwd`"
    DIR="$1/hooks"

    #Change to the hooks directory for the git repo
    cd "$DIR"

    if [ -f "update" ] || [ -f "commit-msg" ] || [ -f "post-commit" ] || [ -f "post-receive" ]; then
        echo "ERROR: The hook script was not installed because there were existing hook scripts." >&2
        cd "$PWD"
        exit 4
    fi

    #The hook script is installed as 'update' and everything else is a symlink
    cp "$HOOKSCRIPT" ./update
    chmod oug+x ./update

    ln -s update commit-msg
    ln -s update post-commit
    ln -s update post-receive

    cd "$PWD"
}

if [ "$#" -ne 1 ]; then
    echo $HELPMSG >&2
elif [ $1 == "-h" ] || [ $1 == "--help" ]; then
    echo $HELPMSG >&2
else
    install $1
    exit 0
fi

exit 1
