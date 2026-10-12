# Muse Watch installation helper for Windows PowerShell 5.1 or PowerShell 7.
# Run only with your own watch. No root, firmware, PIN, or assistant changes.
param([string]$AdbPath = (Join-Path $PSScriptRoot 'platform-tools\adb.exe'))
$ErrorActionPreference = 'Stop'
$packageName = 'dev.community.musewatch'
$activityName = 'dev.cameronpak.muser1.MainActivity'

function Invoke-Adb {
    param([string[]]$Arguments)
    & $AdbPath @Arguments
    if ($LASTEXITCODE -ne 0) { throw 'ADB command failed. Check your watch connection and authorization.' }
}

try {
    if (-not (Test-Path -LiteralPath $AdbPath -PathType Leaf)) {
        throw 'Extract the official Windows platform-tools ZIP into this folder so platform-tools\adb.exe exists, or supply -AdbPath.'
    }
    $apkPath = Join-Path $PSScriptRoot 'muse-watch-debug.apk'
    if (-not (Test-Path -LiteralPath $apkPath -PathType Leaf)) { throw 'Keep this script beside muse-watch-debug.apk.' }
    Write-Host 'Enable ADB debugging and Wireless debugging on your Galaxy Watch5 Pro.'
    Write-Host 'For first connection, select Pair new device on the watch.'
    $pairAddress = Read-Host 'Pairing IP:port (press Enter if this computer is already paired)'
    if ($pairAddress.Trim()) {
        if ($pairAddress -notmatch '^\d{1,3}(\.\d{1,3}){3}:\d{1,5}$') { throw 'Enter the IPv4 address and pairing port shown on the watch.' }
        Invoke-Adb -Arguments @('pair', $pairAddress)
    }
    $watchAddress = Read-Host 'Connection IP:port shown on the main Wireless debugging screen'
    if ($watchAddress -notmatch '^\d{1,3}(\.\d{1,3}){3}:\d{1,5}$') { throw 'Enter the IPv4 address and connection port shown on the watch.' }
    Invoke-Adb -Arguments @('connect', $watchAddress)
    $model = (& $AdbPath -s $watchAddress shell getprop ro.product.model | Out-String).Trim()
    if ($LASTEXITCODE -ne 0) { throw 'Could not verify the selected watch.' }
    if ($model -notmatch '^SM-R92[05]') { throw 'The selected device is not a Galaxy Watch5 Pro. This helper stops before installing.' }
    Write-Host "Connected to Galaxy Watch5 Pro ($model)."
    Invoke-Adb -Arguments @('-s', $watchAddress, 'install', '-r', $apkPath)

    $provision = Read-Host 'First setup: add your Muse SDK token now? Enter Y. For an update, press Enter'
    if ($provision -match '^[Yy]$') {
        Invoke-Adb -Arguments @('-s', $watchAddress, 'shell', 'am', 'force-stop', $packageName)
        $secureToken = Read-Host 'Muse SDK token (hidden)' -AsSecureString
        $tokenBuffer = [IntPtr]::Zero
        try {
            $tokenBuffer = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureToken)
            $plainToken = [Runtime.InteropServices.Marshal]::PtrToStringBSTR($tokenBuffer).Trim()
            if (-not $plainToken.StartsWith('mgst_') -or $plainToken.Length -gt 16384) { throw 'Expected a Muse Gadget SDK token starting with mgst_.' }
            # Token goes over stdin; never in process arguments, a source file, or printed output.
            $shellCommand = "run-as $packageName sh -c 'umask 077; mkdir -p files; cat > files/pending-sdk-token'"
            $plainToken | & $AdbPath -s $watchAddress shell $shellCommand
            if ($LASTEXITCODE -ne 0) { throw 'Token transfer did not complete.' }
        } finally {
            $plainToken = $null
            if ($tokenBuffer -ne [IntPtr]::Zero) { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($tokenBuffer) }
            if ($null -ne $secureToken) { $secureToken.Dispose() }
        }
    }
    Invoke-Adb -Arguments @('-s', $watchAddress, 'shell', 'am', 'start', '-n', "$packageName/$activityName")
    if ($provision -match '^[Yy]$') {
        Start-Sleep -Seconds 2
        Invoke-Adb -Arguments @('-s', $watchAddress, 'shell', "run-as $packageName sh -c 'test ! -e files/pending-sdk-token && test -s no_backup/credentials.enc'")
        Write-Host 'Encrypted token import verified.'
    }
    Write-Host 'On the watch, tap Setup > Pair / reconnect, then add the gadget in Muse on your phone.'
    Write-Host 'After testing, turn off Wireless debugging and ADB debugging on your watch.'
} catch {
    Write-Error $_.Exception.Message
    exit 1
}
