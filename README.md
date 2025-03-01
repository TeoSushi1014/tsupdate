# TSToolkit Update Checker

This tool automatically checks for updates to TSToolkit every time Command Prompt (CMD) is opened.

## How It Works

The update checking system works through the following steps:

1. **AutoRun Setup**: When you install this feature, the system sets up a Registry value or environment variable to make Windows automatically run the `CheckUpdate.cmd` script every time CMD is opened.

2. **Update Check Process**:
   - When CMD is opened, Windows automatically runs the `CheckUpdate.cmd` script
   - This script calls PowerShell with execution privileges to run `UpdateChecker.ps1`
   - `UpdateChecker.ps1` checks the current version and compares it with the latest version from the server
   - If a new version is available, the script displays a notification and asks the user if they want to update

3. **Update Mechanism**:
   - The script compares the current version (`$currentVersion`) with the latest version from the server
   - If a newer version is available, the script displays information about the update and the download link
   - The user can choose to download and update immediately or skip

4. **Skip Check Option**:
   - If you don't want to check for updates in a specific CMD session, you can use the `cmd /D` command to open CMD without running AutoRun

## Setting Up the Update Server

For the update checking system to work fully, you need to set up an update server. Here are methods for setting up the server:

### Official Update Server

TSToolkit uses the GitHub repository [TeoSushi1014/tsupdate](https://github.com/TeoSushi1014/tsupdate) as the official update server. This repository is already set up and you can use it right away:

1. Official update URL: `https://teosushi1014.github.io/tsupdate/updates.json`
2. Download directory: `https://teosushi1014.github.io/tsupdate/dl/`

To use the official update server, update the `$updateServerUrl` variable in `UpdateChecker.ps1`:

```powershell
$updateServerUrl = "https://teosushi1014.github.io/tsupdate/updates.json"
```

Repository structure:
- `/updates.json`: File containing the latest update information
- `/dl/`: Directory containing update files for download
- `/index.html`: Simple webpage displaying update information

### Other Server Setup Methods

If you want to set up your own update server, you can use one of the following methods:

#### 1. Using GitHub Releases

This is the simplest way to store and manage updates:

1. Create a GitHub repository for the TSToolkit project
2. Create releases for each new version
3. Create a JSON file containing update information (can use GitHub Pages):

```json
{
  "latestVersion": "1.1.0",
  "downloadUrl": "https://github.com/username/TSToolkit/releases/download/v1.1.0/TSToolkit-v1.1.0.zip",
  "releaseNotes": "New update with features: ..."
}
```

4. Update the `$updateServerUrl` variable in `UpdateChecker.ps1` to point to the JSON file URL:
```powershell
$updateServerUrl = "https://username.github.io/TSToolkit/updates.json"
```

### 2. Using a Custom Web Server

If you want complete control over the update process:

1. Set up a web server (Apache, Nginx, IIS, etc.)
2. Create an API endpoint that returns update information in JSON format:

```json
{
  "latestVersion": "1.1.0",
  "downloadUrl": "https://your-server.com/downloads/TSToolkit-v1.1.0.zip",
  "releaseNotes": "New update with features: ..."
}
```

3. Host the update files on the server
4. Update the `$updateServerUrl` variable in `UpdateChecker.ps1`:
```powershell
$updateServerUrl = "https://your-server.com/api/updates"
```

### 3. Using File Hosting Services

You can use services like Dropbox, Google Drive, OneDrive:

1. Upload a JSON file containing update information
2. Create a public sharing link for the JSON file
3. Upload the update files and create sharing links
4. Update the `$updateServerUrl` variable in `UpdateChecker.ps1`:
```powershell
$updateServerUrl = "https://dl.dropboxusercontent.com/s/abc123/updates.json"
```

### Update JSON File Structure

The update JSON file should have the following structure:

```json
{
  "latestVersion": "1.1.0",
  "downloadUrl": "https://example.com/download/TSToolkit-v1.1.0.zip",
  "releaseNotes": "New update with features: ...",
  "releaseDate": "2024-07-15",
  "minRequiredVersion": "1.0.0",
  "isRequired": false
}
```

Where:
- `latestVersion`: The latest version (Semantic Versioning format)
- `downloadUrl`: URL to download the update
- `releaseNotes`: Notes about changes in the update
- `releaseDate`: Release date of the update (optional)
- `minRequiredVersion`: Minimum required version (optional)
- `isRequired`: Specifies whether the update is mandatory (optional)

### Updating the PowerShell Script

After setting up the server, you need to update the `UpdateChecker.ps1` script to connect to the server:

1. Open the `UpdateChecker.ps1` file
2. Update the `$updateServerUrl` variable with the update server URL
3. Uncomment the API call code:
```powershell
$response = Invoke-WebRequest -Uri $updateServerUrl -UseBasicParsing
$updateInfo = $response.Content | ConvertFrom-Json
```
4. Customize the update handling logic if needed

## Installation

There are two ways to install the automatic update check feature:

### Method 1: Using AutoRun Registry

1. Open Notepad and create a file with the following content:
```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Command Processor]
"AutoRun"="\"D:\\TSToolkit (Teo Sushi Windows Toolkit)\\UpdateServer\\CheckUpdate.cmd\""
```

2. Save the file as `enable_update_check.reg`
3. Double-click the file to add it to the Registry
4. Every time CMD is opened, the update check script will automatically run

### Method 2: Using the CMDAUTORUN Environment Variable

1. Open Control Panel > System and Security > System
2. Click on "Advanced system settings"
3. Click on "Environment Variables"
4. In the "User variables" section, click on "New"
5. Enter variable name: `CMDAUTORUN`
6. Enter variable value: `D:\TSToolkit (Teo Sushi Windows Toolkit)\UpdateServer\CheckUpdate.cmd`
7. Click OK to save

### Method 3: Using Setup.cmd (Simplest)

1. Run the `Setup.cmd` file in the UpdateServer directory
2. Select option 1 to enable the update check feature
3. The system will automatically set up the Registry for you

## System Structure

The update checking system includes the following components:

1. **UpdateChecker.ps1**: Main PowerShell script for checking and handling updates
   - Stores current version information
   - Connects to the server to check for new versions
   - Compares versions and displays notifications
   - Handles the download and update process
   - Uses UTF-8 encoding configuration to display text correctly

2. **CheckUpdate.cmd**: Simple CMD script to call UpdateChecker.ps1
   - Ensures PowerShell is run with appropriate execution privileges
   - Uses the `-ExecutionPolicy Bypass` parameter to bypass execution policy
   - Uses the `chcp 65001` command to display text correctly
   - Sets UTF-8 encoding for PowerShell when running the script

3. **enable_update_check.reg** and **disable_update_check.reg**: Registry files to enable/disable the feature
   - Add or remove the AutoRun value in the Registry

4. **Setup.cmd**: Update check feature management tool
   - User-friendly interface to enable/disable the feature
   - Allows checking for updates immediately
   - Uses the `chcp 65001` command to display text correctly

## Customization

You can customize the update checking system by:

1. **Changing the server URL**: Open the `UpdateChecker.ps1` file and update the `$updateServerUrl` variable
2. **Changing the current version**: Update the `$currentVersion` variable in `UpdateChecker.ps1`
3. **Customizing messages**: Edit the messages in `UpdateChecker.ps1` as needed
4. **Changing the check logic**: Uncomment the API call code and customize the update check logic

## Uninstallation

### Removing AutoRun Registry

1. Open Notepad and create a file with the following content:
```
Windows Registry Editor Version 5.00

[HKEY_CURRENT_USER\Software\Microsoft\Command Processor]
"AutoRun"=-
```

2. Save the file as `disable_update_check.reg`
3. Double-click the file to remove it from the Registry

### Removing the CMDAUTORUN Environment Variable

1. Open Control Panel > System and Security > System
2. Click on "Advanced system settings"
3. Click on "Environment Variables"
4. In the "User variables" section, select `CMDAUTORUN`
5. Click on "Delete"
6. Click OK to save

### Using Setup.cmd (Simplest)

1. Run the `Setup.cmd` file in the UpdateServer directory
2. Select option 2 to disable the update check feature

## Notes

- The update check script will run every time CMD is opened
- If you don't want to check for updates in a specific CMD session, use the `cmd /D` command to open CMD without running AutoRun
- Make sure the path in the Registry file and environment variable points to the correct location of the `CheckUpdate.cmd` script
- The scripts use the `chcp 65001` command and UTF-8 encoding configuration to ensure correct text display in Command Prompt and PowerShell
- If you have display issues, make sure your CMD and PowerShell are using a Unicode-supporting font (like Consolas or Lucida Console)
- If text still doesn't display correctly in PowerShell, open PowerShell and run the following command before running the script: `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` 