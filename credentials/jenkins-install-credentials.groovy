package credentials

// https://support.cloudbees.com/hc/en-us/articles/217708168-create-credentials-from-groovy

import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;


Credentials c = (Credentials) new UsernamePasswordCredentialsImpl(CredentialsScope.GLOBAL,java.util.UUID.randomUUID().toString(), "description", "user", "password")
def restult = SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), c)

println restult

