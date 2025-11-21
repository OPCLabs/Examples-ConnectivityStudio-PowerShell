# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to event notifications, pull events, and display each incoming event.
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
# In order to use event pull, you must set a non-zero queue capacity upfront.
$client.PullEventNotificationQueueCapacity = 1000

Write-Host "Subscribing..."
[IEasyUAClientExtension]::SubscribeEvent($client, $endpointDescriptor, [UAObjectIds]::Server, 1000)

Write-Host "Processing event notifications for 30 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 60) {    
    $eventArgs = $client.PullEventNotification(2*1000)
    if ($eventArgs -ne $null) {
        # Handle the notification event.
        Write-Host $eventArgs
    }
}

Write-Host "Unsubscribing..."
$client.UnsubscribeAllMonitoredItems()

Write-Host "Finished."


# Example output (truncated):
#Subscribing...
#Processing event notifications for 30 seconds...
#[] Success
#[] Success; Refresh; RefreshInitiated
#[] Success; Refresh; (10 field results) [EastTank] 100! "The dialog was activated" @9/10/2019 8:08:23 PM
#[] Success; Refresh; (10 field results) [EastTank] 500! "The alarm was acknoweledged." @10/14/2019 4:00:13 PM
#[] Success; Refresh; (10 field results) [EastTank] 100! "The alarm was acknoweledged." @11/9/2019 9:56:23 AM
#[] Success; Refresh; (10 field results) [EastTank] 500! "The alarm was acknoweledged." @10/14/2019 4:00:17 PM
#[] Success; Refresh; (10 field results) [EastTank] 100! "The alarm severity has increased." @9/10/2019 8:09:07 PM
#[] Success; Refresh; (10 field results) [EastTank] 100! "The alarm severity has increased." @9/10/2019 8:10:09 PM
#[] Success; Refresh; (10 field results) [NorthMotor] 100! "The dialog was activated" @9/10/2019 8:08:25 PM
#[] Success; Refresh; (10 field results) [NorthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:02 PM
#[] Success; Refresh; (10 field results) [NorthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:16 PM
#[] Success; Refresh; (10 field results) [NorthMotor] 300! "The alarm severity has increased." @11/9/2019 10:29:42 AM
#[] Success; Refresh; (10 field results) [NorthMotor] 100! "The alarm severity has increased." @9/10/2019 8:09:11 PM
#[] Success; Refresh; (10 field results) [NorthMotor] 100! "The alarm severity has increased." @9/10/2019 8:10:19 PM
#[] Success; Refresh; (10 field results) [WestTank] 100! "The dialog was activated" @9/10/2019 8:08:25 PM
#[] Success; Refresh; (10 field results) [WestTank] 300! "The alarm was acknoweledged." @10/14/2019 4:00:12 PM
#[] Success; Refresh; (10 field results) [WestTank] 300! "The alarm severity has increased." @11/9/2019 10:29:42 AM
#[] Success; Refresh; (10 field results) [WestTank] 300! "The alarm was acknoweledged." @10/14/2019 4:00:04 PM
#[] Success; Refresh; (10 field results) [WestTank] 100! "The alarm severity has increased." @9/10/2019 8:08:58 PM
#[] Success; Refresh; (10 field results) [WestTank] 100! "The alarm severity has increased." @9/10/2019 8:09:48 PM
#[] Success; Refresh; (10 field results) [SouthMotor] 100! "The dialog was activated" @9/10/2019 8:08:25 PM
#[] Success; Refresh; (10 field results) [SouthMotor] 300! "The alarm severity has increased." @11/9/2019 10:29:42 AM
#[] Success; Refresh; (10 field results) [SouthMotor] 700! "The alarm was acknoweledged." @10/14/2019 4:00:21 PM
#[] Success; Refresh; (10 field results) [SouthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:03 PM
#[] Success; Refresh; (10 field results) [SouthMotor] 100! "The alarm severity has increased." @9/10/2019 8:09:02 PM
#[] Success; Refresh; (10 field results) [SouthMotor] 100! "The alarm severity has increased." @9/10/2019 8:09:59 PM
#[] Success; Refresh; RefreshComplete
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:43 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:43 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:44 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:44 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:45 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:45 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:46 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:46 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:47 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:47 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:48 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:48 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:49 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:49 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:50 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:50 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:51 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:51 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:52 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:52 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:53 AM
#[] Success; (10 field results) [NorthMotor] 500! "The alarm severity has increased." @11/9/2019 10:29:53 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:53 AM
#[] Success; (10 field results) [WestTank] 500! "The alarm severity has increased." @11/9/2019 10:29:53 AM
#[] Success; (10 field results) [SouthMotor] 500! "The alarm severity has increased." @11/9/2019 10:29:53 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:54 AM
#[] Success; (10 field results) [Internal] 500! "Events Raised" @11/9/2019 10:29:54 AM
#[] Success; (10 field results) [Internal] 500! "Raising Events" @11/9/2019 10:29:55 AM
#...

#endregion Example
