# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to call a single method, and pass arguments to and from it.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace System
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

$inputs = @(
    $false,
    1, 
    2, 
    3, 
    4, 
    5, 
    6, 
    7, 
    8, 
    9, 
    10)

$typeCodes = @(
    [TypeCode]::Boolean,
    [TypeCode]::SByte,
    [TypeCode]::Byte,
    [TypeCode]::Int16,
    [TypeCode]::UInt16,
    [TypeCode]::Int32,
    [TypeCode]::UInt32,
    [TypeCode]::Int64,
    [TypeCode]::UInt64,
    [TypeCode]::Single,
    [TypeCode]::Double)

# Instantiate the client object.
$client = New-Object EasyUAClient

# Perform the operation.
try {
    $outputs = $client.CallMethod(
                    $endpointDescriptor,
                    "nsu=http://test.org/UA/Data/ ;i=10755",
                    "nsu=http://test.org/UA/Data/ ;i=10756",
                    $inputs,
                    $typeCodes)
}
catch [UAException] {
    Write-Host "*** Failure: $($PSItem.Exception.GetBaseException().Message)"
    return
}

# Display results
for ($i = 0; $i -lt $outputs.Length; $i++) {
    Write-Host "outputs[$($i)]: $($outputs[$i])"
}


# Example output:
#
#outputs[0]: False
#outputs[1]: 1
#outputs[2]: 2
#outputs[3]: 3
#outputs[4]: 4
#outputs[5]: 5
#outputs[6]: 6
#outputs[7]: 7
#outputs[8]: 8
#outputs[9]: 9
#outputs[10]: 10        

#endregion Example
