
$ErrorActionPreference = "Stop"

$ProjectPath = Split-Path -Parent $PSScriptRoot
$Inbox = Join-Path $ProjectPath "Inbox"
$Organized = Join-Path $ProjectPath "Organized"
$Backup = Join-Path $ProjectPath "Backup"

Write-Host "Starting File Automation Tests..." -ForegroundColor Cyan

# Test 1: Check that required folders exist
$RequiredFolders = @("Inbox", "Organized", "Backup", "Logs", "Scripts")

foreach ($Folder in $RequiredFolders) {
    $Path = Join-Path $ProjectPath $Folder
    if (Test-Path $Path) {
        Write-Host "PASS: $Folder folder exists" -ForegroundColor Green
    }
    else {
        throw "FAIL: $Folder folder is missing"
    }
}

# Test 2: Check that the main automation script exists
$MainScript = Join-Path $PSScriptRoot "FileAutomation.ps1"

if (Test-Path $MainScript) {
    Write-Host "PASS: Main script exists" -ForegroundColor Green
}
else {
    throw "FAIL: Main script is missing"
}

# Test 3: Check that organized test files exist
$DocumentFolder = Join-Path $Organized "Documents"
$TestFiles = @("TestDocument.txt", "TestNotes.txt")

foreach ($File in $TestFiles) {
    $Path = Join-Path $DocumentFolder $File
    if (Test-Path $Path) {
        Write-Host "PASS: $File was organized" -ForegroundColor Green
    }
    else {
        throw "FAIL: $File was not found in Organized\Documents"
    }
}

# Test 4: Check that a backup folder contains the test files
$BackupFiles = Get-ChildItem $Backup -Recurse -File

foreach ($File in $TestFiles) {
    if ($BackupFiles.Name -contains $File) {
        Write-Host "PASS: $File exists in backup" -ForegroundColor Green
    }
    else {
        throw "FAIL: $File was not found in any backup folder"
    }
}

Write-Host "All automated tests passed." -ForegroundColor Green



Write-Host "All automated tests passed." -ForegroundColor Green
