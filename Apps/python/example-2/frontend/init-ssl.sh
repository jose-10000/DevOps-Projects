#!/bin/sh

# SSL Certificate Initialization Script
# This script handles SSL certificate detection and nginx configuration

DOMAIN=${DOMAIN:-localhost}

echo "Initializing SSL for domain: $DOMAIN"

# Function to check if Let's Encrypt certificates exist and are valid
check_letsencrypt_certs() {
    local cert_path="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
    local key_path="/etc/letsencrypt/live/$DOMAIN/privkey.pem"

    if [ -f "$cert_path" ] && [ -f "$key_path" ]; then
        # Check if certificate is not expired (with 30 days buffer)
        if openssl x509 -checkend 2592000 -noout -in "$cert_path" 2>/dev/null; then
            echo "Valid Let's Encrypt certificates found for $DOMAIN"
            return 0
        else
            echo "Let's Encrypt certificates found but expired or expiring soon"
            return 1
        fi
    else
        echo "No Let's Encrypt certificates found for $DOMAIN"
        return 1
    fi
}

# Start nginx with initial configuration
echo "Starting nginx..."
nginx -c /etc/nginx/nginx.conf

# Wait for nginx to start
sleep 2

# Check certificate status and reload if needed
if check_letsencrypt_certs; then
    echo "Using Let's Encrypt certificates"
    # Force reload nginx to use Let's Encrypt certs
    nginx -s reload
else
    echo "Using self-signed certificates as fallback"
    echo ""
    echo "To obtain Let's Encrypt certificates:"
    echo "1. Ensure your domain $DOMAIN points to this server"
    echo "2. Make sure ports 80 and 443 are accessible from the internet"
    echo "3. Run: docker exec -it nginx_frontend certbot --nginx -d $DOMAIN"
    echo "4. Or use: ./ssl-helper.sh get-cert $DOMAIN your-email@example.com"
fi

# Keep the container running by tailing logs
echo "Nginx started. Tailing logs..."
tail -f /var/log/nginx/access.log /var/log/nginx/error.log

echo "SSL initialization complete. Container ready."

# Keep container running
wait