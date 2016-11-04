package security

import jenkins.model.*
import hudson.security.*
import groovy.json.*

/**
 * This script has one security assumption: It relies on a file called ldap-settings.json in the /tmp directory.
 * It could be created there manually or by encrypted puppet/chef/ansible mechanism. The idea behind is to not send those information
 * via http to the jenkins instance.
 *
 * {
 *       "ldap": {
 *               "server": "",
 *               "rootDn": "",
 *               "userSearchBase": "",
 *               "userSearch": "",
 *               "groupSearchBase": "",
 *               "managerDN": "",
 *               "managerPassword": "",
 *               "inhibitInferRootDN": ""
 *       }
 * }
 *
 */

File ldapSettingsFile = new File ('/tmp/ldap-settings.json')

if (!ldapSettingsFile.exists()){
    throw new Exception('/tmp/ldap-settings.json could not be found')
}

def jsonSlurper = new JsonSlurper()
def json = jsonSlurper.parse(ldapSettingsFile)

String ldapServer=json.ldap.server
String ldapRootDN=json.ldap.rootDn
String ldapUserSearchBase=json.ldap.userSearchBase
String ldapUserSearch=json.ldap.userSearch
String ldapGroupSearchBase=json.ldap.groupSearchBase
String ldapManagerDN=json.ldap.managerDN
String ldapManagerPassword=json.ldap.managerPassword
boolean ldapInhibitInferRootDN=json.ldap.inhibitInferRootDN.toBoolean()

def instance = Jenkins.getInstance()
def ldapRealm = new LDAPSecurityRealm(ldapServer, ldapRootDN, ldapUserSearchBase, ldapUserSearch, ldapGroupSearchBase, ldapManagerDN, ldapManagerPassword, ldapInhibitInferRootDN)
instance.setSecurityRealm(ldapRealm)
instance.setAuthorizationStrategy(new FullControlOnceLoggedInAuthorizationStrategy())
instance.save()