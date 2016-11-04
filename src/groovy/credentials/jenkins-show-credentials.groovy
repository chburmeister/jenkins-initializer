package credentials

import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

def credsWithCertificates = CredentialsProvider.lookupCredentials(
        CertificateCredentialsImpl.class,
        Jenkins.instance,
        null,
        null
);

for (c in credsWithCertificates) {
    println('      ' + c.id + ": " + c.description)
}