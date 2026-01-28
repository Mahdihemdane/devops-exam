# load-env.ps1
# Usage: ./load-env.ps1
Get-Content .env | ForEach-Object {
    if ($_ -match "^(?<name>[^=]+)=(?<value>.*)$") {
        $name = $Matches['name'].Trim()
        $value = $Matches['value'].Trim()
        [System.Environment]::SetEnvironmentVariable($name, $value, [System.EnvironmentVariableTarget]::Process)
        Write-Host "Set $name"
    }
}
Write-Host "Environment variables loaded for this session."
