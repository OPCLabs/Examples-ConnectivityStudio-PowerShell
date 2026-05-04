# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to acknowledge an OPC UA event.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace System.Threading
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard
using namespace OpcLabs.EasyOpc.UA.AlarmsAndConditions
using namespace OpcLabs.EasyOpc.UA.Filtering
using namespace OpcLabs.EasyOpc.UA.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAPrimitives.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUACore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

# Define which server we will work with.
[UAEndpointDescriptor]$endpointDescriptor = "opc.tcp://opcua.demo-this.com:62544/Quickstarts/AlarmConditionServer"

# Instantiate the client objects.
$client = New-Object EasyUAClient
$alarmsAndConditionsClient = $client.AsAlarmsAndConditionsClient()

# Event notification handler
Register-ObjectEvent -InputObject $client -EventName EventNotification -Action { 
    if (-not $EventArgs.Succeeded) {
        Write-Host "*** Failure: $($EventArgs.ErrorMessageBrief)"
        return
    }
    if ($EventArgs.EventData -ne $null) {
        $baseEventObject = $EventArgs.EventData.BaseEvent
        Write-Host $baseEventObject

        # Make sure we do not catch the event more than once.
        if ($acknowledged) {
            return
        }

        $global:nodeId = $baseEventObject.NodeId
        $global:eventId = $baseEventObject.EventId

        $global:acknowledged = $true
    }
}

Write-Host "Subscribing..."
$global:acknowledged = $false
[IEasyUAClientExtension]::SubscribeEvent($client, 
    $endpointDescriptor, 
    [UAObjectIds]::Server, 
    1000,
    [UAEventFilter](New-Object UAEventFilterBuilder(
        [UAFilterElements]::Equals(
            [UABaseEventObject+Operands]::NodeId, 
            (New-Object UANodeId("nsu=http://opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Colours/EastTank?Yellow"))),
        [UABaseEventObject]::AllFields))
    )

Write-Host "Waiting for an event for 30 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 30) {    
    if ($global:acknowledged) {
        break
    }
    Start-Sleep -Seconds 1
}
if (-not $global:acknowledged) {
    Write-Host "Event not received."
    return
}

Write-Host "Acknowledging an event..."
try {
    $alarmsAndConditionsClient.Acknowledge(
        $endpointDescriptor,
        $global:nodeId,
        $global:eventId,
        "Acknowledged by an automated example code.")
}
catch [UAException] {
    Write-Host "*** Failure: $($PSItem.Exception.GetBaseException().Message)"
    return
}

Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

Write-Host "Unsubscribing..."
$client.UnsubscribeAllMonitoredItems()

Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

Write-Host "Finished."


# Example output:
#Subscribing...
#Waiting for an event for 30 seconds...
#[EastTank] 100! "The alarm was acknoweledged." @11/9/2019 9:56:23 AM
#Acknowledging an event...
#Waiting for 5 seconds...
#[EastTank] 100! "The alarm was acknoweledged." @11/9/2019 9:56:23 AM
#Unsubscribing...
#Waiting for 5 seconds...
#Finished.

#endregion Example
