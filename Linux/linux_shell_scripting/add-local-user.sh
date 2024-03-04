#! /bin/bash


#Make sure the script is executed as root user

if [[ ${UID} -ne 0 ]]
then
echo "please use the root user to run this script."
exit 1
fi

# Prompt for username

read -p "Add username: " USER_NAME

# Prompt for additional information

read -p "Add name: " COMMENT

# Prompt for Password

read -p "Set inital Password: " PASSWORD

# Create User

useradd -c "${COMMENT}" ${USER_NAME}

# was user created?
if [[ "${?}" -ne 0 ]]
then 
echo "user could not be created"
exit 1
fi

# set password for user
echo "${PASSWORD}" | passwd --stdin ${USER_NAME}

if [[ "${?}" -ne 0 ]]
then
echo "password could not be set."
exit 1
fi

# set password to expire on next login
passwd -e ${USER_NAME}

# Dispaly the user with passoword has been created at host
echo
echo "username: ${USER_NAME}"
echo
echo "password: ${PASSWORD}"
echo
echo "host: ${HOSTNAME}"
echo
exit 0 
