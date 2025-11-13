# StudioNex — Launch Guide

Everything is ready. Follow these 3 simple steps to go live.

## Step 1: Get Real Credentials (5 min)

You need two things:

### A) MongoDB (Free Database)
1. Go to https://cloud.mongodb.com
2. Create free account → create M0 cluster
3. Create database user (username + password)
4. Click "Connect" → "Drivers" → copy the connection string
5. Replace `username:password` with your actual credentials
6. Copy the full string — you'll paste it into Vercel

Example: `mongodb+srv://myuser:mypass@cluster0.mongodb.net/studionex?retryWrites=true&w=majority`

### B) Gmail App Password
1. Go to https://myaccount.google.com/apppasswords
2. Select "Mail" and "Windows Computer"
3. Generate password (16 characters)
4. Copy it — you'll paste into Vercel

## Step 2: Deploy on Vercel (2 min)

1. Go to https://vercel.com → Sign in with GitHub
2. Click "Add New" → "Project"
3. Select `studionex` repository
4. Scroll to "Environment Variables" and add these (copy/paste):

| Name | Value |
|------|-------|
| MONGODB_URI | Paste your MongoDB connection string |
| ADMIN_API_KEY | `28e4475ea40e246381183b2dd64eb13533dd619e73f5f0afa577b5ca9ce27fd5` |
| SMTP_HOST | `smtp.gmail.com` |
| SMTP_PORT | `587` |
| SMTP_USER | Your Gmail address |
| SMTP_PASS | Your 16-char app password |
| ADMIN_EMAIL | `admin@yourdomain.com` |
| FRONTEND_URL | leave blank for now |
| NODE_ENV | `production` |

5. Click "Deploy" → wait 2–3 minutes
6. Copy the live URL (e.g., `https://studionex.vercel.app`)

## Step 3: Test It Works (1 min)

1. Open: `https://your-live-url/api/ping` → should show `{"status":"ok"}`
2. Open: `https://your-live-url` → your landing page should load
3. Submit the contact form → check if you receive an email in 1–2 seconds
4. Open: `https://your-live-url/admin.html` → paste API key when prompted

## Step 4: Submit to Google (Optional but Recommended)

1. Go to https://search.google.com/search-console
2. Add property (your domain)
3. Submit sitemap: `https://your-live-url/sitemap.xml`
4. Wait 24–48 hours for indexing

---

**That's it! Your Roblox scripting agency site is LIVE.** 🚀

If you get stuck on any step, ask and I'll help.
