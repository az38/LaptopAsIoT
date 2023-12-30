<#

Helper to create scheduled tasks
Run as admin

https://learn.microsoft.com/en-us/powershell/module/scheduledtasks/new-scheduledtask
https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc748841(v=ws.11)

#>

## directory with PS scripts
$dirPS = $PSScriptRoot

$principal = New-ScheduledTaskPrincipal -UserId ($(whoami)).ToUpper() -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
$triggerLogOn = New-ScheduledTaskTrigger -AtLogon
$triggerStartup = New-ScheduledTaskTrigger -AtStartup
$triggerTimeSchedule = New-ScheduledTaskTrigger -Once -At 00:00 -RepetitionInterval (New-TimeSpan -Minutes 30) 


function _GetTask_{

    param (
        $sendEvent, 
        $sendMessage, 
        $triggerExecute, 
        $eventtype
    )

    $actionArgumentEvent = " -File ""$($dirPS)\sendEvent.ps1"" -WindowStyle Hidden -noninteractive -eventtype ""{0}"""
    $actionArgumentMessage = " -File ""$($dirPS)\sendMessage.ps1"" -WindowStyle Hidden -noninteractive"

    $actionEvent = (New-ScheduledTaskAction -Execute "powershell" -Argument ($actionArgumentEvent -f $eventtype))
    $actionMessage = (New-ScheduledTaskAction -Execute "powershell" -Argument $actionArgumentMessage)

    [CimInstance[]]$actions = @()

    if($sendMessage) { 
        $actions += $actionMessage
    }

    if($sendEvent) { 
        $actions += $actionEvent
    }

    $task = New-ScheduledTask -Action $actions -Principal $principal -Trigger $triggerExecute -Settings $settings

    return $task
}

$taskLogon =  _GetTask_ -sendEvent $true -sendMessage $true -triggerExecute $triggerLogOn -eventtype "LogOn"
    Register-ScheduledTask 'SendEvent_LogOn' -InputObject $taskLogon
$taskStartUp =  _GetTask_ -sendEvent $true -sendMessage $true -triggerExecute $triggerStartup -eventtype "StartUp"
    Register-ScheduledTask 'SendEvent_StartUp' -InputObject $taskStartUp
$taskTimeScheduled =  _GetTask_ -sendEvent $false -sendMessage $true -triggerExecute $triggerTimeSchedule -eventtype "TimeScheduled"
    Register-ScheduledTask 'SendEvent_TimeScheduled' -InputObject $taskTimeScheduled
