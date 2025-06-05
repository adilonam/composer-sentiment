#!/bin/bash

# Create self-signed SSL certificates for development
# For production, replace these with proper SSL certificates from Let's Encrypt or your CA

KEYCLOAK_SSL_DIR="./keycloak/ssl"
POSTGRES_SSL_DIR="./postgres/ssl"

# Create SSL directories if they don't exist
mkdir -p ${KEYCLOAK_SSL_DIR}
mkdir -p ${POSTGRES_SSL_DIR}

echo "Generating self-signed SSL certificates for development..."

# Generate Keycloak SSL certificates
echo "1. Generating Keycloak SSL certificates..."
openssl genrsa -out ${KEYCLOAK_SSL_DIR}/keycloak.key 2048
openssl req -new -key ${KEYCLOAK_SSL_DIR}/keycloak.key -out ${KEYCLOAK_SSL_DIR}/keycloak.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
openssl x509 -req -in ${KEYCLOAK_SSL_DIR}/keycloak.csr -signkey ${KEYCLOAK_SSL_DIR}/keycloak.key -out ${KEYCLOAK_SSL_DIR}/keycloak.crt -days 365
rm ${KEYCLOAK_SSL_DIR}/keycloak.csr
echo "   ✓ Keycloak certificate: ${KEYCLOAK_SSL_DIR}/keycloak.crt"
echo "   ✓ Keycloak private key: ${KEYCLOAK_SSL_DIR}/keycloak.key"

# Generate PostgreSQL SSL certificates
echo "2. Generating PostgreSQL SSL certificates..."
openssl genrsa -out ${POSTGRES_SSL_DIR}/postgres.key 2048
openssl req -new -key ${POSTGRES_SSL_DIR}/postgres.key -out ${POSTGRES_SSL_DIR}/postgres.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=postgres-db"
openssl x509 -req -in ${POSTGRES_SSL_DIR}/postgres.csr -signkey ${POSTGRES_SSL_DIR}/postgres.key -out ${POSTGRES_SSL_DIR}/postgres.crt -days 365
rm ${POSTGRES_SSL_DIR}/postgres.csr

echo "   ✓ PostgreSQL certificate: ${POSTGRES_SSL_DIR}/postgres.crt"
echo "   ✓ PostgreSQL private key: ${POSTGRES_SSL_DIR}/postgres.key"

# Set proper permissions for Keycloak
chmod 600 ${KEYCLOAK_SSL_DIR}/*.key
chmod 644 ${KEYCLOAK_SSL_DIR}/*.crt

# PostgreSQL requires specific ownership and permissions
# PostgreSQL runs as user ID 999 in the container, so we need to make files readable by that user
# Set permissions so that PostgreSQL can read the files (must be 0600 for user ownership or 0640 for root ownership)
# PostgreSQL key files need u=rw,g=r (0640) permissions when owned by root
sudo chown 0:70 ${POSTGRES_SSL_DIR}/*.key ${POSTGRES_SSL_DIR}/*.crt
sudo chmod 640 ${POSTGRES_SSL_DIR}/*.key
sudo chmod 644 ${POSTGRES_SSL_DIR}/*.crt

echo ""
echo "🎉 SSL certificates generated successfully!"
echo ""
echo "📋 Summary:"
echo "   Keycloak HTTPS: ${KEYCLOAK_SSL_DIR}/keycloak.crt + ${KEYCLOAK_SSL_DIR}/keycloak.key"
echo "   PostgreSQL SSL: ${POSTGRES_SSL_DIR}/postgres.crt + ${POSTGRES_SSL_DIR}/postgres.key"
echo ""
echo "⚠️  Note: These are self-signed certificates for development only."
echo "   For production, use proper SSL certificates from a trusted CA."
echo ""
echo "🔐 PostgreSQL SSL files have been set with 640 permissions for container access."
echo ""
echo "🚀 To access Keycloak:"
echo "   HTTP:  http://localhost:8080"
echo "   HTTPS: https://localhost:8443"
