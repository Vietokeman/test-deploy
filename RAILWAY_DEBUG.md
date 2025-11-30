# 🚀 Railway Deployment Quick Fix

## ⚠️ Lỗi "Application failed to respond"

### Nguyên nhân chính:
App thiếu **Environment Variables bắt buộc** để start.

---

## ✅ BƯỚC 1: Thêm Environment Variables trong Railway

Vào Railway Dashboard → Service → **Variables** → Thêm các biến sau:

### 🔴 BẮT BUỘC (App sẽ không start nếu thiếu):

```bash
# Database Connection
ConnectionStrings__DefaultConnection=Server=your-server;Database=your-db;User Id=user;Password=pass;TrustServerCertificate=True

# JWT Settings
JwtTokenSettings__Key=your-secret-key-must-be-at-least-32-characters-long-for-security
JwtTokenSettings__Issuer=https://trippio.up.railway.app
JwtTokenSettings__ExpireInHours=24

# Allowed Origins (CORS)
AllowedOrigins__0=https://trippio-fe.vercel.app
AllowedOrigins__1=https://trippio.up.railway.app
```

### 🟡 Tùy chọn (nhưng nên có):

```bash
# Redis (nếu dùng cache)
ConnectionStrings__Redis=your-redis-connection-string

# SMTP (nếu dùng email)
Smtp__Host=smtp.gmail.com
Smtp__Port=587
Smtp__User=your-email@gmail.com
Smtp__Pass=your-app-password
Smtp__FromEmail=your-email@gmail.com
Smtp__FromName=Trippio

# Google OAuth (nếu dùng)
Authentication__Google__ClientId=your-client-id
Authentication__Google__ClientSecret=your-client-secret

# PayOS (nếu dùng payment)
PayOS__ClientId=your-client-id
PayOS__ApiKey=your-api-key
PayOS__ChecksumKey=your-checksum-key
PayOS__WebhookUrl=https://trippio.up.railway.app/api/payment/payos-callback
```

---

## ✅ BƯỚC 2: Kiểm tra Networking Settings

Trong Railway → **Settings** → **Networking**:

- ✅ Domain: `trippio.up.railway.app`
- ✅ Target Port: **8080** (phải khớp với Dockerfile)
- ✅ Protocol: **HTTP**

---

## ✅ BƯỚC 3: Xem Deploy Logs

1. Vào Railway Dashboard
2. Click vào service
3. Tab **Deployments**
4. Click vào deployment mới nhất
5. Xem **Deploy Logs** để biết lỗi cụ thể

### Các lỗi thường gặp:

#### ❌ "The configuration file 'appsettings.json' was not found"
→ **Đã fix:** Dockerfile tạo `appsettings.Production.json` tự động

#### ❌ "Value cannot be null. (Parameter 'connectionString')"
→ **Thiếu:** `ConnectionStrings__DefaultConnection`

#### ❌ "IDX10720: Unable to create KeyedHashAlgorithm..."
→ **Thiếu hoặc ngắn:** `JwtTokenSettings__Key` (cần ≥32 ký tự)

#### ❌ "Application startup exception"
→ Xem chi tiết trong logs, thường là thiếu config

---

## ✅ BƯỚC 4: Redeploy

Sau khi thêm environment variables:
- Railway sẽ tự động trigger redeploy
- Hoặc click **Redeploy** thủ công

---

## 📋 Checklist Debug:

- [ ] Đã thêm `ConnectionStrings__DefaultConnection`
- [ ] Đã thêm `JwtTokenSettings__Key` (≥32 ký tự)
- [ ] Đã thêm `JwtTokenSettings__Issuer`
- [ ] Target Port = **8080**
- [ ] Xem Deploy Logs để biết lỗi cụ thể
- [ ] Database connection string đúng format
- [ ] Không có lỗi trong Build Logs

---

## 🔍 Xem Logs chi tiết:

```bash
# Trong Railway Dashboard:
Deployments → Click deployment → View Logs

# Hoặc nếu có Railway CLI:
railway logs
```

---

## 💡 Tips:

1. **Test local trước:**
   ```bash
   docker build -f Dockerfile.railway -t trippio-test .
   docker run -p 8080:8080 -e "ConnectionStrings__DefaultConnection=..." trippio-test
   ```

2. **Database Railway:**
   Nếu dùng database của Railway, connection string có dạng:
   ```
   ${{Postgres.DATABASE_URL}}
   ```
   Railway sẽ tự động replace biến này.

3. **Check health endpoint:**
   Sau khi deploy, test: `https://trippio.up.railway.app/health`
