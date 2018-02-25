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
