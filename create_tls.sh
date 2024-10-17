#!/bin/bash

# Check if the user provided a file name
if [ -z "$1" ]; then
  echo "Usage: $0 <output-folder-name>"
  exit 1
fi

# Set the folder name from the first argument
TLS_NAME=$1

# Create a folder with the specified name
mkdir -p "${TLS_NAME}"

# Generate the private key (without passphrase for simplicity)
openssl genpkey -algorithm RSA -out "${TLS_NAME}/${TLS_NAME}.key"

# Generate the Certificate Signing Request (CSR)
openssl req -new -key "${TLS_NAME}/${TLS_NAME}.key" -out "${TLS_NAME}/${TLS_NAME}.csr"

# Generate the self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 -in "${TLS_NAME}/${TLS_NAME}.csr" -signkey "${TLS_NAME}/${TLS_NAME}.key" -out "${TLS_NAME}/${TLS_NAME}.crt"

# Combine the key and certificate into a .pem file (optional)
cat "${TLS_NAME}/${TLS_NAME}.key" "${TLS_NAME}/${TLS_NAME}.crt" > "${TLS_NAME}/${TLS_NAME}.pem"

echo "TLS Key, CSR, Certificate, and PEM file created and stored in the folder: ${TLS_NAME}"
