#!/bin/bash

#--------------------------------------------------------------------
# Starts the local development environment
#
# Depending on the arguments, the script launches up to 4 processes:
# - start and watch client app
# - start and watch server app
# - compile and watch other client packages
# - compile and watch other server packages
#
# To launch all four of these processes, call `dev.sh all --watch 1` or `dev.sh --watch 1`.
#
# Usage: dev.sh [client|server|all] [--delay seconds] [--scripts path] [--watch flag] [--watchdelay seconds]
#
# examples:
#
# scripts/dev.sh
# scripts/dev.sh server --delay 5 --watch 1
#
#--------------------------------------------------------------------


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

WORKSPACE_NAME=${1:-"client"}

# whether to watch workspace packages
# Set using " --watch 1"
watch=
# delay for watching packages in seconds
watchdelay=

# path to this /scripts folder - workaround for wrong cwd in docker
# Set using " --scripts my/path"
scripts=.

source $DIR/$scripts/print.sh

#--------------------------------------------------------------------
# named arguments
# creates variables for named arguments starting with --
# e.g `--watch 1` becomes `watch="1"` and you can `echo $watch`,
# see https://unix.stackexchange.com/a/388038/239568
#--------------------------------------------------------------------
while [ $# -gt 0 ]; do
   if [[ $1 == *"--"* ]]; then
        v="${1/--/}"
        declare $v="$2"
   fi
   shift
done

# restore default INT handler for better Ctrl+C handling, see https://unix.stackexchange.com/a/230568/239568
trap '
  trap - INT
  kill -s INT "$$"
' INT


function wait() { if [ -n "$1" ] ; then sleep $1; fi }

#--------------------------------------------------------------------
#
# CLIENT
#
#--------------------------------------------------------------------

function watch_client_packages() {
    wait $1
    echo "Watch client packages"
    node_modules/.bin/lerna run watch --scope @soundclerk/* --ignore @soundclerk/app --parallel --stream
}
function start_client_devserver() {
    wait $1
    echo "Start client app development"
    cd client/app;
    yarn start;
}
function start_client() {
    print_info "Start client development"
    if [[ $watch = "1" ]]; then
        watch_client_packages & start_client_devserver $delay
    else
        start_client_devserver
    fi
}



#--------------------------------------------------------------------
#
# SERVER
#
#--------------------------------------------------------------------

# function watch_server_packages() {
#     wait $1
#     echo "Watch server packages"
#     node_modules/.bin/lerna run watch --scope @server/* --ignore @server/app --parallel --stream
# }
# function develop_server() {
#     wait $1
#     echo "Start server app development"
#     cd server/app;
#     yarn start:debug;
# }
# function start_server() {
#     if [[ $watch = "1" ]]; then
#         watch_server_packages & develop_server $delay
#     else
#         develop_server
#     fi
# }




#--------------------------------------------------------------------
# main script
#--------------------------------------------------------------------

case "$WORKSPACE_NAME" in
    # all)
    #     print_info "Start client and server development" +
    #     start_server & start_client
    #     ;;

    client)
        start_client
        ;;

    # server)
    #     print_info "Start server development"
    #     start_server
    #     ;;

    *)
        if [ -z "$WORKSPACE_NAME" ] ; then
            start_client
        else
            print_error "Invalid target \"$WORKSPACE_NAME\""
            print_info "Usage: dev.sh [client|server|all] [--delay seconds] [--scripts path] [--watch flag]"
            exit 1
        fi
        ;;
esac
