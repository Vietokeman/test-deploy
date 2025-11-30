# 🌐 Cách Tìm Railway Domain

## Cách 1: Trong Railway Dashboard

1. Vào **Railway Dashboard**: https://railway.app/dashboard
2. Click vào **Project** của bạn (test-deploy)
3. Click vào **API Service** (service chính)
4. Vào tab **Settings**
5. Scroll xuống phần **"Networking"** hoặc **"Domains"**
6. Bạn sẽ thấy domain có dạng:
   ```
   https://test-deploy-production-xxxx.up.railway.app
   ```
   hoặc
   ```
   https://your-service-name.railway.app
   ```

## Cách 2: Trong Deployments

1. Vào tab **Deployments**
2. Click vào deployment đang chạy (có dấu ✓ xanh)
3. Bên phải sẽ có button **"View Deployment"** hoặc hiển thị domain

## Cách 3: Generate Domain Mới

Nếu chưa có domain:

1. Vào **Settings** tab của service
2. Scroll xuống **"Networking"**
3. Click **"Generate Domain"**
4. Railway sẽ tạo domain tự động dạng: `xxx.up.railway.app`

## 📝 Update Domain Vào Environment Variables

Sau khi có domain (ví dụ: `test-deploy-production.up.railway.app`), update các biến:

```
AllowedOrigins__1=https://test-deploy-production.up.railway.app
JwtTokenSettings__Issuer=https://test-deploy-production.up.railway.app
PayOS__WebhookUrl=https://test-deploy-production.up.railway.app/api/payment/payos-callback
```

## 🔗 Custom Domain (Tùy chọn)

Nếu muốn dùng domain riêng (ví dụ: api.trippio.com):

1. Vào **Settings** → **Networking**
2. Click **"Custom Domain"**
3. Nhập domain của bạn
4. Thêm CNAME record vào DNS provider:
   ```
   CNAME: api.trippio.com → xxx.up.railway.app
   ```

---

**Lưu ý:** Railway domain được generate tự động khi bạn deploy lần đầu!
