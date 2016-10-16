#!/bin/bash

# precondition: jenkins 2.19 setup with default plugin and admin user on localhost 8080

JENKINS_BASEURL=http://localhost:8080
JENKINS_USERNAME=admin
JENKINS_APITOKEN=XXX

JENKINS_CRUMBPATH=crumbIssuer/api/xml
JENKINS_SCRIPTPATH=scriptText
JENKINS_RESTARTPATH=restart

JENKINS_SSH_PORT=4711

init(){
    printf "\n\n>>> getting the crumb\n"
    CRUMB=$(curl --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} ${JENKINS_BASEURL}/${JENKINS_CRUMBPATH}?xpath=concat\(//crumbRequestField,%22:%22,//crumb\))
}

jenkinsCredentials(){
    printf "\n\n>>> setting credentials\n"
    curl --verbose --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./tools.jenkins-install-credentials.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
}

jenkinsTools(){
    printf "\n\n>>> install tools\n"
    curl --verbose --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./tools.jenkins-install-jdk.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
    curl --verbose --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./tools.jenkins-install-maven.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
    curl --verbose --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./tools.jenkins-install-gradle.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
    curl --verbose --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./tools.jenkins-install-jdk.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}
}

jenkinsPlugins(){
    printf "\n\n>>> install plugins\n"
    curl --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} --data-urlencode "script=$(<./plugins.jenkins-install-plugins.groovy)" ${JENKINS_BASEURL}/${JENKINS_SCRIPTPATH}

    printf "\n\n>>> restarting jenkins\n"
    curl -X POST --header "$CRUMB" --user ${JENKINS_USERNAME}:${JENKINS_APITOKEN} ${JENKINS_BASEURL}/${JENKINS_RESTARTPATH}
    sleep 30 # wait for jenkins reboot --> TODO: this must be improved here. checking a status page?
}

jenkinsScriptler(){
    printf "\n\n>>> install scriptler\n"
    # TODO: add static sshd  setting
    # TODO: add user with public key in jenkins
    # workaround to satisfy jenkins' key algorithm requirements: https://www.drupal.org/node/2552319#comment-10228045
    export GIT_SSH_COMMAND='ssh -o KexAlgorithms=+diffie-hellman-group1-sha1'
    git clone ssh://${JENKINS_USERNAME}@localhost:${JENKINS_SSH_PORT}/scriptler.git /tmp/scriptler
    cp ./scriptler/*.groovy /tmp/scriptler/
    cd /tmp/scriptler && git add * && git commit -m "jenkins setup" && git push origin master
    rm -rf /tmp/scriptler
}


# main section
init
jenkinsCredentials
jenkinsPlugins
jenkinsScriptler
jenkinsTools
