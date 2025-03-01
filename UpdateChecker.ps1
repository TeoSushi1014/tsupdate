[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$currentVersion = "1.1.0"
$updateServerUrl = "https://teosushi1014.github.io/tsupdate/updates.json"

function Check-ForUpdates {
    Write-Host "Checking for TSToolkit updates..." -ForegroundColor Cyan
    
    try {
        $response = Invoke-WebRequest -Uri $updateServerUrl -UseBasicParsing
        $updateInfo = $response.Content | ConvertFrom-Json
        
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
                Write-Host "Downloading update..." -ForegroundColor Cyan
                
                $tempDir = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()
                New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
                
                $downloadFileName = [System.IO.Path]::GetFileName($updateInfo.downloadUrl)
                $downloadFilePath = Join-Path -Path $tempDir -ChildPath $downloadFileName
                
                try {
                    Invoke-WebRequest -Uri $updateInfo.downloadUrl -OutFile $downloadFilePath
                    
                    Write-Host "Download successful at: $downloadFilePath" -ForegroundColor Green
                    Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$downloadFilePath`""
                    
                    Write-Host "Please extract the file and run Setup.cmd to install the update." -ForegroundColor Yellow
                } catch {
                    Write-Host "Unable to download update: $_" -ForegroundColor Red
                    Write-Host "Please download manually at: $($updateInfo.downloadUrl)" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "TSToolkit is already at the latest version (v$currentVersion)" -ForegroundColor Green
            Start-Sleep -Seconds 3  # Pause for 3 seconds to display the message
        }
    } catch {
        Write-Host "Unable to check for updates: $_" -ForegroundColor Red
        Write-Host "Please check your network connection and try again later." -ForegroundColor Yellow
    }
}

Check-ForUpdates 