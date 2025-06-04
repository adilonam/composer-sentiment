#!/bin/bash

# Create self-signed SSL certificates for development
# For production, replace these with proper SSL certificates from Let's Encrypt or your CA

SSL_DIR="./nginx/ssl"

echo "Generating self-signed SSL certificates for development..."

# Generate private key
openssl genrsa -out ${SSL_DIR}/key.pem 2048

# Generate certificate signing request
openssl req -new -key ${SSL_DIR}/key.pem -out ${SSL_DIR}/cert.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"

# Generate self-signed certificate
openssl x509 -req -in ${SSL_DIR}/cert.csr -signkey ${SSL_DIR}/key.pem -out ${SSL_DIR}/cert.pem -days 365

# Remove CSR file
rm ${SSL_DIR}/cert.csr

echo "SSL certificates generated successfully!"
echo "Certificate: ${SSL_DIR}/cert.pem"
echo "Private Key: ${SSL_DIR}/key.pem"
echo ""
echo "Note: These are self-signed certificates for development only."
echo "For production, use proper SSL certificates from a trusted CA."
