# stage5 task

# DevOpsFetch

## Overview
DevOpsFetch is a tool designed to collect and display system information, including active ports, user logins, Nginx configurations, Docker images, and container statuses. It also includes a systemd service for continuous monitoring and logging.

## Installation

### Dependencies
- Docker
- Nginx

### Steps
1. Download and run the installation script:
   ```bash
   wget <installation_script_url> -O install_devopsfetch.sh
   chmod +x install_devopsfetch.sh
   sudo ./install_devopsfetch.sh
