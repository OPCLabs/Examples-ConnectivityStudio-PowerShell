# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to select fields for event notifications.
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

$attributeFieldCollection = New-Object UAAttributeFieldCollection

# Select specific fields using standard operand symbols.
$attributeFieldCollection.Add([UABaseEventObject+Operands]::NodeId)
$attributeFieldCollection.Add([UABaseEventObject+Operands]::SourceNode)
$attributeFieldCollection.Add([UABaseEventObject+Operands]::SourceName) 
$attributeFieldCollection.Add([UABaseEventObject+Operands]::Time)

# Select specific fields using an event type ID and a simple relative path.
$attributeFieldCollection.Add([UAFilterElements]::SimpleAttribute([UAObjectTypeIds]::BaseEventType, "/Message"))
$attributeFieldCollection.Add([UAFilterElements]::SimpleAttribute([UAObjectTypeIds]::BaseEventType, "/Severity"))

[IEasyUAClientExtension]::SubscribeEvent($client, 
    $endpointDescriptor, [UAObjectIds]::Server, 1000, [UAEventFilter]$attributeFieldCollection)

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

#endregion Example
