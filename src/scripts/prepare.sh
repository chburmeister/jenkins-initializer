#!/usr/bin/env bash

TOMCAT_HOME=$1
TOMCAT_DOWNLOAD_LINK=$2
JENKINS_HOME=$3
JENKINS_DOWNLOAD_LINK=$4

# init
rm -rf $TOMCAT_HOME
mkdir -p $TOMCAT_HOME
rm -rf $JENKINS_HOME
mkdir -p $JENKINS_HOME

printf "installing tomcat\n"
printf "#################\n"
wget --output-document $TOMCAT_HOME/tomcat.zip $TOMCAT_DOWNLOAD_LINK
unzip $TOMCAT_HOME/tomcat.zip -d $TOMCAT_HOME
cp -r $TOMCAT_HOME/apache-tomcat*/* $TOMCAT_HOME/
rm -rf $TOMCAT_HOME/apache-tomcat*
rm -f $TOMCAT_HOME/tomcat.zip
chmod +x $TOMCAT_HOME/bin/*

printf "\n\n"

printf "installing jenkins\n"
printf "##################\n"
wget --output-document $TOMCAT_HOME/webapps/jenkins.war $JENKINS_DOWNLOAD_LINK

printf "\n\n"

printf "configuring jenkins\n"
printf "##################\n"
printf "export JAVA_OPTS=\"-Djenkins.install.runSetupWizard=false\"\n" > $TOMCAT_HOME/bin/setenv.sh
printf "export JENKINS_HOME=\"${JENKINS_HOME}\"" >> $TOMCAT_HOME/bin/setenv.sh

printf "\n\n"

printf "starting tomcat with jenkins\n"
printf "############################\n"
$TOMCAT_HOME/bin/startup.sh
JENKINS_READY="false"
while [ $JENKINS_READY = "false" ]
do
    printf "checking, if Jenkins is already available...\n"
    wget --server-response -q -o /tmp/jenkins.ready.check http://localhost:8080/jenkins/cli
    sleep 2
    WGET_RESULT_CODE=$(cat /tmp/jenkins.ready.check | awk '/HTTP/{ print $2 }')

    if [[ $WGET_RESULT_CODE =~ "200" ]] # if jenkins is up & running it will return "302 200"
    then
        JENKINS_READY="true"
        printf "... jenkins is up and running.\n"
    fi
done
