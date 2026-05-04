# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to read a range of values from an array.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-QuickOPC-PowerShell .
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

# Obtain the value, indicating that just the elements 2 to 4 should be returned
try {
    $value = [OpcLabs.EasyOpc.UA.IEasyUAClientExtension]::ReadValue($client,
        (New-Object UAReadArguments(
            $endpointDescriptor, 
            "nsu=http://test.org/UA/Data/ ;ns=2;i=10305", # /Data.Static.Array.Int32Value
            [OpcLabs.EasyOpc.UA.UAIndexRangeList]::OneDimension(2, 4)
        )))
}
catch [UAException] {
    Write-Host ("Failure: {0}" -f  $_.Exception.GetBaseException().Message)
    return
}

# Cast to typed array
[int[]] $arrayValue = $value

# Display results
for ($i = 0; $i -lt 3; $i++) {
    Write-Host ("arrayValue[{0}]: {1}" -f $i, $arrayValue[$i])
}

#    Write-Host "arrayValue[$($i)]: $($arrayValue[$i])"


# Example output:
#arrayValue[0]: 180410224
#arrayValue[1]: 1919239969
#arrayValue[2]: 1700185172

#endregion Example
