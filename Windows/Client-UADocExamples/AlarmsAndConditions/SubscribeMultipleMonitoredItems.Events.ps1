# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to multiple events.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard
using namespace OpcLabs.EasyOpc.UA.AlarmsAndConditions
using namespace OpcLabs.EasyOpc.UA.Filtering
using namespace OpcLabs.EasyOpc.UA.OperationModel

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
$client.SubscribeMultipleMonitoredItems(@(
        (New-Object EasyUAMonitoredItemArguments("firstState",
            $endpointDescriptor, 
            [UAObjectIds]::Server,
            (New-Object UAMonitoringParameters(1000, [UAEventFilter](New-Object UAEventFilterBuilder(
                [UAFilterElements]::GreaterThanOrEqual([UABaseEventObject+Operands]::Severity, 500),
                [UABaseEventObject]::AllFields))))) `
            -Property @{ AttributeId = [UAAttributeId]::EventNotifier }),
        (New-Object EasyUAMonitoredItemArguments("secondState",
            $endpointDescriptor, 
            [UAObjectIds]::Server,
            (New-Object UAMonitoringParameters(2000, [UAEventFilter](New-Object UAEventFilterBuilder(
                [UAFilterElements]::Equals(
                    [UABaseEventObject+Operands]::SourceNode, 
                    (New-Object UANodeId("nsu=http://opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Metals/SouthMotor"))),
                [UABaseEventObject]::AllFields))))) `
            -Property @{ AttributeId = [UAAttributeId]::EventNotifier })
    ))

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
#Processing monitored item changed events for 30 seconds...
#[firstState] Success
#[secondState] Success
#[firstState] Success; Refresh; RefreshInitiated
#[firstState] Success; Refresh; (10 field results) [EastTank] 500! "The alarm was acknoweledged." @10/14/2019 4:00:13 PM
#[firstState] Success; Refresh; (10 field results) [EastTank] 500! "The alarm was acknoweledged." @10/14/2019 4:00:17 PM
#[firstState] Success; Refresh; (10 field results) [NorthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:02 PM
#[firstState] Success; Refresh; (10 field results) [NorthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:16 PM
#[firstState] Success; Refresh; (10 field results) [SouthMotor] 700! "The alarm was acknoweledged." @10/14/2019 4:00:21 PM
#[firstState] Success; Refresh; (10 field results) [SouthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:03 PM
#[firstState] Success; Refresh; RefreshComplete
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:08 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:08 PM
#[secondState] Success; Refresh; RefreshInitiated
#[secondState] Success; Refresh; (10 field results) [SouthMotor] 100! "The dialog was activated" @9/10/2019 8:08:25 PM
#[secondState] Success; Refresh; (10 field results) [SouthMotor] 100! "The alarm is active." @11/8/2019 7:48:07 PM
#[secondState] Success; Refresh; (10 field results) [SouthMotor] 700! "The alarm was acknoweledged." @10/14/2019 4:00:21 PM
#[secondState] Success; Refresh; (10 field results) [SouthMotor] 500! "The alarm was acknoweledged." @10/14/2019 4:00:03 PM
#[secondState] Success; Refresh; (10 field results) [SouthMotor] 100! "The alarm severity has increased." @9/10/2019 8:09:02 PM
#[secondState] Success; Refresh; (10 field results) [SouthMotor] 100! "The alarm severity has increased." @9/10/2019 8:09:59 PM
#[secondState] Success; Refresh; RefreshComplete
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:09 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:09 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:10 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:10 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:11 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:11 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:12 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:12 PM
#[firstState] Success; (10 field results) [EastTank] 500! "The alarm severity has increased." @11/8/2019 7:48:13 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:13 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:13 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:14 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:14 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:15 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:15 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:16 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:16 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:17 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:17 PM
#[firstState] Success; (10 field results) [Internal] 500! "Raising Events" @11/8/2019 7:48:18 PM
#[firstState] Success; (10 field results) [Internal] 500! "Events Raised" @11/8/2019 7:48:18 PM
#[secondState] Success; (10 field results) [SouthMotor] 300! "The alarm severity has increased." @11/8/2019 7:48:18 PM
#...

#endregion Example
