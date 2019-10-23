$ErrorActionPreference = "Stop"
Set-StrictMode -Version 3

. (Join-Path $PSScriptRoot ".\private\New-Keyspace.ps1")
. (Join-Path $PSScriptRoot ".\private\Test-PasswordValidation.ps1")
. (Join-Path $PSScriptRoot ".\public\New-Password.ps1")