#!/bin/bash

LOG_FILE="/var/log/devopsfetch.log"

# Function Definitions

function list_ports {
  echo "Active Ports and Services:"
  sudo netstat -tuln | awk 'NR>2 {print $1, $4}' | column -t
}

function port_details {
  local port=$1
  echo "Details for port $port:"
  sudo lsof -i :$port
}

function list_docker {
  echo "Docker Images and Containers:"
  docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}"
}

function container_details {
  local container=$1
  echo "Details for container $container:"
  docker inspect $container
}

function list_nginx {
  echo "Nginx Domains and Ports:"
  sudo nginx -T 2>/dev/null | grep -E "server_name|listen" | awk '{print $2}' | paste - - | column -t
}

function domain_details {
  local domain=$1
  echo "Details for domain $domain:"
  sudo nginx -T 2>/dev/null | awk -v domain=$domain '/server_name/ {if ($2 == domain) {found=1}} found && /}/ {print; found=0} found'
}

function list_users {
  echo "Users and Last Login Times:"
  lastlog | column -t
}

function user_details {
  local user=$1
  echo "Details for user $user:"
  last $user
}

function activities_in_time_range {
  local time_range=$1
  echo "Activities in the last $time_range:"
  sudo journalctl --since "$time_range ago" | tail -n 100
}

# Command Handling

if [[ $1 == "-p" ]]; then
  if [[ -z $2 ]]; then
    list_ports
  else
    port_details $2
  fi
elif [[ $1 == "-d" ]]; then
  if [[ -z $2 ]]; then
    list_docker
  else
    container_details $2
  fi
elif [[ $1 == "-n" ]]; then
  if [[ -z $2 ]]; then
    list_nginx
  else
    domain_details $2
  fi
elif [[ $1 == "-u" ]]; then
  if [[ -z $2 ]]; then
    list_users
  else
    user_details $2
  fi
elif [[ $1 == "-t" ]]; then
  activities_in_time_range $2
else
  echo "Usage: $0 {-p|--port [port]} {-d|--docker [container]} {-n|--nginx [domain]} {-u|--users [username]} {-t|--time [time_range]}"
fi

# Continuous Monitoring Mode
while true; do
  echo "----- $(date) -----" >> $LOG_FILE
  list_ports >> $LOG_FILE
  list_docker >> $LOG_FILE
  list_nginx >> $LOG_FILE
  list_users >> $LOG_FILE
  sleep 3600  # Run every hour
done
