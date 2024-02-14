# WSL Installation and Update

Write-Host "Installing WSL..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
wsl --set-default-version 2

Write-Host "Updating WSL..."
wsl --update

# Installing Ubuntu 20.04
Write-Host "Installing Ubuntu 20.04..."
wsl --install -d Ubuntu-20.04

# Set Ubuntu 20.04 as the default distribution for WSL
wsl --set-default Ubuntu-20.04

# Display a message indicating the successful installation of Ubuntu 20.04 for WSL
Write-Host "Successfully installed Ubuntu 20.04 for WSL"

Restart-Computer