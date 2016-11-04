package plugins

def pluginsBaseUrl = 'http://updates.jenkins-ci.org/download/plugins'
def jenkinsPluginDir = "${System.getenv('JENKINS_HOME')}/plugins"


def plugins = [
        "ant":"${pluginsBaseUrl}/ant/1.4/ant.hpi",
        "bouncycastle-api":"${pluginsBaseUrl}/bouncycastle-api/2.16.0/bouncycastle-api.hpi",
        "branch-api":"${pluginsBaseUrl}/branch-api/1.11/branch-api.hpi",
        "build-timeout":"${pluginsBaseUrl}/build-timeout/1.17.1/build-timeout.hpi",
        "credentials-binding":"${pluginsBaseUrl}/credentials-binding/1.9/credentials-binding.hpi",
        "credentials":"${pluginsBaseUrl}/credentials/2.1.8/credentials.hpi",
        "display-url-api":"${pluginsBaseUrl}/display-url-api/0.5/display-url-api.hpi",
        "durable-task":"${pluginsBaseUrl}/durable-task/1.12/durable-task.hpi",
        "email-ext":"${pluginsBaseUrl}/email-ext/2.52/email-ext.hpi",
        "external-monitor-job":"${pluginsBaseUrl}/external-monitor-job/1.6/external-monitor-job.hpi",
        "cloudbees-folder":"${pluginsBaseUrl}/cloudbees-folder/5.13/cloudbees-folder.hpi",
        "git-client":"${pluginsBaseUrl}/git-client/2.0.0/git-client.hpi",
        "git":"${pluginsBaseUrl}/git/3.0.0/git.hpi",
        "git-server":"${pluginsBaseUrl}/git-server/1.7/git-server.hpi",
        "github-api":"${pluginsBaseUrl}/github-api/1.79/github-api.hpi",
        "github-branch-source":"${pluginsBaseUrl}/github-branch-source/1.10/github-branch-source.hpi",
        "github-organization-folder":"${pluginsBaseUrl}/github-organization-folder/1.5/github-organization-folder.hpi",
        "github":"${pluginsBaseUrl}/github/1.22.3/github.hpi",
        "gradle":"${pluginsBaseUrl}/gradle/1.25/gradle.hpi",
        "ace-editor":"${pluginsBaseUrl}/ace-editor/1.1/ace-editor.hpi",
        "handlebars":"${pluginsBaseUrl}/handlebars/1.1.1/handlebars.hpi",
        "jquery-detached":"${pluginsBaseUrl}/jquery-detached/1.2.1/jquery-detached.hpi",
        "momentjs":"${pluginsBaseUrl}/momentjs/1.1.1/momentjs.hpi",
        "junit":"${pluginsBaseUrl}/junit/1.19/junit.hpi",
        "ldap":"${pluginsBaseUrl}/ldap/1.13/ldap.hpi",
        "mailer":"${pluginsBaseUrl}/mailer/1.18/mailer.hpi",
        "mapdb-api":"${pluginsBaseUrl}/mapdb-api/1.0.9.0/mapdb-api.hpi",
        "matrix-auth":"${pluginsBaseUrl}/matrix-auth/1.4/matrix-auth.hpi",
        "matrix-project":"${pluginsBaseUrl}/matrix-project/1.7.1/matrix-project.hpi",
        "antisamy-markup-formatter":"${pluginsBaseUrl}/antisamy-markup-formatter/1.5/antisamy-markup-formatter.hpi",
        "pam-auth":"${pluginsBaseUrl}/pam-auth/1.3/pam-auth.hpi",
        "workflow-aggregator":"${pluginsBaseUrl}/workflow-aggregator/2.4/workflow-aggregator.hpi",
        "pipeline-graph-analysis":"${pluginsBaseUrl}/pipeline-graph-analysis/1.2/pipeline-graph-analysis.hpi",
        "workflow-api":"${pluginsBaseUrl}/workflow-api/2.5/workflow-api.hpi",
        "workflow-basic-steps":"${pluginsBaseUrl}/workflow-basic-steps/2.3/workflow-basic-steps.hpi",
        "pipeline-build-step":"${pluginsBaseUrl}/pipeline-build-step/2.3/pipeline-build-step.hpi",
        "workflow-cps":"${pluginsBaseUrl}/workflow-cps/2.22/workflow-cps.hpi",
        "pipeline-input-step":"${pluginsBaseUrl}/pipeline-input-step/2.3/pipeline-input-step.hpi",
        "workflow-job":"${pluginsBaseUrl}/workflow-job/2.8/workflow-job.hpi",
        "pipeline-milestone-step":"${pluginsBaseUrl}/pipeline-milestone-step/1.1/pipeline-milestone-step.hpi",
        "workflow-multibranch":"${pluginsBaseUrl}/workflow-multibranch/2.9/workflow-multibranch.hpi",
        "workflow-durable-task-step":"${pluginsBaseUrl}/workflow-durable-task-step/2.5/workflow-durable-task-step.hpi",
        "pipeline-stage-view":"${pluginsBaseUrl}/pipeline-stage-view/2.1/pipeline-stage-view.hpi",
        "workflow-scm-step":"${pluginsBaseUrl}/workflow-scm-step/2.2/workflow-scm-step.hpi",
        "workflow-cps-global-lib":"${pluginsBaseUrl}/workflow-cps-global-lib/2.4/workflow-cps-global-lib.hpi",
        "pipeline-stage-step":"${pluginsBaseUrl}/pipeline-stage-step/2.2/pipeline-stage-step.hpi",
        "pipeline-stage-view":"${pluginsBaseUrl}/pipeline-stage-view/2.1/pipeline-stage-view.hpi",
        "workflow-step-api":"${pluginsBaseUrl}/workflow-step-api/2.5/workflow-step-api.hpi",
        "workflow-support":"${pluginsBaseUrl}/workflow-support/2.10/workflow-support.hpi",
        "plain-credentials":"${pluginsBaseUrl}/plain-credentials/1.3/plain-credentials.hpi",
        "resource-disposer":"${pluginsBaseUrl}/resource-disposer/0.3/resource-disposer.hpi",
        "scm-api":"${pluginsBaseUrl}/scm-api/1.3/scm-api.hpi",
        "script-security":"${pluginsBaseUrl}/script-security/1.24/script-security.hpi",
        "ssh-credentials":"${pluginsBaseUrl}/ssh-credentials/1.12/ssh-credentials.hpi",
        "ssh-slaves":"${pluginsBaseUrl}/ssh-slaves/1.11/ssh-slaves.hpi",
        "structs":"${pluginsBaseUrl}/structs/1.5/structs.hpi",
        "subversion":"${pluginsBaseUrl}/subversion/2.7.1/subversion.hpi",
        "timestamper":"${pluginsBaseUrl}/timestamper/1.8.7/timestamper.hpi",
        "token-macro":"${pluginsBaseUrl}/token-macro/2.0/token-macro.hpi",
        "windows-slaves":"${pluginsBaseUrl}/windows-slaves/1.2/windows-slaves.hpi",
        "ws-cleanup":"${pluginsBaseUrl}/ws-cleanup/0.32/ws-cleanup.hpi",
        "icon-shim":"${pluginsBaseUrl}/icon-shim/2.0.3/icon-shim.hpi",
        "pipeline-rest-api":"${pluginsBaseUrl}/pipeline-rest-api/2.1/pipeline-rest-api.hpi",
        "scriptler":"${pluginsBaseUrl}/scriptler/2.9/scriptler.hpi"
]


plugins.each{ plugin, url ->
    def ext = url[-3..-1] // workaround to get the extension
    def targetFile = new File("${jenkinsPluginDir}/${plugin}.${ext}")
    def file = targetFile.newOutputStream()
    file << new URL("${url}").openStream()
    file.close()
    println "Successfully loaded ${targetFile}"
}
