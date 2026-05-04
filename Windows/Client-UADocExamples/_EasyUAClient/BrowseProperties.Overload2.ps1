# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to obtain properties under the "Server" node in the address space.
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
    $nodeElementCollection = [IEasyUAClientExtension]::BrowseProperties($client, 
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
#nodeElement.DisplayName: ServerArray
#nodeElement.NodeId: Server_ServerArray
#nodeElement.NodeId.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=2254
#
#nodeElement.DisplayName: NamespaceArray
#nodeElement.NodeId: Server_NamespaceArray
#nodeElement.NodeId.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=2255
#
#nodeElement.DisplayName: ServiceLevel
#nodeElement.NodeId: Server_ServiceLevel
#nodeElement.NodeId.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=2267
#
#nodeElement.DisplayName: Auditing
#nodeElement.NodeId: Server_Auditing
#nodeElement.NodeId.ExpandedText: nsu=http://opcfoundation.org/UA/ ;i=2994

#endregion Example
