#!/bin/bash

# Install dependencies
sudo apt-get update
sudo apt-get install -y net-tools docker.io nginx

# Create systemd service for devopsfetch
cat <<EOF | sudo tee /etc/systemd/system/devopsfetch.service
[Unit]
Description=Devopsfetch Service

[Service]
ExecStart=/usr/local/bin/devopsfetch.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable the service
sudo systemctl daemon-reload
sudo systemctl enable devopsfetch.service
sudo systemctl start devopsfetch.service

# Setup log rotation
cat <<EOF | sudo tee /etc/logrotate.d/devopsfetch
/var/log/devopsfetch.log {
  daily
  rotate 7
  compress
  missingok
  notifempty
}
EOF

echo "Installation completed. Devopsfetch service is now running."
