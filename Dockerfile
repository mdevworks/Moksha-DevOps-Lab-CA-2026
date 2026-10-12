FROM mcr.microsoft.com/powershell:latest

WORKDIR /workspace

CMD ["pwsh", "-File", "/workspace/Scripts/FileAutomation.ps1"]