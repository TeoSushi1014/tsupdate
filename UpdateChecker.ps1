# UpdateChecker.ps1
# Script kiểm tra cập nhật cho TSToolkit
# Tạo bởi: Claude AI

# Thiết lập encoding UTF-8 để hiển thị tiếng Việt đúng
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
$PSDefaultParameterValues['*:Encoding'] = 'utf8'

$currentVersion = "1.0.0"
$updateServerUrl = "https://teosushi1014.github.io/tsupdate/updates.json" # URL server cập nhật chính thức

function Check-ForUpdates {
    Write-Host "Đang kiểm tra cập nhật cho TSToolkit..." -ForegroundColor Cyan
    
    try {
        # Kết nối với server cập nhật
        $response = Invoke-WebRequest -Uri $updateServerUrl -UseBasicParsing
        $updateInfo = $response.Content | ConvertFrom-Json
        
        # Giả lập dữ liệu cập nhật nếu không thể kết nối với server
        if ($null -eq $updateInfo) {
            $updateInfo = @{
                "latestVersion" = "1.0.0"
                "downloadUrl" = "https://teosushi1014.github.io/tsupdate/dl/TSToolkit-v1.0.0.zip"
                "releaseNotes" = "Bản cập nhật mới nhất"
            }
        }
        
        if ([version]$updateInfo.latestVersion -gt [version]$currentVersion) {
            Write-Host "Đã có bản cập nhật mới: v$($updateInfo.latestVersion)" -ForegroundColor Green
            Write-Host "Ghi chú phát hành: $($updateInfo.releaseNotes)" -ForegroundColor Yellow
            Write-Host "Tải về tại: $($updateInfo.downloadUrl)" -ForegroundColor Yellow
            
            $choice = Read-Host "Bạn có muốn tải về bản cập nhật này không? (Y/N)"
            if ($choice -eq "Y" -or $choice -eq "y") {
                # Thực hiện tải về và cập nhật
                Write-Host "Đang tải về bản cập nhật..." -ForegroundColor Cyan
                
                # Tạo thư mục tạm để tải về
                $tempDir = [System.IO.Path]::GetTempPath() + [System.Guid]::NewGuid().ToString()
                New-Item -ItemType Directory -Path $tempDir -Force | Out-Null
                
                # Tên file tải về
                $downloadFileName = [System.IO.Path]::GetFileName($updateInfo.downloadUrl)
                $downloadFilePath = Join-Path -Path $tempDir -ChildPath $downloadFileName
                
                try {
                    # Tải file cập nhật
                    Invoke-WebRequest -Uri $updateInfo.downloadUrl -OutFile $downloadFilePath
                    
                    # Mở thư mục chứa file tải về
                    Write-Host "Đã tải về thành công tại: $downloadFilePath" -ForegroundColor Green
                    Start-Process -FilePath "explorer.exe" -ArgumentList "/select,`"$downloadFilePath`""
                    
                    # Hướng dẫn cài đặt
                    Write-Host "Vui lòng giải nén file và chạy Setup.cmd để cài đặt cập nhật." -ForegroundColor Yellow
                } catch {
                    Write-Host "Không thể tải về bản cập nhật: $_" -ForegroundColor Red
                    Write-Host "Vui lòng tải về thủ công tại: $($updateInfo.downloadUrl)" -ForegroundColor Yellow
                }
            }
        } else {
            Write-Host "TSToolkit đã ở phiên bản mới nhất (v$currentVersion)" -ForegroundColor Green
        }
    } catch {
        Write-Host "Không thể kiểm tra cập nhật: $_" -ForegroundColor Red
        Write-Host "Vui lòng kiểm tra kết nối mạng và thử lại sau." -ForegroundColor Yellow
    }
}

# Chạy hàm kiểm tra cập nhật
Check-ForUpdates 