#!/bin/bash
TARGETIP=""
TARGETUSER=""
REPOSITRY=""
GITUSER=""

sed -i -e "s/【TARGETIP】/${TARGETIP}/g" ./jenkins-script
sed -i -e "s/【TARGETUSER】/${TARGETUSER}/g" ./jenkins-script
sed -i -e "s/【REPOSITRY】/${REPOSITRY}/g" ./jenkins-script
sed -i -e "s/【GITUSER】/${GITUSER}/g" ./jenkins-script
