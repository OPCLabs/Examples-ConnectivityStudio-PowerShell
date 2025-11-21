# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to range of values from an array.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-QuickOPC-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.OperationModel
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

[UAEndpointDescriptor]$endpointDescriptor =
    "opc.tcp://opcua.demo-this.com:51210/UA/SampleServer"
# or "http://opcua.demo-this.com:51211/UA/SampleServer" (currently not supported)
# or "https://opcua.demo-this.com:51212/UA/SampleServer/"

# Instantiate the client object.
$client = New-Object EasyUAClient

Write-Host "Subscribing to range..."
$attributeArguments = New-Object UAAttributeArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10933") -Property @{
	IndexRangeList = [UAIndexRangeList]::OneDimension(2, 4)
}
$monitoredItemArguments = New-Object UAMonitoredItemArguments($attributeArguments, 1000)

# The callback is a lambda expression the displays the value
[void][IEasyUAClientExtension]::SubscribeMonitoredItem($client, $monitoredItemArguments, 
    [RunspacedDelegateFactory]::NewRunspacedDelegate([EasyUADataChangeNotificationEventHandler] { 
        param($sender, $eventArgs)
	    if ($eventArgs.Succeeded) {
                $arrayValue = $eventArgs.AttributeData.Value -as [int[]]
                if ($arrayValue -ne $null) {
                    Write-Host "Value: {$($arrayValue -join ",")}"
                } 
            }
            else {
                 Write-Host "*** Failure: $($EventArgs.ErrorMessageBrief)"
            }
    }))

Write-Host "Processing data change events for 10 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 10) {    
    Start-Sleep -Seconds 1
}

Write-Host "Unsubscribing..."
$client.UnsubscribeAllMonitoredItems()

Write-Host "Waiting for 2 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 2) {    
    Start-Sleep -Seconds 1
}
#endregion Example
