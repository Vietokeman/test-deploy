# ✅ RAILWAY DEPLOYMENT CHECKLIST

Copy checklist này và đánh dấu khi hoàn thành mỗi bước.

## 📋 Pre-Deployment Checklist

### Local Setup
- [ ] Chạy script `setup-railway.ps1` để auto-setup
- [ ] Hoặc manual: Cài Npgsql packages
  ```powershell
  cd src/Trippio.Data
  dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0
  cd ../Trippio.Api
  dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0
  ```
- [ ] Verify Program.cs đã update (check dòng UseNpgsql)
- [ ] Test build local: `dotnet build`
- [ ] Test local với Docker (optional)

### Git & GitHub
- [ ] Commit changes
  ```powershell
  git add .
  git commit -m "feat: add Railway deployment support"
  ```
- [ ] Push to GitHub
  ```powershell
  git push origin main
  ```
- [ ] Verify code đã lên GitHub repository

## 🚂 Railway Setup Checklist

### Create Project
- [ ] Login vào Railway: https://railway.app/dashboard
- [ ] Click "New Project"
- [ ] Select "Deploy from GitHub repo"
- [ ] Authorize Railway với GitHub (nếu chưa)
- [ ] Choose Trippio repository
- [ ] Railway sẽ tạo project và bắt đầu detect

### Add Database Services
- [ ] Click "+ New" → "Database" → "Add PostgreSQL"
- [ ] Chờ PostgreSQL provision (1-2 phút)
- [ ] Verify PostgreSQL đang running (màu xanh)
- [ ] Click "+ New" → "Database" → "Add Redis"
- [ ] Chờ Redis provision (1-2 phút)
- [ ] Verify Redis đang running (màu xanh)

### Configure API Service
- [ ] Click vào API service (tên repo)
- [ ] Tab "Settings" → "Build":
  - [ ] Builder: `Dockerfile`
  - [ ] Dockerfile Path: `Dockerfile.railway`
  - [ ] Docker Build Context: `/`
- [ ] Tab "Settings" → "Deploy":
  - [ ] Health Check Path: `/health`
  - [ ] Health Check Timeout: `300`
- [ ] Tab "Settings" → "Networking":
  - [ ] Enable "Public Networking"
  - [ ] Copy domain được cấp

## ⚙️ Environment Variables Checklist

### Copy Variables
- [ ] Open file `.env.railway`
- [ ] Click vào API service → Tab "Variables"
- [ ] Click icon `</>` (Raw Editor) ở góc phải
- [ ] Paste toàn bộ nội dung từ `.env.railway`
- [ ] **QUAN TRỌNG**: Thay các placeholder

### Update Placeholders
- [ ] `AllowedOrigins__2`: Thay `your-railway-app` bằng domain thực tế
- [ ] `JwtTokenSettings__Issuer`: Thay `your-railway-app` bằng domain thực tế
- [ ] `Payments__RedirectUrls__Web`: Thay bằng frontend domain
- [ ] Verify `ConnectionStrings__DefaultConnection` = `${DATABASE_URL}`
- [ ] Verify `ConnectionStrings__Redis` = `${REDIS_URL}`

### Verify Variables
- [ ] Check PostgreSQL variables auto-injected: `DATABASE_URL`
- [ ] Check Redis variables auto-injected: `REDIS_URL`
- [ ] Double-check không có typo trong tên biến
- [ ] Save/Apply changes

## 🚀 Deployment Checklist

### Initial Deploy
- [ ] Railway tự động trigger deploy sau khi add variables
- [ ] Hoặc click "Deploy" để manual trigger
- [ ] Monitor "Build Logs":
  - [ ] Dockerfile found
  - [ ] .NET SDK installed
  - [ ] Packages restored
  - [ ] Build successful
  - [ ] Image pushed
- [ ] Monitor "Deploy Logs":
  - [ ] Container started
  - [ ] Database connected
  - [ ] Redis connected
  - [ ] Migration ran successfully
  - [ ] Application started
  - [ ] Health check passed

### Verify Deployment
- [ ] Check status: Service shows "Active" (màu xanh)
- [ ] No error logs
- [ ] Health check passing

## ✅ Post-Deployment Testing

### API Health
- [ ] Test health endpoint: `https://your-app.up.railway.app/health`
- [ ] Expected: HTTP 200, JSON response with "Healthy"

### Swagger UI
- [ ] Access: `https://your-app.up.railway.app/swagger`
- [ ] Expected: Swagger UI hiển thị đầy đủ endpoints
- [ ] Test expand một endpoint
- [ ] Test "Try it out" một endpoint đơn giản (GET)

### Database
- [ ] Check logs: Migration completed
- [ ] Test một GET endpoint (hotels, shows, etc.)
- [ ] Verify data trả về (hoặc empty array nếu chưa seed)

### Redis
- [ ] Check logs: Redis connected
- [ ] Test basket/cart endpoints (nếu có)

### Authentication
- [ ] Test login endpoint
- [ ] Test register endpoint
- [ ] Verify JWT token returned

## 🔗 Frontend Integration

### Share URLs
- [ ] Share API Base URL với FE team: `https://your-app.up.railway.app/api`
- [ ] Share Swagger URL: `https://your-app.up.railway.app/swagger`
- [ ] Share Health Check URL: `https://your-app.up.railway.app/health`

### Frontend Config
- [ ] FE team update `.env`:
  ```
  NEXT_PUBLIC_API_URL=https://your-app.up.railway.app/api
  ```
- [ ] Test CORS: FE gọi API từ domain của họ
- [ ] Nếu CORS error: Update `AllowedOrigins` trong Railway Variables

### Integration Testing
- [ ] FE test GET requests
- [ ] FE test POST requests (login/register)
- [ ] FE test authenticated requests (with JWT)
- [ ] FE test file uploads (if any)

## 📊 Monitoring Setup

### Daily Checks
- [ ] Bookmark Railway Dashboard
- [ ] Check service status daily
- [ ] Review logs for errors
- [ ] Monitor memory usage
- [ ] Monitor CPU usage

### Set Alerts (Optional)
- [ ] Railway Pro: Set up email alerts
- [ ] Set up Slack/Discord webhooks

## 🔒 Security Checklist

### Credentials
- [ ] JWT Key đủ mạnh (min 32 chars)
- [ ] Database password đủ mạnh
- [ ] Redis password đủ mạnh
- [ ] No hardcoded secrets trong code

### CORS
- [ ] Only allow trusted domains
- [ ] Remove wildcard (*) nếu có
- [ ] Test CORS policy

### SSL/TLS
- [ ] Railway auto SSL/TLS (verify HTTPS works)
- [ ] Force HTTPS (Railway default)

## 📝 Documentation

### Team Docs
- [ ] Update project README với Railway URLs
- [ ] Document environment variables
- [ ] Document deployment process
- [ ] Share Railway access với team (if needed)

### Postman/API Testing
- [ ] Update Postman collection với Railway URL
- [ ] Export và share với team
- [ ] Test all endpoints

## 💰 Cost Management

### Free Tier Limits
- [ ] Check current usage: Railway Dashboard → Usage
- [ ] Monitor remaining credits
- [ ] Set usage alerts (Railway Pro)
- [ ] Plan for scaling if needed

### Optimization
- [ ] Review logs for excessive requests
- [ ] Optimize database queries
- [ ] Enable caching where possible
- [ ] Remove unused endpoints

## 🎉 Final Checklist

- [ ] ✅ API deployed và running
- [ ] ✅ Swagger accessible publicly
- [ ] ✅ Database connected và migrations ran
- [ ] ✅ Redis working
- [ ] ✅ CORS configured cho frontend
- [ ] ✅ All endpoints tested
- [ ] ✅ Frontend team có URLs
- [ ] ✅ Documentation updated
- [ ] ✅ Monitoring setup
- [ ] ✅ Team notified

## 📞 Support & Troubleshooting

Nếu có vấn đề, check:
- [ ] Railway Logs (Build + Deploy)
- [ ] File `RAILWAY_DEPLOYMENT.md` section Troubleshooting
- [ ] Railway Discord: https://discord.gg/railway
- [ ] GitHub Issues

---

## 🎯 Success Criteria

Deployment thành công khi:

✅ Railway Dashboard shows all services "Active"
✅ Swagger UI accessible và hiển thị đầy đủ
✅ Frontend có thể gọi API không lỗi CORS
✅ Database queries work
✅ Redis caching work
✅ Authentication flow work
✅ Health checks passing

---

**Deployment Date**: __________
**Deployed By**: __________
**Railway URL**: __________
**Swagger URL**: __________

🚀 **READY FOR PRODUCTION!**
