package plugins

def pluginsBaseUrl = 'http://updates.jenkins-ci.org/download/plugins'
def jenkinsPluginDir = "${System.getenv('JENKINS_HOME')}/plugins"

def plugins = [
        'gradle':"${pluginsBaseUrl}/gradle/1.25/gradle.hpi",
        'ant':"${pluginsBaseUrl}/ant/1.4/ant.hpi",
        'structs':"${pluginsBaseUrl}/structs/1.3/structs.hpi", // dependency of ant
        'git':"${pluginsBaseUrl}/git/3.0.0/git.hpi",
        'mailer':"${pluginsBaseUrl}/mailer/1.17/mailer.hpi", // dependency of git
        'ssh-credentials':"${pluginsBaseUrl}/ssh-credentials/1.12/ssh-credentials.hpi", // dependency of git
        'git-client':"${pluginsBaseUrl}/git-client/2.0.0/git-client.hpi", // dependency of git
        'matrix-project':"${pluginsBaseUrl}/matrix-project/1.7.1/matrix-project.hpi", // dependency of git
        'promoted-builds':"${pluginsBaseUrl}/promoted-builds/2.27/promoted-builds.hpi", // dependency of git
        'parametrized-trigger':"${pluginsBaseUrl}/parameterized-trigger/2.4/parameterized-trigger.hpi", // dependency of git
        'tocen-macro':"${pluginsBaseUrl}/token-macro/1.11/token-macro.hpi", // dependency of git
        'credentials':"${pluginsBaseUrl}/credentials/2.1.4/credentials.hpi", // dependency of git
        'workflow-scm-step':"${pluginsBaseUrl}/workflow-scm-step/1.14.2/workflow-scm-step.hpi", // dependency of git
        'scm-api':"${pluginsBaseUrl}/scm-api/1.2/scm-api.hpi", // dependency of git
        'display-url-api':"${pluginsBaseUrl}/display-url-api/0.2/display-url-api.hpi", // dependency of mailer
        'junit':"${pluginsBaseUrl}/junit/1.3/junit.hpi", // dependency of display-url-api
        'script-security':"${pluginsBaseUrl}/script-security/1.13/script-security.hpi",
        'rebuild':"${pluginsBaseUrl}/rebuild/1.22/rebuild.hpi"

]

plugins.each{ plugin, url ->
    def ext = url[-3..-1] // workaround to get the extension
    def targetFile = new File("${jenkinsPluginDir}/${plugin}.${ext}")
    def file = targetFile.newOutputStream()
    file << new URL("${url}").openStream()
    file.close()
    println "Successfully loaded ${targetFile}"
}
