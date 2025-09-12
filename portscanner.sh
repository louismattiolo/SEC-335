#!/bin/bash

# Simple TCP port scanner

if [[ $# -lt 2 ]]; then
    echo "Usage: $0 <hostfile> <portfile>"
    exit 1
fi

hostfile=$1
portfile=$2

# Check files exist
[[ ! -f "$hostfile" ]] && { echo "Host file not found"; exit 1; }
[[ ! -f "$portfile" ]] && { echo "Port file not found"; exit 1; }

echo "host,port,status"

while read host; do
    while read port; do
        if timeout 0.1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            echo "$host,$port,open"
        else
            echo "$host,$port,closed"
        fi
    done < "$portfile"
done < "$hostfile"
