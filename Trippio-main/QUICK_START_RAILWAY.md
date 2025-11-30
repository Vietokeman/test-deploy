# ⚡ QUICK START - Deploy Trippio lên Railway (5 phút)

## 🎯 Các Bước Nhanh

### 1️⃣ Cài package PostgreSQL (1 phút)

```powershell
cd src/Trippio.Data
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0

cd ../Trippio.Api
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0

cd ../..
```

### 2️⃣ Commit code (30 giây)

```powershell
git add .
git commit -m "feat: add Railway deployment support"
git push origin main
```

### 3️⃣ Setup Railway (2 phút)

1. Vào https://railway.app → Login với GitHub
2. New Project → Deploy from GitHub → Chọn repo này
3. Add PostgreSQL: **+ New → Database → PostgreSQL**
4. Add Redis: **+ New → Database → Redis**

### 4️⃣ Configure API Service (1.5 phút)

Click vào API service → **Variables** → Paste đoạn này vào Raw Editor:

```env
# Core
ASPNETCORE_ENVIRONMENT=Production
Repository__Provider=PostgreSql

# Database (Railway auto-inject)
ConnectionStrings__DefaultConnection=${DATABASE_URL}
ConnectionStrings__Redis=${REDIS_URL}

# CORS - THAY your-app-name bằng tên thật
AllowedOrigins__0=http://localhost:3000
AllowedOrigins__1=https://trippio-fe.vercel.app
AllowedOrigins__2=https://your-app-name.up.railway.app

# JWT - THAY your-app-name
JwtTokenSettings__Key=bXlfc2VjdXJlX2p3dF9rZXlfMTI4IQ==
JwtTokenSettings__Issuer=https://your-app-name.up.railway.app
JwtTokenSettings__ExpireInHours=24

# Google OAuth (copy từ appsettings.json của bạn)
Authentication__Google__ClientId=45013553161-9c1mg1qmk428buh8aqsnvr6uq5bpg6e4.apps.googleusercontent.com
Authentication__Google__ClientSecret=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

# Payment (copy từ appsettings.json)
PayOS__ClientId=0386ff7b-5d12-419f-8471-5015b22aff94
PayOS__ApiKey=6d78ef9e-4c3c-47be-b750-89583c33948a
PayOS__ChecksumKey=9c37932e3ace8e716c270f6a0e68ea47c3b0a0e8a13f80c8fcb627a70d6df8e7

Payments__VNPay__TmnCode=TMPRY52R
Payments__VNPay__THashSecret=28G11MCL1G6Q3D2DO3Q2J9I5OSVA04W3
```

### 5️⃣ Deploy! (30 giây)

Railway tự động deploy. Chờ 2-3 phút.

### 6️⃣ Lấy URL & Test

1. Vào API service → **Settings → Domains**
2. Copy URL: `https://your-app-name.up.railway.app`
3. Truy cập Swagger: `https://your-app-name.up.railway.app/swagger`

## ✅ Checklist

- [ ] Cài Npgsql packages
- [ ] Push code lên GitHub
- [ ] Tạo Railway project
- [ ] Add PostgreSQL database
- [ ] Add Redis cache
- [ ] Configure environment variables
- [ ] Đợi deployment hoàn tất
- [ ] Test Swagger UI
- [ ] Share URL với Frontend team

## 🔗 URLs Quan Trọng

Sau khi deploy, bạn sẽ có:

```
API Base:     https://your-app.up.railway.app
Swagger:      https://your-app.up.railway.app/swagger
Health:       https://your-app.up.railway.app/health
API Endpoint: https://your-app.up.railway.app/api/...
```

## 🎯 Cho Frontend Team

Thêm vào `.env`:
```env
NEXT_PUBLIC_API_URL=https://your-app.up.railway.app/api
```

Test API:
```javascript
fetch('https://your-app.up.railway.app/api/hotels')
  .then(res => res.json())
  .then(data => console.log(data))
```

## 🐛 Troubleshooting

**Build failed?**
→ Check Dockerfile path: `Dockerfile.railway`

**Database connection failed?**
→ Check `ConnectionStrings__DefaultConnection` có `${DATABASE_URL}`

**Swagger 404?**
→ Đã update Program.cs chưa?

**CORS error?**
→ Update `AllowedOrigins__2` với domain Railway thực tế

## 📚 Chi Tiết Hơn

Đọc file `RAILWAY_DEPLOYMENT.md` để biết thêm chi tiết.

---

🎉 **Xong! API đã online, FE có thể gọi và xem Swagger rồi!**
