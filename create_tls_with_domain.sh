#!/bin/bash

# Check if the user provided both a folder name and a domain name
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <output-folder-name> <domain-name>"
  exit 1
fi

# Set the folder and domain name from the arguments
TLS_NAME=$1
DOMAIN_NAME=$2

# Create a folder with the specified name
mkdir -p "${TLS_NAME}"

# Generate the private key (without passphrase for simplicity)
openssl genpkey -algorithm RSA -out "${TLS_NAME}/${TLS_NAME}.key"

# Generate the Certificate Signing Request (CSR) with the domain name
openssl req -new -key "${TLS_NAME}/${TLS_NAME}.key" -out "${TLS_NAME}/${TLS_NAME}.csr" \
  -subj "/CN=${DOMAIN_NAME}"

# Generate the self-signed certificate (valid for 365 days)
openssl x509 -req -days 365 -in "${TLS_NAME}/${TLS_NAME}.csr" -signkey "${TLS_NAME}/${TLS_NAME}.key" -out "${TLS_NAME}/${TLS_NAME}.crt"

# Combine the key and certificate into a .pem file (optional)
cat "${TLS_NAME}/${TLS_NAME}.key" "${TLS_NAME}/${TLS_NAME}.crt" > "${TLS_NAME}/${TLS_NAME}.pem"

echo "TLS Key, CSR, Certificate, and PEM file created for the domain ${DOMAIN_NAME} and stored in the folder: ${TLS_NAME}"
