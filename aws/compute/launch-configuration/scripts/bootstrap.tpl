#!/bin/bash
set -e

echo "Updating yum..."
yum update -y

INCLUDE_RUXIT=${include_ruxit}
if [ "$INCLUDE_RUXIT" = true ] || [ "$INCLUDE_RUXIT" = "1" ] ; then
    echo "Installing Ruxit Dynatrace OneAgent..."
    wget -O Dynatrace-OneAgent-Linux-1.99.191.sh https://tmu05513.live.dynatrace.com/installer/agent/unix/latest/4hrCOkiEcO19V1cg
    /bin/sh Dynatrace-OneAgent-Linux-1.99.191.sh APP_LOG_CONTENT_ACCESS=1 
fi
