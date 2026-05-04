# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to obtain dictionary of parameters of all monitored item subscriptions.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAPrimitives.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUACore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

[UAEndpointDescriptor]$endpointDescriptor =
    "opc.tcp://opcua.demo-this.com:51210/UA/SampleServer"
# or "http://opcua.demo-this.com:51211/UA/SampleServer" (currently not supported)
# or "https://opcua.demo-this.com:51212/UA/SampleServer/"

# Instantiate the client object.
$client = New-Object EasyUAClient

# Data change notification handler
Register-ObjectEvent -InputObject $client -EventName DataChangeNotification -Action { 
    # Your code would do the processing here.
}

Write-Host "Subscribing..."
$handleArray = $client.SubscribeMultipleMonitoredItems(@(
    (New-Object UAMonitoredItemArguments(
        (New-Object UAAttributeArguments($endpointDescriptor, [UANodeDescriptor]"nsu=http://test.org/UA/Data/ ;i=10845")), 
        1000)),
    (New-Object UAMonitoredItemArguments(
        (New-Object UAAttributeArguments($endpointDescriptor, [UANodeDescriptor]"nsu=http://test.org/UA/Data/ ;i=10853")), 
        1000)),
    (New-Object UAMonitoredItemArguments(
        (New-Object UAAttributeArguments($endpointDescriptor, [UANodeDescriptor]"nsu=http://test.org/UA/Data/ ;i=10855")),
        1000))
    ))

Write-Host "Getting monitored item arguments dictionary..."
$monitoredItemArgumentsDictionary = $client.GetMonitoredItemArgumentsDictionary()

foreach ($monitoredItemArguments in $monitoredItemArgumentsDictionary.Values) {
    Write-Host
    Write-Host "NodeDescriptor: $($monitoredItemArguments.NodeDescriptor)"
    Write-Host "SamplingInterval: $($monitoredItemArguments.MonitoringParameters.SamplingInterval)"
    Write-Host "PublishingInterval: $($monitoredItemArguments.SubscriptionParameters.PublishingInterval)"
}

Write-Host
Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

Write-Host "Unsubscribing..."
$client.UnsubscribeAllMonitoredItems()

Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

Write-Host "Finished."


# Example output:
#
#Subscribing...
#Getting monitored item arguments dictionary...
#
#NodeDescriptor: NodeId="nsu=http://test.org/UA/Data/ ;i=10845"
#SamplingInterval: 1000
#PublishingInterval: 0
#
#NodeDescriptor: NodeId="nsu=http://test.org/UA/Data/ ;i=10853"
#SamplingInterval: 1000
#PublishingInterval: 0
#
#NodeDescriptor: NodeId="nsu=http://test.org/UA/Data/ ;i=10855"
#SamplingInterval: 1000
#PublishingInterval: 0
#
#Waiting for 5 seconds...
#Unsubscribing...
#Waiting for 5 seconds...
#Finished.

#endregion Example
