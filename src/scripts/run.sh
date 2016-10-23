#!/bin/bash

# note:
# to execute against an already running jenkins with security setup,
# you have use crumbs like this:
#
# JENKINS_USERNAME=admin
# JENKINS_APITOKEN=XXX
# JENKINS_CRUMBPATH=crumbIssuer/api/xml
# CRUMB=$(curl --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} ${JENKINS_BASEURL}/${JENKINS_CRUMBPATH}?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
# curl --verbose --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./SOMESCRIPT.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
#
# but in case you use jenkins initializer, you will be working against a non-secured jenkins instance


TOMCAT_HOME="/home/christoph/test/tomcat"
TOMCAT_DOWNLOAD_LINK="http://mirror.synyx.de/apache/tomcat/tomcat-8/v8.5.6/bin/apache-tomcat-8.5.6.zip"
JENKINS_HOME="/home/christoph/test/jenkins"
JENKINS_DOWNLOAD_LINK="https://updates.jenkins-ci.org/download/war/2.26/jenkins.war"
GROOVY_PATH="./../groovy"
JENKINS_BASEURL="http://localhost:8080/jenkins"
JENKINS_SCRIPTPATH="scriptText"
JENKINS_SSH_PORT="4711" # required for scriptler

./prepare.sh $TOMCAT_HOME $TOMCAT_DOWNLOAD_LINK $JENKINS_HOME $JENKINS_DOWNLOAD_LINK

restartJenkins(){

    printf "\n\n"

    printf "restarting jenkins\n"
    printf "##################\n"
    $TOMCAT_HOME/bin/shutdown.sh
    sleep 2
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
}

# function to install plugins
jenkinsPlugins(){

    printf "\n\n"

    printf "plugin installation\n"
    printf "###################\n"
    RESULT=$(curl -s -o /dev/null -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/plugins/jenkins-install-plugins.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            printf "... plugins installations successful.\n"
        else
            printf "... plugins installations NOT succesfull.\n"
            exit 1
    fi;

    restartJenkins

    printf "\n\n"

    printf "plugins installation summary\n"
    printf "############################\n"
    RESULT=$(curl -s -o /tmp/jenkins-initializer.plugins.installation.summary -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/plugins/jenkins-show-plugins.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            cat /tmp/jenkins-initializer.plugins.installation.summary
        else
            printf "... plugins installations NOT succesfull.\n"
            exit 1
    fi;
}

# function to install tools like maven, jdk, ...
jenkinsTools(){

    printf "\n\n"

    printf "jdk installation\n"
    printf "################\n"
    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.jdk -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-jdk.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            printf "... jdk installations successful.\n"
        else
            printf "... jdk installations NOT succesfull.\n"
            exit 1
    fi;

    printf "\n\n"

    printf "maven installation\n"
    printf "##################\n"
    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.maven -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-maven.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            printf "... maven installations successful.\n"
        else
            printf "... maven installations NOT succesfull.\n"
            exit 1
    fi;

    printf "\n\n"

    printf "ant installation\n"
    printf "################\n"
    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.ant -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-ant.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            printf "... ant installations successful.\n"
        else
            printf "... ant installations NOT succesfull.\n"
    fi;

    printf "\n\n"

    printf "gradle installation\n"
    printf "###################\n"
    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.gradle  -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-gradle.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            printf "... gradle installations successful.\n"
        else
            printf "... gradle installations NOT succesfull.\n"
            exit 1
    fi;

    printf "\n\n"

    printf "tools installation summary\n"
    printf "##########################\n"
    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.summary -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-show-tools.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            cat /tmp/jenkins-initializer.tools.installation.summary
            printf "\n"
        else
            printf "... tools installations NOT succesfull.\n"
            exit 1
    fi;
}

# to be documented
#
#jenkinsCredentials(){
#    printf "\n\n>>> setting credentials\n"
#    curl --data-urlencode "script=$(<./tools.jenkins-install-credentials.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
#}


#jenkinsScriptler(){
#    printf "\n\n>>> install scriptler\n"
#    # TODO: add static sshd  setting
#    # TODO: add user with public key in jenkins
#    # workaround to satisfy jenkins' key algorithm requirements: https://www.drupal.org/node/2552319#comment-10228045
#    export GIT_SSH_COMMAND='ssh -o KexAlgorithms=+diffie-hellman-group1-sha1'
#   git clone ssh://${JENKINS_USERNAME}@localhost:${JENKINS_SSH_PORT}/scriptler.git /tmp/scriptler
#    cp ./scriptler/*.groovy /tmp/scriptler/
#    cd /tmp/scriptler && git add * && git commit -m "jenkins setup" && git push origin master
#    rm -rf /tmp/scriptler
#}


jenkinsPlugins
jenkinsTools
#jenkinsCredentials
#jenkinsScriptler
