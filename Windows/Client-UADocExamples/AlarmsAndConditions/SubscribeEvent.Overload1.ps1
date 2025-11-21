# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to event notifications and display each incoming event.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

# Define which server we will work with.
[UAEndpointDescriptor]$endpointDescriptor = "opc.tcp://opcua.demo-this.com:62544/Quickstarts/AlarmConditionServer"

# Instantiate the client object.
$client = New-Object EasyUAClient

# Event notification handler
Register-ObjectEvent -InputObject $client -EventName EventNotification -Action { 
    # Display the event.
    Write-Host $EventArgs
}

Write-Host "Subscribing..."
[IEasyUAClientExtension]::SubscribeEvent($client, $endpointDescriptor, [UAObjectIds]::Server, 1000)

Write-Host "Processing event notifications for 30 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 30) {    
    Start-Sleep -Seconds 1
}

Write-Host "Unsubscribing..."
$client.UnsubscribeAllMonitoredItems()

Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

Write-Host "Finished."


# Example output (truncated):
#Subscribing...
#Processing event notifications for 30 seconds...
#[] Success
#[] Success; Refresh; RefreshInitiated
#[] Success; Refresh; [EastTank] 100! {DialogConditionType} "The dialog was activated" @9/9/2021 2:22:18 PM (10 fields)
#[] Success; Refresh; [EastTank] 100! {ExclusiveDeviationAlarmType} "The alarm is active." @9/9/2021 4:19:37 PM (10 fields)
#[] Success; Refresh; [EastTank] 500! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/9/2021 4:19:35 PM (10 fields)
#[] Success; Refresh; [EastTank] 900! {TripAlarmType} "The alarm severity has increased." @9/9/2021 4:19:29 PM (10 fields)
#[] Success; Refresh; [EastTank] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:39:03 PM (10 fields)
#[] Success; Refresh; [EastTank] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:40:03 PM (10 fields)
#[] Success; Refresh; [NorthMotor] 100! {DialogConditionType} "The dialog was activated" @9/9/2021 2:22:18 PM (10 fields)
#[] Success; Refresh; [NorthMotor] 500! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/9/2021 4:19:35 PM (10 fields)
#[] Success; Refresh; [NorthMotor] 900! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/9/2021 4:19:29 PM (10 fields)
#[] Success; Refresh; [NorthMotor] 100! {TripAlarmType} "The alarm is active." @9/9/2021 4:19:32 PM (10 fields)
#[] Success; Refresh; [NorthMotor] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:39:08 PM (10 fields)
#[] Success; Refresh; [NorthMotor] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:40:14 PM (10 fields)
#[] Success; Refresh; [WestTank] 100! {DialogConditionType} "The dialog was activated" @9/9/2021 2:22:18 PM (10 fields)
#[] Success; Refresh; [WestTank] 900! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/9/2021 4:19:29 PM (10 fields)
#[] Success; Refresh; [WestTank] 100! {NonExclusiveLevelAlarmType} "The alarm is active." @9/9/2021 4:19:32 PM (10 fields)
#[] Success; Refresh; [WestTank] 100! {TripAlarmType} "The alarm is active." @9/9/2021 4:19:37 PM (10 fields)
#[] Success; Refresh; [WestTank] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:38:55 PM (10 fields)
#[] Success; Refresh; [WestTank] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:39:43 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {DialogConditionType} "The dialog was activated" @9/9/2021 2:22:18 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {ExclusiveDeviationAlarmType} "The alarm is active." @9/9/2021 4:19:32 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {NonExclusiveLevelAlarmType} "The alarm is active." @9/9/2021 4:19:37 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 500! {TripAlarmType} "The alarm severity has increased." @9/9/2021 4:19:35 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:39:51 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:38:57 PM (10 fields)
#[] Success; Refresh; RefreshComplete
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:39 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:39 PM (10 fields)
#[] Success; [EastTank] 100! {TripAlarmType} "The alarm was deactivated by the system." @9/9/2021 4:19:39 PM (10 fields)
#[] Success; [NorthMotor] 100! {NonExclusiveLevelAlarmType} "The alarm was deactivated by the system." @9/9/2021 4:19:39 PM (10 fields)
#[] Success; [WestTank] 100! {ExclusiveDeviationAlarmType} "The alarm was deactivated by the system." @9/9/2021 4:19:39 PM (10 fields)
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:40 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:40 PM (10 fields)
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:41 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:41 PM (10 fields)
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:42 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:42 PM (10 fields)
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:43 PM (10 fields)
#[] Success; [NorthMotor] 300! {TripAlarmType} "The alarm severity has increased." @9/9/2021 4:19:43 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:43 PM (10 fields)
#[] Success; [WestTank] 300! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/9/2021 4:19:43 PM (10 fields)
#[] Success; [SouthMotor] 300! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/9/2021 4:19:43 PM (10 fields)
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:44 PM (10 fields)
#[] Success; [EastTank] 700! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/9/2021 4:19:44 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:44 PM (10 fields)
#[] Success; [NorthMotor] 700! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/9/2021 4:19:44 PM (10 fields)
#[] Success; [SouthMotor] 700! {TripAlarmType} "The alarm severity has increased." @9/9/2021 4:19:44 PM (10 fields)
#[] Success; [Internal] 500! {SystemEventType} "Raising Events" @9/9/2021 4:19:45 PM (10 fields)
#[] Success; [EastTank] 300! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/9/2021 4:19:45 PM (10 fields)
#[] Success; [Internal] 500! {AuditEventType} "Events Raised" @9/9/2021 4:19:45 PM (10 fields)
#...

#endregion Example
