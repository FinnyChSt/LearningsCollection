#! /bin/bash

# Use servers as the server File
SERVER_FILE="/vagrant/servers"

VERBOSE="false"
DRY_RUN="false"
SUPER_USER="false"
NEW_SERVER_FILE="false"

usage(){
echo "usage: [option]... [command]"
echo "viable options:"
echo "f provide new server file"
echo "n do a dry run"
echo "s run as root"
echo "v enable verbose mode"
echo
exit 1
}

# Create a script that runs a command on all given servers
# options for running are -f user can change the file for servers, -n allows the user to perform dry runs, s runs the command as superuser, v enables verbose mode

if [[ ${UID} -eq 0 ]]
then
  echo "don't run this script as root. please use the s option"
  exit 1
fi

while getopts f:nsv OPTION
do 
case ${OPTION} in
 v) VERBOSE="true" ;;
 n) DRY_RUN="true" ;;
 s) SUPER_USER="true" ;;
 f) NEW_SERVER_FILE="true" ;;
 ?) usage
esac
done
shift "$((OPTIND -1))"

if [[ ${NEW_SERVER_FILE} == "true" ]]
then
  if [[ "${#}" -ne 2 ]]
  then
    echo "please provide a file and a command"
    exit 1
  else
    SERVER_FILE="${1}"
    echo "set new server file to: ${SERVER_FILE}"
    shift
  fi
fi

if [[ "${#}" -ne 1 ]]
then 
  usage
fi

for SERVER in $(cat "${SERVER_FILE}")
do
  if [[ "${DRY_RUN}" == "true" ]]
  then
    echo  "DRY RUN: ssh ${SERVER} ${1}"
  else
    if [[ "${VERBOSE}" == "true" ]] 
    then
      echo "running comand on ${SERVER}"
    fi
    if [[ "${SUPER_USER}" == "true" ]]
    then
    ssh -o ConnectTimeout=2 "${SERVER}" sudo "${1}"
    else
    ssh -o ConnectTimeout=2 "${SERVER}" "${1}"
    fi
    if [[ "${?}" -ne 0 ]]
    then
      echo "The command on ${SERVER} was not executed it exited with status ${?}"
    fi
  fi
done

exit 0
