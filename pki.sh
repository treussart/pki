#!/usr/bin/env bash
# ./pki.sh ca
# ./pki.sh cert mail|web
# /etc/ssl/certs/
# /etc/ssl/private/
name="Example"
tld=".com"
sld="example"
dest_cert=""
dest_key=""
days="3652"
TYPE=""
CN_CA="$name"" Authority"
CN_CERT=""
CN_CERT_SERVER="$name"" Server"
CN_CERT_EMAIL="$name"" Email"
EXTENSIONS=""
EXTENSIONS_SERVER="server.extensions.ini"
EXTENSIONS_MAIL="mail.extensions.ini"


generate_ca() {
    if [ -f "$dest_key""$sld""$tld"-ca.key ]; then
        echo 'CA already created, override CA ? y/N'
        read response
        if [[ "$response" == 'N' ]] || [ -z "$response" ]; then
            exit 0
        fi
    fi
    # clean
    rm "$dest_key"*.csr
    # Generate ca
    openssl req -x509 -newkey rsa:4096 -keyout "$dest_key""$sld""$tld"-ca.key -out "$dest_cert""$sld""$tld"-ca.pem -days "$days" -subj '/CN='"$CN_CA" -sha256
    # Show the ca
    openssl x509 -text -noout -in "$dest_cert""$sld""$tld"-ca.pem
}

generate_csr(){
    if [ ! -f "$dest_key""$TYPE"."$sld""$tld".csr ]; then
        # Generate a csr
        openssl req -new -keyout "$dest_key""$sld""$tld"-"$TYPE".key -nodes -out "$dest_key""$TYPE"."$sld""$tld".csr -sha256 -subj '/CN='"$CN_CERT"
        # Show the csr
        openssl req -in "$dest_key""$TYPE"."$sld""$tld".csr -noout -text
    fi
}

create_cert(){
    # Create a certificate for a domain
    openssl x509 -req -in "$dest_key""$TYPE"."$sld""$tld".csr -CA "$dest_cert""$sld""$tld"-ca.pem -CAkey "$dest_key""$sld""$tld"-ca.key -CAcreateserial -days "$days" -sha256 -extfile "$EXTENSIONS" -out "$dest_cert""$TYPE"."$sld""$tld".pem
    # Show the certificate
    openssl x509 -text -noout -in "$dest_cert""$TYPE"."$sld""$tld".pem
}

bundle() {
    # Add ca to the certificate for a domain
    cat "$dest_cert""$TYPE"."$sld""$tld".pem "$dest_cert""$sld""$tld"-ca.pem > "$dest_cert""$TYPE"."$sld""$tld"-bundle.pem
    cat "$dest_key""$sld""$tld"-"$TYPE".key "$dest_cert""$TYPE"."$sld""$tld".pem > "$dest_key""$TYPE"."$sld""$tld"-key.pem
    cat "$dest_key""$sld""$tld"-"$TYPE".key "$dest_cert""$TYPE"."$sld""$tld"-ca.pem > "$dest_key""$TYPE"."$sld""$tld"-cakey.pem
}

verify(){
    openssl verify -CAfile "$dest_cert""$sld""$tld"-ca.pem "$dest_cert""$TYPE"."$sld""$tld".pem
}

if [ -z $1 ]; then
    echo 'Bad argument'
    exit 1
else
    if [ "$1" == 'ca' ]; then
        generate_ca
    elif [ "$1" == 'cert' ]; then
        if [ ! -z $2 ]; then
            if [[ "$2" == 'server' ]]; then
                CN_CERT="$CN_CERT_SERVER"
                EXTENSIONS="$EXTENSIONS_SERVER"
                TYPE="$2"
            elif [[ "$2" == 'mail' ]]; then
                CN_CERT="$CN_CERT_EMAIL"
                EXTENSIONS="$EXTENSIONS_MAIL"
                TYPE="$2"
            else
                echo 'Bad argument'
                exit 1
            fi
        fi
        generate_csr
        create_cert
        verify
        bundle
    fi
    exit 0
fi

