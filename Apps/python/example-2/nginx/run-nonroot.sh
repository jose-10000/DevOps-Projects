#!/bin/bash

# Simple script to build and run the nginx test container with SSL (non-root version)

echo "🐳 Building nginx SSL test container (non-root)..."
docker build -f Dockerfile.nonroot -t nginx-ssl-nonroot-test .

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "🚀 Starting non-root container on ports 9080 (HTTP->HTTPS redirect) and 9443 (HTTPS)..."
    
    # Stop and remove existing container if running
    docker stop nginx-ssl-nonroot-container 2>/dev/null || true
    docker rm nginx-ssl-nonroot-container 2>/dev/null || true
    
    # Run the container (map different host ports to avoid conflicts)
    docker run -d \
        --name nginx-ssl-nonroot-container \
        -p 8080:8080 \
        -p 8443:8443 \
        nginx-ssl-nonroot-test
    
    if [ $? -eq 0 ]; then
        echo "✅ Container started successfully!"
        echo "🌐 HTTP (redirects to HTTPS): http://localhost:8080"
        echo "🔒 HTTPS: https://localhost:8443"
        echo "🏥 Health check: https://localhost:8443/health"
        echo ""
        echo "🔐 Security Features:"
        echo "   - Running as non-root user (nginxuser:1001)"
        echo "   - Using standard internal ports (80/443) mapped to host ports (8080/8443)"
        echo "   - All files owned by nginxuser"
        echo ""
        echo "⚠️  Note: Self-signed certificate will show security warning in browser"
        echo "   You can safely proceed or accept the certificate for testing"
        echo ""
        echo "To stop the container: docker stop nginx-ssl-nonroot-container"
        echo "To view logs: docker logs nginx-ssl-nonroot-container"
        echo "To enter container: docker exec -it nginx-ssl-nonroot-container sh"
        echo "To check running user: docker exec nginx-ssl-nonroot-container whoami"
    else
        echo "❌ Failed to start container"
        exit 1
    fi
else
    echo "❌ Build failed"
    exit 1
fi
