# 🚀 PowerShell Deployment Scripts Guide

**Complete automation for deploying StudioNex!**

---

## 📋 Scripts Included

| Script | Purpose | Use When |
|--------|---------|----------|
| `setup.ps1` | Auto-setup environment | First time setup |
| `deploy.ps1` | Main menu | Choose deployment option |
| `deploy-vercel.ps1` | Deploy to Vercel | Want easiest deployment |
| `deploy-heroku.ps1` | Deploy to Heroku | Want simple deployment |
| `deploy-gcp.ps1` | Deploy to Google Cloud | Want advanced control |

---

## ⚡ Quick Start (5 Minutes)

### **Step 1: Run Setup Script**

```powershell
# Right-click on setup.ps1 → Run with PowerShell
# OR
.\setup.ps1
```

**What it does:**
- ✅ Checks Node.js is installed
- ✅ Generates ADMIN_API_KEY
- ✅ Creates .env file
- ✅ Installs npm dependencies
- ✅ Prompts for MongoDB and email setup

---

### **Step 2: Edit .env File**

After setup completes, edit `backend\.env`:

```bash
# Paste your MongoDB URI
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/studionex

# Paste your Gmail app password
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-16-char-app-password
ADMIN_EMAIL=your-email@gmail.com

# Update URLs (optional)
FRONTEND_URL=https://your-domain.com
ADMIN_DASHBOARD_URL=https://your-domain.com/admin.html
```

---

### **Step 3: Deploy**

```powershell
# Right-click on deploy.ps1 → Run with PowerShell
# OR
.\deploy.ps1
```

**Choose option:**
1. Vercel (easiest)
2. Heroku (simple)
3. Google Cloud (advanced)
4. Local development (testing)

---

## 🟢 Detailed: Vercel Deployment (Easiest)

### **Prerequisites**
- Vercel account (free at https://vercel.com)
- MongoDB Atlas URI
- Email credentials

### **Steps**

```powershell
# Run deployment menu
.\deploy.ps1

# Select option 1 (Vercel)
# Follow the prompts:
# 1. Login with GitHub/Google
# 2. Choose to deploy to production or preview
# 3. Wait for deployment (2-3 mins)
```

### **What Happens**
- Creates project on Vercel
- Sets environment variables
- Deploys your backend
- Gives you live URL

### **Your URL**
```
https://your-app.vercel.app
```

---

## 🟡 Detailed: Heroku Deployment (Simple)

### **Prerequisites**
- Heroku account (free at https://heroku.com)
- Heroku CLI installed
- MongoDB Atlas URI
- Email credentials

### **Steps**

```powershell
# Run deployment menu
.\deploy.ps1

# Select option 2 (Heroku)
# Follow the prompts:
# 1. Login with email/password
# 2. Enter app name (e.g., "studionex")
# 3. Enter environment variables
# 4. Wait for deployment (3-5 mins)
```

### **What Happens**
- Creates app on Heroku
- Installs dependencies
- Deploys your backend
- Gives you live URL

### **Your URL**
```
https://your-app-name.herokuapp.com
```

---

## 🔵 Detailed: Google Cloud Deployment (Advanced)

### **Prerequisites**
- Google Cloud account (free tier available)
- Google Cloud SDK installed
- MongoDB Atlas URI
- Email credentials

### **Steps**

```powershell
# Run deployment menu
.\deploy.ps1

# Select option 3 (Google Cloud)
# Follow the prompts:
# 1. Login with your Google account
# 2. Enter Google Cloud Project ID
# 3. Build Docker image (3-5 mins)
# 4. Deploy to Cloud Run
```

### **What Happens**
- Builds Docker container
- Pushes to Container Registry
- Deploys to Cloud Run
- Gives you live URL

### **Your URL**
```
https://studionex-xxx-uc.a.run.app
```

---

## 🔧 Script Troubleshooting

### **"Cannot run script, execution policy"**

```powershell
# Run this ONCE as Administrator
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Then try again
.\setup.ps1
```

---

### **"Node.js not found"**

```powershell
# Check if Node is installed
node --version

# If not installed, download from:
# https://nodejs.org/
```

---

### **"MongoDB not connecting"**

```powershell
# Check your MONGODB_URI in .env
# Format should be:
# mongodb+srv://user:password@cluster.mongodb.net/studionex

# Or for local:
# mongodb://localhost:27017/studionex

# Test connection with mongosh:
mongosh "your-connection-string"
```

---

### **"Email not sending"**

```powershell
# Verify in .env:
# SMTP_HOST=smtp.gmail.com
# SMTP_PORT=587
# SMTP_USER=your-gmail@gmail.com
# SMTP_PASS=your-app-specific-password

# Get app password from:
# https://myaccount.google.com/apppasswords
```

---

## 📊 Deployment Comparison

| Feature | Vercel | Heroku | Google Cloud |
|---------|--------|--------|--------------|
| **Ease** | ⭐⭐⭐ | ⭐⭐ | ⭐ |
| **Cost** | Free | $7/mo after free | Free (first 100 requests) |
| **Speed** | Very Fast | Fast | Fast |
| **Setup** | 5 mins | 10 mins | 15 mins |
| **Recommended** | ✅ YES | Good option | Advanced users |

---

## 🎯 Recommended Flow

### **First Time Deploy (New Users)**

```
1. Run setup.ps1
2. Configure MongoDB Atlas (5 mins)
3. Configure Gmail (2 mins)
4. Run deploy.ps1
5. Choose Vercel (easiest)
6. Done! ✅
```

### **Total Time: 20-30 minutes**

---

## 🔐 Security Notes

**After Deployment:**

```powershell
# NEVER share these in public:
# - ADMIN_API_KEY
# - MONGODB_URI
# - SMTP_PASS

# Keep in .env only
# Never commit .env to GitHub
# It's in .gitignore for this reason
```

---

## 📈 Monitor Your Deployment

### **Vercel**
```
Visit: https://vercel.com/dashboard
See: Real-time logs and performance
```

### **Heroku**
```powershell
# View logs
heroku logs --tail

# Monitor performance
heroku ps

# Check environment variables
heroku config
```

### **Google Cloud**
```
Visit: https://console.cloud.google.com
See: Real-time metrics and logs
```

---

## 🆘 Need Help?

**Common Issues:**

1. **"Script won't run"** → Right-click → Run with PowerShell → Yes to UAC prompt
2. **"Need admin"** → Right-click PowerShell → Run as Administrator
3. **"Can't find Node"** → Install from nodejs.org, restart terminal
4. **"MongoDB error"** → Create MongoDB Atlas account, get connection string
5. **"Email error"** → Get Gmail app password, not regular password

---

## 🚀 After Deployment

### **Test Your Live App**

```powershell
# Test form submission
$uri = "https://your-live-url.com/api/ping"
Invoke-RestMethod -Uri $uri

# Should return:
# status  : ok
# message : StudioNex API is running
```

### **Setup Google Search Console**

```
1. Go to https://search.google.com/search-console
2. Add your domain
3. Verify ownership (paste meta tag from .env)
4. Submit sitemap
```

### **Setup Analytics**

```
1. Create Google Analytics 4 property
2. Get Measurement ID (G-XXXXX)
3. Update index.html
4. Redeploy
```

---

## 📋 Checklist Before Going Live

- [ ] MongoDB URI configured
- [ ] Email credentials configured
- [ ] ADMIN_API_KEY generated
- [ ] .env file created
- [ ] npm dependencies installed
- [ ] Tested locally with `npm start`
- [ ] All 4 errors fixed (CSS)
- [ ] No visual changes made
- [ ] Deployment script ran successfully
- [ ] Live URL working
- [ ] Form submission tested
- [ ] Admin API tested with API key
- [ ] Sitemap submitted to Google
- [ ] Analytics setup complete

---

## 🎉 You're All Set!

Everything is automated. Just run the scripts and follow the prompts!

**Total setup time: 30-45 minutes**  
**Total deployment time: 5-15 minutes**

🚀 **You're going live today!**
