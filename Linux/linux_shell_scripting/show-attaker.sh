#! /bin/bash

LIMIT=10

LOG_FILE=${1}

if [[ ! -e "${LOG_FILE}" ]]
then
   echo "can't read the log file: ${LOG_FILE}"
   exit 1
fi

IP_SORT=$(grep "rhost" "${LOG_FILE}" | awk -F '=' '{print $(NF-1)}' | cut -d " " -f1 | grep -v '^$' | sort | uniq -c | sort -n)

echo "COUNT,IP,LOCATION"
echo "${IP_SORT}" | while read COUNT IP
do
  if [[ "${COUNT}" -gt 10 ]]
  then
    LOCATION=$(geoiplookup "${IP}" | awk -F ', ' '{print $2}')
    echo " ${COUNT},${IP},${LOCATION}"
  fi
done
exit 0
