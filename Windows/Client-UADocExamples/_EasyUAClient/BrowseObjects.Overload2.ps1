# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to obtain objects under the "Server" node in the address space.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard
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

# Obtain objects under "Server" node.
try {
    $nodeElementCollection = [IEasyUAClientExtension]::BrowseObjects($client, 
        $endpointDescriptor, [UAObjectIds]::Server)
}
catch [UAException] {
    Write-Host "*** Failure: $($PSItem.Exception.GetBaseException().Message)"
    return
}

# Display results
foreach ($nodeElement in $nodeElementCollection) {
    Write-Host
    Write-Host "nodeElement.DisplayName: $($nodeElement.DisplayName)"
    Write-Host "nodeElement.NodeId: $($nodeElement.NodeId)"
    Write-Host "nodeElement.NodeId.ExpandedText: $($nodeElement.NodeId.ExpandedText)"
}


# Example output:
#
#nodeElement.DisplayName: ServerCapabilities
#nodeElement.NodeId: Server_ServerCapabilities
#nodeElement.NodeId.ExpandedText: nsu = http://opcfoundation.org/UA/ ;i=2268
#
#nodeElement.DisplayName: ServerDiagnostics
#nodeElement.NodeId: Server_ServerDiagnostics
#nodeElement.NodeId.ExpandedText: nsu = http://opcfoundation.org/UA/ ;i=2274
#
#nodeElement.DisplayName: VendorServerInfo
#nodeElement.NodeId: Server_VendorServerInfo
#nodeElement.NodeId.ExpandedText: nsu = http://opcfoundation.org/UA/ ;i=2295
#
#nodeElement.DisplayName: ServerRedundancy
#nodeElement.NodeId: Server_ServerRedundancy
#nodeElement.NodeId.ExpandedText: nsu = http://opcfoundation.org/UA/ ;i=2296
#
#nodeElement.DisplayName: Namespaces
#nodeElement.NodeId: Server_Namespaces
#nodeElement.NodeId.ExpandedText: nsu = http://opcfoundation.org/UA/ ;i=11715

#endregion Example
