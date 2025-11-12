# 🚀 StudioNex Deployment & Setup Guide

Complete guide to setup, configure, and deploy StudioNex backend with security best practices.

---

## 🔐 CRITICAL SECURITY SETUP (DO THIS FIRST!)

### **1. Generate Secure ADMIN_API_KEY**

```powershell
# Windows PowerShell
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Output: 64-character random string
# Copy this and paste into .env
```

**Why?** Protects your admin API endpoints from unauthorized access.

---

### **2. Create .env File from Template**

```powershell
# In backend folder
Copy-Item .env.example .env
```

Then edit `.env` and fill in:

```bash
# REQUIRED - Security
ADMIN_API_KEY=paste-your-64-char-key-here

# REQUIRED - Database
MONGODB_URI=mongodb+srv://user:pass@cluster.mongodb.net/studionex

# REQUIRED - Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
ADMIN_EMAIL=your-email@gmail.com

# REQUIRED - URLs
FRONTEND_URL=https://studionex.com
ADMIN_DASHBOARD_URL=https://studionex.com/admin.html

# Server
PORT=3000
NODE_ENV=production
```

**CRITICAL**: Never commit .env to git! It's in .gitignore for this reason.

---

### **3. Setup MongoDB**

**Option A: Local (Development)**
```bash
# Install MongoDB
# macOS: brew install mongodb-community
# Ubuntu: sudo apt install mongodb
# Windows: Download from https://www.mongodb.com/try/download/community

# Start MongoDB
mongod

# Connection string
MONGODB_URI=mongodb://localhost:27017/studionex
```

**Option B: MongoDB Atlas Cloud (Recommended for Production)**

1. Go to https://www.mongodb.com/cloud/atlas
2. Create free account
3. Create M0 free cluster
4. Create database user with strong password
5. Whitelist your IP address (allow 0.0.0.0/0 for development)
6. Get connection string: `mongodb+srv://username:password@cluster.mongodb.net/studionex`
7. Paste in `.env`

---

### **4. Setup Email (Gmail)**

**Gmail App Password Setup:**

1. Enable 2-Factor Authentication: https://myaccount.google.com/security
2. Go to App Passwords: https://myaccount.google.com/apppasswords
3. Select "Mail" and "Windows Computer"
4. Generate 16-character password
5. Copy password to `.env`:

```bash
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=16-character-app-password
ADMIN_EMAIL=your-email@gmail.com
```

---

### **5. Verify Security Configuration**

Check that these are already done:

- ✅ `.env` is in `.gitignore` (never commit secrets!)
- ✅ Helmet.js enabled (security headers)
- ✅ CORS configured (server.js)
- ✅ Rate limiting enabled (100 req/15min)
- ✅ Input validation (ContactSubmission schema)
- ✅ API authentication required (admin endpoints)
- ✅ Sensitive files blocked (.env, .git, .htaccess)
- ✅ HTTPS enforced (.htaccess / nginx.conf)

---

## 🔧 Development Setup

### **Local Testing**

```powershell
# 1. Install dependencies
cd backend
npm install

# 2. Verify .env is configured
# Check all REQUIRED fields above

# 3. Start development server
npm start

# Output should show:
# Server listening on port 3000
# MongoDB connected
```

### **Test Form Submission**

```powershell
# Test POST /api/contact
$body = @{
    name = "Test User"
    email = "test@example.com"
    discord = "testuser#1234"
    service = "Game Systems Development"
    budget = "$1000-$2500"
    details = "Test project"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://localhost:3000/api/contact" `
    -Method POST `
    -ContentType "application/json" `
    -Body $body
```

### **Test Admin API**

```powershell
# Replace with your ADMIN_API_KEY from .env
$headers = @{ "x-api-key" = "your-admin-api-key-here" }

# Get stats
Invoke-RestMethod -Uri "http://localhost:3000/api/stats" -Headers $headers

# Get submissions
Invoke-RestMethod -Uri "http://localhost:3000/api/submissions?page=1&limit=10" -Headers $headers
```

---

## 📦 Production Deployment

### **Option 1: Vercel (Easiest)**

```powershell
# Install Vercel CLI
npm install -g vercel

# Login
vercel login

# Deploy
cd backend
vercel --prod

# Set environment variables when prompted
# You'll paste each .env value
```

**Pros**: Free tier, auto-HTTPS, auto-scaling, easy deployment  
**Cons**: Cold starts on free tier, limited database options

---

### **Option 2: Heroku**

```powershell
# Install Heroku CLI & login
heroku login

# Create app
heroku create studionex

# Add MongoDB add-on (optional - use Atlas instead)
# heroku addons:create mongolab:sandbox

# Set environment variables
heroku config:set ADMIN_API_KEY="your-key"
heroku config:set MONGODB_URI="your-uri"
heroku config:set SMTP_HOST="smtp.gmail.com"
heroku config:set SMTP_PORT="587"
heroku config:set SMTP_USER="your-email"
heroku config:set SMTP_PASS="your-password"
heroku config:set NODE_ENV="production"
heroku config:set FRONTEND_URL="https://studionex.com"
heroku config:set ADMIN_DASHBOARD_URL="https://studionex.com/admin.html"

# Deploy
git push heroku main

# View logs
heroku logs --tail
```

**Pros**: Simple, includes free SSL, good documentation  
**Cons**: Costs $7+/month after free tier, slower than dedicated servers

---

### **Option 3: Linux VPS (Best Control)**

#### **Step 1: Server Setup (Ubuntu 20.04+)**

```bash
# SSH into server
ssh root@your-server-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Install PM2 (process manager)
sudo npm install -g pm2

# Install Nginx (web server)
sudo apt install -y nginx

# Install Certbot (SSL/HTTPS)
sudo apt install -y certbot python3-certbot-nginx

# Install MongoDB (optional - use Atlas instead)
# curl -fsSL https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
# echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list
# sudo apt update && sudo apt install -y mongodb-org
```

#### **Step 2: Clone Project**

```bash
# Navigate to home directory
cd ~

# Clone your repository
git clone https://github.com/yourusername/studionex.git
cd studionex/backend

# Install dependencies
npm install

# Copy .env.example to .env
cp ../.env.example .env

# Edit .env with your values
nano .env
# Fill in all REQUIRED fields
```

#### **Step 3: Start with PM2**

```bash
# Start server
pm2 start server.js --name studionex

# Save startup script
pm2 startup
pm2 save

# Check status
pm2 status
pm2 logs studionex
```

#### **Step 4: Setup Nginx Reverse Proxy**

```bash
# Remove default Nginx config
sudo rm /etc/nginx/sites-enabled/default

# Create new config
sudo nano /etc/nginx/sites-available/studionex
```

Paste this config:

```nginx
server {
    listen 80;
    server_name studionex.com www.studionex.com;

    # Redirect HTTP to HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name studionex.com www.studionex.com;

    # SSL certificates (added by certbot)
    ssl_certificate /etc/letsencrypt/live/studionex.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/studionex.com/privkey.pem;

    # Security headers
    add_header Strict-Transport-Security "max-age=31536000" always;
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;

    # Gzip compression
    gzip on;
    gzip_types text/plain text/css application/json application/javascript;

    # Reverse proxy to Node.js
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Enable it:

```bash
sudo ln -s /etc/nginx/sites-available/studionex /etc/nginx/sites-enabled/
sudo nginx -t  # Test config
sudo systemctl restart nginx
```

#### **Step 5: Setup SSL (HTTPS)**

```bash
# Get free SSL certificate from Let's Encrypt
sudo certbot --nginx -d studionex.com -d www.studionex.com

# Auto-renewal check
sudo systemctl timer-list | grep certbot
```

#### **Step 6: Monitor Server**

```bash
# Monitor application
pm2 monit

# View logs
pm2 logs studionex

# View system resources
top
df -h  # Disk space
free -h  # Memory

# Check Nginx
sudo systemctl status nginx
sudo tail -f /var/log/nginx/error.log
```

---

## 🐛 Troubleshooting

### **MongoDB Connection Error**

```
Error: connect ECONNREFUSED 127.0.0.1:27017
```

**Solutions:**
1. Check MongoDB is running: `mongod`
2. Verify MONGODB_URI in .env
3. If using Atlas, check IP whitelist: https://cloud.mongodb.com/v2
4. Check firewall: `sudo ufw allow 27017`

---

### **Email Not Sending**

**Gmail:**
- Verify app password at https://myaccount.google.com/apppasswords
- Use "App password" NOT regular password
- Enable 2FA first if not done
- Check spam folder

**Custom SMTP:**
- Verify host, port, credentials
- Check firewall: `sudo ufw allow 587`
- Test with: `telnet smtp.example.com 587`

---

### **CORS Error**

```
Access to XMLHttpRequest blocked by CORS policy
```

**Solution:**
1. Check FRONTEND_URL in .env matches your domain
2. Restart server: `pm2 restart studionex`
3. Clear browser cache

---

### **Port 3000 Already in Use**

```powershell
# Windows: Find process using port 3000
Get-Process -Id (Get-NetTCPConnection -LocalPort 3000).OwningProcess

# Kill process (replace PID)
Stop-Process -Id PID -Force

# OR change port in .env
# PORT=3001
```

---

### **SSL Certificate Issues**

```bash
# Check certificate expiry
openssl x509 -enddate -noout -in /etc/letsencrypt/live/studionex.com/cert.pem

# Renew manually
sudo certbot renew --dry-run

# Force renewal
sudo certbot renew --force-renewal
```

---

## 📊 Monitoring & Maintenance

### **Daily**
- Check PM2 status: `pm2 status`
- Check error logs: `pm2 logs studionex`
- Monitor CPU/Memory: `top`

### **Weekly**
- Check disk space: `df -h`
- Review access logs: `tail -f /var/log/nginx/access.log`
- Backup database (if not using cloud)

### **Monthly**
- Update Node packages: `npm update`
- Check security updates: `npm audit`
- Monitor SSL certificate expiry

### **Useful Commands**

```bash
# Restart application
pm2 restart studionex

# Stop application
pm2 stop studionex

# Start application
pm2 start studionex

# View real-time logs
pm2 logs studionex --lines 100

# Save PM2 config
pm2 save

# Recover PM2 after reboot
pm2 startup
```

---

## ✅ Pre-Deployment Checklist

Before going live, verify:

- [ ] ADMIN_API_KEY is secure (32+ characters)
- [ ] MONGODB_URI is set and working
- [ ] SMTP credentials are correct
- [ ] FRONTEND_URL and ADMIN_DASHBOARD_URL are correct
- [ ] .env is in .gitignore (never commit secrets)
- [ ] All dependencies installed: `npm install`
- [ ] Test form submission locally
- [ ] Test admin API with your API key
- [ ] HTTPS is enabled (SSL certificate)
- [ ] Firewall allows ports 80, 443, 3000
- [ ] Database has backups
- [ ] PM2 startup script is configured
- [ ] Nginx is configured correctly
- [ ] DNS records point to your server

---

## 📈 Performance Optimization

### **Database Indexing**
Already done in `ContactSubmission.js`:
- Email index (fast lookups)
- Status index (fast filtering)
- Submitted date index (fast sorting)

### **Caching**
Add HTTP caching headers in Nginx:

```nginx
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 30d;
    add_header Cache-Control "public, immutable";
}
```

### **Rate Limiting**
Already enabled:
- 100 requests per 15 minutes per IP
- Prevents brute force attacks
- Prevents DDoS

---

## 🎯 Next Steps

1. **Setup .env** with all REQUIRED values
2. **Test locally** with `npm start`
3. **Choose deployment** option (Vercel, Heroku, or VPS)
4. **Deploy** and test live
5. **Monitor** with PM2 and server logs
6. **Backup** database regularly

---

## 📞 Need Help?

- **Deployment issues?** Check error logs: `pm2 logs studionex`
- **Connection issues?** Verify .env values and firewall
- **Security concerns?** Review `.env.example` documentation
- **Performance problems?** Check server resources: `top`, `df -h`

Good luck with your deployment! 🚀
