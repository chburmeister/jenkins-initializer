package tools

import jenkins.model.Jenkins
import hudson.tasks.Ant.AntInstallation
import hudson.tasks.Ant.AntInstaller
import hudson.tools.InstallSourceProperty

def toolName = 'apache-ant'
def versions = ['1.7.4', '1.8.2', '1.9.7']
def toolsToInstall = []

versions.each { version ->
    def installation = new AntInstallation(
            "${toolName}-${version}",
            "",
            [new InstallSourceProperty([new AntInstaller(version)])])

    toolsToInstall << installation
}

def plugin = Jenkins.instance.getExtensionList(hudson.tasks.Ant.DescriptorImpl.class)[0]
plugin.setInstallations(*toolsToInstall)
