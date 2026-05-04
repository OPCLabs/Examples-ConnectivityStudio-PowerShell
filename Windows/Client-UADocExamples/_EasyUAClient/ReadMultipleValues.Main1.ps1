# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to read the Value attributes of 3 different nodes at once. Using the same method, it is also possible 
# to read multiple attributes of the same node.
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

# Obtain values. By default, the Value attributes of the nodes will be read.
$valueResultArray = $client.ReadMultipleValues([UAReadArguments[]]@(
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10845")), 
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10853")), 
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10855"))
    ))

foreach ($valueResult in $valueResultArray) {
    if ($valueResult.Succeeded) {
        Write-Host "Value: $($valueResult.Value)"
    }
    else {
        Write-Host "*** Failure: $($valueResult.ErrorMessageBrief)"
    }
}


# Example output:
#
#Value: 8
#Value: -8.06803E+21
#Value: Strawberry Pig Banana Snake Mango Purple Grape Monkey Purple? Blueberry Lemon^            

#endregion Example
