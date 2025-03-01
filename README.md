# TSToolkit Update Checker

Công cụ này giúp tự động kiểm tra cập nhật cho TSToolkit mỗi khi mở Command Prompt (CMD).

## Cách hoạt động

Hệ thống kiểm tra cập nhật hoạt động theo các bước sau:

1. **Thiết lập AutoRun**: Khi bạn cài đặt tính năng này, hệ thống sẽ thiết lập một giá trị Registry hoặc biến môi trường để Windows tự động chạy script `CheckUpdate.cmd` mỗi khi mở CMD.

2. **Quy trình kiểm tra cập nhật**:
   - Khi mở CMD, Windows sẽ tự động chạy script `CheckUpdate.cmd`
   - Script này sẽ gọi PowerShell với quyền thực thi để chạy `UpdateChecker.ps1`
   - `UpdateChecker.ps1` sẽ kiểm tra phiên bản hiện tại và so sánh với phiên bản mới nhất từ server
   - Nếu có phiên bản mới, script sẽ hiển thị thông báo và hỏi người dùng có muốn cập nhật không

3. **Cơ chế cập nhật**:
   - Script sẽ so sánh phiên bản hiện tại (`$currentVersion`) với phiên bản mới nhất từ server
   - Nếu phiên bản mới hơn, script sẽ hiển thị thông tin về bản cập nhật và đường dẫn tải về
   - Người dùng có thể chọn tải về và cập nhật ngay hoặc bỏ qua

4. **Tùy chọn bỏ qua kiểm tra**:
   - Nếu không muốn kiểm tra cập nhật trong một phiên CMD cụ thể, bạn có thể sử dụng lệnh `cmd /D` để mở CMD mà không chạy AutoRun

## Thiết lập Server Cập Nhật

Để hệ thống kiểm tra cập nhật hoạt động đầy đủ, bạn cần thiết lập một server cập nhật. Dưới đây là các phương pháp thiết lập server:

### Server Cập Nhật Chính Thức

TSToolkit sử dụng repository GitHub [TeoSushi1014/tsupdate](https://github.com/TeoSushi1014/tsupdate) làm server cập nhật chính thức. Repository này đã được thiết lập sẵn và bạn có thể sử dụng ngay:

1. URL cập nhật chính thức: `https://teosushi1014.github.io/tsupdate/updates.json`
2. Thư mục tải về: `https://teosushi1014.github.io/tsupdate/dl/`

Để sử dụng server cập nhật chính thức, hãy cập nhật biến `$updateServerUrl` trong `UpdateChecker.ps1`:

```powershell
$updateServerUrl = "https://teosushi1014.github.io/tsupdate/updates.json"
```

Cấu trúc repository:
- `/updates.json`: File chứa thông tin cập nhật mới nhất
- `/dl/`: Thư mục chứa các file cập nhật để tải về
- `/index.html`: Trang web đơn giản hiển thị thông tin cập nhật

### Các Phương Pháp Thiết Lập Server Khác

Nếu bạn muốn tự thiết lập server cập nhật riêng, bạn có thể sử dụng một trong các phương pháp sau:

#### 1. Sử dụng GitHub Releases

Đây là cách đơn giản nhất để lưu trữ và quản lý các bản cập nhật:

1. Tạo một repository trên GitHub cho dự án TSToolkit
2. Tạo releases cho mỗi phiên bản mới
3. Tạo file JSON chứa thông tin cập nhật (có thể sử dụng GitHub Pages):

```json
{
  "latestVersion": "1.1.0",
  "downloadUrl": "https://github.com/username/TSToolkit/releases/download/v1.1.0/TSToolkit-v1.1.0.zip",
  "releaseNotes": "Bản cập nhật mới với các tính năng: ..."
}
```

4. Cập nhật biến `$updateServerUrl` trong `UpdateChecker.ps1` để trỏ đến URL của file JSON:
```powershell
$updateServerUrl = "https://username.github.io/TSToolkit/updates.json"
```

### 2. Sử dụng Web Server Tùy Chỉnh

Nếu bạn muốn kiểm soát hoàn toàn quá trình cập nhật:

1. Thiết lập web server (Apache, Nginx, IIS, v.v.)
2. Tạo API endpoint trả về thông tin cập nhật dạng JSON:

```json
{
  "latestVersion": "1.1.0",
  "downloadUrl": "https://your-server.com/downloads/TSToolkit-v1.1.0.zip",
  "releaseNotes": "Bản cập nhật mới với các tính năng: ..."
}
```

3. Lưu trữ các file cập nhật trên server
4. Cập nhật biến `$updateServerUrl` trong `UpdateChecker.ps1`:
```powershell
$updateServerUrl = "https://your-server.com/api/updates"
```

### 3. Sử dụng Dịch Vụ Lưu Trữ File

Bạn có thể sử dụng các dịch vụ như Dropbox, Google Drive, OneDrive:

1. Tải lên file JSON chứa thông tin cập nhật
2. Tạo liên kết chia sẻ công khai cho file JSON
3. Tải lên các file cập nhật và tạo liên kết chia sẻ
4. Cập nhật biến `$updateServerUrl` trong `UpdateChecker.ps1`:
```powershell
$updateServerUrl = "https://dl.dropboxusercontent.com/s/abc123/updates.json"
```

### Cấu Trúc File JSON Cập Nhật

File JSON cập nhật nên có cấu trúc sau:

```json
{
  "latestVersion": "1.1.0",
  "downloadUrl": "https://example.com/download/TSToolkit-v1.1.0.zip",
  "releaseNotes": "Bản cập nhật mới với các tính năng: ...",
  "releaseDate": "2024-07-15",
  "minRequiredVersion": "1.0.0",
  "isRequired": false
}
```

Trong đó:
- `latestVersion`: Phiên bản mới nhất (định dạng Semantic Versioning)
- `downloadUrl`: URL để tải về bản cập nhật
- `releaseNotes`: Ghi chú về các thay đổi trong bản cập nhật
- `releaseDate`: Ngày phát hành bản cập nhật (tùy chọn)
- `minRequiredVersion`: Phiên bản tối thiểu cần thiết (tùy chọn)
- `isRequired`: Xác định xem cập nhật có bắt buộc hay không (tùy chọn)

### Cập Nhật Script PowerShell

Sau khi thiết lập server, bạn cần cập nhật script `UpdateChecker.ps1` để kết nối với server:

1. Mở file `UpdateChecker.ps1`
2. Cập nhật biến `$updateServerUrl` với URL của server cập nhật
3. Bỏ comment phần code gọi API:
```powershell
$response = Invoke-WebRequest -Uri $updateServerUrl -UseBasicParsing
$updateInfo = $response.Content | ConvertFrom-Json
```
4. Tùy chỉnh logic xử lý cập nhật nếu cần

## Cách cài đặt

Có hai cách để cài đặt tính năng tự động kiểm tra cập nhật:

### Cách 1: Sử dụng AutoRun Registry

1. Mở Notepad và tạo file với nội dung sau:
```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Command Processor]
"AutoRun"="\"D:\\TSToolkit (Teo Sushi Windows Toolkit)\\UpdateServer\\CheckUpdate.cmd\""
```

2. Lưu file với tên `enable_update_check.reg`
3. Nhấp đúp vào file để thêm vào Registry
4. Mỗi khi mở CMD, script kiểm tra cập nhật sẽ tự động chạy

### Cách 2: Sử dụng biến môi trường CMDAUTORUN

1. Mở Control Panel > System and Security > System
2. Nhấp vào "Advanced system settings"
3. Nhấp vào "Environment Variables"
4. Trong phần "User variables", nhấp vào "New"
5. Nhập tên biến: `CMDAUTORUN`
6. Nhập giá trị biến: `D:\TSToolkit (Teo Sushi Windows Toolkit)\UpdateServer\CheckUpdate.cmd`
7. Nhấp OK để lưu

### Cách 3: Sử dụng Setup.cmd (Đơn giản nhất)

1. Chạy file `Setup.cmd` trong thư mục UpdateServer
2. Chọn tùy chọn 1 để bật tính năng kiểm tra cập nhật
3. Hệ thống sẽ tự động thiết lập Registry cho bạn

## Cấu trúc hệ thống

Hệ thống kiểm tra cập nhật bao gồm các thành phần sau:

1. **UpdateChecker.ps1**: Script PowerShell chính để kiểm tra và xử lý cập nhật
   - Lưu trữ thông tin phiên bản hiện tại
   - Kết nối với server để kiểm tra phiên bản mới
   - So sánh phiên bản và hiển thị thông báo
   - Xử lý quá trình tải về và cập nhật
   - Sử dụng cấu hình encoding UTF-8 để hiển thị tiếng Việt đúng

2. **CheckUpdate.cmd**: Script CMD đơn giản để gọi UpdateChecker.ps1
   - Đảm bảo PowerShell được chạy với quyền thực thi phù hợp
   - Sử dụng tham số `-ExecutionPolicy Bypass` để bỏ qua chính sách thực thi
   - Sử dụng lệnh `chcp 65001` để hiển thị tiếng Việt đúng
   - Thiết lập encoding UTF-8 cho PowerShell khi chạy script

3. **enable_update_check.reg** và **disable_update_check.reg**: File Registry để bật/tắt tính năng
   - Thêm hoặc xóa giá trị AutoRun trong Registry

4. **Setup.cmd**: Công cụ quản lý tính năng kiểm tra cập nhật
   - Giao diện thân thiện để bật/tắt tính năng
   - Cho phép kiểm tra cập nhật ngay lập tức
   - Sử dụng lệnh `chcp 65001` để hiển thị tiếng Việt đúng

## Tùy chỉnh

Bạn có thể tùy chỉnh hệ thống kiểm tra cập nhật bằng cách:

1. **Thay đổi URL server**: Mở file `UpdateChecker.ps1` và cập nhật biến `$updateServerUrl`
2. **Thay đổi phiên bản hiện tại**: Cập nhật biến `$currentVersion` trong `UpdateChecker.ps1`
3. **Tùy chỉnh thông báo**: Chỉnh sửa các thông báo trong `UpdateChecker.ps1` theo nhu cầu
4. **Thay đổi logic kiểm tra**: Bỏ comment phần code gọi API và tùy chỉnh logic kiểm tra cập nhật

## Cách gỡ bỏ

### Gỡ bỏ AutoRun Registry

1. Mở Notepad và tạo file với nội dung sau:
```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Command Processor]
"AutoRun"=-
```

2. Lưu file với tên `disable_update_check.reg`
3. Nhấp đúp vào file để xóa khỏi Registry

### Gỡ bỏ biến môi trường CMDAUTORUN

1. Mở Control Panel > System and Security > System
2. Nhấp vào "Advanced system settings"
3. Nhấp vào "Environment Variables"
4. Trong phần "User variables", chọn `CMDAUTORUN`
5. Nhấp vào "Delete"
6. Nhấp OK để lưu

### Sử dụng Setup.cmd (Đơn giản nhất)

1. Chạy file `Setup.cmd` trong thư mục UpdateServer
2. Chọn tùy chọn 2 để tắt tính năng kiểm tra cập nhật

## Lưu ý

- Script kiểm tra cập nhật sẽ chạy mỗi khi mở CMD
- Nếu bạn không muốn kiểm tra cập nhật trong một phiên CMD cụ thể, hãy sử dụng lệnh `cmd /D` để mở CMD mà không chạy AutoRun
- Đảm bảo đường dẫn trong file Registry và biến môi trường trỏ đến vị trí chính xác của script `CheckUpdate.cmd`
- Các script sử dụng lệnh `chcp 65001` và cấu hình encoding UTF-8 để đảm bảo hiển thị tiếng Việt đúng trong Command Prompt và PowerShell
- Nếu bạn gặp vấn đề về hiển thị, hãy đảm bảo rằng CMD và PowerShell của bạn đang sử dụng font hỗ trợ Unicode (như Consolas hoặc Lucida Console)
- Nếu tiếng Việt vẫn hiển thị không đúng trong PowerShell, hãy mở PowerShell và chạy lệnh sau trước khi chạy script: `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` 