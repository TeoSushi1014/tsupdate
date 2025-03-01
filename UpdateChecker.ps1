# UpdateChecker.ps1
# Update checker script for TSToolkit
# Created by: Claude AI

# Set UTF-8 encoding for correct text display
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$currentVersion = "1.0.0"
$updateServerUrl = "https://teosushi1014.github.io/tsupdate/updates.json" # Official update server URL

function Check-ForUpdates {
    Write-Host "Checking for TSToolkit updates..." -ForegroundColor Cyan
    
    try {
        # Connect to update server
        $response = Invoke-WebRequest -Uri $updateServerUrl -UseBasicParsing
        $updateInfo = $response.Content | ConvertFrom-Json
        
        # Simulate update data if unable to connect to server
        if ($null -eq $updateInfo) {
            $updateInfo = @{
                "latestVersion" = "1.0.0"
                "downloadUrl" = "https://teosushi1014.github.io/tsupdate/dl/TSToolkit-v1.0.0.zip"
                "releaseNotes" = "Latest update"
            }
        }
        
        if ([version]$updateInfo.latestVersion -gt [version]$currentVersion) {
            Write-Host "New update available: v$($updateInfo.latestVersion)" -ForegroundColor Green
            Write-Host "Release notes: $($updateInfo.releaseNotes)" -ForegroundColor Yellow
            Write-Host "Download at: $($updateInfo.downloadUrl)" -ForegroundColor Yellow
            
            $choice = Read-Host "Do you want to download this update? (Y/N)"
            if ($choice -eq "Y" -or $choice -eq "y") {
                # Perform download and update
                Write-Host "Downloading update..." -ForegroundColor Cyan
                
                # Create temp directory for download
                $tempDir = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()
                New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
                
                # Download file name
                $downloadFileName = [System.IO.Path]::GetFileName($updateInfo.downloadUrl)
                $downloadFilePath = Join-Path -Path $tempDir -ChildPath $downloadFileName
                
                try {
                    # Download update file
                    Invoke-WebRequest -Uri $updateInfo.downloadUrl -OutFile $downloadFilePath
                    
                    # Open folder containing downloaded file
                    Write-Host "Download successful at: $downloadFilePath" -ForegroundColor Green
                    Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$downloadFilePath`""
                    
                    # Installation instructions
                    Write-Host "Please extract the file and run Setup.cmd to install the update." -ForegroundColor Yellow
                } catch {
                    Write-Host "Unable to download update: $_" -ForegroundColor Red
                    Write-Host "Please download manually at: $($updateInfo.downloadUrl)" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "TSToolkit is already at the latest version (v$currentVersion)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Unable to check for updates: $_" -ForegroundColor Red
        Write-Host "Please check your network connection and try again later." -ForegroundColor Yellow
    }
}

# Run update check function
Check-ForUpdates 