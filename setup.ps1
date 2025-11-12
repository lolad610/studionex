# StudioNex - Automated Setup Script for Windows PowerShell
# Run this script to automatically configure everything!
# Right-click → Run with PowerShell

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "🚀 StudioNex Automated Setup" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running as admin
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
if (-not $isAdmin) {
    Write-Host "⚠️ WARNING: This script should run as Administrator for best results!" -ForegroundColor Yellow
    Write-Host "Please right-click PowerShell and select 'Run as administrator'" -ForegroundColor Yellow
    Read-Host "Press Enter to continue anyway"
}

# Step 1: Check if Node.js is installed
Write-Host ""
Write-Host "📦 Step 1: Checking Node.js..." -ForegroundColor Cyan
$nodeVersion = node --version 2>$null
if ($nodeVersion) {
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js not found! Please install from https://nodejs.org/" -ForegroundColor Red
    exit 1
}

# Step 2: Check if MongoDB is accessible
Write-Host ""
Write-Host "📦 Step 2: Checking MongoDB..." -ForegroundColor Cyan
$mongoCheck = mongosh --version 2>$null
if ($mongoCheck) {
    Write-Host "✅ MongoDB shell found" -ForegroundColor Green
} else {
    Write-Host "⚠️ MongoDB shell not found locally (that's OK, we'll use MongoDB Atlas)" -ForegroundColor Yellow
}

# Step 3: Generate ADMIN_API_KEY
Write-Host ""
Write-Host "🔐 Step 3: Generating Secure ADMIN_API_KEY..." -ForegroundColor Cyan
$adminApiKey = node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
Write-Host "✅ Generated: $adminApiKey" -ForegroundColor Green
Write-Host "   (Saving to clipboard and .env file)" -ForegroundColor Cyan
$adminApiKey | Set-Clipboard

# Step 4: Create .env file
Write-Host ""
Write-Host "📝 Step 4: Creating .env file from template..." -ForegroundColor Cyan

$backendDir = Join-Path $PSScriptRoot "backend"
$envExamplePath = Join-Path $backendDir ".env.example"
$envPath = Join-Path $backendDir ".env"

if (-not (Test-Path $envExamplePath)) {
    Write-Host "❌ .env.example not found at $envExamplePath" -ForegroundColor Red
    exit 1
}

if (Test-Path $envPath) {
    Write-Host "⚠️ .env already exists. Do you want to overwrite it?" -ForegroundColor Yellow
    $response = Read-Host "Enter 'yes' to overwrite, or 'no' to keep existing"
    if ($response -ne "yes") {
        Write-Host "Skipping .env creation" -ForegroundColor Cyan
    } else {
        Copy-Item $envExamplePath $envPath -Force
        Write-Host "✅ Created .env file" -ForegroundColor Green
    }
} else {
    Copy-Item $envExamplePath $envPath
    Write-Host "✅ Created .env file" -ForegroundColor Green
}

# Step 5: Update .env with ADMIN_API_KEY
Write-Host ""
Write-Host "🔑 Step 5: Updating .env with ADMIN_API_KEY..." -ForegroundColor Cyan
if (Test-Path $envPath) {
    $envContent = Get-Content $envPath
    $envContent = $envContent -replace 'ADMIN_API_KEY=.*', "ADMIN_API_KEY=$adminApiKey"
    Set-Content $envPath $envContent
    Write-Host "✅ Updated ADMIN_API_KEY in .env" -ForegroundColor Green
}

# Step 6: Install dependencies
Write-Host ""
Write-Host "📚 Step 6: Installing npm dependencies..." -ForegroundColor Cyan
Write-Host "This may take 1-2 minutes..." -ForegroundColor Cyan

Push-Location $backendDir
npm install --silent
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "❌ Failed to install dependencies" -ForegroundColor Red
    Pop-Location
    exit 1
}
Pop-Location

# Step 7: Test MongoDB connection string
Write-Host ""
Write-Host "🗄️  Step 7: MongoDB Setup" -ForegroundColor Cyan
Write-Host "Your .env has a placeholder MONGODB_URI" -ForegroundColor Yellow
Write-Host ""
Write-Host "Choose one:" -ForegroundColor Cyan
Write-Host "1. Use MongoDB Atlas (Cloud) - Recommended" -ForegroundColor Green
Write-Host "2. Use Local MongoDB" -ForegroundColor Yellow
Write-Host ""
$mongoChoice = Read-Host "Enter 1 or 2"

if ($mongoChoice -eq "1") {
    Write-Host ""
    Write-Host "📍 MongoDB Atlas Setup:" -ForegroundColor Cyan
    Write-Host "  1. Go to https://mongodb.com/cloud/atlas" -ForegroundColor White
    Write-Host "  2. Create free account" -ForegroundColor White
    Write-Host "  3. Create M0 cluster" -ForegroundColor White
    Write-Host "  4. Create database user" -ForegroundColor White
    Write-Host "  5. Get connection string" -ForegroundColor White
    Write-Host "  6. Replace MONGODB_URI in .env file" -ForegroundColor White
    Write-Host ""
    Write-Host "Keep .env file open and paste your MongoDB URI when ready" -ForegroundColor Green
} elseif ($mongoChoice -eq "2") {
    Write-Host ""
    Write-Host "📍 Local MongoDB Setup:" -ForegroundColor Cyan
    $mongoRunning = Get-Process mongod -ErrorAction SilentlyContinue
    if ($mongoRunning) {
        Write-Host "✅ MongoDB is running on port 27017" -ForegroundColor Green
        Write-Host "Connection string: mongodb://localhost:27017/studionex" -ForegroundColor Cyan
    } else {
        Write-Host "⚠️ MongoDB is not running" -ForegroundColor Yellow
        Write-Host "Start MongoDB with: mongod" -ForegroundColor Cyan
    }
}

# Step 8: Email Configuration
Write-Host ""
Write-Host "📧 Step 8: Email Configuration" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your .env needs SMTP credentials for email notifications" -ForegroundColor Yellow
Write-Host ""
Write-Host "📍 Gmail Setup (Recommended):" -ForegroundColor Cyan
Write-Host "  1. Go to https://myaccount.google.com/apppasswords" -ForegroundColor White
Write-Host "  2. Select 'Mail' and 'Windows Computer'" -ForegroundColor White
Write-Host "  3. Generate app password (16 chars)" -ForegroundColor White
Write-Host "  4. Copy and paste into .env:" -ForegroundColor White
Write-Host "     SMTP_USER=your-gmail@gmail.com" -ForegroundColor Cyan
Write-Host "     SMTP_PASS=your-16-char-app-password" -ForegroundColor Cyan
Write-Host ""
Write-Host "Keep .env file open and update these values" -ForegroundColor Green

# Step 9: Test the setup
Write-Host ""
Write-Host "🧪 Step 9: Testing Setup..." -ForegroundColor Cyan
Write-Host ""
Write-Host "Before starting server, ensure:" -ForegroundColor Yellow
Write-Host "  ✓ MONGODB_URI is set in .env" -ForegroundColor White
Write-Host "  ✓ SMTP_USER and SMTP_PASS are set in .env" -ForegroundColor White
Write-Host "  ✓ ADMIN_API_KEY is set (already done!)" -ForegroundColor Green
Write-Host ""

$testChoice = Read-Host 'Ready to test? Enter "yes" to start server, or "no" to exit'

if ($testChoice -eq "yes") {
    Write-Host ""
    Write-Host "🚀 Starting development server..." -ForegroundColor Green
    Write-Host "Server will run at http://localhost:3000" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Press Ctrl+C to stop the server" -ForegroundColor Yellow
    Write-Host ""
    
    Push-Location $backendDir
    npm start
    Pop-Location
} else {
    Write-Host ""
    Write-Host "✅ Setup complete!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Edit .env file with your MongoDB URI and SMTP credentials" -ForegroundColor White
    Write-Host "  2. Run: cd backend && npm start" -ForegroundColor White
    Write-Host "  3. Visit: http://localhost:3000" -ForegroundColor White
    Write-Host ""
    Write-Host "📌 Your ADMIN_API_KEY was copied to clipboard!" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
