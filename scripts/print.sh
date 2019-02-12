#!/bin/bash
# https://raw.githubusercontent.com/loopmode/bash-print/master/print.sh

# helper functions for printing colored blocks to the CLI

JOIN_PARAM="+"

RED='\u001b[41;1m'
GREEN='\u001b[42;1m'
BLUE='\u001b[46;1m'

CLEAR_COLOR='\033[0m'
CLEAR_EOL='\x1B[K' # for colored empty lines, see https://stackoverflow.com/a/20058323/368254

function print_block() {

    clr=${@: -1} # last arg
    msg=${@:1:$#-1} # all except last arg, see https://stackoverflow.com/a/1215592/368254

    # check if JOIN_PARAM was set, and if so, remove it from the message and skip the trailing linebreak
    unset skip_trailing_break
    if [ "${msg: -1}" == "$JOIN_PARAM" ]; then
        msg=${@:1:$#-2}
        skip_trailing_break=1
    fi

    # always print leading linebreak
    echo

    # print formatted message
    echo -e "$clr $CLEAR_EOL $CLEAR_COLOR
$clr    $msg $CLEAR_EOL $CLEAR_COLOR
$clr    $CLEAR_EOL $CLEAR_COLOR"

    # only print trailing linebreak when JOIN_PARAM was not set
    if [ -z "$skip_trailing_break" ]; then
        echo
    fi
}


function print_info() {
    print_block $@ $BLUE
}

function print_error() {
    print_block $@ $RED
}

function print_success() {
    print_block $@ $GREEN
}
