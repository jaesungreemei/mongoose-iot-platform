# Check the WSL version to ensure the WSL installation and update were successful
wsl --version

# List all installed WSL distributions with their verbose details, such as their state and version, to verify the installation and configuration
wsl --list --verbose

$ports = @(9092, 9042, 9012)
$serviceNames = @("wsl-kafka", "wsl-cassandra", "wsl-api")

# Obtaining the IP address of the current WSL2 instance via WSL
Write-Host "Retrieving the IP address of the WSL2 instance..."
$wslIp = wsl -- ip -4 addr show eth0 | Select-String -Pattern "inet" | ForEach-Object { $_ -replace '.*inet (\d+(\.\d+){3}).*', '$1' }
$wslIp = $wslIp.Trim()
Write-Host "WSL2 IP Address: $wslIp"

# Port Forwarding and Firewall Rule Setup
for ($i = 0; $i -lt $ports.Length; $i++) {
    $port = $ports[$i]
    $serviceName = $serviceNames[$i]

    # Adding Port Forwarding
    Write-Host "Setting up port forwarding for port $port..."
    netsh interface portproxy add v4tov4 listenport=$port listenaddress=0.0.0.0 connectport=$port connectaddress=$wslIp

    # Adding Firewall Rules
    Write-Host "Adding Windows Firewall rule for the $serviceName service (Port $port)..."
    New-NetFirewallRule -DisplayName $serviceName -Direction Inbound -Action Allow -Protocol TCP -LocalPort $port
}

Write-Host "Configuration completed. Port forwarding and firewall rules have been added for all specified ports."
