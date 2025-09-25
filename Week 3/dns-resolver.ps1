# DNS lookup but now in powershell
# Assign the command-line arguments to variables for clarity.
$networkPrefix = $args[0]
$dnsServer = $args[1]

# Loop through the last octet of the IP address, from 1 to 254
For ($i=1; $i -le 254; $i++) {

    # Construct the full IP address for the current iteration.
    $ip = "$networkPrefix.$i"
    # Attempt to resolve the IP address.
    $result = Resolve-DnsName -Name $ip -Server $dnsServer -ErrorAction SilentlyContinue

    # If a result is found, display the IP and the resolved hostname.
    if ($result) {
        Write-Host "IP: $ip -> Hostname: $($result.NameHost)"   
    }   
}
