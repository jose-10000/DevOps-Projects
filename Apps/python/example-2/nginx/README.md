# Nginx SSL Test Container

A simple nginx Docker container with SSL/HTTPS for testing nginx configuration files with SSL redirection.

## Structure

```text
nginx/
├── Dockerfile          # Main Docker configuration with SSL
├── config/
│   └── default.conf    # Custom nginx server configuration with SSL
├── html/
│   └── index.html      # Test webpage
├── run.sh              # Build and run script
└── README.md           # This file
```

## Features

- ✅ SSL/HTTPS enabled with self-signed certificate (for testing)
- ✅ HTTP to HTTPS redirect (port 80 → 443)
- ✅ Custom nginx configuration loaded from `config/default.conf`
- ✅ Modern SSL security configuration (TLS 1.2/1.3)
- ✅ Security headers (HSTS, CSP, etc.)
- ✅ Simple test webpage with SSL styling
- ✅ Health check endpoint at `/health`
- ✅ Gzip compression enabled
- ✅ Docker health checks configured

## Quick Start

### Option 1: Use the provided script (recommended)

```bash
./run.sh
```

### Option 2: Manual build and run

```bash
# Build the image
docker build -t nginx-ssl-test .

# Run the container (both HTTP and HTTPS ports)
docker run -d --name nginx-ssl-test-container -p 8080:80 -p 8443:443 nginx-ssl-test
```

## Access

- **HTTP (redirects to HTTPS)**: <http://localhost:8080>
- **HTTPS**: <https://localhost:8443>
- **Health check**: <https://localhost:8443/health>

⚠️ **Note**: Since this uses a self-signed certificate, your browser will show a security warning. This is expected for testing. You can safely proceed or accept the certificate.

## SSL Configuration

The container automatically generates a self-signed certificate with:
- **Algorithm**: RSA 2048-bit
- **Validity**: 365 days
- **Subject**: CN=localhost
- **Protocols**: TLS 1.2 and TLS 1.3
- **Cipher Suites**: Modern, secure ciphers only

## Management Commands

```bash
# View logs
docker logs nginx-ssl-test-container

# Enter container shell
docker exec -it nginx-ssl-test-container sh

# Stop container
docker stop nginx-ssl-test-container

# Remove container
docker rm nginx-ssl-test-container

# Remove image
docker rmi nginx-ssl-test
```

## Configuration Testing

1. Modify `config/default.conf` with your nginx SSL settings
2. Update `html/index.html` if needed
3. Rebuild and test: `./run.sh`

## Health Check

The container includes a health check that:

- Runs every 30 seconds
- Checks the `/health` endpoint via HTTPS
- Has a 3-second timeout
- Allows 3 retries before marking as unhealthy

## Security Features

The configuration includes comprehensive security:

- **HSTS**: `Strict-Transport-Security` with preload
- **Content Security**: `X-Content-Type-Options: nosniff`
- **Frame Protection**: `X-Frame-Options: SAMEORIGIN`
- **XSS Protection**: `X-XSS-Protection: 1; mode=block`
- **Referrer Policy**: `strict-origin-when-cross-origin`
- **Permissions Policy**: Restricted geolocation, microphone, camera

## Performance

- Gzip compression enabled for text files
- SSL session caching configured
- Modern cipher suites for optimal performance
- Optimized for testing and development use

## Production Notes

For production use:
1. Replace self-signed certificates with valid SSL certificates
2. Update the certificate paths in `default.conf`
3. Consider using Let's Encrypt or proper CA-signed certificates
4. Review and adjust SSL security headers as needed
