# Cấu hình APPSETTINGS_JSON cho Railway

## Cách sử dụng

Trong Railway, tạo một environment variable tên là `APPSETTINGS_JSON` với nội dung sau (format JSON minified):

```json
{"ConnectionStrings":{"DefaultConnection":"YOUR_DATABASE_CONNECTION_STRING","Redis":"YOUR_REDIS_CONNECTION_STRING"},"Logging":{"LogLevel":{"Default":"Information","Microsoft.AspNetCore":"Warning"}},"AllowedHosts":"*","Authentication":{"Google":{"ClientId":"YOUR_GOOGLE_CLIENT_ID","ClientSecret":"YOUR_GOOGLE_CLIENT_SECRET"}},"JwtTokenSettings":{"Key":"YOUR_JWT_SECRET_KEY","Issuer":"YOUR_ISSUER","ExpireInHours":24},"AllowedOrigins":["http://localhost:3000","https://trippio-fe.vercel.app","http://localhost:4200","https://trippiov2.azurewebsites.net","exp://localhost:8081","trippio://*"],"MediaSettings":{"AllowImageFileTypes":"image/png,image/jpeg,image/gif,image/bmp,image/webp,image/svg+xml","ImagePath":"media","ImageUrl":"/images/no-image.png"},"Serilog":{"Using":["Serilog.Sinks.Console","Serilog.Sinks.File"],"MinimumLevel":{"Default":"Information","Override":{"Microsoft":"Warning","System":"Warning"}},"WriteTo":[{"Name":"Console"},{"Name":"File","Args":{"path":"Logs/log-.txt","rollingInterval":"Day","outputTemplate":"[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj}{NewLine}{Exception}"}}],"Enrich":["FromLogContext","WithMachineName","WithThreadId"],"Properties":{"Application":"Trippio.Api"}},"Repository":{"Provider":"SqlServer"},"Smtp":{"Host":"smtp.gmail.com","Port":587,"User":"YOUR_EMAIL","Pass":"YOUR_APP_PASSWORD","UseSsl":false,"UseStartTls":true,"FromName":"Trippio","FromEmail":"YOUR_EMAIL"},"Twilio":{"AccountSid":"YOUR_TWILIO_ACCOUNT_SID","AuthToken":"YOUR_TWILIO_AUTH_TOKEN","PhoneNumber":"YOUR_TWILIO_PHONE"},"PayOS":{"ClientId":"YOUR_PAYOS_CLIENT_ID","ApiKey":"YOUR_PAYOS_API_KEY","ChecksumKey":"YOUR_PAYOS_CHECKSUM_KEY","WebReturnUrl":"https://trippio-fe.vercel.app/payment/success","WebCancelUrl":"https://trippio-fe.vercel.app/payment/cancel","MobileReturnUrl":"trippio://payment/success","MobileCancelUrl":"trippio://payment/cancel","WebhookUrl":"YOUR_WEBHOOK_URL"}}
```

## Hướng dẫn chi tiết

### 1. Truy cập Railway Dashboard
- Vào project của bạn
- Chọn service cần deploy
- Click vào tab **Variables**

### 2. Thêm Environment Variable

**Tên biến:** `APPSETTINGS_JSON`

**Giá trị:** Copy nội dung JSON ở trên và thay thế các giá trị:

- `YOUR_DATABASE_CONNECTION_STRING`: Connection string database của bạn (Railway PostgreSQL hoặc SQL Server)
- `YOUR_REDIS_CONNECTION_STRING`: Connection string Redis của bạn
- `YOUR_GOOGLE_CLIENT_ID`: Google OAuth Client ID
- `YOUR_GOOGLE_CLIENT_SECRET`: Google OAuth Client Secret
- `YOUR_JWT_SECRET_KEY`: Secret key cho JWT (tạo random string)
- `YOUR_ISSUER`: Domain của bạn
- `YOUR_EMAIL`: Email SMTP
- `YOUR_APP_PASSWORD`: App password của email
- `YOUR_TWILIO_ACCOUNT_SID`: Twilio Account SID
- `YOUR_TWILIO_AUTH_TOKEN`: Twilio Auth Token
- `YOUR_TWILIO_PHONE`: Twilio phone number
- `YOUR_PAYOS_CLIENT_ID`: PayOS Client ID
- `YOUR_PAYOS_API_KEY`: PayOS API Key
- `YOUR_PAYOS_CHECKSUM_KEY`: PayOS Checksum Key
- `YOUR_WEBHOOK_URL`: URL webhook của bạn trên Railway

### 3. Cách tạo minified JSON

Nếu bạn muốn format lại JSON từ file appsettings.json hiện tại:

**Option 1: Sử dụng online tool**
- Truy cập: https://codebeautify.org/jsonminifier
- Paste nội dung appsettings.json
- Click "Minify JSON"
- Copy kết quả

**Option 2: Sử dụng PowerShell**
```powershell
$json = Get-Content "src/Trippio.Api/appsettings.json" -Raw | ConvertFrom-Json
$minified = $json | ConvertTo-Json -Compress -Depth 10
$minified | Set-Content "appsettings.min.json"
```

### 4. Deploy

Sau khi thêm environment variable:
1. Railway sẽ tự động trigger deploy lại
2. Dockerfile sẽ tự động generate file appsettings.json từ biến `APPSETTINGS_JSON`
3. Application sẽ sử dụng file config này

## Lưu ý quan trọng

⚠️ **BẢO MẬT:**
- Không commit file `appsettings.json` vào git (đã có trong .gitignore)
- Các thông tin nhạy cảm chỉ lưu trong Railway Environment Variables
- Thường xuyên rotate keys và passwords

📝 **DEVELOPMENT:**
- Để develop local, tạo file `appsettings.Development.json` với config local
- File này cũng đã được ignore trong git

🔄 **CẬP NHẬT CONFIG:**
- Khi cần thay đổi config, chỉ cần update environment variable `APPSETTINGS_JSON` trong Railway
- Railway sẽ tự động redeploy với config mới
