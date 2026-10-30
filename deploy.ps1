
# MFSIP - Flutter Web Cloudflare Deployment

$ErrorActionPreference = "Stop"

$ProjectName = "mfsip"
$Branch = "main"

try {
    Set-Location $PSScriptRoot

    Write-Host "Starting MFSIP deployment..." -ForegroundColor Cyan

    # Step 1 - Check required tools
    if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
        throw "Flutter CLI is not installed or not in PATH."
    }

    if (-not (Get-Command npx -ErrorAction SilentlyContinue)) {
        throw "Node.js/npm is not installed or not in PATH."
    }

    # Step 2 - Install dependencies
    Write-Host "Installing Flutter dependencies..." -ForegroundColor Yellow

    flutter pub get
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter dependency installation failed."
    }

    # Step 3 - Build Flutter Web
    Write-Host "Building Flutter Web..." -ForegroundColor Yellow

    flutter build web --release --no-tree-shake-icons
    if ($LASTEXITCODE -ne 0) {
        throw "Flutter Web build failed."
    }

    # Step 4 - Check build output
    if (-not (Test-Path "build/web/index.html")) {
        throw "Flutter build output not found."
    }

    # Step 5 - Deploy to Cloudflare Pages
    Write-Host "Deploying to Cloudflare Pages..." -ForegroundColor Yellow

    npx --no-install wrangler pages deploy build/web `
        --project-name=$ProjectName `
        --branch=$Branch

    if ($LASTEXITCODE -ne 0) {
        throw "Cloudflare Pages deployment failed."
    }

    Write-Host "Deployment successful!" -ForegroundColor Green
}
catch {
    Write-Host "Deployment failed: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
