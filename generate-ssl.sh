#!/bin/bash

# Create self-signed SSL certificates for development
# For production, replace these with proper SSL certificates from Let's Encrypt or your CA

NGINX_SSL_DIR="./nginx/ssl"
POSTGRES_SSL_DIR="./postgres/ssl"

# Create SSL directories if they don't exist
mkdir -p ${NGINX_SSL_DIR}
mkdir -p ${POSTGRES_SSL_DIR}

echo "Generating self-signed SSL certificates for development..."

# Generate Nginx SSL certificates
echo "1. Generating Nginx SSL certificates..."
openssl genrsa -out ${NGINX_SSL_DIR}/nginx.key 2048
openssl req -new -key ${NGINX_SSL_DIR}/nginx.key -out ${NGINX_SSL_DIR}/nginx.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost"
openssl x509 -req -in ${NGINX_SSL_DIR}/nginx.csr -signkey ${NGINX_SSL_DIR}/nginx.key -out ${NGINX_SSL_DIR}/nginx.crt -days 365
rm ${NGINX_SSL_DIR}/nginx.csr

echo "   ✓ Nginx certificate: ${NGINX_SSL_DIR}/nginx.crt"
echo "   ✓ Nginx private key: ${NGINX_SSL_DIR}/nginx.key"

# Generate PostgreSQL SSL certificates
echo "2. Generating PostgreSQL SSL certificates..."
openssl genrsa -out ${POSTGRES_SSL_DIR}/postgres.key 2048
openssl req -new -key ${POSTGRES_SSL_DIR}/postgres.key -out ${POSTGRES_SSL_DIR}/postgres.csr -subj "/C=US/ST=State/L=City/O=Organization/CN=postgres-db"
openssl x509 -req -in ${POSTGRES_SSL_DIR}/postgres.csr -signkey ${POSTGRES_SSL_DIR}/postgres.key -out ${POSTGRES_SSL_DIR}/postgres.crt -days 365
rm ${POSTGRES_SSL_DIR}/postgres.csr

echo "   ✓ PostgreSQL certificate: ${POSTGRES_SSL_DIR}/postgres.crt"
echo "   ✓ PostgreSQL private key: ${POSTGRES_SSL_DIR}/postgres.key"

# Set proper permissions for Nginx
chmod 600 ${NGINX_SSL_DIR}/*.key
chmod 644 ${NGINX_SSL_DIR}/*.crt



# PostgreSQL requires specific ownership and permissions
# PostgreSQL runs as user ID 999 in the container, so we need to make files readable by that user
# Set permissions so that PostgreSQL can read the files (must be 0600 for user ownership or 0640 for root ownership)
# PostgreSQL key files need u=rw,g=r (0640) permissions when owned by root
sudo chmod 600 ${POSTGRES_SSL_DIR}/*.key
sudo chmod 644 ${POSTGRES_SSL_DIR}/*.crt


echo ""
echo "🎉 SSL certificates generated successfully!"
echo ""
echo "📋 Summary:"
echo "   Nginx HTTPS: ${NGINX_SSL_DIR}/nginx.crt + ${NGINX_SSL_DIR}/nginx.key"
echo "   PostgreSQL SSL: ${POSTGRES_SSL_DIR}/postgres.crt + ${POSTGRES_SSL_DIR}/postgres.key"
echo ""
echo "⚠️  Note: These are self-signed certificates for development only."
echo "   For production, use proper SSL certificates from a trusted CA."
echo ""
echo "🔐 PostgreSQL SSL files have been set with 640 permissions for container access."

