#!/bin/bash

set -e

sed -i -e 's/<%=cert_client_storepass%>/'"${CERT_CLIENT_STOREPASS}"'/g' /opt/ems/share/import_certificate.sh

/opt/ems/share/import_certificate.sh 2>&1
RES=$?
if [ $RES != 0 ]; then
  echo "Importing Certicates is not success, return code:" $RES
  exit -1
fi

: ${JVM_NS_MEM_START:='512M'}
: ${JVM_NS_MEM_MAX:='512M'}

export LOG_APP_NAME=rabbitmq_monitor
export CONTEXT_FILE="/opt/ems/conf/rabbitmq-monitor-context.xml"

myprog="/opt/ems/bin/emsjava \
   -XX:+HeapDumpOnOutOfMemoryError \
   -XX:HeapDumpPath=/var/log/oom \
   com.m1.ems.util.SpringService $CONTEXT_FILE "

echo "Rabbitmq Monitor Service starting with:" $myprog

exec $myprog 2>&1
