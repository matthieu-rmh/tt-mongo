# Use the official MongoDB image
FROM mongo:latest

# Install wget to download initialization scripts
RUN apt-get update && apt-get install -y wget && rm -rf /var/lib/apt/lists/*

# Copy the database dump into the container
COPY ./db_dump /db_dump

# Download initialization scripts
RUN wget https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh -O /usr/local/bin/wait-for-it.sh \
    && chmod +x /usr/local/bin/wait-for-it.sh

# Copy our custom initialization script
COPY init-mongo.sh /docker-entrypoint-initdb.d/

# Make sure the script is executable
RUN chmod +x /docker-entrypoint-initdb.d/init-mongo.sh

# Expose the MongoDB port
EXPOSE 27017

# Set environment variables
ENV MONGO_INITDB_ROOT_USERNAME=ttuser
ENV MONGO_INITDB_ROOT_PASSWORD=thrifttrackrpword

# Use the modified entrypoint script
CMD ["mongod", "--auth"]