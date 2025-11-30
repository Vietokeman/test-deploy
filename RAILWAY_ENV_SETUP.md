# Railway Environment Variables Setup

## ⚠️ Quan trọng: Dockerfile đã tạo appsettings.json tối thiểu

File config sẽ được override bởi Environment Variables trong Railway.

## 🔧 Các biến cần thiết trong Railway → Variables:

### 1. Database Connection (BẮT BUỘC)
```
ConnectionStrings__DefaultConnection=${{DATABASE_URL}}
```
Hoặc nếu dùng PostgreSQL từ Railway:
```
ConnectionStrings__DefaultConnection=${{PGDATABASE_URL}}
```

### 2. JWT Settings (BẮT BUỘC)
```
JwtTokenSettings__Key=YOUR_SECRET_KEY_AT_LEAST_32_CHARACTERS_LONG
JwtTokenSettings__Issuer=https://your-app.railway.app
JwtTokenSettings__ExpireInHours=24
```

### 3. Redis (nếu dùng)
```
ConnectionStrings__Redis=your-redis-connection-string
```

### 4. Google OAuth (nếu dùng)
```
Authentication__Google__ClientId=your-google-client-id
Authentication__Google__ClientSecret=your-google-client-secret
```

### 5. PayOS (nếu dùng payment)
```
PayOS__ClientId=your-payos-client-id
PayOS__ApiKey=your-payos-api-key
PayOS__ChecksumKey=your-payos-checksum-key
PayOS__WebReturnUrl=https://trippio-fe.vercel.app/payment/success
PayOS__WebCancelUrl=https://trippio-fe.vercel.app/payment/cancel
PayOS__WebhookUrl=https://your-app.railway.app/api/payment/payos-callback
```

### 6. SMTP (nếu dùng email)
```
Smtp__Host=smtp.gmail.com
Smtp__Port=587
Smtp__User=your-email@gmail.com
Smtp__Pass=your-app-password
Smtp__UseSsl=false
Smtp__UseStartTls=true
Smtp__FromName=Trippio
Smtp__FromEmail=your-email@gmail.com
```

### 7. Logging
```
Logging__LogLevel__Default=Information
Logging__LogLevel__Microsoft.AspNetCore=Warning
```

## 📝 Cách thêm trong Railway:

1. Vào Railway Dashboard
2. Chọn service của bạn
3. Tab **Variables**
4. Click **+ New Variable**
5. Thêm từng biến ở trên
6. Click **Deploy**

## 🎯 Ưu điểm cách này:

✅ Không cần commit appsettings.json vào git  
✅ File được tạo tự động trong Docker  
✅ Config thật được override qua Environment Variables  
✅ Bảo mật cao hơn (không lộ secrets trong git)  
✅ Dễ dàng thay đổi config mà không cần redeploy code  

## 🔄 Sau khi thêm variables:

Railway sẽ tự động restart app với config mới!
