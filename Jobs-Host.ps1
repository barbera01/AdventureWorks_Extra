# Define the path to your script
$scriptPath = "/Users/andybarber/Documents/Repos/ADW_Extras/Sales_Order_Generation.ps1"

for ($i = 0; $i -lt 2; $i++) {
    Start-Job -ScriptBlock {
        param($scriptPath)
        & $scriptPath
    } -ArgumentList $scriptPath
}

# Wait for all jobs to complete
Get-Job | Wait-Job

# Retrieve job results (if needed)
Get-Job | Receive-Job

# Clean up
Get-Job | Remove-Job
