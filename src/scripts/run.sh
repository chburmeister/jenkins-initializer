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

source ./settings.conf
source ./../../lib/log4bash.v1.0/log4bash.sh

init(){

    log4bash 1 'initialization'

    rm -rf $TOMCAT_HOME
    mkdir -p $TOMCAT_HOME
    rm -rf $JENKINS_HOME
    mkdir -p $JENKINS_HOME
    mkdir -p $JENKINS_JOBS_DIR

    log4bash 1 'killing all running catalina processes'
    for PID in $(ps -ef | grep catalina | grep -v grep | awk '{print $2}')
    do
        log4bash 1 "killing process ${PID}"
        kill -9 $PID;
    done
}

installTomcat(){

    log4bash 1 'installing tomcat'

    wget --quiet --output-document $TOMCAT_HOME/tomcat.zip $TOMCAT_DOWNLOAD_LINK
    unzip -qq $TOMCAT_HOME/tomcat.zip -d $TOMCAT_HOME
    cp -r $TOMCAT_HOME/apache-tomcat*/* $TOMCAT_HOME/
    rm -rf $TOMCAT_HOME/apache-tomcat*
    rm -f $TOMCAT_HOME/tomcat.zip
    chmod +x $TOMCAT_HOME/bin/*
}

installJenkins(){

    log4bash 1 'installing jenkins'

    wget --quiet --output-document $TOMCAT_HOME/webapps/jenkins.war $JENKINS_DOWNLOAD_LINK

    echo "export JAVA_OPTS=\"-Djenkins.install.runSetupWizard=false\"" > $TOMCAT_HOME/bin/setenv.sh
    echo "export JENKINS_HOME=\"${JENKINS_HOME}\"" >> $TOMCAT_HOME/bin/setenv.sh
    # linking the jobs dir. this makes it quite easy to separate between cattle- and pet-parts of jenkins
    rm -rf $JENKINS_HOME/jobs
    ln -s $JENKINS_JOBS_DIR $JENKINS_HOME/jobs

    restartJenkins
}

restartJenkins(){

    log4bash 1 'restarting jenkins'

    $TOMCAT_HOME/bin/shutdown.sh > /dev/null 2>&1
    sleep 2
    $TOMCAT_HOME/bin/startup.sh > /dev/null 2>&1

    JENKINS_READY="false"
    while [ $JENKINS_READY = "false" ]
    do
        log4bash 1 'checking, if Jenkins is already available'
        wget --server-response -q -o /tmp/jenkins.ready.check http://localhost:8080/jenkins/cli
        sleep 2
        WGET_RESULT_CODE=$(cat /tmp/jenkins.ready.check | awk '/HTTP/{ print $2 }')

        if [[ $WGET_RESULT_CODE =~ "200" ]] # if jenkins is up & running it will return "302 200"
        then
            JENKINS_READY="true"
            log4bash 1 'jenkins is up and running'
        fi
    done
}

jenkinsPlugins(){

    log4bash 1 'starting plugin installation'

    RESULT=$(curl -s -o /dev/null -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/plugins/jenkins-install-plugins.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'plugin installations succesful'
        else
            log4bash 3 'plugin installations NOT succesful'
            exit 1
    fi;

    restartJenkins

    log4bash 1 'plugin installation summary'
    log4bash 1 '---------------------------'
    RESULT=$(curl -s -o /tmp/jenkins-initializer.plugins.installation.summary -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/plugins/jenkins-show-plugins.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            cat /tmp/jenkins-initializer.plugins.installation.summary
        else
            log4bash 3 'plugin installation NOT succesful.'
            exit 1
    fi;
}

jenkinsTools(){

    log4bash 1 'starting jdk installation'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.jdk -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-jdk.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'jdk installation succesful.'
        else
            log4bash 3 'jdk installation NOT succesful.'
            exit 1
    fi;


    log4bash 1 'starting maven installation'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.maven -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-maven.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'maven installation succesful.'
        else
            log4bash 3 'maven installation NOT succesful.'
            exit 1
    fi;

    log4bash 1 'starting ant installation'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.ant -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-ant.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'ant installation succesful.'
        else
            log4bash 3 'ant installation NOT succesful.'
            exit 1
    fi;

    log4bash 1 'starting gradle installation'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.gradle  -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-install-gradle.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'gradle installations succesful.'
        else
            log4bash 3 'gradle installations NOT succesful.'
            exit 1
    fi;

    log4bash 1 'tool installation summary'
    log4bash 1 '-------------------------'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.tools.installation.summary -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/tools/jenkins-show-tools.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            cat /tmp/jenkins-initializer.tools.installation.summary
        else
            log4bash 3 'tool installation NOT succesful.'
            exit 1
    fi;
}


jenkinsCredentials(){

    log4bash 1 'starting credential installation'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.credentials.installation  -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/credentials/jenkins-install-credentials.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'credential installations succesful.'
        else
            log4bash 3 'credential installation NOT succesful.'
            exit 1
    fi;

    log4bash 1 'credential installation summary'
    log4bash 1 '-------------------------------'

    RESULT=$(curl -s -o /tmp/jenkins-initializer.credentials.installation.summary -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/credentials/jenkins-show-credentials.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            cat /tmp/jenkins-initializer.credentials.installation.summary
        else
            log4bash 3 'credential installation NOT succesful.'
            exit 1
    fi;
}


jenkinsScriptler(){

    log4bash 1 'starting scriptler installation'

    # get the sshd port
    curl -L -v -D /tmp/jenkins-initializer.scriptler.sshdport http://localhost:8080/jenkins > /dev/null 2>&1
    SSHD_ENDPOINT=$(cat /tmp/jenkins-initializer.scriptler.sshdport | grep X-SSH-Endpoint)
    SSHD_PORT=$(echo $SSHD_ENDPOINT | cut -d \: -f 3 | tr -d '\r')
    log4bash 1 "found ssh port: ${SSHD_PORT}"

    log4bash 1 "clone the scriptler repo"
    mkdir /tmp/jenkins-initializer
    # in case you work with authentication: git clone ssh://${JENKINS_USERNAME}@localhost:${JENKINS_SSH_PORT}/scriptler.git /tmp/scriptler
    GIT_SSH_COMMAND='ssh -o StrictHostKeyChecking=no' git clone ssh://localhost:${SSHD_PORT}/scriptler.git /tmp/jenkins-initializer/scriptler
    cp ${GROOVY_PATH}/scriptler/repo/*.groovy /tmp/jenkins-initializer/scriptler/

    log4bash 1 "push the scriptlers to the repo"
    cd /tmp/jenkins-initializer/scriptler && git add . && git commit -m "jenkins-initializer" && git push origin master

    rm -rf /tmp/jenkins-initializer/scriptler

    log4bash 1 'scriptler installation succesful'
}


# let this be the last call!
jenkinsInstallSecurity(){

    # if your are in ldaps environment, make sure that your jre has the ldap certificat imported
    # https://issues.jenkins-ci.org/browse/JENKINS-3810

    log4bash 1 'starting security installation'

    RESULT=$(curl -s -o /dev/null -w "%{http_code}" -l --data-urlencode "script=$(<${GROOVY_PATH}/security/jenkins-install-security.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH})
    if [ 200 -eq $RESULT ];
        then
            log4bash 1 'security installations succesful'
        else
            log4bash 3 'security installations NOT succesful'
            exit 1
    fi;
}

#init
#installTomcat
#installJenkins
#jenkinsPlugins
#jenkinsTools
#jenkinsCredentials
#jenkinsScriptler
jenkinsInstallSecurity
