# pki
Easily create certificate X509 for server and email encryption

KISSS Principle : Keep it simple, stupid and Secure

## Requirements
  * OpenSSL
  * Bash

## Configuration
Edit pki.sh
```
name="Example"
tld=".com"
sld="example"
dest_cert=""
dest_key=""
days="3652"
```
Edit *.extensions.ini
```
[ my_subject_alt_names ]
DNS.1 = www.example.com
...
```

## Usage
```
# Create Certificate Authority
./pki.sh ca
# Create Certificate for servers (Apache, Nginx, Postfix, Dovecot ...)
./pki.sh cert server
# Create Certificate for Encrypt emails
./pki.sh cert mail
```

## Configure your services
### Apache
```
SSLProtocol +TLSv1.2
SSLCipherSuite ECDH:!DH:!RSA:!RSAPSK:!DHEPSK:!ECDHEPSK:!PSK
SSLCertificateFile /etc/ssl/certs/server.example.com-bundle.pem
SSLCertificateKeyFile /etc/ssl/private/example.com-server.key
```
### Postfix
```
smtpd_tls_cert_file=/etc/ssl/certs/server.example.com.pem
smtpd_tls_key_file=/etc/ssl/private/example.com-server.key
smtpd_tls_CAfile = /etc/ssl/certs/example.com-ca.pem
smtpd_tls_mandatory_ciphers = high
smtpd_tls_mandatory_exclude_ciphers = LOW, 3DES, MD5, EXP, CBC, PSK, SRP, DSS, RC4, aNULL, eNULL
```
### Dovecot
```
ssl = required
ssl_cert = </etc/ssl/certs/server.example.com-bundle.pem
ssl_key = </etc/ssl/private/example.com-server.key
ssl_protocols = TLSv1.2
ssl_cipher_list = ECDH:!DH:!RSA:!RSAPSK:!DHEPSK:!ECDHEPSK:!PSKALL:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!CBC:!PSK:!SRP:!DSS:!RC4
```
### MongoDB
```
  ssl:
    mode: requireSSL
    PEMKeyFile: /etc/ssl/private/server.example.com-key.pem
    CAFile: /etc/ssl/certs/example.com-ca.pem
    allowConnectionsWithoutCertificates: true
    disabledProtocols: TLS1_0,TLS1_1
```
## Email encryption
Preferably use OpenGPG but otherwise:
```
Encrypt :
openssl smime -encrypt  -in file.txt -out file.txt.enc -outform PEM mail.example.com.pem
Decrypt :
openssl smime -decrypt  -in file.txt.enc -out file.txt -inform PEM -inkey example.com-mail.key

```
