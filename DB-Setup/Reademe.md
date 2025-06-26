# 🛠️ Docker Compose Run Instructions

This guide explains how to extract a zipped Docker project and start the containers using PowerShell.

---

## ✅ Step 1: Extract the ZIP

Make sure `archive.zip` is in the same directory as your PowerShell terminal.

```powershell
Write-Host "🧨 Stopping Docker containers..."
docker compose down --volumes --remove-orphans

Write-Host "🚀 Starting Docker containers..."
docker compose up --build
```