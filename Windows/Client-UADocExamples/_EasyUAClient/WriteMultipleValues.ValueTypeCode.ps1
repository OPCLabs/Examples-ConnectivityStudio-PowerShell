# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to write values into 3 nodes at once, specifying a type code explicitly. It tests for success of 
# each write and displays the exception message in case of failure.
#
# Reasons for specifying the type explicitly might be:
# - The data type in the server has subtypes, and the client therefore needs to pick the subtype to be written.
# - The data type that the reports is incorrect.
# - Writing with an explicitly specified type is more efficient.
#
# Alternative ways of specifying the type are using the ValueType or ValueTypeFullName properties.
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

Write-Host "Modifying values of nodes..."
$operationResultArray = $client.WriteMultipleValues([UAWriteValueArguments[]]@(
        (New-Object UAWriteValueArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10221", 23456) `
            -Property @{ValueTypeCode = [TypeCode]::Int32}), # here is the type explicitly specified
        (New-Object UAWriteValueArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;i=10226", 
            "This string cannot be converted to Double") `
            -Property @{ValueTypeCode = [TypeCode]::Double}), # here is the type explicitly specified
        (New-Object UAWriteValueArguments($endpointDescriptor, "nsu=http://test.org/UA/Data/ ;s=UnknownNode", "ABC") `
            -Property @{ValueTypeCode = [TypeCode]::String}) # here is the type explicitly specified
    ))

for ($i = 0; $i -lt $operationResultArray.Length; $i++) {
    if ($operationResultArray[$i].Succeeded) {
        Write-Host "Result $($i): success"
    }
    else {
        Write-Host "Result $($i): $($operationResultArray[$i].Exception.GetBaseException().Message)"
    }
}


# Example output:
#
#Modifying values of nodes...
#Result 0: success
#Result 1: Input string was not in a correct format.
#+ Attempting to change an object of type "System.String" to type "System.Double".
#+ The specified original value (string) was "This string cannot be converted to Double".
#+ The node descriptor used was: NodeId="nsu=http://test.org/UA/Data/ ;i=10226".
#+ The client method called (or event/callback invoked) was 'WriteMultiple[3]'.
#Result 2: The status of the OPC-UA attribute data is not Good. The actual status is 'BadNodeIdUnknown'.
#+ During writing or method calls, readings may occur when value type is not specified.
#+ The node descriptor used was: NodeId="nsu=http://test.org/UA/Data/ ;s=UnknownNode".
#+ The client method called (or event/callback invoked) was 'WriteMultiple[3]'.

#endregion Example
