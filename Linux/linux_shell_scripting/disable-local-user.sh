#! /bin/bash

# functions

#usage statement
usage(){
  echo "usage: ${0} [-dra] [USERNAME]..." >&2
  echo "-d delete user" >&2
  echo "-r remove home directoty" >&2
  echo "-a archive user" >&2
  echo "default: deactivate user" >&2
  exit 1
}

# functions end
# costants
readonly ARCHIVE_DIR="/archive"
# constants end

# Make sure this script is  run as root or with sudo

if [[ ${UID} -ne 0 ]]
then
  echo "run this script with root priviliges" >&2
 exit 1
fi

while getopts dra OPTION
do
 case ${OPTION} in
   a) ARCHIVE='true' ;;
   d) DELETE='true' ;;   
   r) REMOVE="-r" ;;
   ?) usage ;;
 esac
done


#Remove options while leaving the arguments
shift "$((OPTIND -1))"

#show usage f no username was supplied

if [[ "${#}" -lt 1 ]]
then
 usage
fi

# apply action for all the supplied users
for USERNAME in "${@}"
do
   echo "doing something"
   if [[ $(id -u ${USERNAME}) -lt 1000 ]]
   then
      echo "do not remove system accounts" >&2
   else
     if [[ "${ARCHIVE}" == 'true' ]]
     then
       if [[ ! -d "${ARCHIVE_DIR}" ]]
       then
         mkdir -p ${ARCHIVE_DIR}
         echo "creating ${ARCHIVE_DIR}"
       fi
       echo "archiving ${USERNAME}"
       tar -zcf "${ARCHIVE_DIR}/${USERNAME}.tgz"  "/home/${USERNAME}" &> /dev/null
     fi
     if [[ "${DELETE}" == 'true' ]]
     then
       userdel ${REMOVE} ${USERNAME}
       if [[ "${?}" -ne 0 ]]
       then
         echo "The account ${USERNAME} was not deleted">&2
       fi
     else
       chage -E 0 ${USERNAME}
       if [[ "${?}" -ne 0  ]]
       then
         echo "The account ${USERNAME} was not deactivated " >&2
       fi
     fi
   fi
done

echo "script done"  
exit 0


