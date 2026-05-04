# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to display all fields of incoming events, or extract specific fields.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.BaseLib.OperationModel
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard
using namespace OpcLabs.EasyOpc.UA.AlarmsAndConditions
using namespace OpcLabs.EasyOpc.UA.Filtering

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
    Write-Host 

    # Display the event.
    if ($EventArgs.EventData -eq $null) {
        Write-Host $EventArgs
        return
    }
    Write-Host "All fields:"
    foreach ($pair in $EventArgs.EventData.FieldResults.GetEnumerator()) {
        [UAAttributeField]$attributeField = $pair.Key
        [ValueResult]$valueResult = $pair.Value
        Write-Host "  $($attributeField) -> $($valueResult)"
    }

    # Extracting a specific field using a standard operand symbol.
    Write-Host "Source name: $($EventArgs.EventData.FieldResults[[UABaseEventObject+Operands]::SourceName])"

    # Extracting a specific field using an event type ID and a simple relative path.
    Write-Host `
        "Message: $($EventArgs.EventData.FieldResults[[UAFilterElements]::SimpleAttribute([UAObjectTypeIds]::BaseEventType, "/Message")])"
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
#
#[] Success
#
#[] Success; Refresh; RefreshInitiated
#
#All fields:
#  NodeId="BaseEventType", NodeId -> Success; nsu=http:#opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Colours/EastTank?OnlineState {OpcLabs.EasyOpc.UA.AddressSpace.UANodeId}
#  NodeId="BaseEventType"/EventId -> Success; [16] {95, 68, 22, 205, 114, ...} {System.Byte[]}
#  NodeId="BaseEventType"/EventType -> Success; DialogConditionType {OpcLabs.EasyOpc.UA.AddressSpace.UANodeId}
#  NodeId="BaseEventType"/SourceNode -> Success; nsu=http:#opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Colours/EastTank {OpcLabs.EasyOpc.UA.AddressSpace.UANodeId}
#  NodeId="BaseEventType"/SourceName -> Success; EastTank {System.String}
#  NodeId="BaseEventType"/Time -> Success; 9/10/2019 8:08:23 PM {System.DateTime}
#  NodeId="BaseEventType"/ReceiveTime -> Success; 9/10/2019 8:08:23 PM {System.DateTime}
#  NodeId="BaseEventType"/LocalTime -> Success; 00:00, DST {OpcLabs.EasyOpc.UA.UATimeZoneData}
#  NodeId="BaseEventType"/Message -> Success; The dialog was activated {System.String}
#  NodeId="BaseEventType"/Severity -> Success; 100 {System.Int32}
#Source name: Success; EastTank {System.String}
#Message: Success; The dialog was activated {System.String}
#
#All fields:
#  NodeId="BaseEventType", NodeId -> Success; nsu=http:#opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Colours/EastTank?Red {OpcLabs.EasyOpc.UA.AddressSpace.UANodeId}
#  NodeId="BaseEventType"/EventId -> Success; [16] {124, 156, 219, 54, 120, ...} {System.Byte[]}
#  NodeId="BaseEventType"/EventType -> Success; ExclusiveDeviationAlarmType {OpcLabs.EasyOpc.UA.AddressSpace.UANodeId}
#  NodeId="BaseEventType"/SourceNode -> Success; nsu=http:#opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=1:Colours/EastTank {OpcLabs.EasyOpc.UA.AddressSpace.UANodeId}
#  NodeId="BaseEventType"/SourceName -> Success; EastTank {System.String}
#  NodeId="BaseEventType"/Time -> Success; 10/14/2019 4:00:13 PM {System.DateTime}
#  NodeId="BaseEventType"/ReceiveTime -> Success; 10/14/2019 4:00:13 PM {System.DateTime}
#  NodeId="BaseEventType"/LocalTime -> Success; 00:00, DST {OpcLabs.EasyOpc.UA.UATimeZoneData}
#  NodeId="BaseEventType"/Message -> Success; The alarm was acknoweledged. {System.String}
#  NodeId="BaseEventType"/Severity -> Success; 500 {System.Int32}
#Source name: Success; EastTank {System.String}
#Message: Success; The alarm was acknoweledged. {System.String}
#
#...

#endregion Example
