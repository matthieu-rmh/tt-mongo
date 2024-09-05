#!/bin/bash
set -e

# Wait for MongoDB to start
/usr/local/bin/wait-for-it.sh localhost:27017 -t 30

# Restore the database dump
mongorestore --host localhost --port 27017 -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin /db_dump

# Create admin user
mongosh --host localhost -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" --authenticationDatabase admin <<EOF
use admin
db.createUser({
  user: "ttuser",
  pwd: "thrifttrackrpword",
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" },
    { role: "dbAdminAnyDatabase", db: "admin" },
    { role: "userAdminAnyDatabase", db: "thrift-trackr" },
    { role: "readWriteAnyDatabase", db: "thrift-trackr" },
    { role: "dbAdminAnyDatabase", db: "thrift-trackr" }
  ]
})
EOF

echo "MongoDB initialized."