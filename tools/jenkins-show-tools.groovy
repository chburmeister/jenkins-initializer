package tools

import hudson.tasks.Maven;
import hudson.tasks.Ant;
import hudson.plugins.gradle.GradleInstallation
import hudson.model.JDK;
import jenkins.model.Jenkins;

def mavens 		= Jenkins.instance.getDescriptorByType(Maven.DescriptorImpl.class).getInstallations();
def ants 		= Jenkins.instance.getDescriptorByType(Ant.DescriptorImpl.class).getInstallations();
def gradles 	= Jenkins.instance.getDescriptorByType(GradleInstallation.DescriptorImpl.class).getInstallations();
def jdks 		= Jenkins.instance.getDescriptorByType(JDK.DescriptorImpl.class).getInstallations();

println "Maven installations: ${mavens}"
println "Ant installations: ${ants}"
println "Gradle installations: ${gradles}"
println "JDK installations: ${jdks}"
