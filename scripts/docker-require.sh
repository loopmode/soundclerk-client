#!/bin/bash

# check docker is running at all, otherwise allow user retry with ENTER key
#
# based on https://stackoverflow.com/questions/22009364/is-there-a-try-catch-command-in-bash
{
  # will throw an error if the docker daemon is not running and jump
  # to the next code chunk
  docker ps -q
} || {
  echo "-----------------------------------------------------------------------"
  echo ""
  echo "    Docker is not running. Please start docker on your computer"
  echo "    When docker has finished starting up press [ENTER} to continue"
  echo ""
  echo "-----------------------------------------------------------------------"
  read
}
