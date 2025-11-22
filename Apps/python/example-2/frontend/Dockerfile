# Dockerfile for frontend
FROM nginx:alpine

# Install certbot and security tools
RUN apk add --no-cache certbot certbot-nginx openssl curl

# Create directories for SSL certificates and ensure nginx user owns them
RUN mkdir -p /etc/nginx/ssl /var/www/certbot /var/cache/nginx /var/log/nginx && \
    chown -R nginx:nginx /etc/nginx/ssl /var/www/certbot /var/cache/nginx /var/log/nginx /etc/nginx/conf.d

# Generate self-signed SSL certificate as fallback
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/CN=localhost" && \
    chown nginx:nginx /etc/nginx/ssl/*

# Copy static files
COPY --chown=nginx:nginx . /usr/share/nginx/html

# Copy nginx configuration
COPY --chown=nginx:nginx nginx.conf /etc/nginx/nginx.conf

# Copy certbot script
COPY --chown=nginx:nginx init-ssl.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init-ssl.sh

# Switch to non-root user (nginx user exists in alpine image)
USER nginx

# Expose ports
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start script
CMD ["/usr/local/bin/init-ssl.sh"]
