package tools

import jenkins.model.Jenkins
import hudson.tools.InstallSourceProperty
import hudson.plugins.gradle.GradleInstallation
import hudson.plugins.gradle.GradleInstaller

def toolName = 'gradle'
def versions = ['2.1', '2.13', '3.1']
def toolsToInstall = []

versions.each { version ->
    def installation = new GradleInstallation(
            "${toolName}-${version}",
            "",
            [new InstallSourceProperty([new GradleInstaller(version)])])

    toolsToInstall << installation
}

def plugin = Jenkins.instance.getExtensionList(hudson.plugins.gradle.GradleInstallation.DescriptorImpl)[0]
plugin.setInstallations(*toolsToInstall)
