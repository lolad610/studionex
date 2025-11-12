# Deploy to Google Cloud Run (Free Tier Available)
# Run: .\deploy-gcp.ps1

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "📱 Deploy to Google Cloud Run" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if gcloud CLI is installed
$gcloudVersion = gcloud --version 2>$null
if (-not $gcloudVersion) {
    Write-Host "❌ Google Cloud CLI not found!" -ForegroundColor Red
    Write-Host "Install from: https://cloud.google.com/sdk/docs/install" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Google Cloud CLI found" -ForegroundColor Green
Write-Host ""

# Login to Google Cloud
Write-Host "🔐 Logging into Google Cloud..." -ForegroundColor Cyan
gcloud auth login
Write-Host ""

# Set project
$projectId = Read-Host "Enter your Google Cloud Project ID"
gcloud config set project $projectId
Write-Host ""

# Build and deploy
Write-Host "🚀 Building and deploying to Cloud Run..." -ForegroundColor Green
Write-Host ""

Push-Location "backend"

# Build Docker image
gcloud builds submit --tag gcr.io/$projectId/studionex

# Deploy to Cloud Run
gcloud run deploy studionex `
    --image gcr.io/$projectId/studionex `
    --platform managed `
    --region us-central1 `
    --allow-unauthenticated `
    --set-env-vars MONGODB_URI=$env:MONGODB_URI,ADMIN_API_KEY=$env:ADMIN_API_KEY,SMTP_HOST=$env:SMTP_HOST,SMTP_PORT=$env:SMTP_PORT,SMTP_USER=$env:SMTP_USER,SMTP_PASS=$env:SMTP_PASS,ADMIN_EMAIL=$env:ADMIN_EMAIL

Pop-Location

Write-Host ""
Write-Host "✅ Deployment complete!" -ForegroundColor Green
Write-Host "Your app is live on Google Cloud Run" -ForegroundColor Cyan
