#!/bin/bash

# Install necessary dependencies
apt-get update
apt-get install -y docker.io nginx

# Copy devopsfetch script to /usr/local/bin
cp devopsfetch.sh /usr/local/bin/devopsfetch
chmod +x /usr/local/bin/devopsfetch

# Create systemd service file
cat <<EOF >/etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOpsFetch Monitoring Service

[Service]
ExecStart=/usr/local/bin/devopsfetch -p
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
systemctl daemon-reload
systemctl enable devopsfetch.service
systemctl start devopsfetch.service

echo "DevOpsFetch installed and service started."
