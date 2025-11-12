# ✅ PRE-DEPLOYMENT CHECKLIST

Last Updated: 2024  
Status: 🟢 **READY FOR PRODUCTION**

---

## 📋 Phase 1: Environment Setup

- [ ] **Node.js Installed**
  - Command: `node --version`
  - Required: v16 or higher
  - Download: https://nodejs.org

- [ ] **Git Installed** (optional but recommended)
  - Command: `git --version`
  - Download: https://git-scm.com

- [ ] **MongoDB Account Created**
  - Go to: https://www.mongodb.com/cloud/atlas
  - Create free account
  - Create cluster
  - Get connection string

- [ ] **Gmail Account Ready**
  - Have Gmail account
  - Enable 2-factor authentication
  - Generate app password for SMTP

---

## 🔧 Phase 2: Local Setup

- [ ] **Run setup.ps1**
  ```powershell
  .\setup.ps1
  ```
  - Should auto-generate ADMIN_API_KEY
  - Should create `.env` file
  - Should install npm packages
  - Should test server startup

- [ ] **Verify .env File**
  ```powershell
  .\utils.ps1  # Option 2
  ```
  - [ ] PORT is set to 3000
  - [ ] NODE_ENV is set to production
  - [ ] MONGODB_URI is valid
  - [ ] ADMIN_API_KEY is generated
  - [ ] SMTP variables are filled

- [ ] **Install Dependencies**
  ```powershell
  cd backend
  npm install
  cd ..
  ```
  - Should complete without errors
  - Should create node_modules folder

- [ ] **Test Local Server**
  ```powershell
  .\utils.ps1  # Option 6
  ```
  - Server should start on http://localhost:3000
  - Website should load
  - No console errors

---

## 🧪 Phase 3: Local Testing

- [ ] **Test API Health**
  ```powershell
  .\utils.ps1  # Option 3
  ```
  - GET /api/ping should respond
  - Response should be OK

- [ ] **Test Database Connection**
  ```powershell
  .\utils.ps1  # Option 4
  ```
  - Should connect to MongoDB
  - Should show success message

- [ ] **Test Email Configuration**
  ```powershell
  .\utils.ps1  # Option 5
  ```
  - Should send test email
  - Should receive email in inbox
  - Should have correct SMTP credentials

- [ ] **Test Form Submission**
  1. Open http://localhost:3000
  2. Fill contact form
  3. Submit form
  4. Check MongoDB for entry
  5. Check email inbox for notification
  6. Verify all data is correct

- [ ] **Test Admin Dashboard**
  1. Open http://localhost:3000/admin.html
  2. Check browser console for ADMIN_API_KEY prompt
  3. Enter ADMIN_API_KEY from .env
  4. Should display submission
  5. Try filtering and searching
  6. Try updating status

---

## 🚀 Phase 4: Pre-Deployment

- [ ] **Choose Deployment Platform**
  - [ ] Vercel (easiest, recommended)
  - [ ] Heroku (easy, good for learning)
  - [ ] Google Cloud Run (advanced, scalable)
  - [ ] Local VPS (advanced, full control)

- [ ] **Prepare Git Repository** (for Vercel/Heroku)
  ```powershell
  git init
  git add .
  git commit -m "Initial commit"
  git remote add origin <your-repo-url>
  git push -u origin main
  ```

- [ ] **Create .env in Backend**
  - Copy `backend/.env.example` to `backend/.env`
  - Add real MongoDB URI
  - Add real SMTP credentials
  - Add ADMIN_API_KEY (from setup.ps1)
  - **Note**: Do NOT commit .env to Git

- [ ] **Prepare Environment for Deployment**
  - [ ] .env file ready with all variables
  - [ ] MONGODB_URI is correct
  - [ ] SMTP credentials are valid
  - [ ] ADMIN_API_KEY is generated
  - [ ] FRONTEND_URL set to domain name

- [ ] **Review Security Settings**
  - [ ] Rate limiting enabled
  - [ ] HTTPS will be enabled (automatic on Vercel/Heroku)
  - [ ] CORS configured
  - [ ] API key authentication working
  - [ ] Input validation enabled

- [ ] **Check SEO Setup**
  - [ ] robots.txt exists
  - [ ] sitemap.xml exists
  - [ ] Meta tags in index.html
  - [ ] JSON-LD schemas included
  - [ ] OG tags configured

---

## 🌐 Phase 5: Deployment

- [ ] **Run Deployment Script**
  ```powershell
  .\deploy.ps1
  ```
  - Choose your platform
  - Follow automated prompts
  - Get live URL

- [ ] **Verify Deployment**
  - [ ] Website loads at live URL
  - [ ] Contact form visible
  - [ ] Form submission works
  - [ ] Email received
  - [ ] No console errors
  - [ ] Mobile responsive

- [ ] **Test Production API**
  ```powershell
  .\utils.ps1  # Option 3
  # Enter live URL: https://your-domain.com
  ```
  - GET /api/ping responds
  - GET /api/submissions works with API key

- [ ] **Test Production Admin**
  - Open https://your-domain.com/admin.html
  - Submit test form
  - Verify in admin dashboard
  - Check email notification

---

## 📊 Phase 6: Post-Deployment

- [ ] **Monitor Logs**
  ```powershell
  .\utils.ps1  # Option 10
  ```
  - Check for errors
  - Check for warnings
  - Verify submissions logging

- [ ] **Submit to Google**
  1. Add GA4 Measurement ID to .env
  2. Go to Google Search Console
  3. Add property: https://your-domain.com
  4. Upload sitemap from robots.txt
  5. Request URL indexing

- [ ] **Submit to Bing**
  1. Go to Bing Webmaster Tools
  2. Add site: https://your-domain.com
  3. Upload sitemap.xml
  4. Wait for indexing

- [ ] **Set Up Domain Name**
  - [ ] Purchase domain (optional)
  - [ ] Point DNS to deployment platform
  - [ ] Enable HTTPS (automatic on Vercel/Heroku)
  - [ ] Set custom domain

- [ ] **Set Up Email Forwarding**
  - [ ] Create email alias (e.g., contact@your-domain.com)
  - [ ] Forward to personal email
  - [ ] Test with form submission

- [ ] **Backup Important Files**
  ```powershell
  .\utils.ps1  # Option 9
  ```
  - Backup .env file
  - Store in safe location
  - Keep ADMIN_API_KEY secure

---

## 🔒 Security Verification

Before Going Live, Verify:

- [ ] **API Security**
  - [ ] ADMIN_API_KEY is set and secure
  - [ ] API key not exposed in client-side code
  - [ ] Rate limiting active
  - [ ] CORS headers correct

- [ ] **Database Security**
  - [ ] MongoDB URI has strong password
  - [ ] Network access limited to app
  - [ ] Encryption at rest enabled
  - [ ] Regular backups configured

- [ ] **Server Security**
  - [ ] HTTPS enabled
  - [ ] Security headers active (Helmet.js)
  - [ ] Sensitive files blocked (.env, .git)
  - [ ] Logging enabled

- [ ] **Form Security**
  - [ ] Input validation working
  - [ ] XSS prevention active
  - [ ] CSRF protection enabled
  - [ ] Rate limiting on POST /api/contact

- [ ] **Email Security**
  - [ ] SMTP using app-specific password
  - [ ] Email template sanitized
  - [ ] Only sending necessary data
  - [ ] Unsubscribe option available (optional)

---

## 📱 Functionality Verification

Before Going Live, Test:

- [ ] **Homepage**
  - [ ] Loads in <3 seconds
  - [ ] All animations smooth
  - [ ] Responsive on mobile
  - [ ] All links working

- [ ] **Contact Form**
  - [ ] All fields visible
  - [ ] Form validation working
  - [ ] Submit button responsive
  - [ ] Success message appears
  - [ ] Error handling working

- [ ] **Submissions**
  - [ ] Data saved to MongoDB
  - [ ] Admin notified by email
  - [ ] Client receives confirmation
  - [ ] No duplicate submissions

- [ ] **Admin Dashboard**
  - [ ] Protected with API key
  - [ ] Shows all submissions
  - [ ] Filter/search working
  - [ ] Update status working
  - [ ] Delete working

- [ ] **SEO**
  - [ ] Meta tags in page source
  - [ ] JSON-LD schemas valid (check with https://schema.org/validator)
  - [ ] robots.txt accessible
  - [ ] sitemap.xml accessible
  - [ ] Open Graph tags present

---

## 📈 Performance Verification

Before Going Live, Check:

- [ ] **Page Speed**
  - [ ] Google PageSpeed Insights: >80
  - [ ] Lighthouse score: >90
  - [ ] First Contentful Paint: <1.5s
  - [ ] Largest Contentful Paint: <2.5s

- [ ] **Uptime**
  - [ ] No 500 errors
  - [ ] No 404 errors
  - [ ] API responding consistently
  - [ ] Database responsive

- [ ] **Load Testing**
  - [ ] Handle 10+ simultaneous users
  - [ ] Form submissions under load
  - [ ] API responsive under load
  - [ ] No memory leaks

---

## 🚨 Contingency Plans

If Something Goes Wrong:

- [ ] **Server Down**
  - Check logs: `.\utils.ps1` option 10
  - Restart: Platform dashboard
  - Rollback: Use previous version

- [ ] **Database Connection Lost**
  - Verify MongoDB is running
  - Check connection string in .env
  - Verify network access
  - Check MongoDB Atlas status

- [ ] **Email Not Sending**
  - Test SMTP: `.\utils.ps1` option 5
  - Check credentials in .env
  - Verify Gmail app password
  - Check spam folder

- [ ] **Form Submissions Missing**
  - Check MongoDB for entries
  - Verify API endpoint accessible
  - Check browser console for errors
  - Test with `.\utils.ps1` option 3

- [ ] **Admin Dashboard Not Working**
  - Verify ADMIN_API_KEY correct
  - Check API endpoint accessible
  - Try incognito mode
  - Clear browser cache

---

## 📋 Sign-Off Checklist

Before Declaring "Ready for Production":

**Code Quality**
- [ ] No console errors
- [ ] No unhandled exceptions
- [ ] All API endpoints working
- [ ] All dependencies compatible
- [ ] No security vulnerabilities

**Testing**
- [ ] Unit tests passing (if any)
- [ ] Integration tests passing
- [ ] Manual testing complete
- [ ] Cross-browser tested
- [ ] Mobile responsive tested

**Security**
- [ ] All security checks passed
- [ ] No exposed credentials
- [ ] Rate limiting active
- [ ] Input validation working
- [ ] HTTPS enabled

**Performance**
- [ ] Page load time acceptable
- [ ] API response time acceptable
- [ ] Database queries optimized
- [ ] Caching configured
- [ ] No memory leaks

**Documentation**
- [ ] README complete and accurate
- [ ] DEPLOYMENT_GUIDE complete
- [ ] SECURITY_CHECKLIST complete
- [ ] API documentation available
- [ ] Troubleshooting guide available

**Monitoring**
- [ ] Error logging configured
- [ ] Analytics configured
- [ ] Uptime monitoring enabled
- [ ] Performance monitoring enabled
- [ ] Alert system configured

---

## 🎉 Final Status

### ✅ Production Ready When:
- All sections marked with ✅
- All checks passed
- All tests successful
- All security verified
- All performance acceptable
- All documentation complete

### 📊 Completion Percentage

- Phase 1 (Setup): ___ %
- Phase 2 (Local Setup): ___ %
- Phase 3 (Testing): ___ %
- Phase 4 (Pre-Deployment): ___ %
- Phase 5 (Deployment): ___ %
- Phase 6 (Post-Deployment): ___ %

**Overall Progress**: ___ % (= (sum of all phases) / 600)

---

## 📝 Notes

Use this section to track issues, notes, or special configurations:

```
Date: _________________
Notes: _________________________________________________________________

_____________________________________________________________________

_____________________________________________________________________
```

---

## 🎯 Next Steps

Once all checks are complete:

1. ✅ Website is live and working
2. ✅ Form submissions flowing in
3. ✅ Email notifications sending
4. ✅ Admin dashboard operational
5. ✅ SEO indexed on Google
6. 🚀 **Ready to start scaling!**

---

**Good luck with your launch! 🎉**

Need help? Check:
- START_HERE.md (quick overview)
- DEPLOYMENT_GUIDE.md (detailed instructions)
- SECURITY_CHECKLIST.md (security setup)
- README.md (full project info)
