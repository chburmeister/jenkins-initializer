package credentials

// https://support.cloudbees.com/hc/en-us/articles/217708168-create-credentials-from-groovy
import com.cloudbees.plugins.credentials.impl.*;
import com.cloudbees.plugins.credentials.*;
import com.cloudbees.plugins.credentials.domains.*;

class User{
    String credentialId
    String description
    String privateKeyfilePath
    String password

    public User(String credentialId, String description, String privateKeyfilePath, String password){
        this.credentialId = credentialId
        this.description = description
        this.privateKeyfilePath = privateKeyfilePath
        this.password = password
    }
}

User user1 = new User('1122334455', 'user1 credentials', '/tmp/data/keys/user1.pub', 'user1pass')
User user2 = new User('6677889900', 'user2 credentials', '/tmp/data/keys/user2.pub', 'user2pass')

Credentials credentials1 = new CertificateCredentialsImpl(
        CredentialsScope.GLOBAL,
        user1.credentialId,
        user1.description,
        user1.password,
        new CertificateCredentialsImpl.FileOnMasterKeyStoreSource(user1.privateKeyfilePath)
)

Credentials credentials2 = new CertificateCredentialsImpl(
        CredentialsScope.GLOBAL,
        user2.credentialId,
        user2.description,
        user2.password,
        new CertificateCredentialsImpl.FileOnMasterKeyStoreSource(user2.privateKeyfilePath)
)

SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), credentials1)
SystemCredentialsProvider.getInstance().getStore().addCredentials(Domain.global(), credentials2)
