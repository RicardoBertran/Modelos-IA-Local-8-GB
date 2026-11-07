$ErrorActionPreference = 'Stop'
$base = Split-Path $PSScriptRoot -Parent
$exe = Join-Path $base 'llama.cpp\llama-server.exe'
$preset = Join-Path $PSScriptRoot 'modelos.ini'
$runtime = Join-Path $PSScriptRoot 'modelos-local.ini'
$url = 'http://127.0.0.1:8080'
$server = $null
try {
    if (!(Test-Path -LiteralPath $exe)) { throw 'Falta llama.cpp\llama-server.exe. Revisa el paso de instalacion del README.' }
    if (Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue) {
        throw 'El puerto 8080 ya esta ocupado. Cierra la otra instancia antes de iniciar esta.'
    }
    $lines = foreach ($line in Get-Content -LiteralPath $preset -Encoding UTF8) {
        if ($line -match '^\s*model\s*=\s*(.+?)\s*$') {
            $path = $Matches[1]
            if (![IO.Path]::IsPathRooted($path)) { $path = Join-Path $base $path }
            if (!(Test-Path -LiteralPath $path -PathType Leaf)) { throw "No se encuentra el modelo: $path" }
            'model = ' + $path
        } else { $line }
    }
    [IO.File]::WriteAllLines($runtime, [string[]]$lines, (New-Object Text.UTF8Encoding($false)))
    $arguments = '--models-preset "{0}" --models-max 1 --host 127.0.0.1 --port 8080' -f $runtime
    $server = Start-Process -FilePath $exe -ArgumentList $arguments -WorkingDirectory $base -WindowStyle Hidden -PassThru -RedirectStandardOutput (Join-Path $PSScriptRoot 'servidor.log') -RedirectStandardError (Join-Path $PSScriptRoot 'servidor-error.log')
    $ready = $false
    $deadline = (Get-Date).AddSeconds(90)
    while ((Get-Date) -lt $deadline) {
        if ($server.HasExited) { throw 'El servidor se ha detenido. Consulta configuraciones\servidor-error.log.' }
        try {
            $models = Invoke-RestMethod "$url/v1/models" -TimeoutSec 2
            if (@($models.data.id) -contains 'Qwen3.5-9B-Q4_K_M' -and @($models.data.id) -contains 'MiMo-V2.6-9B-Q4_K_M') { $ready = $true; break }
        } catch { Start-Sleep -Milliseconds 400 }
    }
    if (!$ready) { throw 'La interfaz no ha respondido en 90 segundos. Consulta servidor-error.log.' }
    Start-Process $url
    Write-Host 'Elige Qwen o MiMo en el desplegable. Se carga un modelo a la vez.'
    Read-Host 'Pulsa INTRO aqui para detener el servidor antes de abrir ComfyUI'
} catch {
    Write-Host $_.Exception.Message -ForegroundColor Red
    Read-Host 'Pulsa INTRO para cerrar'
} finally {
    if ($server -and !$server.HasExited) { & taskkill.exe /PID $server.Id /T /F | Out-Null }
    Remove-Item -LiteralPath $runtime -ErrorAction SilentlyContinue
}
