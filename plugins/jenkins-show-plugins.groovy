package plugins

import jenkins.model.Jenkins

def plugins = Jenkins.instance.getPluginManager().getPlugins()

plugins.each { plugin ->
    println "${plugin.getShortName()} - ${plugin.getVersion()}"
}
