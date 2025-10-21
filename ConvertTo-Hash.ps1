# HashMyString.ps1
# Simple interactive script: enter a string, choose algorithm, get hash.

$algorithms = 'MD5','SHA1','SHA256','SHA384','SHA512'

# Ask for the input string
$string = Read-Host "Enter the string to hash"

# Ask for algorithm until valid
do {
    $algPrompt = "Choose algorithm ($($algorithms -join ', ')) [default SHA256]"
    $algInput = Read-Host $algPrompt
    if ([string]::IsNullOrWhiteSpace($algInput)) { $alg = 'SHA256'; break }
    $alg = $algInput.ToUpper().Trim()
} until ($algorithms -contains $alg)

# Compute hash (UTF-8)
try {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($string)
    $hashAlg = [System.Security.Cryptography.HashAlgorithm]::Create($alg)
    if (-not $hashAlg) { throw "Unsupported algorithm: $alg" }
    $hashBytes = $hashAlg.ComputeHash($bytes)
    $hex = ([BitConverter]::ToString($hashBytes) -replace '-','').ToLower()
    Write-Host "`nAlgorithm: $alg"
    Write-Host "Input: $string"
    Write-Host "Hash: $hex"
}
catch {
    Write-Error $_.Exception.Message
}
