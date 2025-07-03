Write-Host "🧨 Stopping Docker containers..."
docker compose down --volumes --remove-orphans

Write-Host "🚀 Starting Docker containers..."
docker compose up --build
