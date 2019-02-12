#!/bin/bash

# development script. creates a new workspace package
#
# usage:
#
#   scripts/create-package.sh <PACKAGE_NAME> [PACKAGE_NAMESPACE=@soundclerk WORKSPACE_NAME=client TEMPLATE_NAME=package]
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
WORKSPACES_DIR="$DIR/.."

source $DIR/print.sh

if [ -z "$HELP" ]; then
    HELP="Usage: create-package.sh <PACKAGE_NAME>"
fi

# name for the new package
PACKAGE_NAME=${1}

# name of the
PACKAGE_NAMESPACE=${2:-"@soundclerk"}
WORKSPACE_NAME=${3:-"client"}
TEMPLATE_NAME=${4:-"templates/package"}

PACKAGE_DIR="$WORKSPACES_DIR/$WORKSPACE_NAME/$PACKAGE_NAME/"

#-------------------------------------------------------------------------------
# ensure required arguments are set
#-------------------------------------------------------------------------------

if [ -z "$PACKAGE_NAME" ]
then
    print_error "No package name specified"
    print_info $HELP
    exit 1;
fi

if [ ! -d "$WORKSPACES_DIR/$WORKSPACE_NAME" ]; then
    print_error "No such workspace: $WORKSPACE_NAME"
    print_info $HELP
    exit 1;
fi

if [ -d "$PACKAGE_DIR" ]; then
    print_error "Package already exists"
    print_info $HELP
    exit 1;
fi

PACKAGE_DIR=$(realpath $PACKAGE_DIR)


#-------------------------------------------------------------------------------
# copy template files
#-------------------------------------------------------------------------------

mkdir -p $PACKAGE_DIR
cp -a "$DIR/$TEMPLATE_NAME/." $PACKAGE_DIR

#-------------------------------------------------------------------------------
# replace placeholders in copied files
#-------------------------------------------------------------------------------

grep -rl "__PACKAGE_NAMESPACE__" $PACKAGE_DIR | xargs -r sed -i "s/__PACKAGE_NAMESPACE__/$PACKAGE_NAMESPACE/g"
grep -rl "__PACKAGE_NAME__" $PACKAGE_DIR | xargs -r sed -i "s/__PACKAGE_NAME__/$PACKAGE_NAME/g"
grep -rl "__WORKSPACE_NAME__" $PACKAGE_DIR | xargs -r sed -i "s/__WORKSPACE_NAME__/$WORKSPACE_NAME/g"

#-------------------------------------------------------------------------------
# create symlink (instead of running full yarn install)
#-------------------------------------------------------------------------------

if [ ! -f "WORKSPACES_DIR/node_modules/.bin/symlink-dir" ]; then
    print_info "Unable to create symlink - please run yarn install"
fi

$WORKSPACES_DIR/node_modules/.bin/symlink-dir $PACKAGE_DIR "$WORKSPACES_DIR/node_modules/$PACKAGE_NAMESPACE/$PACKAGE_NAME"

print_success "New package created: $(readlink -f $PACKAGE_DIR)"


