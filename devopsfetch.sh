#!/bin/bash

# Help function
function display_help() {
    echo "Usage: $0 [option] [argument]"
    echo
    echo "Options:"
    echo "  -p, --port [port_number]    Display active ports and services or details for a specific port."
    echo "  -d, --docker [container_name]    List Docker images and containers or details for a specific container."
    echo "  -n, --nginx [domain]    Display Nginx domains and ports or details for a specific domain."
    echo "  -u, --users [username]    List users and their last login times or details for a specific user."
    echo "  -t, --time [time_range]    Display activities within a specified time range."
    echo "  -h, --help    Display this help message."
    echo
}

# Display active ports and services
function display_ports() {
    if [ -z "$1" ]; then
        ss -tuln | awk 'NR>1 {print $1, $4}' | column -t
    else
        ss -tuln | grep ":$1 "
    fi
}

# List Docker images and containers
function display_docker() {
    if [ -z "$1" ]; then
        docker ps -a --format "table {{.Names}}\t{{.Image}}\t{{.Status}}" && docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}"
    else
        docker inspect $1
    fi
}

# Display Nginx domains and ports
function display_nginx() {
    if [ -z "$1" ]; then
        grep -E 'server_name|listen' /etc/nginx/sites-available/* | sed 'N;s/\n/ /' | awk '{print $1, $2, $3}' | column -t
    else
        grep -A 10 "server_name $1" /etc/nginx/sites-available/*
    fi
}

# List users and their last login times
function display_users() {
    if [ -z "$1" ]; then
        lastlog | awk '{print $1, $3, $4, $5, $6, $7, $8}' | column -t
    else
        lastlog -u $1
    fi
}

# Display activities within a specified time range
function display_time_range() {
    journalctl --since "$1" --no-pager
}

# Main script logic
if [[ $# -eq 0 ]]; then
    display_help
    exit 1
fi

while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -p|--port)
        display_ports "$2"
        shift
        shift
        ;;
        -d|--docker)
        display_docker "$2"
        shift
        shift
        ;;
        -n|--nginx)
        display_nginx "$2"
        shift
        shift
        ;;
        -u|--users)
        display_users "$2"
        shift
        shift
        ;;
        -t|--time)
        display_time_range "$2"
        shift
        shift
        ;;
        -h|--help)
        display_help
        exit 0
        ;;
        *)
        display_help
        exit 1
        ;;
    esac
done
