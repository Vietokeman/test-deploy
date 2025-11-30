# Railway Environment Variables

Copy và paste các biến môi trường này vào Railway Dashboard.

## 🔴 Required Variables (Bắt buộc)

### Database & Cache
```
ConnectionStrings__DefaultConnection=Host=postgres.railway.internal;Port=5432;Database=railway;Username=postgres;Password=LTspTgDoWcyiqBpVXjjwaKBWWrTVMIbj;SSL Mode=Prefer
ConnectionStrings__Redis=redis.railway.internal:6379,password=GIVTarRHyHtJEtwYLHipfrLfJXQbdOrW,ssl=False,abortConnect=False
Repository__Provider=PostgreSQL
```

### ASP.NET Core Environment
```
ASPNETCORE_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:8080
DOTNET_ENVIRONMENT=Production
```

### CORS - Allowed Origins
```
AllowedOrigins__0=http://localhost:3000
AllowedOrigins__1=https://trippio-fe.vercel.app
AllowedOrigins__2=https://your-railway-app.up.railway.app
AllowedOrigins__3=https://your-custom-domain.com
```

### JWT Settings
```
JwtTokenSettings__Key=bXlfc2VjdXJlX2p3dF9rZXlfMTI4IQ==
JwtTokenSettings__Issuer=https://your-railway-app.up.railway.app
JwtTokenSettings__ExpireInHours=24
```

## 🟡 Optional Variables (Tùy chọn)

### Google Authentication
```
Authentication__Google__ClientId=45013553161-9c1mg1qmk428buh8aqsnvr6uq5bpg6e4.apps.googleusercontent.com
Authentication__Google__ClientSecret=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
```

### PayOS Payment Gateway
```
PayOS__ClientId=0386ff7b-5d12-419f-8471-5015b22aff94
PayOS__ApiKey=6d78ef9e-4c3c-47be-b750-89583c33948a
PayOS__ChecksumKey=8babdef8d145850c9e2af2b7f2be7e5d340a8f46fe1756ed11b40ed0c7d010f1
PayOS__WebReturnUrl=https://trippio-fe.vercel.app/payment/success
PayOS__WebCancelUrl=https://trippio-fe.vercel.app/payment/cancel
PayOS__MobileReturnUrl=trippio://payment/success
PayOS__MobileCancelUrl=trippio://payment/cancel
PayOS__WebhookUrl=https://your-railway-app.up.railway.app/api/payment/payos-callback
```

### Media Settings
```
MediaSettings__AllowImageFileTypes=image/png,image/jpeg,image/gif,image/bmp,image/webp,image/svg+xml
MediaSettings__ImagePath=media
MediaSettings__ImageUrl=/images/no-image.png
```

### Email SMTP (Gmail)
```
Smtp__Host=smtp.gmail.com
Smtp__Port=587
Smtp__User=vietbmt19@gmail.com
Smtp__Pass=raka azkp yhzv ltgd
Smtp__UseSsl=false
Smtp__UseStartTls=true
Smtp__FromName=Trippio
Smtp__FromEmail=vietnse180672@fpt.edu.vn
```

---

## 📝 Lưu ý khi setup trên Railway:

1. **DATABASE_URL** - Railway tự động tạo khi add PostgreSQL service
2. **REDIS_URL** - Railway tự động tạo khi add Redis service  
3. Thay `your-railway-app.up.railway.app` bằng domain Railway của bạn
4. Thay `your-custom-domain.com` bằng custom domain nếu có
5. **Repository__Provider=PostgreSQL** - Quan trọng! Bắt buộc phải có để dùng PostgreSQL

## 🚀 Quick Copy (Ready to Use - With Your Credentials)

Copy block này vào Railway Variables (đã có PostgreSQL & Redis credentials):

```
ASPNETCORE_ENVIRONMENT=Production
DOTNET_ENVIRONMENT=Production
ASPNETCORE_URLS=http://+:8080
Repository__Provider=PostgreSQL
ConnectionStrings__DefaultConnection=Host=postgres.railway.internal;Port=5432;Database=railway;Username=postgres;Password=LTspTgDoWcyiqBpVXjjwaKBWWrTVMIbj;SSL Mode=Prefer
ConnectionStrings__Redis=redis.railway.internal:6379,password=GIVTarRHyHtJEtwYLHipfrLfJXQbdOrW,ssl=False,abortConnect=False
AllowedOrigins__0=https://trippio-fe.vercel.app
AllowedOrigins__1=https://your-railway-app.up.railway.app
JwtTokenSettings__Key=bXlfc2VjdXJlX2p3dF9rZXlfMTI4IQ==
JwtTokenSettings__Issuer=https://your-railway-app.up.railway.app
JwtTokenSettings__ExpireInHours=24
PayOS__ClientId=0386ff7b-5d12-419f-8471-5015b22aff94
PayOS__ApiKey=6d78ef9e-4c3c-47be-b750-89583c33948a
PayOS__ChecksumKey=8babdef8d145850c9e2af2b7f2be7e5d340a8f46fe1756ed11b40ed0c7d010f1
PayOS__WebReturnUrl=https://trippio-fe.vercel.app/payment/success
PayOS__WebCancelUrl=https://trippio-fe.vercel.app/payment/cancel
PayOS__MobileReturnUrl=trippio://payment/success
PayOS__MobileCancelUrl=trippio://payment/cancel
PayOS__WebhookUrl=https://your-railway-app.up.railway.app/api/payment/payos-callback
Authentication__Google__ClientId=45013553161-9c1mg1qmk428buh8aqsnvr6uq5bpg6e4.apps.googleusercontent.com
Authentication__Google__ClientSecret=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
Smtp__Host=smtp.gmail.com
Smtp__Port=587
Smtp__User=vietbmt19@gmail.com
Smtp__Pass=raka azkp yhzv ltgd
Smtp__FromName=Trippio
Smtp__FromEmail=vietnse180672@fpt.edu.vn
MediaSettings__AllowImageFileTypes=image/png,image/jpeg,image/gif,image/bmp,image/webp,image/svg+xml
MediaSettings__ImagePath=media
```

**⚠️ Chỉ cần thay `your-railway-app.up.railway.app` bằng domain Railway thực của bạn!**
```
