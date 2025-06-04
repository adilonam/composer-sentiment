# Composer Sentiment

## Docker Compose Setup

This repository contains a Docker Compose configuration with the following services:

- **PostgreSQL**: Database for Keycloak
- **Keycloak**: Identity and Access Management
- **Nginx**: Reverse proxy with HTTPS support

## Quick Start

1. **Generate SSL certificates** (for development):
   ```bash
   ./generate-ssl.sh
   ```

2. **Start the services**:
   ```bash
   docker-compose up -d
   ```

3. **Access Keycloak**:
   - HTTPS: https://localhost (redirects from HTTP)
   - Admin Console: https://localhost/admin
   - Admin credentials: `admin` / `admin`

## Service Details

### PostgreSQL
- **Image**: postgres:15
- **Database**: keycloak
- **User**: keycloak
- **Password**: keycloak_password
- **Port**: 5432 (internal)

### Keycloak
- **Image**: quay.io/keycloak/keycloak:23.0
- **Admin User**: admin
- **Admin Password**: admin
- **Port**: 8080 (internal)

### Nginx
- **Image**: nginx:alpine
- **HTTP Port**: 80 (redirects to HTTPS)
- **HTTPS Port**: 443
- **SSL Certificates**: `nginx/ssl/`

## Configuration

### Environment Variables

You can customize the following environment variables in `docker-compose.yml`:

- `POSTGRES_PASSWORD`: PostgreSQL password
- `KEYCLOAK_ADMIN_PASSWORD`: Keycloak admin password
- `KC_HOSTNAME`: Keycloak hostname (default: localhost)

### SSL Certificates

For development, use the provided script to generate self-signed certificates:
```bash
./generate-ssl.sh
```

For production, replace the certificates in `nginx/ssl/` with proper certificates from a trusted CA or Let's Encrypt.

### Nginx Configuration

The Nginx configuration includes:
- HTTP to HTTPS redirect
- SSL optimization
- Security headers
- Proxy configuration for Keycloak
- WebSocket support for Keycloak Admin Console

## Production Considerations

1. **Change default passwords** in `docker-compose.yml`
2. **Use proper SSL certificates** instead of self-signed ones
3. **Update hostname** configuration for your domain
4. **Configure backup** for PostgreSQL data
5. **Review security settings** and firewall rules

## Troubleshooting

### Check service logs:
```bash
docker-compose logs keycloak
docker-compose logs postgres
docker-compose logs nginx
```

### Restart services:
```bash
docker-compose restart
```

### Reset everything:
```bash
docker-compose down -v
docker-compose up -d
```
