$credential = "protocol=https`nhost=github.com`n" | git credential fill
$token = (($credential | Where-Object { $_ -like 'password=*' }) -replace '^password=', '')

if ([string]::IsNullOrWhiteSpace($token)) {
  throw 'No GitHub credential is available for asset publishing.'
}

$headers = @{
  Authorization = "Bearer $token"
  Accept = 'application/vnd.github+json'
  'X-GitHub-Api-Version' = '2022-11-28'
}

$asset = Invoke-RestMethod -Method Post `
  -Uri 'https://uploads.github.com/repos/mysteriousarmy24/Expenz/releases/364694548/assets?name=Expenz-v1.0.0.apk' `
  -Headers $headers `
  -ContentType 'application/vnd.android.package-archive' `
  -InFile 'D:\Library\Projects\Flutter\Expenz\build\app\outputs\flutter-apk\app-release.apk'

$asset.browser_download_url | Set-Content 'D:\Library\Projects\Flutter\Expenz\build\release-upload-result.log'
