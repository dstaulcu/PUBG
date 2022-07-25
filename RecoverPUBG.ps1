# Self-elevate the script if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
 if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
  $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
  Start-Process -FilePath PowerShell.exe -Verb Runas -ArgumentList $CommandLine
  Exit
 }
}

# variables
$gameid = 578080  
$LoadingScreenPath = "C:\Program Files (x86)\Steam\steamapps\common\PUBG\TslGame\Content\Movies"
$SavedLogs = "$($env:LOCALAPPDATA)\TslGame\Saved\Logs"
$StartStateExpectedPortCount = 2   # number of ports expected by lobby load
$StartStateExpected443ConnectionCount = 8 # number of port 443 connections expected by lobby load
$StartTime = Get-Date

# main
write-host "$(get-date) - Killing any existing Steam and PUBG related processes."
get-process ("steam*","gldriverquery*","vulkandriverquery*","execpubg*","tslgame*","ucsvc*","x64launcher*","x86launcher*","zksvc*","ucldr_battlegrounds*","beservice*","easyanticheat*") | stop-process -force -ErrorAction SilentlyContinue
& fltmc unload BEDaisy | Out-Null

write-host "$(get-date) - Removing logs which may require upload at startup."
Get-ChildItem -Path $SavedLogs | Remove-Item -Force -ErrorAction SilentlyContinue

write-host "$(get-date) - Removing movies which could delay startup time."
$movies = get-childitem -path $LoadingScreenPath -Filter "*.MP4" -Recurse
foreach ($movie in $movies) {
    if ($movie.name -match '^(LoadingScreen|PlatformScreen|season_autoplay_film)') {
        remove-Item -Path $movie.FullName -Force -ErrorAction SilentlyContinue
    }
}

write-host "$(get-date) - Starting steam game with gameid $($gameid)."
Start-Process -FilePath "steam://rungameid/$($gameid)"

<#
write-host "$(get-date) - Waiting for previous tcp connections to clear."
Start-Sleep -Seconds 5
#>

write-host "$(get-date) - Waiting for lobby to load."
$GameConnectedStatus = $false
do
{
    # get list of TSLGame process instances
    [array]$Process = Get-Process -Name TslGame -ErrorAction SilentlyContinue
    if ($Process) {
        # get list of established tcp connections for instances of TSLGame
        $NetTCPConnections = Get-NetTCPConnection -OwningProcess $Process.id -ErrorAction SilentlyContinue | ?{$_.state -eq "Established"}
        if ($NetTCPConnections) {
            # when connections exist group them by remoteport number
            $Group = $NetTCPConnections | Group-Object -Property RemotePort
            write-progress -Activity "Waiting for lobby to load..." -Status "There are connections to $(($Group.name).Count) distinct ports with $(($Group | ?{$_.name -eq 443}).count) connections over port 443."
            if ((($Group | ?{$_.name -eq 443}).count -ge $StartStateExpected443ConnectionCount) -and ($Group.name).Count -gt $StartStateExpectedPortCount) { 
                $GameConnectedStatus = $true 
            }
        }
    }
    Start-Sleep -Seconds 1
}
until ($GameConnectedStatus -eq $true)

# write summary of restart duration to screen
$TimeSpan = New-TimeSpan -Start $StartTime
write-host "$(get-date) - Game startup operation completed after $($TimeSpan)."
Read-Host -Prompt "Press Enter to continue..." | Out-Null
