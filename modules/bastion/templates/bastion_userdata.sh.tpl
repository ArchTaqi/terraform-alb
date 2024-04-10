#!/bin/bash
# variables for the database
DB_HOST={{DB_HOST}}
DB_NAME={{DB_NAME}}
DB_ADMIN_USER={{DB_ADMIN_USER}}
DB_ADMIN_PASSWORD="{{DB_ADMIN_PASSWORD}}"

# an array of users and their passwords
USERS=({{USERS}})
DB_PASSWORDS=({{DB_PASSWORDS}})
SERVER_PASSWORDS=({{SERVER_PASSWORDS}})

len=${#USERS[@]}

for ((i=0; i<$len; i++)); do
    NEW_USER="${USERS[i]}"
    DB_USER="${USERS[i]}"
    DB_PASSWORD="${DB_PASSWORDS[i]}"
    DB_GROUP="${DB_USER}_group"
    SERVER_PASSWORD="${SERVER_PASSWORDS[i]}"

    # Add a new user with restricted shell
    sudo adduser --gecos "" --disabled-password $NEW_USER
    chpasswd <<<"$NEW_USER:$SERVER_PASSWORD"
    sudo usermod -s /bin/false $NEW_USER

    # Configure SSH access (optional)
    echo "Match User $NEW_USER" | sudo tee -a /etc/ssh/sshd_config
    echo "AllowTcpForwarding yes" | sudo tee -a /etc/ssh/sshd_config
    echo "PasswordAuthentication yes" | sudo tee -a /etc/ssh/sshd_config
    echo "PermitRootLogin no" | sudo tee -a /etc/ssh/sshd_config
    echo "X11Forwarding no" | sudo tee -a /etc/ssh/sshd_config
    echo "AllowAgentForwarding no" | sudo tee -a /etc/ssh/sshd_config
    echo "AllowTcpForwarding yes" | sudo tee -a /etc/ssh/sshd_config
    echo "ForceCommand /bin/false" | sudo tee -a /etc/ssh/sshd_config

    # Reload SSH service
    sudo systemctl reload sshd

    # Connect to RDS and grant database access
    echo "Creating PostgreSQL user and granting access for $DB_USER..."
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "CREATE ROLE $DB_GROUP;"
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "GRANT USAGE ON SCHEMA public TO $DB_GROUP;"
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "GRANT SELECT ON users, companies TO $DB_GROUP;"
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "GRANT $DB_GROUP TO $DB_USER;"
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "GRANT CONNECT ON DATABASE $DB_NAME TO $DB_USER;"
    PGPASSWORD=$DB_ADMIN_PASSWORD psql -h $DB_HOST -U $DB_ADMIN_USER -d $DB_NAME -c "ALTER USER $DB_USER SET search_path TO public;"
    echo "PostgreSQL user $DB_USER created and granted access to the database."

    # Provide instructions to the user
    echo "User $NEW_USER created with restricted shell and added to their dedicated group."
    echo "You can connect to the RDS database using:"
    echo "psql -h $DB_HOST -U $DB_USER -d $DB_NAME"
done