#! /bin/bash

# Enforce script to be used by root if not return with message and exit 1

if [[ ${UID} -ne 0 ]]
then
echo "please run the script as root."
exit 1
fi

# show useage error if no arguments provided
NUMBER_OF_PARAMETERS="${#}"

echo "${#}"

if [[ "${#}" -eq 0 ]]
then
echo "Usage: ./add-new-local-user.sh USER_NAME [COMMENT]..."
exit 1
fi
#Save Parameters in variables
USER_NAME=${1}

while [[ "${#}" -gt 1 ]]
do
shift
COMMENT="${COMMENT}${1}"
done

# creat username
useradd -c ${COMMENT} ${USER_NAME}

# exit if user could not be created
if [[ ${?} -ne 0 ]]
then
echo "error creating the user"
exit 1
fi

# generate random password

S=$(echo "!@#$%&" | fold -w1 | shuf | head -c1)

PASSWORD=$(date +%s | sha256sum | head -c12)  

SPASSWD="${S}${PASSWORD}"

echo "${SPASSWD}" | passwd --stdin ${USER_NAME}

# let password expire on first login
passwd -e ${USER_NAME}

# Display username password and host
echo
echo "Username: ${USER_NAME}"
echo
echo "Password: ${SPASSWD}"
echo
echo "Host: ${HOSTNAME}"
echo
exit 0


