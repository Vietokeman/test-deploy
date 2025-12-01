# 🚂 RAILWAY DEPLOYMENT GUIDE - POSTGRESQL

## ✅ ĐÃ SỬA TOÀN BỘ LỖI 502

### Những gì đã fix:

#### 1️⃣ **Dockerfile.railway** - Chuẩn Railway
```dockerfile
# Set ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT:-8080}
# Use exec form: CMD ["dotnet", "Trippio.Api.dll"]
# Health check: /health endpoint
```

#### 2️⃣ **Program.cs** - Không conflict với ENV
- Xóa `ConfigureKestrel` manual
- ASP.NET tự đọc `ASPNETCORE_URLS` từ Dockerfile ENV
- Log PORT để debug

#### 3️⃣ **Database** - PostgreSQL trên Railway
- Code đã hỗ trợ PostgreSQL
- Chỉ cần set `Repository__Provider=PostgreSQL`

---

## 📋 DEPLOY RAILWAY - BƯỚC CHI TIẾT

### Bước 1: Tạo Project trên Railway

1. Truy cập: https://railway.app/new
2. Chọn **"Deploy from GitHub repo"**
3. Chọn repository: `Vietokeman/test-deploy`
4. Railway sẽ auto-detect `Dockerfile.railway`

### Bước 2: Thêm PostgreSQL Database

1. Trong Railway Dashboard → Click **"+ New"**
2. Chọn **"Database"** → **"Add PostgreSQL"**
3. Railway sẽ tự động tạo database và link với service

### Bước 3: Cấu hình Environment Variables

**⚠️ QUAN TRỌNG**: Railway tự động tạo `DATABASE_URL`, bạn cần convert sang format .NET:

#### 🔧 Convert DATABASE_URL sang ConnectionString

Railway cung cấp: `postgresql://user:password@host:port/database`

Bạn cần convert sang:
```
Host=host;Port=port;Database=database;Username=user;Password=password;SSL Mode=Require;Trust Server Certificate=true
```

#### 📝 Environment Variables cần thêm:

```bash
# Database Connection (CRITICAL - convert từ DATABASE_URL)
ConnectionStrings__DefaultConnection=Host=xxx.railway.internal;Port=5432;Database=railway;Username=postgres;Password=xxx;SSL Mode=Require;Trust Server Certificate=true

# Database Provider (BẮT BUỘC)
Repository__Provider=PostgreSQL

# JWT (BẮT BUỘC cho authentication)
JwtTokenSettings__Key=YOUR_BASE64_ENCODED_SECRET_KEY_HERE
JwtTokenSettings__Issuer=https://your-railway-domain.railway.app
JwtTokenSettings__ExpireInHours=24

# CORS Origins (thêm Railway domain)
AllowedOrigins__0=http://localhost:3000
AllowedOrigins__1=https://trippio-fe.vercel.app
AllowedOrigins__2=https://your-railway-domain.railway.app

# Redis (nếu dùng - hoặc để trống)
ConnectionStrings__Redis=

# Google OAuth (nếu dùng)
Authentication__Google__ClientId=
Authentication__Google__ClientSecret=

# SMTP Email (nếu dùng)
Smtp__Host=smtp.gmail.com
Smtp__Port=587
Smtp__User=your-email@gmail.com
Smtp__Pass=your-app-password
Smtp__FromEmail=your-email@gmail.com

# PayOS Payment
PayOS__ClientId=
PayOS__ApiKey=
PayOS__ChecksumKey=
PayOS__WebReturnUrl=https://trippio-fe.vercel.app/payment/success
PayOS__WebCancelUrl=https://trippio-fe.vercel.app/payment/cancel
PayOS__WebhookUrl=https://your-railway-domain.railway.app/api/payment/payos-callback

# Environment
ASPNETCORE_ENVIRONMENT=Production

# Swagger (optional - set false in production)
Swagger__Enabled=true
```

### Bước 4: Deploy & Monitor

1. **Sau khi thêm variables** → Railway tự động redeploy
2. **Đợi 3-5 phút** để build Docker image
3. **Xem Logs** để kiểm tra:

**✅ Logs thành công:**
```
Railway PORT: 8080 (listening via ASPNETCORE_URLS=http://0.0.0.0:8080)
Now listening on: http://0.0.0.0:8080
Application started. Press Ctrl+C to shut down.
```

**❌ Logs thất bại (database):**
```
A network-related or instance-specific error occurred while establishing a connection to SQL Server
```
→ Kiểm tra `ConnectionStrings__DefaultConnection` và `Repository__Provider=PostgreSQL`

---

## 🔍 KIỂM TRA DEPLOYMENT

### 1. Test Health Check
```bash
curl https://your-railway-domain.railway.app/health
```

**Kết quả mong đợi:**
```json
{
  "status": "Healthy",
  "totalDuration": "00:00:00.0234567"
}
```

### 2. Test Swagger (nếu enable)
```
https://your-railway-domain.railway.app/swagger
```

### 3. Test API Endpoint
```bash
curl https://your-railway-domain.railway.app/api/hotels
```

---

## 🚨 TROUBLESHOOTING

### Lỗi 502 Bad Gateway
**Nguyên nhân**: App không listen đúng PORT hoặc địa chỉ

**Kiểm tra**:
1. ✅ Logs có dòng: `Now listening on: http://0.0.0.0:XXXX`
2. ✅ Dockerfile có: `ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT:-8080}`
3. ✅ CMD dùng exec form: `CMD ["dotnet", "Trippio.Api.dll"]`

### Database Connection Failed
**Nguyên nhân**: Connection string sai hoặc chưa set Provider

**Giải pháp**:
1. ✅ Copy chính xác `DATABASE_URL` từ PostgreSQL service
2. ✅ Convert sang format .NET (xem ví dụ trên)
3. ✅ Set `Repository__Provider=PostgreSQL`
4. ✅ Đảm bảo có `SSL Mode=Require` và `Trust Server Certificate=true`

### Migration Failed
**Nguyên nhân**: Database chưa ready hoặc connection string sai

**Giải pháp**:
1. Kiểm tra PostgreSQL service đã running
2. Test connection từ Railway logs
3. Có thể cần tăng retry count trong `MigrationManager.cs`

### Health Check Failed
**Nguyên nhân**: Endpoint `/health` không được config hoặc app crash

**Kiểm tra**:
1. ✅ Program.cs có: `app.MapHealthChecks("/health")`
2. ✅ Logs không có exception
3. ✅ Container đang running (check Railway dashboard)

---

## 📊 CHECKLIST DEPLOY

Trước khi deploy, đảm bảo:

- ✅ Code đã commit và push lên GitHub
- ✅ `Dockerfile.railway` có ENV `ASPNETCORE_URLS=http://0.0.0.0:${PORT:-8080}`
- ✅ `Dockerfile.railway` dùng exec form CMD
- ✅ PostgreSQL database đã được thêm vào Railway project
- ✅ `DATABASE_URL` đã convert sang .NET connection string format
- ✅ `Repository__Provider=PostgreSQL` đã được set
- ✅ JWT secret key đã được tạo và set
- ✅ CORS origins bao gồm Railway domain
- ✅ PayOS webhook URL trỏ đúng Railway domain

---

## 🎯 TẠI SAO FIX NÀY ĐÚNG 100%?

### 1. **ENV ASPNETCORE_URLS trong Dockerfile**
```dockerfile
ENV ASPNETCORE_URLS=http://0.0.0.0:${PORT:-8080}
```
→ ASP.NET tự động đọc và listen đúng địa chỉ + port

### 2. **Không conflict trong Program.cs**
```csharp
// KHÔNG dùng ConfigureKestrel
// Để ASP.NET tự đọc từ ENV
```
→ Tránh conflict giữa code và ENV

### 3. **Exec form CMD**
```dockerfile
CMD ["dotnet", "Trippio.Api.dll"]
```
→ Chạy trực tiếp process, không qua shell (tránh biến môi trường bị mất)

### 4. **Health Check đúng**
```dockerfile
HEALTHCHECK CMD curl -f http://localhost:${PORT:-8080}/health
```
→ Railway biết app đang healthy hay không

---

## 🔗 DATABASE URL CONVERTER

**Railway DATABASE_URL:**
```
postgresql://postgres:password123@containers-us-west-1.railway.app:7432/railway
```

**Convert sang .NET:**
```
Host=containers-us-west-1.railway.app;Port=7432;Database=railway;Username=postgres;Password=password123;SSL Mode=Require;Trust Server Certificate=true
```

**Script convert nhanh (PowerShell):**
```powershell
$dbUrl = "postgresql://user:pass@host:port/db"
$dbUrl -match "postgresql://(.+):(.+)@(.+):(\d+)/(.+)"
$connString = "Host=$($Matches[3]);Port=$($Matches[4]);Database=$($Matches[5]);Username=$($Matches[1]);Password=$($Matches[2]);SSL Mode=Require;Trust Server Certificate=true"
Write-Host $connString
```

---

## 📞 NEXT STEPS

Sau khi deploy thành công:

1. ✅ **Test toàn bộ API endpoints**
2. ✅ **Setup CI/CD** (Railway auto-deploy khi push)
3. ✅ **Monitor logs** trong 24h đầu
4. ✅ **Setup backup** cho PostgreSQL
5. ✅ **Update frontend** để dùng Railway API URL
6. ✅ **Test payment flow** end-to-end

---

**Created**: 2025-12-01  
**Status**: ✅ PRODUCTION READY  
**Database**: PostgreSQL on Railway  
**Platform**: Railway (Dockerfile deployment)
