# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to changes of multiple monitored items
# and display each change, identifying the different subscriptions by an
# integer.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
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
    # Obtain the integer state we have passed in.
    [int]$stateAsInteger = $EventArgs.Arguments.State

    # Display the data.
    if ($EventArgs.Succeeded) {
        Write-Host "$($stateAsinteger): $($EventArgs.AttributeData)"
    }
    else {
        Write-Host "$($stateAsinteger) *** Failure: $($EventArgs.ErrorMessageBrief)"
    }
}

Write-Host "Subscribing..."
$handleArray = $client.SubscribeMultipleMonitoredItems(@(
    (New-Object UAMonitoredItemArguments(
        (New-Object UAAttributeArguments($endpointDescriptor, [UANodeDescriptor]"nsu=http://test.org/UA/Data/ ;i=10845")), 
        1000) -Property @{State = 1}), # An integer we have chosen to identify the subscription
    (New-Object UAMonitoredItemArguments(
        (New-Object UAAttributeArguments($endpointDescriptor, [UANodeDescriptor]"nsu=http://test.org/UA/Data/ ;i=10853")), 
        1000) -Property @{State = 2}), # An integer we have chosen to identify the subscription
    (New-Object UAMonitoredItemArguments(
        (New-Object UAAttributeArguments($endpointDescriptor, [UANodeDescriptor]"nsu=http://test.org/UA/Data/ ;i=10855")),
        1000) -Property @{State = 3}) # An integer we have chosen to identify the subscription
    ))

for ($i = 0; $i -lt $handleArray.Length; $i++) {
    Write-Host "handleArray[$($i)]: $($handleArray[$i])"
}

Write-Host
Write-Host "Processing monitored item changed events for 10 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 10) {    
    Start-Sleep -Seconds 1
}

Write-Host "Unsubscribing..."
$client.UnsubscribeAllMonitoredItems()

Write-Host "Waiting for 5 seconds..."
Start-Sleep -Seconds 5

Write-Host "Finished."

#endregion Example
