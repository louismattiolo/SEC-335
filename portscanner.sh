#!/bin/bash

# Port scanner for a /24 subnet (1-254) targeting a single TCP port

# Check for correct number of arguments
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <network_prefix> <tcp_port>"
    echo "Example: $0 10.0.5 53"
    exit 1
fi

network_prefix=$1 # e.g., 10.0.5
target_port=$2    # e.g., 53 (TCP port for DNS)
timeout_sec=0.1   # Connection timeout in seconds

echo "Scanning $network_prefix.1-254 for TCP port $target_port"
echo "---"
echo "host,port,status"

# Loop through the last octet (1 through 254)
for i in $(seq 1 254); do
    host="$network_prefix.$i"
    
    # Use bash's built-in /dev/tcp for port scanning with a timeout
    # timeout 0.1: Limits the connection attempt time
    # bash -c "...": Executes the connection attempt
    # echo >/dev/tcp/$host/$target_port: Attempts TCP connection
    # 2>/dev/null: Suppresses connection error messages
    
    if timeout "$timeout_sec" bash -c "echo >/dev/tcp/$host/$target_port" 2>/dev/null; then
        echo "$host,$target_port,open"
    else
        # To reduce output, only print 'open' hosts, 
        # or uncomment the line below to show 'closed' hosts
        # echo "$host,$target_port,closed"
        :
    fi
done

echo "---"
echo "Scan complete."
