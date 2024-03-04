#!/bin/bash

# Enfore the script to be used with root, if not turn output into an error

if [[ ${UID} -ne 0 ]]
then
echo "run script as root user" >&2 
exit 1
fi

# CHeck that at least on argument was provided by the user
if [[ "${#}" -lt 1 ]]
then
echo "Usage [USERNAME] [COMMENT]..." >&2
exit 1
fi

USERNAME=${1}
shift
COMMENT=${@}

useradd -c "${COMMENT}" ${USERNAME} &> /dev/null

if [[ "${?}" -ne 0 ]] 
then
echo "user could not be added" >&2 
exit 1
fi

PASSWORD=$(date +s% | sha256sum | head -c12)

echo ${PASSWORD} | passwd --stdin ${USERNAME}  &> /dev/null

passwd -e ${USERNAME} &> /dev/null

echo "username: ${USERNAME}"
echo
echo "password: ${PASSWORD}"
echo
echo "host: ${HOSTNAME}"
echo
exit 0

