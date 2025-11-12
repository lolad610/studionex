# Main Deployment Menu
# Run: .\deploy.ps1

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  StudioNex - Deployment Menu          ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Choose your deployment option:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1) 🟢 Vercel (Easiest - Recommended)" -ForegroundColor Green
Write-Host "  2) 🟡 Heroku (Simple) " -ForegroundColor Yellow
Write-Host "  3) 🔵 Google Cloud Run (Advanced)" -ForegroundColor Cyan
Write-Host "  4) 📊 Local Development" -ForegroundColor Magenta
Write-Host "  5) ⚙️  Setup Environment First" -ForegroundColor White
Write-Host ""
Write-Host "  0) ❌ Exit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice (0-5)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "Launching Vercel deployment..." -ForegroundColor Green
        & ".\deploy-vercel.ps1"
    }
    "2" {
        Write-Host ""
        Write-Host "Launching Heroku deployment..." -ForegroundColor Green
        & ".\deploy-heroku.ps1"
    }
    "3" {
        Write-Host ""
        Write-Host "Launching Google Cloud Run deployment..." -ForegroundColor Green
        & ".\deploy-gcp.ps1"
    }
    "4" {
        Write-Host ""
        Write-Host "Starting local development server..." -ForegroundColor Green
        Push-Location "backend"
        npm start
        Pop-Location
    }
    "5" {
        Write-Host ""
        Write-Host "Running setup wizard..." -ForegroundColor Green
        & ".\setup.ps1"
    }
    "0" {
        Write-Host "Goodbye!" -ForegroundColor Green
        exit 0
    }
    default {
        Write-Host "Invalid choice! Please run the script again." -ForegroundColor Red
        exit 1
    }
}
