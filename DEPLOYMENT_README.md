# 🚀 Các File Deployment cho Railway

Thư mục này chứa các file cần thiết để deploy Trippio Backend lên Railway Platform.

## 📁 Danh Sách Files

### 1. `Dockerfile.railway`
Dockerfile được tối ưu cho Railway deployment:
- Base image: .NET 8.0
- Port: 8080 (Railway standard)
- Health check: `/health` endpoint
- Multi-stage build để giảm image size

### 2. `railway.json`
Railway configuration:
- Builder: Dockerfile
- Health check settings
- Restart policy

### 3. `.env.railway`
Template environment variables cho Railway:
- Database connection strings
- Redis configuration
- CORS settings
- JWT settings
- Payment gateway configs
- Email SMTP settings

**⚠️ QUAN TRỌNG**: Copy nội dung file này vào Railway Dashboard > Variables

### 4. `.railwayignore`
Ignore unnecessary files khi deploy:
- Logs
- Build artifacts
- IDE files
- Documentation

### 5. `RAILWAY_DEPLOYMENT.md`
Hướng dẫn chi tiết từng bước deploy:
- Setup PostgreSQL
- Setup Redis
- Configure environment variables
- Monitoring & troubleshooting

### 6. `QUICK_START_RAILWAY.md`
Quick start guide - deploy trong 5 phút:
- Các bước tóm tắt
- Commands cần chạy
- URLs quan trọng

## 🎯 Quy Trình Deploy

### Lần Đầu (First Time Setup)

1. **Cài packages**:
   ```powershell
   cd src/Trippio.Data
   dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0
   
   cd ../Trippio.Api
   dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0
   ```

2. **Commit code**:
   ```powershell
   git add .
   git commit -m "feat: add Railway deployment support"
   git push origin main
   ```

3. **Setup Railway**:
   - Đọc `QUICK_START_RAILWAY.md` để biết chi tiết
   - Hoặc đọc `RAILWAY_DEPLOYMENT.md` để hiểu sâu hơn

### Deploy Lần Sau (Re-deployment)

Railway tự động deploy khi bạn push code lên GitHub:

```powershell
git add .
git commit -m "your commit message"
git push origin main
```

## 🔗 Kiến Trúc Trên Railway

```
┌─────────────────────┐
│   PostgreSQL DB     │
│  (Railway Plugin)   │
└──────────┬──────────┘
           │
           │
┌──────────▼──────────┐      ┌─────────────────┐
│    .NET API         │◄─────┤   Redis Cache   │
│  (Your Backend)     │      │ (Railway Plugin)│
└──────────┬──────────┘      └─────────────────┘
           │
           │ HTTPS
           ▼
    ┌─────────────┐
    │  Public URL │
    │   /swagger  │
    │   /api/*    │
    └─────────────┘
```

## ✨ Tính Năng

### Auto-Scaling
Railway tự động scale theo traffic (trong giới hạn free tier).

### Auto-SSL
Railway tự động cấp SSL certificate cho domain.

### Auto-Backup
PostgreSQL tự động backup hàng ngày.

### Health Checks
Railway tự động restart nếu health check fail.

### Logs & Metrics
Real-time logs và metrics trong Dashboard.

## 💰 Chi Phí (Free Tier)

### Miễn Phí:
- ✅ $5 credit/month
- ✅ 500 execution hours
- ✅ 1GB RAM per service
- ✅ 100GB bandwidth
- ✅ 1GB storage

### Estimate cho project này:
- API: ~300MB RAM
- PostgreSQL: ~200MB RAM
- Redis: ~100MB RAM
- **Total: ~600MB** ✅ Fit!

## 🛠️ Maintenance

### View Logs
```
Railway Dashboard → API Service → Logs
```

### Update Environment Variables
```
Railway Dashboard → API Service → Variables → Edit
```

### Force Redeploy
```
Railway Dashboard → API Service → Deployments → Redeploy
```

### Rollback
```
Railway Dashboard → API Service → Deployments → [Previous Deployment] → Redeploy
```

## 🐛 Debug

### Check Build Logs
```
Deployments → Latest → Build Logs
```

### Check Runtime Logs
```
Deployments → Latest → Deploy Logs
```

### Test Health Check
```
curl https://your-app.up.railway.app/health
```

### Test Swagger
```
https://your-app.up.railway.app/swagger
```

## 📞 Support

- 📖 [Railway Docs](https://docs.railway.app/)
- 💬 [Railway Discord](https://discord.gg/railway)
- 📧 [Railway Support](https://railway.app/help)

## 🎓 Best Practices

### 1. Environment Variables
- ✅ Dùng Railway Variables, không commit sensitive data
- ✅ Update `.env.railway` làm template
- ❌ Không commit `.env` hoặc `appsettings.Production.json`

### 2. Database
- ✅ Dùng PostgreSQL connection pooling
- ✅ Enable SSL/TLS
- ✅ Regular backups (Railway auto)

### 3. Security
- ✅ Restrict CORS to specific domains
- ✅ Use strong JWT secret
- ✅ Enable rate limiting

### 4. Performance
- ✅ Use Redis caching
- ✅ Enable compression
- ✅ Optimize database queries

### 5. Monitoring
- ✅ Check logs regularly
- ✅ Monitor memory usage
- ✅ Set up alerts (Railway Pro)

## 📋 Checklist Trước Khi Deploy

- [ ] Cài Npgsql packages
- [ ] Update Program.cs (PostgreSQL support)
- [ ] Test local với Docker
- [ ] Push code lên GitHub
- [ ] Setup Railway project
- [ ] Add PostgreSQL
- [ ] Add Redis
- [ ] Configure Variables
- [ ] Test Swagger UI
- [ ] Test API endpoints
- [ ] Share URL với team

## 🚀 Next Steps

Sau khi deploy thành công:

1. **Update Frontend**: Share API URL với FE team
2. **Setup Custom Domain** (optional): Add domain trong Railway
3. **Setup CI/CD** (optional): Auto-deploy on push
4. **Monitor Usage**: Check Railway dashboard daily
5. **Optimize**: Monitor logs và optimize bottlenecks

---

Happy Deploying! 🎉

Need help? Check `RAILWAY_DEPLOYMENT.md` for detailed guide.
