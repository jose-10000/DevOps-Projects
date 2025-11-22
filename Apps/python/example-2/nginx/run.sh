#!/bin/bash

# Simple script to build and run the nginx test container with SSL

echo "🐳 Building nginx SSL test container..."
docker build -t nginx-ssl-test .

if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "🚀 Starting container on ports 8080 (HTTP->HTTPS redirect) and 8443 (HTTPS)..."
    
    # Stop and remove existing container if running
    docker stop nginx-ssl-test-container 2>/dev/null || true
    docker rm nginx-ssl-test-container 2>/dev/null || true
    
    # Run the container
    docker run -d \
        --name nginx-ssl-test-container \
        -p 8080:80 \
        -p 8443:443 \
        nginx-ssl-test
    
    if [ $? -eq 0 ]; then
        echo "✅ Container started successfully!"
        echo "🌐 HTTP (redirects to HTTPS): http://localhost:8080"
        echo "🔒 HTTPS: https://localhost:8443"
        echo "🏥 Health check: https://localhost:8443/health"
        echo ""
        echo "⚠️  Note: Self-signed certificate will show security warning in browser"
        echo "   You can safely proceed or accept the certificate for testing"
        echo ""
        echo "To stop the container: docker stop nginx-ssl-test-container"
        echo "To view logs: docker logs nginx-ssl-test-container"
        echo "To enter container: docker exec -it nginx-ssl-test-container sh"
    else
        echo "❌ Failed to start container"
        exit 1
    fi
else
    echo "❌ Build failed"
    exit 1
fi
