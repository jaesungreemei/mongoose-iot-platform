# Specify the ports and related service names. This script demonstrates how to remove several ports and services as an example.
$ports = @(9092, 9042, 9012)
$serviceNames = @("wsl-kafka", "wsl-cassandra", "wsl-api")

# Delete firewall rules and port forwarding
foreach ($serviceName in $serviceNames) {
    Write-Host "Removing Windows Firewall rule for $serviceName..."
    Remove-NetFirewallRule -DisplayName $serviceName -ErrorAction SilentlyContinue
    Write-Host "Successfully Windows Firewall rule for port $port."
}

foreach ($port in $ports) {
    Write-Host "Removing port forwarding for port $port..."
    netsh interface portproxy delete v4tov4 listenport=$port listenaddress=0.0.0.0
    Write-Host "Successfully remove port forwarding for port $port."
}

# Stop all WSL instances and remove existing distributions
Write-Host "Stopping all WSL instances and removing existing distributions..."
wsl --shutdown
# Here, Ubuntu-20.04 is used as an example, but you should use the exact name of the distribution you want to remove when actually using this script.
wsl --unregister Ubuntu-20.04 -ErrorAction SilentlyContinue

Write-Host "WSL reset completed."
