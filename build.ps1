param(
    [ValidateSet("Debug", "Release")]
    [string]$Config = "Debug"
)

$vcvars = "C:\Program Files\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvarsall.bat"
if (!(Test-Path $vcvars)) {
    Write-Error "vcvarsall.bat not found at $vcvars"
    exit 1
}

$env:VSCMD_ARG_TGT_ARCH = "x86"
& cmd /c "`"$vcvars`" x86 && set" | ForEach-Object {
    if ($_ -match "^(.*?)=(.*)$") {
        Set-Item -Path "env:$($matches[1])" -Value $matches[2]
    }
}

$buildDir = "$PSScriptRoot\build\$Config"

Write-Output "=== Configuring CMake ($Config) ==="
cmake -B $buildDir -S $PSScriptRoot -G "Visual Studio 17 2022" -A Win32
if ($LASTEXITCODE -ne 0) { Write-Error "CMake configure failed"; exit 1 }

Write-Output "=== Building ($Config) ==="
cmake --build $buildDir --config $Config
if ($LASTEXITCODE -ne 0) { Write-Error "CMake build failed"; exit 1 }

Write-Output "=== Build successful ==="
$output = "$buildDir\bin\AnimFix.dll"
if (Test-Path $output) {
    Write-Output "Output: $output"
    Write-Output "Size: $((Get-Item $output).Length) bytes"
}
