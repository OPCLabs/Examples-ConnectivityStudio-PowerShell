# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to call multiple methods, and pass arguments to and
# from them.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.BaseLib.OperationModel
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

[UAEndpointDescriptor]$endpointDescriptor =
    "opc.tcp://opcua.demo-this.com:51210/UA/SampleServer"
# or "http://opcua.demo-this.com:51211/UA/SampleServer" (currently not supported)
# or "https://opcua.demo-this.com:51212/UA/SampleServer/"
$nodeDescriptor = New-Object UANodeDescriptor("nsu=http://test.org/UA/Data/ ;i=10755")

$inputs1 = @(
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

$typeCodes1 = @(
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


$inputs2 = @(
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
    10,
    "eleven")

$typeCodes2 = @(
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
    [TypeCode]::Double,
    [TypeCode]::String)

# Instantiate the client object.
$client = New-Object EasyUAClient

# Perform the operation.
$results = $client.CallMultipleMethods(@(
    (New-Object UACallArguments($endpointDescriptor, $nodeDescriptor, 
        "nsu=http://test.org/UA/Data/ ;i=10756", $inputs1, $typeCodes1)),
    (New-Object UACallArguments($endpointDescriptor, $nodeDescriptor, 
        "nsu=http://test.org/UA/Data/ ;i=10774", $inputs2, $typeCodes2))
    ))

# Display results
for ($i = 0; $i -lt $results.Length; $i++) {
    Write-Host
    Write-Host "results[$($i)]:"

    $result = $results[$i]
    if ($result.Succeeded) {
        $outputs = $result.ValueArray
        for ($j = 0; $j -lt $outputs.Length; $j++) {
            Write-Host "    outputs[$($j)]: $($outputs[$j])"
        }
    }
    else {
        Write-Host "*** Failure: $($vtqResult.ErrorMessageBrief)"
    }


# Example output:
#
#results[0]:
#    outputs[0]: False
#    outputs[1]: 1
#    outputs[2]: 2
#    outputs[3]: 3
#    outputs[4]: 4
#    outputs[5]: 5
#    outputs[6]: 6
#    outputs[7]: 7
#    outputs[8]: 8
#    outputs[9]: 9
#    outputs[10]: 10

#results[1]:
#    outputs[0]: False
#    outputs[1]: 1
#    outputs[2]: 2
#    outputs[3]: 3
#    outputs[4]: 4
#    outputs[5]: 5
#    outputs[6]: 6
#    outputs[7]: 7
#    outputs[8]: 8
#    outputs[9]: 9
#    outputs[10]: 10
#    outputs[11]: eleven
}

#endregion Example
