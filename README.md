# pki
Easily create certificate X509 for Web and Email

## Requirements
  * OpenSSL
  * Bash

## Usage
```
# Create Certificate Authority
./pki.sh ca
# Create Certificate for Web servers (Apache, Nginx ...)
./pki.sh cert web
# Create Certificate for Email servers (Postfix, Dovecot ...)
./pki.sh cert mail
```
