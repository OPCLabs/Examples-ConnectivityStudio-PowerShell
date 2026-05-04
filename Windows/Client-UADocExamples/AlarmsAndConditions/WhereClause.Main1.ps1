# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to specify criteria for event notifications.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAPrimitives.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUACore.dll"
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
[IEasyUAClientExtension]::SubscribeEvent($client, 
    $endpointDescriptor, 
    [UAObjectIds]::Server, 
    1000,
    [UAEventFilter](New-Object UAEventFilterBuilder(
        [UAFilterElements]::Equals(
            [UABaseEventObject+Operands]::SourceNode, 
            (New-Object UANodeId("nsu=http://opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Metals/SouthMotor"))),
        [UABaseEventObject]::AllFields))
    )

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


# Example output:
#
#Subscribing...
#13000008
#Processing event notifications for 30 seconds...
#[] Success
#[] Success; Refresh; RefreshInitiated
#[] Success; Refresh; [SouthMotor] 100! {DialogConditionType} "The dialog was activated" @9/9/2021 2:22:18 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 700! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/22/2021 7:17:59 AM (10 fields)
#[] Success; Refresh; [SouthMotor] 900! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/22/2021 7:17:57 AM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {TripAlarmType} "The alarm is active." @9/22/2021 7:17:59 AM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:39:51 PM (10 fields)
#[] Success; Refresh; [SouthMotor] 100! {TripAlarmType} "The alarm severity has increased." @9/9/2021 3:38:57 PM (10 fields)
#[] Success; Refresh; RefreshComplete
#[] Success; [SouthMotor] 100! {NonExclusiveLevelAlarmType} "The alarm was deactivated by the system." @9/22/2021 7:18:05 AM (10 fields)
#[] Success; [SouthMotor] 300! {TripAlarmType} "The alarm severity has increased." @9/22/2021 7:18:08 AM (10 fields)
#[] Success; [SouthMotor] 900! {ExclusiveDeviationAlarmType} "The alarm severity has increased." @9/22/2021 7:18:10 AM (10 fields)
#[] Success; [SouthMotor] 100! {NonExclusiveLevelAlarmType} "The alarm is active." @9/22/2021 7:18:13 AM (10 fields)
#[] Success; [SouthMotor] 500! {TripAlarmType} "The alarm severity has increased." @9/22/2021 7:18:17 AM (10 fields)
#[] Success; [SouthMotor] 100! {ExclusiveDeviationAlarmType} "The alarm was deactivated by the system." @9/22/2021 7:18:21 AM (10 fields)
#[] Success; [SouthMotor] 300! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/22/2021 7:18:21 AM (10 fields)
#[] Success; [SouthMotor] 700! {TripAlarmType} "The alarm severity has increased." @9/22/2021 7:18:26 AM (10 fields)
#[] Success; [SouthMotor] 500! {NonExclusiveLevelAlarmType} "The alarm severity has increased." @9/22/2021 7:18:29 AM (10 fields)
#[] Success; [SouthMotor] 100! {ExclusiveDeviationAlarmType} "The alarm is active." @9/22/2021 7:18:32 AM (10 fields)
#Unsubscribing...
#Waiting for 5 seconds...
#Finished.

#endregion Example
