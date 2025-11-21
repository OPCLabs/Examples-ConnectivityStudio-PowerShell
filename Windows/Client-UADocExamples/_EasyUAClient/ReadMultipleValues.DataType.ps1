# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to read the DataType attributes of 3 different nodes at once. Using the same method, it is also possible 
# to read multiple attributes of the same node.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
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

# Obtain values. 
$valueResultArray = $client.ReadMultipleValues([UAReadArguments[]]@(
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10845", [UAAttributeId]::DataType)), 
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10853", [UAAttributeId]::DataType)), 
        (New-Object UAReadArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10855", [UAAttributeId]::DataType))
    ))

foreach ($valueResult in $valueResultArray) {
    Write-Host

    if ($valueResult.Succeeded) {
        Write-Host "Value: $($valueResult.Value)"
        [UANodeId]$dataTypeId = $valueResult.Value;
        if ($dataTypeId -ne $null) {
            Write-Host "Value.ExpandedText: $($dataTypeId.ExpandedText)"
            Write-Host "Value.NamespaceUriString: $($dataTypeId.NamespaceUriString)"
            Write-Host "Value.NamespaceIndex: $($dataTypeId.NamespaceIndex)"
            Write-Host "Value.NumericIdentifier: $($dataTypeId.NumericIdentifier)"
        }
    }
    else {
        Write-Host "*** Failure: $($valueResult.ErrorMessageBrief)"
    }
}


# Example output:
#
#Value: SByte
#Value.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=2
#Value.NamespaceUriString: http://opcfoundation.org/UA/
#Value.NamespaceIndex: 0
#Value.NumericIdentifier: 2
#
#Value: Float
#Value.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=10
#Value.NamespaceUriString: http://opcfoundation.org/UA/
#Value.NamespaceIndex: 0
#Value.NumericIdentifier: 10
#
#Value: String
#Value.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=12
#Value.NamespaceUriString: http://opcfoundation.org/UA/
#Value.NamespaceIndex: 0
#Value.NumericIdentifier: 12

#endregion Example
