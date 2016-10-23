package tools

import jenkins.model.Jenkins
import hudson.tasks.Maven.MavenInstallation
import hudson.tasks.Maven.MavenInstaller
import hudson.tools.InstallSourceProperty

def toolName = 'apache-maven'
def versions = ['2.2.1', '3.0.4', '3.3.9']
def toolsToInstall = []

versions.each { version ->
    def installation = new MavenInstallation(
            "${toolName}-${version}",
            "",
            [new InstallSourceProperty([new MavenInstaller(version)])])

    toolsToInstall << installation
}

def plugin = Jenkins.instance.getExtensionList(hudson.tasks.Maven.DescriptorImpl.class)[0]
plugin.setInstallations(*toolsToInstall)
