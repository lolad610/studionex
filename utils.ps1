# Utility Commands - Common Tasks
# Run: .\utils.ps1

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  StudioNex - Utility Menu             ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "Available utilities:" -ForegroundColor Yellow
Write-Host ""
Write-Host "  1) 🔐 Generate New ADMIN_API_KEY" -ForegroundColor Green
Write-Host "  2) 📝 View/Edit .env File" -ForegroundColor Cyan
Write-Host "  3) 🧪 Test API Endpoints" -ForegroundColor Yellow
Write-Host "  4) 📊 Check Database Connection" -ForegroundColor Magenta
Write-Host "  5) 📧 Test Email Configuration" -ForegroundColor White
Write-Host "  6) 🚀 Start Local Dev Server" -ForegroundColor Green
Write-Host "  7) 📦 Install/Update Dependencies" -ForegroundColor Cyan
Write-Host "  8) 🧹 Clean Up (remove node_modules)" -ForegroundColor Yellow
Write-Host "  9) 💾 Backup .env File" -ForegroundColor Magenta
Write-Host " 10) 📋 View Application Logs" -ForegroundColor White
Write-Host ""
Write-Host "  0) ❌ Exit" -ForegroundColor Red
Write-Host ""

$choice = Read-Host "Enter your choice (0-10)"

switch ($choice) {
    "1" {
        # Generate new API key
        Write-Host ""
        Write-Host "🔐 Generating new ADMIN_API_KEY..." -ForegroundColor Green
        $newKey = node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
        Write-Host "✅ New Key: $newKey" -ForegroundColor Green
        Write-Host ""
        Write-Host "Copied to clipboard!" -ForegroundColor Cyan
        $newKey | Set-Clipboard
        Write-Host ""
        Write-Host "Update your .env file:" -ForegroundColor Yellow
        Write-Host "ADMIN_API_KEY=$newKey" -ForegroundColor White
    }
    
    "2" {
        # Edit .env file
        Write-Host ""
        Write-Host "📝 Opening .env file..." -ForegroundColor Green
        $envPath = "./backend/.env"
        if (Test-Path $envPath) {
            notepad $envPath
        } else {
            Write-Host "❌ .env file not found at $envPath" -ForegroundColor Red
        }
    }
    
    "3" {
        # Test API endpoints
        Write-Host ""
        Write-Host "🧪 Testing API Endpoints..." -ForegroundColor Green
        Write-Host ""
        
        $url = Read-Host "Enter server URL (default: http://localhost:3000)"
        if ([string]::IsNullOrWhiteSpace($url)) {
            $url = "http://localhost:3000"
        }
        
        # Test ping endpoint
        Write-Host ""
        Write-Host "Testing: GET $url/api/ping" -ForegroundColor Cyan
        try {
            $result = Invoke-RestMethod -Uri "$url/api/ping" -TimeoutSec 5
            Write-Host "✅ Response:" -ForegroundColor Green
            Write-Host ($result | ConvertTo-Json) -ForegroundColor White
        } catch {
            Write-Host "❌ Error: $_" -ForegroundColor Red
        }
        
        # Test stats endpoint (requires API key)
        Write-Host ""
        $apiKey = Read-Host "Enter ADMIN_API_KEY to test protected endpoints (or press Enter to skip)"
        
        if (-not [string]::IsNullOrWhiteSpace($apiKey)) {
            Write-Host ""
            Write-Host "Testing: GET $url/api/stats" -ForegroundColor Cyan
            try {
                $headers = @{ "x-api-key" = $apiKey }
                $result = Invoke-RestMethod -Uri "$url/api/stats" -Headers $headers -TimeoutSec 5
                Write-Host "✅ Response:" -ForegroundColor Green
                Write-Host ($result | ConvertTo-Json) -ForegroundColor White
            } catch {
                Write-Host "❌ Error: $_" -ForegroundColor Red
            }
        }
    }
    
    "4" {
        # Check database connection
        Write-Host ""
        Write-Host "📊 Testing MongoDB Connection..." -ForegroundColor Green
        Write-Host ""
        
        $mongoUri = Read-Host "Enter MongoDB connection string"
        
        Write-Host ""
        Write-Host "Attempting connection..." -ForegroundColor Cyan
        
        try {
            # Try connecting with mongosh
            mongosh $mongoUri --eval "db.adminCommand('ping')" 2>$null
            Write-Host "✅ MongoDB connection successful!" -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Could not verify connection" -ForegroundColor Yellow
            Write-Host "Ensure MongoDB is running and URI is correct" -ForegroundColor Yellow
        }
    }
    
    "5" {
        # Test email configuration
        Write-Host ""
        Write-Host "📧 Testing Email Configuration..." -ForegroundColor Green
        Write-Host ""
        
        $smtpHost = Read-Host "SMTP Host (e.g., smtp.gmail.com)"
        $smtpPort = Read-Host "SMTP Port (e.g., 587)"
        $smtpUser = Read-Host "SMTP User (email)"
        $smtpPass = Read-Host "SMTP Password" -AsSecureString
        $testEmail = Read-Host "Send test email to"
        
        Write-Host ""
        Write-Host "Sending test email..." -ForegroundColor Cyan
        
        try {
            $emailParams = @{
                SmtpServer = $smtpHost
                Port = $smtpPort
                UseSsl = $true
                Credential = New-Object System.Management.Automation.PSCredential($smtpUser, $smtpPass)
                From = $smtpUser
                To = $testEmail
                Subject = "StudioNex - SMTP Test"
                Body = "If you received this, your email is configured correctly!"
            }
            
            Send-MailMessage @emailParams
            Write-Host "✅ Test email sent successfully!" -ForegroundColor Green
            Write-Host "Check your inbox for the test email" -ForegroundColor Cyan
        } catch {
            Write-Host "❌ Failed to send email: $_" -ForegroundColor Red
            Write-Host "Common issues:" -ForegroundColor Yellow
            Write-Host "- Wrong password (use app-specific password for Gmail)" -ForegroundColor White
            Write-Host "- Wrong SMTP host or port" -ForegroundColor White
            Write-Host "- Firewall blocking SMTP port" -ForegroundColor White
        }
    }
    
    "6" {
        # Start dev server
        Write-Host ""
        Write-Host "🚀 Starting Development Server..." -ForegroundColor Green
        Write-Host ""
        Write-Host "Server will start at http://localhost:3000" -ForegroundColor Cyan
        Write-Host "Press Ctrl+C to stop" -ForegroundColor Yellow
        Write-Host ""
        
        Push-Location "backend"
        npm start
        Pop-Location
    }
    
    "7" {
        # Install/update dependencies
        Write-Host ""
        Write-Host "📦 Managing Dependencies..." -ForegroundColor Green
        Write-Host ""
        Write-Host "  1) Install dependencies" -ForegroundColor White
        Write-Host "  2) Update all packages" -ForegroundColor White
        Write-Host "  3) Check for vulnerabilities" -ForegroundColor White
        Write-Host ""
        
        $subChoice = Read-Host "Enter choice (1-3)"
        
        Push-Location "backend"
        
        switch ($subChoice) {
            "1" {
                Write-Host ""
                Write-Host "Installing dependencies..." -ForegroundColor Cyan
                npm install
                Write-Host "✅ Done!" -ForegroundColor Green
            }
            "2" {
                Write-Host ""
                Write-Host "Updating packages..." -ForegroundColor Cyan
                npm update
                Write-Host "✅ Done!" -ForegroundColor Green
            }
            "3" {
                Write-Host ""
                Write-Host "Auditing for vulnerabilities..." -ForegroundColor Cyan
                npm audit
            }
        }
        
        Pop-Location
    }
    
    "8" {
        # Clean up
        Write-Host ""
        Write-Host "🧹 Cleaning Up..." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "This will remove node_modules folder (can reinstall with: npm install)" -ForegroundColor Yellow
        $confirm = Read-Host "Continue? (yes/no)"
        
        if ($confirm -eq "yes") {
            Write-Host ""
            Write-Host "Removing node_modules..." -ForegroundColor Cyan
            
            $nodePath = "./backend/node_modules"
            if (Test-Path $nodePath) {
                Remove-Item -Recurse -Force $nodePath
                Write-Host "✅ Cleanup complete!" -ForegroundColor Green
            } else {
                Write-Host "No node_modules found" -ForegroundColor Cyan
            }
        } else {
            Write-Host "Cancelled" -ForegroundColor Yellow
        }
    }
    
    "9" {
        # Backup .env
        Write-Host ""
        Write-Host "💾 Backing Up .env File..." -ForegroundColor Green
        Write-Host ""
        
        $envPath = "./backend/.env"
        if (Test-Path $envPath) {
            $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
            $backupPath = "./backend/.env.backup.$timestamp"
            
            Copy-Item $envPath $backupPath
            Write-Host "✅ Backup created: $backupPath" -ForegroundColor Green
        } else {
            Write-Host "❌ .env file not found" -ForegroundColor Red
        }
    }
    
    "10" {
        # View logs
        Write-Host ""
        Write-Host "📋 Viewing Logs..." -ForegroundColor Green
        Write-Host ""
        Write-Host "  1) PM2 logs (if deployed with PM2)" -ForegroundColor White
        Write-Host "  2) Heroku logs (if deployed on Heroku)" -ForegroundColor White
        Write-Host ""
        
        $subChoice = Read-Host "Enter choice (1-2)"
        
        switch ($subChoice) {
            "1" {
                Write-Host ""
                Write-Host "PM2 logs:" -ForegroundColor Cyan
                pm2 logs studionex
            }
            "2" {
                Write-Host ""
                Write-Host "Heroku logs:" -ForegroundColor Cyan
                heroku logs --tail
            }
        }
    }
    
    "0" {
        Write-Host "Goodbye!" -ForegroundColor Green
        exit 0
    }
    
    default {
        Write-Host "Invalid choice!" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
