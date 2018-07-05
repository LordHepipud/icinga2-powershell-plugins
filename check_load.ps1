<#
.Synopsis
    PowerShell adoption of check_load from Icinga
.DESCRIPTION
    More Information on https://github.com/LordHepipud/icinga2-powershell-plugins
.EXAMPLE
    check_load.ps1 -w 20 -c 40
.NOTES
    This plugin requires the Icinga 2 PerfCounter Lib from
    https://github.com/LordHepipud/icinga2-perfcounter-lib
#>
param(
    # The warning threshold in percent for the current load
    [Alias('w')]
    [float]$Warning  = 0,
    # The critical threshold in percent for the current load
    [Alias('c')]
    [float]$Critical = 0,
    # Print detailed debug informations of the script
    [Alias('d')]
    [Switch]$Debug   = $FALSE
)

if ($Debug) {
    Set-PSDebug -Trace 2
}

function Icinga2CheckLoad
{
    param(
        [float]$Warning  = 0,
        [float]$Critical = 0
    )

    $CPUCounter = Get-Icinga2Counter -CounterArray @(
        '\Processor(_Total)\% Processor Time'
    )

    [float]$CPULoad   = $CPUCounter['\Processor(_Total)\% Processor Time'].value;
    [string]$Severity = 'OK';
    [int]$ExitCode    = 0;

    if ($Critical -ne 0 -And $CPULoad -ge $Critical) {
        $Severity = 'CRITICAL';
        $ExitCode = 2;
    } elseif ($Warning -ne 0 -And $CPULoad -ge $Warning) {
        $Severity = 'WARNING';
        $ExitCode = 1;
    }

    Write-Host ([string]::Format('LOAD {0} {1}% | load={1}%;{2};{3};0;100',
        $Severity,
        $CPULoad,
        $Warning,
        $Critical
    ));
}

exit Icinga2CheckLoad -Warning $Warning -Critical $Critical;