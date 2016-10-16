package tools

import hudson.model.JDK
import hudson.tools.InstallSourceProperty
import hudson.tools.ToolInstallation
import hudson.tools.ZipExtractionInstaller

def toolName = 'jdk'
def versionsAndUrls = [
        '6u45_custom': 'http://myrepo/jdk-6u45_custom',
        '7u80_custom': 'http://myrepo/jdk-7u80_custom',
        '8u45_custom': 'http://myrepo/jdk-8u45_custom'
]
def toolsToInstall = []

// as we use customized jdk packages, we cannot rely on hudson.tools.JDKInstaller class because they are not located at Oracle
versionsAndUrls.each { version, url ->
    def installer = new ZipExtractionInstaller(
            "${toolName}-${version}",
            "${url}",
            null
    )

    toolsToInstall << new JDK(version, null, [new InstallSourceProperty([installer])])
}

def jdkDescriptor = new JDK.DescriptorImpl()
jdkDescriptor.setInstallations(*toolsToInstall)

