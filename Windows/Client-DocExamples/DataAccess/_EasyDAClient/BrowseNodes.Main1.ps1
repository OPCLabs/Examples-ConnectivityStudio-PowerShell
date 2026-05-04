# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to obtain all nodes under the "Simulation" branch of the address space. For each node, it displays
# whether the node is a branch or a leaf.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.OperationModel
using namespace OpcLabs.EasyOpc.DataAccess

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyDAClient

try {
    $nodeElements = [IEasyDAClientExtension]::BrowseNodes($client,
        "", "OPCLabs.KitServer.2", "Greenhouse", [DABrowseParameters]::Default)
}
catch [OpcException] {
    Write-Host "*** Failure: $($PSItem.Exception.GetBaseException().Message)"
    return
}

Foreach ($nodeElement in $nodeElements) {
    Write-Host "NodeElements(`"$($nodeElement.Name)`"):"
    Write-Host "    .IsBranch: $($nodeElement.IsBranch)"
    Write-Host "    .IsLeaf: $($nodeElement.IsLeaf)"
}

#endregion Example
