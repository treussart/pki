# pki
Easily create certificate X509 for Web and Email

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
# Create Certificate for Web servers (Apache, Nginx ...)
./pki.sh cert web
# Create Certificate for Email servers (Postfix, Dovecot ...)
./pki.sh cert mail
```

## Configure your services
### Apache
```
SSLProtocol +TLSv1.2
SSLCipherSuite ECDH:!DH:!RSA:!RSAPSK:!DHEPSK:!ECDHEPSK:!PSK
SSLCertificateFile /etc/ssl/certs/web.example.com-bundle.pem
SSLCertificateKeyFile /etc/ssl/private/example.com-web.key
```
### Postfix
```
smtpd_tls_cert_file=/etc/ssl/certs/mail.example.com.pem
smtpd_tls_key_file=/etc/ssl/private/example.com-mail.key
smtpd_tls_CAfile = /etc/ssl/certs/example.com-ca.pem
smtpd_tls_mandatory_ciphers = high
smtpd_tls_mandatory_exclude_ciphers = LOW, 3DES, MD5, EXP, CBC, PSK, SRP, DSS, RC4, aNULL, eNULL
```
### Dovecot
```
ssl = required
ssl_cert = </etc/ssl/certs/mail.example.com-bundle.pem
ssl_key = </etc/ssl/private/example.com-mail.key
ssl_protocols = TLSv1.2
ssl_cipher_list = ECDH:!DH:!RSA:!RSAPSK:!DHEPSK:!ECDHEPSK:!PSKALL:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!CBC:!PSK:!SRP:!DSS:!RC4
```
### MongoDB
cat /etc/ssl/private/example.com-web.key /etc/ssl/certs/web.example.com.pem > /etc/ssl/private/mongodb.example.com.pem
```
  ssl:
    mode: requireSSL
    PEMKeyFile: /etc/ssl/private/mongodb.example.com.pem
    allowConnectionsWithoutCertificates: true
    disabledProtocols: TLS1_0,TLS1_1
```
