# ⚡ Quick Reference Card

## 🚀 3-Step Launch (15-30 minutes)

```powershell
# Step 1: Setup (2 min)
.\setup.ps1

# Step 2: Configure
# Edit backend\.env with MongoDB URI and Gmail app password

# Step 3: Deploy (5-15 min)
.\deploy.ps1
# Choose: 1 (Vercel - easiest), 2 (Heroku), 3 (Google Cloud), 4 (Local Dev)
```

---

## 📚 Documentation Quick Links

| Need | File | Time |
|------|------|------|
| Just launch now? | START_HERE.md | 5 min |
| Full deployment guide? | DEPLOYMENT_GUIDE.md | 350 lines |
| Security setup? | SECURITY_CHECKLIST.md | 400 lines |
| PowerShell automation? | POWERSHELL_DEPLOYMENT_GUIDE.md | 350 lines |
| What's included? | STATUS_REPORT.md | 150 lines |
| Full project info? | README.md | Complete |

---

## 🛠️ Common Commands

```powershell
# Setup environment
.\setup.ps1

# Deploy to production
.\deploy.ps1

# Utility menu (10 tools)
.\utils.ps1

# Start local dev server
.\utils.ps1  # Choose option 6

# Test API endpoints
.\utils.ps1  # Choose option 3

# Test email setup
.\utils.ps1  # Choose option 5

# Generate new API key
.\utils.ps1  # Choose option 1

# View .env file
.\utils.ps1  # Choose option 2

# Check database connection
.\utils.ps1  # Choose option 4

# Clean up node_modules
.\utils.ps1  # Choose option 8

# View logs
.\utils.ps1  # Choose option 10
```

---

## 🔐 Essential Configuration

### 1. MongoDB URI (Required)
Get free at: https://www.mongodb.com/cloud/atlas

Add to `backend/.env`:
```env
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/studionex
```

### 2. Gmail SMTP (Required)
1. Enable 2-factor on Gmail
2. Get app password: https://myaccount.google.com/apppasswords
3. Add to `backend/.env`:
```env
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-specific-password
```

### 3. ADMIN_API_KEY (Auto-Generated)
✅ Generated automatically by `setup.ps1`
```env
ADMIN_API_KEY=auto-generated-by-setup
```

---

## 🌐 Deployment Comparison

| Platform | Speed | Cost | Setup Time |
|----------|-------|------|-----------|
| **Vercel** ⭐ | ⚡ Fastest | Free | 2 min |
| **Heroku** | Fast | Free tier | 3 min |
| **Google Cloud** | Very fast | Pay-per-use | 5 min |
| **Local Dev** | Instant | Free | 1 min |

**Recommendation**: Start with **Vercel** (easiest, fastest, free)

---

## ✅ Success Indicators

### Setup Complete ✓
- [ ] Node.js installed (`node --version`)
- [ ] `setup.ps1` ran successfully
- [ ] `.env` file created with credentials
- [ ] `npm install` completed without errors

### Testing Complete ✓
- [ ] `.\utils.ps1` option 6 (dev server) starts
- [ ] Website loads at http://localhost:3000
- [ ] Form submits without errors
- [ ] Email received after submission
- [ ] MongoDB shows new entry

### Deployment Complete ✓
- [ ] `.\deploy.ps1` finished successfully
- [ ] Live URL provided
- [ ] Website loads and works
- [ ] API endpoints responding
- [ ] Admin dashboard accessible

---

## 🎯 API Endpoints

| Endpoint | Method | Auth | Purpose |
|----------|--------|------|---------|
| `/api/ping` | GET | No | Health check |
| `/api/contact` | POST | No | Form submission |
| `/api/submissions` | GET | Yes* | List all submissions |
| `/api/submissions/:id` | GET | Yes* | Get single submission |
| `/api/submissions/:id` | PUT | Yes* | Update submission |
| `/api/submissions/:id` | DELETE | Yes* | Delete submission |
| `/api/stats` | GET | Yes* | Dashboard stats |

*Yes = Requires `ADMIN_API_KEY` header

**Test with**:
```powershell
.\utils.ps1  # Choose option 3 (Test API Endpoints)
```

---

## 🔒 Security Summary

✅ All features enabled and configured:
- API key authentication
- Rate limiting (100 req/15min)
- HTTPS ready
- Security headers (Helmet.js)
- Input validation
- CORS protection
- XSS prevention
- Sensitive file blocking

See: **SECURITY_CHECKLIST.md** for full details

---

## 🌐 SEO Status

✅ Fully optimized:
- 9 JSON-LD schemas
- Meta tags (title, description, keywords)
- Open Graph tags (Facebook)
- Twitter Card
- robots.txt
- sitemap.xml
- Mobile responsive
- Fast loading

**Next**: Submit sitemap to Google Search Console

---

## 🐛 If Something Breaks

```powershell
# 1. Check node_modules
cd backend
npm install

# 2. Check .env file
.\utils.ps1  # Option 2 (View .env)

# 3. Test connection
.\utils.ps1  # Option 4 (Check database)

# 4. Clean and reinstall
.\utils.ps1  # Option 8 (Clean up)
npm install

# 5. View logs
.\utils.ps1  # Option 10 (View logs)
```

Full troubleshooting: **DEPLOYMENT_GUIDE.md** → Troubleshooting section

---

## 📞 Where to Get Help

| Issue | Solution |
|-------|----------|
| "How do I start?" | Read START_HERE.md (5 min) |
| "How do I deploy?" | Run .\deploy.ps1 (automated) |
| "Server won't start" | Run .\utils.ps1 option 6 + check .env |
| "Email not sending" | Run .\utils.ps1 option 5 (test email) |
| "Can't access admin" | Check ADMIN_API_KEY in .env |
| "Database not connecting" | Run .\utils.ps1 option 4 (test DB) |

---

## 📋 Project Contents

✅ **Frontend** (index.html - 2,983 lines)
- Hero section with animations
- 6 service cards
- 3-tier pricing
- 6 testimonials
- 8-item FAQ
- Contact form
- 100% SEO optimized

✅ **Backend** (Express.js)
- 7 REST API endpoints
- MongoDB integration
- Email notifications
- Admin authentication

✅ **Admin Dashboard** (admin.html)
- View submissions
- Filter & search
- Update status
- Admin notes

✅ **Automation** (5 PowerShell scripts)
- Auto-setup environment
- Deploy to Vercel/Heroku/GCP
- Utility commands

✅ **Security**
- API authentication
- Rate limiting
- HTTPS ready
- Input validation

✅ **SEO**
- 9 JSON-LD schemas
- Complete meta tags
- robots.txt
- sitemap.xml

---

## 💡 Pro Tips

1. **Use Vercel** - Easiest deployment, just 2 minutes
2. **Test locally first** - Run `.\utils.ps1` option 6
3. **Save API key** - Keep ADMIN_API_KEY in password manager
4. **Backup .env** - Run `.\utils.ps1` option 9 regularly
5. **Monitor logs** - Run `.\utils.ps1` option 10 after deployment

---

## 🎉 Ready to Launch?

**Follow these 3 steps:**

```powershell
# 1. Setup (2 min)
.\setup.ps1

# 2. Configure (edit .env with credentials)

# 3. Deploy (5-15 min)
.\deploy.ps1
```

**Your professional Roblox scripting agency website will be LIVE!** 🚀

---

**Questions?** Read START_HERE.md for 5-minute overview  
**Full guide?** Read DEPLOYMENT_GUIDE.md (350 lines)  
**Power user?** Read POWERSHELL_DEPLOYMENT_GUIDE.md (350 lines)
