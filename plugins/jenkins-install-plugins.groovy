package plugins

import jenkins.model.Jenkins

def pluginsBaseUrl = 'http://updates.jenkins-ci.org/download/plugins'
def jenkinsPluginDir = "${System.getenv('JENKINS_HOME')}/plugins"
http://updates.jenkins-ci.org/download/plugins/

def plugins = [
        'artifactory':"${pluginsBaseUrl}/artifactory/2.3.0/artifactory.hpi",
        'chucknorris':"${pluginsBaseUrl}/chucknorris/1.0/chucknorris.hpi"
]

plugins.each{ plugin, url ->
    def ext = url[-3..-1] // workaround to get the extension
    def targetFile = new File("${jenkinsPluginDir}/${plugin}.${ext}")
    def file = targetFile.newOutputStream()
    file << new URL("${url}").openStream()
    file.close()
    println "Successfully loaded ${targetFile}"
}

println 'restarting for plugin deployment'
Jenkins.instance.restart()
