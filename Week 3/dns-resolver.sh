#!/bin/bash

# Configuration
NETWORK_PREFIX="10.0.5."
DNS_SERVER="10.0.5.22"

echo "dns-resolver.sh $DNS_SERVER"

# Loop through host addresses 1 to 254 (for a /24 network)
for i in {1..254}; do
    IP="${NETWORK_PREFIX}${i}"
    
    # Construct the ARPA name: X.5.0.10.in-addr.arpa where X is the host number ($i)
    ARPA_NAME="${i}.5.0.10.in-addr.arpa"

    # Use nslookup to perform a PTR (reverse) query against the specific DNS server
    # The output is filtered and cleaned to extract only the hostname

    # EXPLAINING
    # 1. nslookup -query=PTR $ARPA_NAME $DNS_SERVER: executes the query.
    # 2. grep 'name =': filters lines containing the hostname.
    # 3. awk '{print $NF}': takes the last field (the hostname).
    # 4. sed 's/.$//': removes the trailing dot (.) from the hostname.
    
    HOSTNAME=$(nslookup -query=PTR "$ARPA_NAME" "$DNS_SERVER" 2> /dev/null | \
               grep 'name = ' | \
               awk '{print $NF}' | \
               sed 's/.$//')

    # If a hostname was successfully resolved, print the result in the required format.
    if [[ ! -z "$HOSTNAME" ]]; then
        # The output format: X.5.0.10.in-addr.arpa        name = hostname.
        printf "%s\t\tname = %s.\n" "$ARPA_NAME" "$HOSTNAME"
    fi
done
