# Custom MongoDB Dockerfile with initialization
FROM mongo:7.0

# Copy initialization scripts
COPY database/init-mongo.js /docker-entrypoint-initdb.d/

# Set environment variables
ENV MONGO_INITDB_ROOT_USERNAME=admin
ENV MONGO_INITDB_ROOT_PASSWORD=password123
ENV MONGO_INITDB_DATABASE=cloudpipeline

# Expose MongoDB port
EXPOSE 27017

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD echo 'db.runCommand("ping").ok' | mongosh localhost:27017/test --quiet