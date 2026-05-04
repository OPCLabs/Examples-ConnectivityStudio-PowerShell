# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to read data (value, timestamps, and status code) of 3 attributes at once. In this example,
# we are reading a Value attribute of 3 different nodes, but the method can also be used to read multiple attributes
# of the same node.
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

# Obtain attribute data. By default, the Value attributes of the nodes will be read.
$attributeDataResultArray = $client.ReadMultiple(@(
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10845")), 
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10853")), 
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10855"))
    ))

foreach ($attributeDataResult in $attributeDataResultArray) {
    if ($attributeDataResult.Succeeded) {
        Write-Host "AttributeData: $($attributeDataResult.AttributeData)"
    }
    else {
        Write-Host "*** Failure: $($attributeDataResult.ErrorMessageBrief)"
    }
}


# Example output:
#
#AttributeData: 51 {Int16} @11/6/2011 1:49:19 PM @11/6/2011 1:49:19 PM; Good
#AttributeData: -1993984 {Single} @11/6/2011 1:49:19 PM @11/6/2011 1:49:19 PM; Good
#AttributeData: Yellow% Dragon Cat) White Blue Dog# Green Banana- {String} @11/6/2011 1:49:19 PM @11/6/2011 1:49:19 PM; Good            

#endregion Example
