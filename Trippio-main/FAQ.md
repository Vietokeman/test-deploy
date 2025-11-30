# ❓ FAQ - Railway Deployment

## 🎯 Câu Hỏi Thường Gặp

### 1. Tại sao chọn Railway?

**A:** Railway là platform tốt nhất cho Free Tier vì:
- ✅ PostgreSQL & Redis miễn phí
- ✅ $5 credit/month đủ cho API nhỏ-trung
- ✅ Auto SSL/TLS
- ✅ Auto deploy từ GitHub
- ✅ Public domain free
- ✅ Developer-friendly UI

**So sánh với các platform khác:**

| Platform | PostgreSQL | Redis | API Hosting | SSL | Cost |
|----------|-----------|-------|-------------|-----|------|
| **Railway** | ✅ Free | ✅ Free | $5 credit | ✅ Auto | ~$2-3/mo |
| Heroku | ❌ Paid | ❌ Paid | 550h free | ✅ Auto | Limited |
| Render | ✅ Free | ❌ Paid | 750h free | ✅ Auto | Complex |
| Azure | ❌ 32MB only | ❌ Paid | ❌ Paid | ✅ Manual | Expensive |
| AWS | ❌ Paid | ❌ Paid | ❌ Complex | ✅ Manual | Complex |

### 2. Tại sao dùng PostgreSQL thay vì SQL Server?

**A:** Vì:
- ✅ PostgreSQL có free tier trên Railway
- ✅ SQL Server không có trên Railway
- ✅ PostgreSQL performance tốt hơn cho cloud
- ✅ EF Core hỗ trợ tốt cả hai
- ✅ Migration code gần như không đổi

**SQL Server trên cloud rất đắt:**
- Azure SQL: $5-15/month cho tier thấp nhất
- AWS RDS SQL Server: $15-30/month

### 3. Có mất tiền không?

**A:** 
- **Free $5 credit/month** từ Railway
- Project này dùng ~$2-3/month
- **Không cần credit card** nếu dùng GitHub Student Pack
- Nếu vượt $5 → Railway sẽ stop services (không charge)

### 4. Railway có throttle hay limit gì không?

**A:** Free tier limits:
- ✅ 500 execution hours/month (đủ 24/7)
- ✅ 1GB RAM per service
- ✅ 100GB bandwidth/month
- ✅ 1GB storage

**Project này dùng:**
- ~600MB RAM total (API + DB + Redis)
- ~10GB bandwidth (ước tính)
- ~200MB storage (database)

→ **Fit hoàn toàn trong free tier!**

### 5. Swagger có accessible public không?

**A:** 
✅ **CÓ!** Swagger UI sẽ public tại:
```
https://your-app.up.railway.app/swagger
```

Frontend team có thể:
- ✅ Xem tất cả endpoints
- ✅ Test API trực tiếp
- ✅ Xem models & schemas
- ✅ Export OpenAPI spec

### 6. CORS có hoạt động không?

**A:**
✅ **CÓ!** Bạn cần config AllowedOrigins trong Railway Variables:

```env
AllowedOrigins__0=http://localhost:3000
AllowedOrigins__1=https://your-frontend.vercel.app
AllowedOrigins__2=https://your-app.up.railway.app
```

Nếu FE gặp CORS error → thêm domain FE vào danh sách.

### 7. Database có tự động backup không?

**A:**
✅ **CÓ!** Railway PostgreSQL tự động:
- Daily backups
- Point-in-time recovery (Railway Pro)
- Auto snapshots

### 8. Deploy mất bao lâu?

**A:**
- **First deploy**: 5-10 phút
  - Build image: 3-5 phút
  - Database migration: 1-2 phút
  - Health check: 1 phút

- **Subsequent deploys**: 2-5 phút
  - Build: 2-3 phút (có cache)
  - Deploy: 1 phút

### 9. Có downtime khi deploy không?

**A:**
✅ **KHÔNG!** Railway dùng zero-downtime deployment:
1. Build image mới
2. Start container mới
3. Health check pass
4. Chuyển traffic sang container mới
5. Stop container cũ

### 10. Làm sao để FE connect đến API?

**A:**
FE team chỉ cần update `.env`:

```env
NEXT_PUBLIC_API_URL=https://your-app.up.railway.app/api
```

Test connection:
```javascript
fetch('https://your-app.up.railway.app/api/hotels')
  .then(res => res.json())
  .then(data => console.log(data))
```

### 11. Có thể dùng custom domain không?

**A:**
✅ **CÓ!** 

**Railway domain free:**
```
https://your-app.up.railway.app
```

**Custom domain** (cần mua domain):
1. Mua domain từ Namecheap, GoDaddy, etc.
2. Railway Settings → Domains → Add Custom Domain
3. Add CNAME record: `your-domain.com` → `your-app.up.railway.app`
4. Railway tự động generate SSL

### 12. Logs có persistent không?

**A:**
❌ **KHÔNG persistent**, logs chỉ trong runtime.

**Giải pháp:**
- Dùng Serilog write to file (đã config)
- Hoặc integrate với logging service:
  - Papertrail (free tier)
  - Logtail (free tier)
  - CloudWatch (AWS)

### 13. Có thể rollback nếu deploy lỗi không?

**A:**
✅ **CÓ!** Railway cho phép rollback dễ dàng:

1. Vào Dashboard → Deployments
2. Click vào deployment trước đó (working)
3. Click "Redeploy"
4. Done! (1-2 phút)

### 14. Redis có persistent không?

**A:**
✅ **CÓ!** Railway Redis có persistence:
- AOF (Append-Only File) enabled
- Data persist qua restarts
- Snapshot theo interval

**Nhưng:** Nếu service bị delete → data mất

### 15. Database connection string ở đâu?

**A:**
Railway tự động inject vào environment variables:

```
DATABASE_URL=postgresql://user:pass@host:port/db
```

Trong code, dùng:
```csharp
var connectionString = configuration.GetConnectionString("DefaultConnection");
// Railway sẽ map DATABASE_URL → DefaultConnection
```

### 16. Email/SMTP có hoạt động không?

**A:**
✅ **CÓ!** SMTP settings đã config trong `.env.railway`:

```env
Smtp__Host=smtp.gmail.com
Smtp__Port=587
Smtp__User=your-email@gmail.com
Smtp__Pass=your-app-password
```

**Lưu ý:** Gmail yêu cầu "App Password", không dùng password thật.

### 17. Payment gateway (VNPay, PayOS) có hoạt động không?

**A:**
✅ **CÓ!** Settings đã config:

```env
Payments__VNPay__TmnCode=...
Payments__VNPay__THashSecret=...
PayOS__ClientId=...
PayOS__ApiKey=...
```

**Lưu ý:** Update webhook URLs trong VNPay/PayOS dashboard:
```
https://your-app.up.railway.app/api/payments/vnpay-callback
https://your-app.up.railway.app/api/payments/payos-webhook
```

### 18. File uploads có hoạt động không?

**A:**
⚠️ **KHÔNG persistent** - Railway containers là ephemeral.

**Giải pháp:**
- Dùng cloud storage:
  - Cloudinary (free 25GB)
  - AWS S3 (free 5GB)
  - Azure Blob Storage
  - Supabase Storage (free 1GB)

### 19. Có thể schedule background jobs không?

**A:**
✅ **CÓ!** Options:

1. **Hangfire** (recommended):
```csharp
services.AddHangfire(...);
RecurringJob.AddOrUpdate("cleanup", () => ..., Cron.Daily);
```

2. **Railway Cron Jobs** (separate service):
- Tạo cron service gọi API endpoint
- Schedule trong Railway

3. **External**: 
- Cron-job.org (free)
- EasyCron (free tier)

### 20. Có thể scale nếu traffic tăng không?

**A:**
✅ **CÓ!**

**Free tier:** 1 instance only

**Railway Pro ($20/month):**
- Multiple replicas
- Auto-scaling
- Load balancing

**Manual scaling:**
1. Upgrade Railway Pro
2. Settings → Replicas → Set số lượng
3. Railway tự động load balance

### 21. Health check có bắt buộc không?

**A:**
✅ **BẮT BUỘC** để Railway biết app healthy.

Đã implement:
```csharp
app.MapHealthChecks("/health", new HealthCheckOptions
{
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
});
```

Railway check mỗi 30s. Nếu fail 3 lần → restart container.

### 22. JWT Token có hoạt động cross-domain không?

**A:**
✅ **CÓ!** Miễn là:
1. CORS configured đúng
2. Frontend gửi token trong header:
```javascript
Authorization: Bearer <token>
```

### 23. Database migration có tự động chạy không?

**A:**
✅ **CÓ!** Khi container start, `MigrationManager.cs` sẽ:
1. Check pending migrations
2. Apply migrations
3. Seed data (nếu có)

Check logs để verify:
```
[INF] Applying migration: 20230101_InitialCreate
[INF] Migration completed successfully
```

### 24. Redis connection string có SSL không?

**A:**
Railway Redis **không require SSL** (internal network).

Config:
```
redis:6379,password=xxx,ssl=false,abortConnect=false
```

Nếu dùng external Redis (Azure, AWS) → ssl=true.

### 25. Có rate limiting không?

**A:**
Railway **không có built-in rate limiting**.

**Implement trong code:**
```csharp
// Program.cs
services.AddRateLimiter(options =>
{
    options.AddFixedWindowLimiter("api", opt =>
    {
        opt.Window = TimeSpan.FromMinutes(1);
        opt.PermitLimit = 100;
    });
});

app.UseRateLimiter();
```

### 26. Có thể debug production logs không?

**A:**
✅ **CÓ!** 

**Real-time logs:**
```
Railway Dashboard → Service → Logs tab
```

**Download logs:**
```
Railway CLI:
railway logs --service=api
```

**Serilog file logs:**
Logs save trong container (ephemeral), cần stream to external service.

### 27. Environment có thể thay đổi runtime không?

**A:**
✅ **CÓ!** 

1. Railway Dashboard → Variables
2. Add/Edit/Delete biến
3. Railway tự động redeploy với variables mới

**Lưu ý:** Redeploy mất 2-3 phút.

### 28. Có thể SSH vào container không?

**A:**
❌ **KHÔNG trực tiếp**, nhưng có workaround:

**Railway CLI:**
```powershell
railway run bash
```

**Hoặc exec commands:**
```
railway run dotnet ef database update
```

### 29. Multi-region có support không?

**A:**
Railway mặc định deploy ở:
- **US West** (Oregon)

Railway Pro có thể chọn:
- US East
- EU West
- Asia Pacific

### 30. Có SLA guarantee không?

**A:**
- **Free tier**: ❌ No SLA
- **Railway Pro**: ✅ 99.9% uptime SLA

**Best practices:**
- Monitor uptime với UptimeRobot (free)
- Setup alerts
- Have rollback plan

---

## 🚨 Troubleshooting Common Issues

### Issue 1: Build Failed - "Dockerfile not found"

**Solution:**
```
Settings → Build → Dockerfile Path = Dockerfile.railway
```

### Issue 2: Database Connection Failed

**Solution:**
```env
# Check biến này có đúng không
ConnectionStrings__DefaultConnection=${DATABASE_URL}
```

### Issue 3: Redis Connection Failed

**Solution:**
```env
# Check format
ConnectionStrings__Redis=${REDIS_URL}
# Hoặc
ConnectionStrings__Redis=${REDIS_HOST}:${REDIS_PORT},password=${REDIS_PASSWORD}
```

### Issue 4: Swagger 404 Error

**Solution:**
Check Program.cs enable Swagger cho Production:
```csharp
if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
```

### Issue 5: CORS Error từ Frontend

**Solution:**
Add frontend domain vào AllowedOrigins:
```env
AllowedOrigins__3=https://your-frontend-domain.com
```

### Issue 6: Out of Memory

**Solution:**
- Optimize queries
- Enable pagination
- Use Redis caching
- Upgrade to Railway Pro

### Issue 7: Slow Response Time

**Solution:**
- Check database indexes
- Enable Redis caching
- Optimize N+1 queries
- Use async/await properly

### Issue 8: Migration Failed

**Solution:**
Check logs:
```
[ERR] Migration failed: column already exists
```

Fix:
```powershell
# Rollback migration locally
dotnet ef migrations remove
# Fix migration
# Commit & push
```

---

## 📞 Còn Câu Hỏi?

- 📖 [Railway Docs](https://docs.railway.app/)
- 💬 [Railway Discord](https://discord.gg/railway)
- 📧 [Railway Support](https://railway.app/help)
- 🐛 [GitHub Issues](https://github.com/railwayapp/nixpacks/issues)

---

**Updated**: 2025-11-30
**Version**: 1.0.0
