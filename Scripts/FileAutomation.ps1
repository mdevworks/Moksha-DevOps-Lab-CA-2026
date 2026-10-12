# ============================================
# Automated File Backup and Organization
# ============================================

# Project folders
$ProjectPath = "D:\Desktop\PowerShell_File_Automation"

$SourcePath = "$ProjectPath\Inbox"
$OrganizedPath = "$ProjectPath\Organized"
$BackupPath = "$ProjectPath\Backup"
$LogPath = "$ProjectPath\Logs"

# Create required folders if they do not exist
New-Item -ItemType Directory -Path $OrganizedPath -Force | Out-Null
New-Item -ItemType Directory -Path $BackupPath -Force | Out-Null
New-Item -ItemType Directory -Path $LogPath -Force | Out-Null

# Create timestamp
$TimeStamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

# Create backup folder
$CurrentBackup = "$BackupPath\Backup_$TimeStamp"
New-Item -ItemType Directory -Path $CurrentBackup -Force | Out-Null

# Create log file
$LogFile = "$LogPath\Automation_$TimeStamp.log"

function Write-Log {
    param([string]$Message)

    $LogTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$LogTime - $Message" | Out-File -FilePath $LogFile -Append
    Write-Host $Message
}

Write-Log "=========================================="
Write-Log "File Backup and Organization Started"
Write-Log "=========================================="

# File categories
$Categories = @{
    "Documents" = @(".pdf", ".doc", ".docx", ".txt", ".xls", ".xlsx", ".ppt", ".pptx")
    "Images"    = @(".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp")
    "Videos"    = @(".mp4", ".avi", ".mkv", ".mov", ".wmv")
    "Audio"     = @(".mp3", ".wav", ".aac", ".flac", ".m4a")
    "Archives"  = @(".zip", ".rar", ".7z", ".tar", ".gz")
}

# Get all files from Inbox
$Files = Get-ChildItem -Path $SourcePath -File

if ($Files.Count -eq 0) {

    Write-Log "No files found in Inbox."
    Write-Log "Automation completed."

}
else {

    foreach ($File in $Files) {

        try {

            # Get file extension
            $Extension = $File.Extension.ToLower()

            # Default category
            $Category = "Others"

            # Find correct category
            foreach ($Key in $Categories.Keys) {

                if ($Categories[$Key] -contains $Extension) {
                    $Category = $Key
                    break
                }
            }

            # Create category folder
            $CategoryFolder = "$OrganizedPath\$Category"

            New-Item -ItemType Directory -Path $CategoryFolder -Force | Out-Null

            # Create backup copy
            Copy-Item -Path $File.FullName -Destination $CurrentBackup -Force

            Write-Log "Backup created: $($File.Name)"

            # Move original file
            Move-Item -Path $File.FullName -Destination $CategoryFolder -Force

            Write-Log "Organized: $($File.Name) -> $Category"

        }

        catch {

            Write-Log "ERROR processing $($File.Name): $($_.Exception.Message)"
        }
    }
}

Write-Log "=========================================="
Write-Log "Backup and Organization Completed"
Write-Log "=========================================="

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host " AUTOMATION COMPLETED SUCCESSFULLY" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green

Write-Host ""
Write-Host "Backup Location:"
Write-Host $CurrentBackup

Write-Host ""
Write-Host "Organized Files:"
Write-Host $OrganizedPath

Write-Host ""
Write-Host "Log File:"
Write-Host $LogFile