# Deploy to Heroku
# Run: .\deploy-heroku.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 Deploy to Heroku" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Heroku CLI is installed
$herokuVersion = heroku --version 2>$null
if (-not $herokuVersion) {
    Write-Host "❌ Heroku CLI not found!" -ForegroundColor Red
    Write-Host "Install from: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Heroku CLI found: $herokuVersion" -ForegroundColor Green
Write-Host ""

# Login to Heroku
Write-Host "🔐 Logging into Heroku..." -ForegroundColor Cyan
heroku login
Write-Host ""

# App name
$appName = Read-Host "Enter Heroku app name (e.g., 'studionex')"
Write-Host ""

# Create app
Write-Host "📝 Creating Heroku app: $appName..." -ForegroundColor Cyan
heroku create $appName --buildpack heroku/nodejs
Write-Host ""

# Set environment variables
Write-Host "🔐 Setting environment variables..." -ForegroundColor Cyan

$mongoUri = Read-Host "Enter MONGODB_URI"
$adminApiKey = Read-Host "Enter ADMIN_API_KEY"
$smtpHost = Read-Host "Enter SMTP_HOST (e.g., smtp.gmail.com)"
$smtpPort = Read-Host "Enter SMTP_PORT (e.g., 587)"
$smtpUser = Read-Host "Enter SMTP_USER"
$smtpPass = Read-Host "Enter SMTP_PASS"
$adminEmail = Read-Host "Enter ADMIN_EMAIL"

heroku config:set `
    MONGODB_URI=$mongoUri `
    ADMIN_API_KEY=$adminApiKey `
    SMTP_HOST=$smtpHost `
    SMTP_PORT=$smtpPort `
    SMTP_USER=$smtpUser `
    SMTP_PASS=$smtpPass `
    ADMIN_EMAIL=$adminEmail `
    NODE_ENV=production

Write-Host "✅ Environment variables set" -ForegroundColor Green
Write-Host ""

# Deploy
Write-Host "🚀 Deploying to Heroku..." -ForegroundColor Green
Write-Host "This may take 2-3 minutes..." -ForegroundColor Cyan
Write-Host ""

git push heroku main

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host ""
Write-Host "Your app is live at: https://$appName.herokuapp.com" -ForegroundColor Green
Write-Host ""
Write-Host "Monitor logs with:" -ForegroundColor Cyan
Write-Host "  heroku logs --tail" -ForegroundColor White
Write-Host ""
