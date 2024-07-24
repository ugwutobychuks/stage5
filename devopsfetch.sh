  GNU nano 2.9.3     devopsfetch.sh
#!/bin/bash

# Help function
function display_help() {
    echo "Usage: $0 [option] [argument]"
    echo
    echo "Options:"
    echo "  -p, --port [port_number]    Display ac$    echo "  -d, --docker [container_name]    List $    echo "  -n, --nginx [domain]    Display Nginx $    echo "  -u, --users [username]    List users a$    echo "  -t, --time [time_range]    Display act$    echo "  -h, --help    Display this help messag$    echo
}

# Display active ports and services
function display_ports() {
    if [ -z "$1" ]; then
        ss -tuln | awk 'NR>1 {print $1, $4}' | col$    else
        ss -tuln | grep ":$1 "
    fi
}

# List Docker images and containers
function display_docker() {
    if [ -z "$1" ]; then
        docker ps -a --format "table {{.Names}}\t{$    else
        docker inspect $1
    fi
}

# Display Nginx domains and ports
function display_nginx() {
                [ Read 104 lines ]
^G Get Help ^O Write Out^W Where Is ^K Cut Text
^X Exit     ^R Read File^\ Replace  ^U Uncut Text
