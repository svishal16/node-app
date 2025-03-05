#!/bin/bash

# Export the certificate to a .cer file
keytool -exportcert -keystore $KEYSTORE_DIR/$KEYSTORE -alias $CERT_ALIAS -file "${PKCS_KEYSTORE_DIR}/${CERT_ALIAS}.cer" -storepass $STOREPASS

# Export the private key from the keystore to a PKCS#12 (.p12) file
keytool -importkeystore -srckeystore $KEYSTORE_DIR/$KEYSTORE -srcstorepass $STOREPASS -destkeystore $PKCS_KEYSTORE_DIR/$PKCS_KEYSTORE -deststoretype PKCS12 -srcalias $CERT_ALIAS -destkeypass $STOREPASS
