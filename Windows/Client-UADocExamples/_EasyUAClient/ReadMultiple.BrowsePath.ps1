# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to read the attributes of 4 OPC-UA nodes specified by browse paths at once, and display the
# results.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.Navigation.Parsing
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

# Instantiate the browse path parser.
$browsePathParser = New-Object UABrowsePathParser -Property @{DefaultNamespaceUriString = "http://test.org/UA/Data/"}

# Prepare arguments.
# Note: Add error handling around the following statement if the browse paths are not guaranteed to be
## syntactically valid.
$readArgumentsArray = @(
        (New-Object UAReadArguments($endpointDescriptor, 
            $browsePathParser.Parse("[ObjectsFolder]/Data/Dynamic/Scalar/FloatValue"))),
        (New-Object UAReadArguments($endpointDescriptor,
            $browsePathParser.Parse("[ObjectsFolder]/Data/Dynamic/Scalar/SByteValue"))),
        (New-Object UAReadArguments($endpointDescriptor,
            $browsePathParser.Parse("[ObjectsFolder]/Data/Static/Array/UInt16Value"))),
        (New-Object UAReadArguments($endpointDescriptor,
            $browsePathParser.Parse("[ObjectsFolder]/Data/Static/UserScalar/Int32Value")))
    )

# Obtain attribute data.
$attributeDataResultArray = $client.ReadMultiple($readArgumentsArray)

for ($i = 0; $i -lt $attributeDataResultArray.Length; $i++) {
    $attributeDataResult = $attributeDataResultArray[$i]
    if ($attributeDataResult.Succeeded) {
        Write-Host "results[$($i)].AttributeData: $($attributeDataResult.AttributeData)"
    }
    else {
        Write-Host "results[$($i)]: *** Failure: $($attributeDataResult.ErrorMessageBrief)"
    }
}


# Example output:
#
#results[0].AttributeData: 4.187603E+21 {Single} @2019-11-09T14:05:46.268 @@2019-11-09T14:05:46.268; Good
#results[1].AttributeData: -98 {Int16} @2019-11-09T14:05:46.268 @@2019-11-09T14:05:46.268; Good
#results[2].AttributeData: [58] {38240, 11129, 64397, 22845, 30525, ...} {Int32[]} @2019-11-09T14:00:07.543 @@2019-11-09T14:05:46.268; Good
#results[3].AttributeData: 1280120396 {Int32} @2019-11-09T14:00:07.590 @@2019-11-09T14:05:46.268; Good

#endregion Example
