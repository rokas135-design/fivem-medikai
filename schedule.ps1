param(
    [string]$Python = '.venv\Scripts\python.exe',
    [string]$Config = 'settings.json',
    [string]$Data = 'data',
    [string]$TaskName = 'FireM-Medikai-Lokaliai',
    [switch]$Register,
    [switch]$EnableDiscordRead
)
$ErrorActionPreference = 'Stop'
if (-not $Register) {
    Write-Output "Paleisk su -Register, jei nori įjungti vietinį grafiką."
    return
}
function In-Project($Path) {
    if ([IO.Path]::IsPathRooted($Path)) { return $Path }
    Join-Path $PSScriptRoot $Path
}
$pythonPath = (Resolve-Path -LiteralPath (In-Project $Python)).Path
$configPath = (Resolve-Path -LiteralPath (In-Project $Config)).Path
$dataPath = In-Project $Data
if ($configPath.Contains('"') -or $dataPath.Contains('"') -or $dataPath.EndsWith('\')) {
    throw "Netinkamas konfigūracijos arba duomenų kelias."
}
if (Get-ScheduledTask -TaskName $TaskName -ErrorAction SilentlyContinue) {
    throw "Tokia užduotis jau yra. Pasirink kitą pavadinimą arba pakeisk esamą per Task Scheduler."
}
$arguments = '-m firem --config "' + $configPath + '" --data "' + $dataPath + '" bot --scheduled'
if ($EnableDiscordRead) { $arguments += ' --enable-discord-read' }
$action = New-ScheduledTaskAction -Execute $pythonPath -WorkingDirectory $PSScriptRoot -Argument $arguments
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 15)
$settings = New-ScheduledTaskSettingsSet -StartWhenAvailable -MultipleInstances IgnoreNew -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Settings $settings -Description 'FireM nuotraukų importas ir vietiniai ataskaitų juodraščiai.'

