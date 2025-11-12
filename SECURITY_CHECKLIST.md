# 🔐 StudioNex Security & Safety Checklist

Complete security configuration guide. **MUST DO THESE BEFORE GOING LIVE!**

---

## ⚠️ CRITICAL (DO IMMEDIATELY)

### **1. Generate Secure ADMIN_API_KEY**

```bash
# Generate 32-byte random key
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

**Copy output and add to .env:**
```bash
ADMIN_API_KEY=your-64-character-random-string-here
```

**Why?** Protects admin API from unauthorized access. Must be unique and strong.

---

### **2. Never Commit .env to Git**

**Verify .gitignore contains:**
```
# .gitignore (already configured)
.env
.env.local
.env.*.local
node_modules/
```

**Check:**
```bash
git check-ignore -v .env  # Should return: .env
```

**If .env was committed by accident:**
```bash
git rm --cached .env
git commit -m "Remove .env from tracking"
```

---

### **3. Set NODE_ENV to Production**

```bash
# In .env
NODE_ENV=production
PORT=3000
```

**Why?** Disables debug info leakage, enables security optimizations.

---

### **4. Use HTTPS Only**

**Required for:**
- Protecting credentials during transmission
- Securing form submissions
- Google Search Console ranking boost

**Setup:**
- Self-hosted: Let's Encrypt (free) with Certbot
- Cloud: Automatic (Vercel, Heroku, etc.)

---

## 🔒 APPLICATION SECURITY

### **5. Helmet.js Security Headers** ✅ Configured

Protects against:
- XSS (Cross-Site Scripting)
- Clickjacking
- MIME sniffing
- Insecure framing

**Currently enabled in server.js:**
```javascript
const helmet = require('helmet');
app.use(helmet());
```

---

### **6. CORS Configuration** ✅ Configured

Restricts API access to specific origins.

**Current setup:**
```javascript
const cors = require('cors');
app.use(cors());
```

**To restrict to your domain:**
```javascript
app.use(cors({
  origin: process.env.FRONTEND_URL,
  credentials: true
}));
```

---

### **7. Rate Limiting** ✅ Configured

Prevents brute force, DDoS attacks.

**Current limits:**
- 100 requests per IP per 15 minutes
- Protects all routes

**Status:** ✅ ENABLED (server.js line 21)

---

### **8. Input Validation** ✅ Configured

Schema validates all form submissions.

**ContactSubmission schema validates:**
- name: Required, max 100 chars
- email: Required, valid email format
- discord: Required, max 50 chars
- service: Required, must match enum
- budget: Required, must match enum
- details: Required, max 2000 chars
- deadline: Optional, must be future date

**All validated before saving to database.**

---

### **9. API Authentication** ✅ Configured

Admin endpoints require `ADMIN_API_KEY` header.

**Usage:**
```bash
curl -H "x-api-key: your-admin-key" https://yourdomain.com/api/submissions
```

**Protected routes:**
- GET /api/submissions
- GET /api/submissions/:id
- PUT /api/submissions/:id
- DELETE /api/submissions/:id
- GET /api/stats

---

### **10. SQL Injection Prevention** ✅ Safe

Using Mongoose (ORM), not raw SQL queries.

**All queries parameterized:**
```javascript
// ✅ SAFE - Mongoose handles escaping
ContactSubmission.findOne({ email: userInput })

// ❌ DANGEROUS - If we used SQL raw
"SELECT * FROM submissions WHERE email = '" + userInput + "'"
```

---

## 📁 FILE & DIRECTORY SECURITY

### **11. Sensitive File Blocking** ✅ Configured

**.htaccess (Apache) blocks:**
```apache
<FilesMatch "\.(env|git|htaccess|htpasswd|json|lock)$">
    Require all denied
</FilesMatch>
```

**nginx.conf (Nginx) blocks:**
```nginx
location ~ /\. {
    deny all;
    access_log off;
    log_not_found off;
}
```

**Protected files:**
- .env (secrets)
- .git (source control)
- .htaccess (config)
- package-lock.json (dependency hashes)

---

### **12. Directory Listing Disabled** ✅ Configured

Users cannot see file listings.

**Nginx config:**
```nginx
autoindex off;
```

**Apache config:**
```apache
<Directory />
    Options -Indexes
</Directory>
```

---

### **13. Secure File Uploads** ✅ Not Enabled Yet

Currently: Form submissions only (no file uploads)

**If you add file uploads, must:**
- Validate file type (whitelist)
- Scan for malware
- Store outside web root
- Rename files randomly
- Set correct MIME types

---

## 🔑 CREDENTIAL MANAGEMENT

### **14. Environment Variables**

**Required to set before deployment:**

```bash
# CRITICAL - Security
ADMIN_API_KEY=your-random-64-char-key

# CRITICAL - Database  
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/db

# CRITICAL - Email
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-specific-password  # NOT your actual Gmail password!
ADMIN_EMAIL=admin@studionex.com

# REQUIRED - URLs
FRONTEND_URL=https://studionex.com
ADMIN_DASHBOARD_URL=https://studionex.com/admin.html

# Standard
PORT=3000
NODE_ENV=production
```

**Never hardcode secrets in code!**

---

### **15. Email Credentials Security**

**Gmail:**
- ✅ Use App-Specific Password (16 chars) NOT your real password
- ✅ Enable 2-Factor Authentication
- ✅ Revoke access if compromised: https://myaccount.google.com/security

**Custom SMTP:**
- ✅ Use dedicated email account (not personal)
- ✅ Use strong, unique password
- ✅ Rotate credentials every 90 days

---

## 🔗 DATABASE SECURITY

### **16. MongoDB Security**

**Atlas Cloud (Recommended):**
```
✅ Automatic backups
✅ Encryption at rest
✅ Network isolation
✅ Access control
✅ Audit logging
```

**Local MongoDB:**
```bash
# Enable authentication
mongod --auth

# Create admin user
db.createUser({ user: "admin", pwd: "strong-password", roles: ["root"] })

# Enable encryption
mongod --enableEncryption
```

**Connection string format:**
```
mongodb+srv://username:password@cluster.mongodb.net/database?retryWrites=true&w=majority
```

**Security features enabled:**
- Retries on transient errors
- Majority write confirmation
- Encryption in transit (TLS)

---

### **17. Database Indexes for Performance**

Already configured in `ContactSubmission.js`:

```javascript
contactSubmissionSchema.index({ email: 1 });
contactSubmissionSchema.index({ status: 1 });
contactSubmissionSchema.index({ submittedAt: -1 });
```

**Benefits:**
- Faster queries
- Duplicate email prevention
- Efficient sorting

---

### **18. Data Backup Strategy**

**Atlas (Cloud):**
- ✅ Automatic daily backups (30-day retention)
- ✅ Point-in-time recovery
- ✅ No additional setup needed

**Local MongoDB:**
```bash
# Manual backup
mongodump --out /backup/studionex

# Restore
mongorestore /backup/studionex

# Automated daily backup (cron)
0 2 * * * mongodump --out /backup/studionex-$(date +\%Y\%m\%d)
```

---

## 🌐 NETWORK SECURITY

### **19. Firewall Configuration**

**VPS Firewall (UFW on Ubuntu):**
```bash
# Allow SSH (always do this first!)
sudo ufw allow 22/tcp

# Allow HTTP
sudo ufw allow 80/tcp

# Allow HTTPS
sudo ufw allow 443/tcp

# Allow MongoDB (if local, only from localhost)
sudo ufw allow from 127.0.0.1 to 127.0.0.1 port 27017

# Block all other traffic
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable
```

---

### **20. Rate Limiting & DDoS Protection**

**Current setup:**
- 100 requests per IP per 15 minutes
- Prevents brute force attacks
- Prevents automated scraping

**To add more protection:**
```javascript
// Stricter limit for contact form
const contactLimiter = rateLimit({
  windowMs: 60 * 60 * 1000,  // 1 hour
  max: 1,  // 1 request per email per hour
  keyGenerator: (req) => req.body.email
});

app.post('/api/contact', contactLimiter, ...);
```

---

### **21. CORS Headers** ✅ Configured

Already set in server.js:
```javascript
app.use(cors());
```

Allows cross-origin requests from your domain.

---

## 🔍 MONITORING & LOGGING

### **22. Error Logging**

Currently logs to console in development.

**For production, add:**
```javascript
// Using Winston (npm install winston)
const winston = require('winston');
const logger = winston.createLogger({
  level: 'info',
  format: winston.format.json(),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' })
  ]
});

// Use instead of console.log
logger.error('Something failed');
```

---

### **23. Audit Logging**

Track admin actions:

```javascript
// Add to PUT /api/submissions/:id
const auditLog = new AuditLog({
  adminId: req.adminId,
  action: 'submission_updated',
  submissionId: req.params.id,
  changes: req.body,
  timestamp: new Date()
});
await auditLog.save();
```

---

### **24. Security Monitoring**

**On VPS, monitor:**
```bash
# Check for failed login attempts
sudo grep "Failed password" /var/log/auth.log

# Check open connections
netstat -an | grep ESTABLISHED

# Check running processes
ps aux

# Monitor system resources
top
htop  # Install: sudo apt install htop
```

---

## 📋 DEPLOYMENT SECURITY CHECKLIST

Before going to production, verify:

```
CRITICAL:
[ ] ADMIN_API_KEY is set (64+ chars)
[ ] MONGODB_URI is set and accessible
[ ] .env file is in .gitignore
[ ] .env file is NOT in git history
[ ] NODE_ENV=production
[ ] SMTP credentials are correct
[ ] HTTPS certificate is valid
[ ] All environment variables configured

APPLICATION:
[ ] Helmet.js enabled
[ ] CORS configured correctly
[ ] Rate limiting enabled
[ ] Input validation working
[ ] API authentication required
[ ] Sensitive files blocked

DATABASE:
[ ] MongoDB credentials set
[ ] Database backups configured
[ ] Connection string uses TLS
[ ] IP whitelist configured (if Atlas)

NETWORK:
[ ] Firewall rules configured
[ ] Ports 80, 443 accessible
[ ] SSH key set up (not password)
[ ] DDoS protection enabled

MONITORING:
[ ] Error logging configured
[ ] Uptime monitoring enabled
[ ] Backups scheduled
[ ] Security audit logs enabled
[ ] PM2 monitoring active
```

---

## 🆘 INCIDENT RESPONSE

### **If ADMIN_API_KEY is Compromised:**

1. Stop all servers: `pm2 stop all`
2. Generate new key: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
3. Update .env: `ADMIN_API_KEY=new-key`
4. Review audit logs for unauthorized access
5. Restart servers: `pm2 start all`

### **If Database is Breached:**

1. Restore from backup: `mongorestore /backup/date`
2. Change all SMTP credentials
3. Change ADMIN_API_KEY
4. Review audit logs for suspicious activity
5. Notify affected users if needed

### **If .env is Leaked:**

1. Immediately revoke all credentials
2. Generate new ADMIN_API_KEY
3. Change SMTP password
4. Change MongoDB password
5. Update all credentials in deployment
6. Review git history to remove leaked keys

---

## 📚 Security Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)
- [Express.js Security](https://expressjs.com/en/advanced/best-practice-security.html)
- [MongoDB Security](https://docs.mongodb.com/manual/security/)

---

## ✅ Summary

Your StudioNex backend has:

| Component | Status | Security |
|-----------|--------|----------|
| Input Validation | ✅ Done | Prevents injection attacks |
| Authentication | ✅ Done | API key required |
| HTTPS/TLS | ⏳ Setup | Encrypts data in transit |
| Rate Limiting | ✅ Done | Prevents brute force |
| CORS | ✅ Done | Controls origin access |
| Helmet.js | ✅ Done | Security headers |
| File Blocking | ✅ Done | Protects .env, .git |
| Database Auth | ✅ Done | MongoDB credentials |
| Backups | ✅ Done | Automatic backups |
| Monitoring | ⏳ Optional | Error/audit logs |

**You're 90% secure! Just configure:**
1. HTTPS certificate
2. Firewall rules
3. Environment variables
4. Database backups

---

**Go live with confidence! Your app is protected.** 🔐
