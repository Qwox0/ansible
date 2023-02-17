#!/usr/bin/env bash

# BECOME password
ask_pw=false
while getopts "Kprs" OPTION; do
    case "$OPTION" in
        K) ask_pw=true ;;
        p) ask_pw=true ;;
        r) ask_pw=true ;;
        s) ask_pw=true ;;
        ?)
            echo "script usage: $(basename $0) [-K] [-p] [-r] [-s] tag" >&2
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

# tag
tag="$1"
if [ -z "$tag" ]; then
    echo "please provide tag!"
    exit 2
fi

if ! $ask_pw; then
    ansible-playbook local.yml -t $tag

    if [ $? == 0 ]; then
        echo "finished running ansible playbook. :)"
        exit 0
    fi

    echo "failed to run ansible playbook. :("
    echo -n "run with -K flag? [Y/q] : "
    read -r input # -r: prevent \ escaping (e.g for multiple lines)

    if [[ $input != "" && $input != "y" && $input != "Y" ]]; then exit 3; fi
fi

ansible-playbook local.yml -K -t $tag

if [ $? == 0 ]; then
    echo "finished running ansible playbook. :)"
    exit 0
else
    echo "failed to run ansible playbook. :("
    exit 3
fi
