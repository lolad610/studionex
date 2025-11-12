# Deploy to Vercel (Easiest Option)
# Run: .\deploy-vercel.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 Deploy to Vercel" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Vercel CLI is installed
$vercelVersion = vercel --version 2>$null
if (-not $vercelVersion) {
    Write-Host "❌ Vercel CLI not found!" -ForegroundColor Red
    Write-Host "Installing Vercel CLI..." -ForegroundColor Cyan
    npm install -g vercel
    Write-Host "✅ Vercel CLI installed" -ForegroundColor Green
}

Write-Host "✅ Vercel CLI found: $vercelVersion" -ForegroundColor Green
Write-Host ""

# Login to Vercel
Write-Host "🔐 Logging into Vercel..." -ForegroundColor Cyan
vercel login
Write-Host ""

# Deploy
Write-Host "🚀 Deploying to Vercel..." -ForegroundColor Green
Write-Host ""

Push-Location "backend"

# Deploy with --prod for production
$prodChoice = Read-Host "Deploy to production? (yes/no)"

if ($prodChoice -eq "yes") {
    Write-Host "🌍 Deploying to production..." -ForegroundColor Green
    vercel --prod `
        --env MONGODB_URI=$env:MONGODB_URI `
        --env ADMIN_API_KEY=$env:ADMIN_API_KEY `
        --env SMTP_HOST=$env:SMTP_HOST `
        --env SMTP_PORT=$env:SMTP_PORT `
        --env SMTP_USER=$env:SMTP_USER `
        --env SMTP_PASS=$env:SMTP_PASS `
        --env ADMIN_EMAIL=$env:ADMIN_EMAIL
} else {
    Write-Host "🧪 Deploying to preview (staging)..." -ForegroundColor Green
    vercel `
        --env MONGODB_URI=$env:MONGODB_URI `
        --env ADMIN_API_KEY=$env:ADMIN_API_KEY `
        --env SMTP_HOST=$env:SMTP_HOST `
        --env SMTP_PORT=$env:SMTP_PORT `
        --env SMTP_USER=$env:SMTP_USER `
        --env SMTP_PASS=$env:SMTP_PASS `
        --env ADMIN_EMAIL=$env:ADMIN_EMAIL
}

Pop-Location

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "Check https://vercel.com/dashboard for your live URL" -ForegroundColor Cyan
