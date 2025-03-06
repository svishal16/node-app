#!/bin/bash

mkdir -p ./certs/p12_cert
mkdir -p ./certs/pem_cert

# # Export the certificate to a .cer file
# keytool -exportcert -keystore $KEYSTORE_DIR/$KEYSTORE -alias $CERT_ALIAS -file "${PKCS_KEYSTORE_DIR}/${CERT_ALIAS}.cer" -storepass $STOREPASS

# # Export the private key from the keystore to a PKCS#12 (.p12) file
# keytool -importkeystore -srckeystore $KEYSTORE_DIR/$KEYSTORE -srcstorepass $STOREPASS -destkeystore $PKCS_KEYSTORE_DIR/$PKCS_KEYSTORE -deststoretype PKCS12 -srcalias $CERT_ALIAS -destkeypass $STOREPASS -deststorepass $STOREPASS

# # Convert the .p12 file to PEM format (certificate and private key)
# export P12_PASSWORD="admin123"
# openssl pkcs12 -in $PKCS_KEYSTORE_DIR/$PKCS_KEYSTORE -out $PEM_KEYSTORE_DIR/$PEM_KEYSTORE -clcerts -nokeys -passin env:P12_PASSWORD


keytool -exportcert -keystore $KEYSTORE_DIR/$KEYSTORE -alias $CERT_ALIAS -file "${PKCS_KEYSTORE_DIR}/${CERT_ALIAS}.cer" -storepass $STOREPASS

openssl x509 -inform der -in "${PKCS_KEYSTORE_DIR}/${CERT_ALIAS}.cer" -out "${PEM_KEYSTORE_DIR}/${CERT_ALIAS}.pem"



keytool -importkeystore -srckeystore $KEYSTORE_DIR/$KEYSTORE -srcstoretype PKCS12 -alias $CERT_ALIAS -destkeystore $PKCS_KEYSTORE_DIR/$PKCS_KEYSTORE -deststoretype PKCS12 -srcstorepass $STOREPASS -deststorepass $STOREPASS

openssl pkcs12 -in $PKCS_KEYSTORE_DIR/$PKCS_KEYSTORE -nocerts -out $PEM_KEYSTORE_DIR/$PEM_KEYSTORE