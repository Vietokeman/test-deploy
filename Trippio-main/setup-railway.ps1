# Script tu dong setup Railway deployment
# Chay script nay de chuan bi project cho Railway deployment

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  TRIPPIO RAILWAY DEPLOYMENT SETUP" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if running in correct directory
if (-Not (Test-Path "src/Trippio.Api/Trippio.Api.csproj")) {
    Write-Host "X Error: Please run this script from the root directory (where Trippio.BE.sln is)" -ForegroundColor Red
    Write-Host "Current directory: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "OK Directory check passed" -ForegroundColor Green
Write-Host ""

# Step 1: Install Npgsql packages
Write-Host "Package Step 1: Installing Npgsql packages..." -ForegroundColor Yellow
Write-Host ""

Write-Host "  -> Installing Npgsql for Trippio.Data..." -ForegroundColor Gray
Set-Location "src/Trippio.Data"
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0

if ($LASTEXITCODE -ne 0) {
    Write-Host "X Failed to install Npgsql for Trippio.Data" -ForegroundColor Red
    Set-Location "../.."
    exit 1
}

Write-Host "  OK Npgsql installed for Trippio.Data" -ForegroundColor Green
Write-Host ""

Write-Host "  -> Installing Npgsql for Trippio.Api..." -ForegroundColor Gray
Set-Location "../Trippio.Api"
dotnet add package Npgsql.EntityFrameworkCore.PostgreSQL --version 8.0.0

if ($LASTEXITCODE -ne 0) {
    Write-Host "X Failed to install Npgsql for Trippio.Api" -ForegroundColor Red
    Set-Location "../.."
    exit 1
}

Write-Host "  OK Npgsql installed for Trippio.Api" -ForegroundColor Green
Set-Location "../.."
Write-Host ""

# Step 2: Check if files exist
Write-Host "Checklist Step 2: Checking deployment files..." -ForegroundColor Yellow
Write-Host ""

$requiredFiles = @(
    "Dockerfile.railway",
    "railway.json",
    ".env.railway",
    ".railwayignore",
    "RAILWAY_DEPLOYMENT.md",
    "QUICK_START_RAILWAY.md",
    "DEPLOYMENT_README.md"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  OK $file" -ForegroundColor Green
    } else {
        Write-Host "  X $file (missing)" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-Not $allFilesExist) {
    Write-Host ""
    Write-Host "X Some deployment files are missing. Please ensure all files are created." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "OK All deployment files present" -ForegroundColor Green
Write-Host ""

# Step 3: Git status check
Write-Host "Note Step 3: Checking Git status..." -ForegroundColor Yellow
Write-Host ""

$gitStatus = git status --porcelain 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Warning: Git not initialized or not a git repository" -ForegroundColor Yellow
    Write-Host "   You may need to initialize git manually" -ForegroundColor Gray
} else {
    Write-Host "  OK Git repository detected" -ForegroundColor Green
    
    if ($gitStatus) {
        Write-Host ""
        Write-Host "  Chart Changed files:" -ForegroundColor Cyan
        Write-Host $gitStatus
    } else {
        Write-Host "  Info No changes detected" -ForegroundColor Gray
    }
}

Write-Host ""

# Step 4: Ask to commit
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Party Setup completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Checklist Next Steps:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Review the changes:" -ForegroundColor White
Write-Host "   git status" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Commit and push to GitHub:" -ForegroundColor White
Write-Host "   git add ." -ForegroundColor Gray
Write-Host "   git commit -m 'feat: add Railway deployment support with PostgreSQL'" -ForegroundColor Gray
Write-Host "   git push origin main" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Go to Railway:" -ForegroundColor White
Write-Host "   https://railway.app/dashboard" -ForegroundColor Cyan
Write-Host ""
Write-Host "4. Read the quick start guide:" -ForegroundColor White
Write-Host "   Open QUICK_START_RAILWAY.md" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Read the detailed guide:" -ForegroundColor White
Write-Host "   Open RAILWAY_DEPLOYMENT.md" -ForegroundColor Gray
Write-Host ""

# Ask if user wants to commit now
$commit = Read-Host "Do you want to commit and push changes now? (y/N)"

if ($commit -eq "y" -or $commit -eq "Y") {
    Write-Host ""
    Write-Host "Upload Committing and pushing to GitHub..." -ForegroundColor Yellow
    
    git add .
    git commit -m "feat: add Railway deployment support with PostgreSQL"
    git push origin main
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "OK Successfully pushed to GitHub!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Rocket You can now deploy on Railway!" -ForegroundColor Cyan
        Write-Host "   Visit: https://railway.app/new" -ForegroundColor Cyan
    } else {
        Write-Host ""
        Write-Host "X Failed to push to GitHub" -ForegroundColor Red
        Write-Host "   Please check your git configuration and try manually" -ForegroundColor Yellow
    }
} else {
    Write-Host ""
    Write-Host "Info Skipping git commit. Don't forget to commit and push manually!" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Setup script completed! Happy deploying!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
