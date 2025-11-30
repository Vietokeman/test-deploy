# 🚀 HƯỚNG DẪN DEPLOY TRIPPIO LÊN RAILWAY (MIỄN PHÍ)

## 📋 Tổng Quan

Dự án Trippio Backend sẽ được deploy với kiến trúc:
- **API**: .NET 8.0 Web API
- **Database**: PostgreSQL (Railway cung cấp free)
- **Cache**: Redis (Railway cung cấp free)
- **Deployment**: Railway Platform

## 🎯 Yêu Cầu Trước Khi Bắt Đầu

1. ✅ Tài khoản GitHub (để connect với Railway)
2. ✅ Tài khoản Railway (đăng ký tại https://railway.app)
3. ✅ Code đã push lên GitHub repository
4. ✅ Credit card để verify (không bị charge, chỉ verify - hoặc dùng GitHub Student Pack)

## 🔧 Bước 1: Chuẩn Bị Code

### 1.1. Cài đặt Npgsql Provider cho PostgreSQL

Mở terminal trong thư mục `src/` và chạy:

```powershell
# Di chuyển vào thư mục Trippio.Data
cd src/Trippio.Data

# Cài đặt Npgsql Entity Framework Core provider
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0

# Di chuyển vào thư mục Trippio.Api
cd ../Trippio.Api

# Cài đặt Npgsql cho API project
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0

# Về lại root
cd ../..
```

### 1.2. Update DbContext Configuration

Mở file `src/Trippio.Api/Program.cs` và tìm dòng:

```csharp
builder.Services.AddDbContext<TrippioDbContext>(options =>
    options.UseSqlServer(connectionString));
```

Thay bằng:

```csharp
// Lấy provider từ configuration (SqlServer hoặc PostgreSql)
var dbProvider = configuration.GetValue<string>("Repository:Provider");

builder.Services.AddDbContext<TrippioDbContext>(options =>
{
    if (dbProvider == "PostgreSql")
    {
        options.UseNpgsql(connectionString);
    }
    else
    {
        options.UseSqlServer(connectionString);
    }
});
```

### 1.3. Tạo Health Check Endpoint

Kiểm tra trong `Program.cs` có đoạn này chưa (thường ở cuối file):

```csharp
// Health checks
app.MapHealthChecks("/health", new HealthCheckOptions
{
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
});

app.MapGet("/", () => Results.Redirect("/swagger"));
```

Nếu chưa có, thêm vào trước `app.Run()`.

### 1.4. Commit và Push Code

```powershell
git add .
git commit -m "feat: add Railway deployment support with PostgreSQL"
git push origin main
```

## 🚂 Bước 2: Setup Railway Project

### 2.1. Tạo Project Mới

1. Truy cập https://railway.app/dashboard
2. Click **"New Project"**
3. Chọn **"Deploy from GitHub repo"**
4. Authorize Railway với GitHub
5. Chọn repository **Trippio Backend**

### 2.2. Add PostgreSQL Database

1. Trong Railway project, click **"+ New"**
2. Chọn **"Database"** → **"Add PostgreSQL"**
3. Railway sẽ tự động tạo database và generate credentials
4. Database sẽ có tên như `postgres-xxx`

### 2.3. Add Redis Cache

1. Click **"+ New"** lại
2. Chọn **"Database"** → **"Add Redis"**
3. Railway sẽ tự động tạo Redis instance
4. Redis sẽ có tên như `redis-xxx`

### 2.4. Configure API Service

1. Click vào service API (tên repository của bạn)
2. Vào tab **"Settings"**
3. Tìm **"Build"** section:
   - **Builder**: Dockerfile
   - **Dockerfile Path**: `Dockerfile.railway`
   - **Docker Build Context**: `/` (root)

4. Tìm **"Deploy"** section:
   - **Start Command**: (để trống, dùng ENTRYPOINT từ Dockerfile)
   - **Health Check Path**: `/health`
   - **Health Check Timeout**: `300` seconds

5. Tìm **"Networking"** section:
   - Enable **"Public Networking"**
   - Railway sẽ generate domain: `https://your-app-name.up.railway.app`
   - (Optional) Thêm custom domain nếu có

## ⚙️ Bước 3: Configure Environment Variables

### 3.1. Lấy Database Connection String

1. Click vào **PostgreSQL service**
2. Vào tab **"Variables"**
3. Copy các biến:
   - `DATABASE_URL` hoặc
   - `PGHOST`, `PGPORT`, `PGDATABASE`, `PGUSER`, `PGPASSWORD`

### 3.2. Lấy Redis Connection String

1. Click vào **Redis service**
2. Vào tab **"Variables"**
3. Copy biến `REDIS_URL` hoặc `REDIS_PRIVATE_URL`

### 3.3. Configure API Service Variables

1. Click vào **API service**
2. Vào tab **"Variables"**
3. Click **"+ New Variable"** và thêm từng biến sau:

#### **Database Connection** (Chọn 1 trong 2 cách)

**Cách 1: Dùng DATABASE_URL trực tiếp** (Khuyến nghị)
```
ConnectionStrings__DefaultConnection = ${DATABASE_URL}
```

**Cách 2: Build connection string từ các biến riêng**
```
ConnectionStrings__DefaultConnection = Host=${PGHOST};Port=${PGPORT};Database=${PGDATABASE};Username=${PGUSER};Password=${PGPASSWORD};SSL Mode=Require;Trust Server Certificate=true
```

#### **Redis Connection**
```
ConnectionStrings__Redis = ${REDIS_URL}
```

Hoặc nếu cần format khác:
```
ConnectionStrings__Redis = ${REDIS_HOST}:${REDIS_PORT},password=${REDIS_PASSWORD},ssl=false,abortConnect=false
```

#### **Application Settings**
```
ASPNETCORE_ENVIRONMENT = Production
DOTNET_ENVIRONMENT = Production
Repository__Provider = PostgreSql
```

#### **CORS - CẬP NHẬT DOMAIN RAILWAY CỦA BẠN**
```
AllowedOrigins__0 = http://localhost:3000
AllowedOrigins__1 = https://trippio-fe.vercel.app
AllowedOrigins__2 = https://your-railway-app.up.railway.app
```
> ⚠️ **QUAN TRỌNG**: Thay `your-railway-app` bằng domain thực tế Railway cấp cho bạn!

#### **JWT Settings**
```
JwtTokenSettings__Key = bXlfc2VjdXJlX2p3dF9rZXlfMTI4IQ==
JwtTokenSettings__Issuer = https://your-railway-app.up.railway.app
JwtTokenSettings__ExpireInHours = 24
```

#### **Google OAuth** (Copy từ appsettings.json)
```
Authentication__Google__ClientId = 45013553161-9c1mg1qmk428buh8aqsnvr6uq5bpg6e4.apps.googleusercontent.com
Authentication__Google__ClientSecret = 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
```

#### **Payment Settings** (Copy từ appsettings.json)
```
Payments__WebhookSecret = hahaae
Payments__VNPay__TmnCode = TMPRY52R
Payments__VNPay__THashSecret = 28G11MCL1G6Q3D2DO3Q2J9I5OSVA04W3
PayOS__ClientId = 0386ff7b-5d12-419f-8471-5015b22aff94
PayOS__ApiKey = 6d78ef9e-4c3c-47be-b750-89583c33948a
PayOS__ChecksumKey = 9c37932e3ace8e716c270f6a0e68ea47c3b0a0e8a13f80c8fcb627a70d6df8e7
```

#### **Email Settings**
```
Smtp__Host = smtp.gmail.com
Smtp__Port = 587
Smtp__User = vietbmt19@gmail.com
Smtp__Pass = raka azkp yhzv ltgd
Smtp__FromEmail = vietnse180672@fpt.edu.vn
```

> 💡 **TIP**: Copy toàn bộ nội dung file `.env.railway` và paste vào Raw Editor của Railway (click icon `</>` ở góc phải màn hình Variables)

## 🚀 Bước 4: Deploy

### 4.1. Trigger Deployment

1. Sau khi configure xong variables, Railway sẽ tự động deploy
2. Hoặc click **"Deploy"** để trigger manually

### 4.2. Monitor Deployment

1. Vào tab **"Deployments"**
2. Click vào deployment mới nhất
3. Xem **"Build Logs"** để theo dõi quá trình build
4. Xem **"Deploy Logs"** để theo dõi runtime

### 4.3. Chờ Database Migration

Khi lần đầu chạy, API sẽ tự động:
- Chạy migration tạo tables
- Seed initial data (nếu có)

Check logs để đảm bảo migration thành công.

## ✅ Bước 5: Kiểm Tra & Truy Cập API

### 5.1. Lấy Public URL

1. Vào **API service** → tab **"Settings"**
2. Tìm phần **"Domains"**
3. Copy URL dạng: `https://your-app.up.railway.app`

### 5.2. Test Health Check

Mở browser hoặc dùng curl:
```
https://your-app.up.railway.app/health
```

Kết quả mong đợi:
```json
{
  "status": "Healthy",
  "checks": [...]
}
```

### 5.3. Truy Cập Swagger UI

```
https://your-app.up.railway.app/swagger
```

hoặc

```
https://your-app.up.railway.app/swagger/index.html
```

🎉 **SWAGGER UI HIỂN THỊ - FE CÓ THỂ GỌI API VÀ XEM TÀI LIỆU!**

### 5.4. Test API Endpoint

```bash
# Test get hotels
curl https://your-app.up.railway.app/api/hotels

# Test authentication
curl -X POST https://your-app.up.railway.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"Test@123"}'
```

## 🔗 Bước 6: Kết Nối Frontend

### 6.1. Cập Nhật Frontend Config

Trong frontend project (React/Next.js):

```javascript
// .env hoặc config file
NEXT_PUBLIC_API_URL=https://your-railway-app.up.railway.app
NEXT_PUBLIC_API_BASE_URL=https://your-railway-app.up.railway.app/api
```

### 6.2. Test Connection

```javascript
// Test API call
fetch('https://your-railway-app.up.railway.app/api/hotels')
  .then(res => res.json())
  .then(data => console.log(data));
```

### 6.3. Cập Nhật CORS

Nếu frontend deploy ở domain khác, thêm vào Railway Variables:
```
AllowedOrigins__3 = https://your-frontend-domain.com
```

## 📊 Bước 7: Monitoring & Maintenance

### 7.1. View Logs

```
Railway Dashboard → Service → Logs tab
```

### 7.2. View Metrics

```
Railway Dashboard → Service → Metrics tab
```
- CPU Usage
- Memory Usage
- Network Traffic

### 7.3. Database Management

**Connect qua TablePlus/pgAdmin:**
```
Host: ${PGHOST}
Port: ${PGPORT}
Database: ${PGDATABASE}
Username: ${PGUSER}
Password: ${PGPASSWORD}
SSL: Required
```

### 7.4. Redis Management

**Connect qua RedisInsight:**
```
Host: ${REDIS_HOST}
Port: ${REDIS_PORT}
Password: ${REDIS_PASSWORD}
```

## 🔒 Bước 8: Security Best Practices

### 8.1. Update Secrets

Đổi các sensitive values trong Railway Variables:
- JWT Key mới
- Database password mạnh hơn
- Redis password mạnh hơn

### 8.2. Restrict CORS

Chỉ allow domains thực sự cần:
```
AllowedOrigins__0 = https://your-production-frontend.com
AllowedOrigins__1 = https://your-staging-frontend.vercel.app
```

### 8.3. Enable Rate Limiting

Thêm middleware rate limiting trong code (nếu cần).

## 💰 Chi Phí & Giới Hạn Free Tier

### Railway Free Tier:
- ✅ **$5 credit/month** (đủ cho project nhỏ)
- ✅ **500 hours execution time**
- ✅ **1GB RAM per service**
- ✅ **100GB bandwidth**
- ✅ **1GB storage**

### Estimate Usage:
- API Service: ~300MB RAM
- PostgreSQL: ~200MB RAM
- Redis: ~100MB RAM

**Total: ~600MB RAM** ✅ Fit trong 1GB limit!

## 🎯 Tối Ưu Cho Free Tier

### 1. Giảm số replicas
```
Deploy → Replicas = 1
```

### 2. Sleep khi không dùng
Railway tự động sleep services khi idle > 5 phút.

### 3. Monitor usage
```
Dashboard → Usage → View current month
```

## 🐛 Troubleshooting

### Issue 1: Build Failed

**Lỗi**: `Could not find Trippio.Data.csproj`

**Fix**: Check Dockerfile path và build context
```
Settings → Build → Docker Build Context = /
Settings → Build → Dockerfile Path = Dockerfile.railway
```

### Issue 2: Database Connection Failed

**Lỗi**: `Could not connect to PostgreSQL`

**Fix**: 
1. Check biến `ConnectionStrings__DefaultConnection` có đúng format
2. Check PostgreSQL service có đang chạy
3. Check SSL mode = Require

### Issue 3: Swagger 404

**Lỗi**: Cannot access /swagger

**Fix**: Check Program.cs có enable Swagger cho Production:
```csharp
if (app.Environment.IsDevelopment() || app.Environment.IsProduction())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
```

### Issue 4: CORS Error từ Frontend

**Lỗi**: `Access-Control-Allow-Origin error`

**Fix**: Thêm frontend domain vào AllowedOrigins variables.

## 📚 Tài Liệu Tham Khảo

- [Railway Documentation](https://docs.railway.app/)
- [Railway PostgreSQL Guide](https://docs.railway.app/databases/postgresql)
- [Railway Redis Guide](https://docs.railway.app/databases/redis)
- [.NET on Railway](https://docs.railway.app/guides/dotnet)

## 🎉 Hoàn Thành!

Bây giờ bạn đã có:

✅ API running trên Railway với public URL
✅ PostgreSQL database tự động backup
✅ Redis cache cho performance
✅ Swagger UI public để FE xem docs và test
✅ Tất cả MIỄN PHÍ (trong giới hạn $5/month)

**API Base URL**: `https://your-app.up.railway.app/api`
**Swagger URL**: `https://your-app.up.railway.app/swagger`
**Health Check**: `https://your-app.up.railway.app/health`

---

## 📞 Support

Nếu gặp vấn đề, check:
1. Railway Logs
2. GitHub Issues
3. Railway Discord Community

Happy Deploying! 🚀
