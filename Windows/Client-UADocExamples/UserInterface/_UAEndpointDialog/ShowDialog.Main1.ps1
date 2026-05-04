# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to let the user browse for an OPC-UA server endpoint.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

using namespace OpcLabs.EasyOpc.UA.Forms.Browsing

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcForms.dll"

# Instantiate the dialog object.
$endpointDialog = New-Object UAEndpointDialog
$endpointDialog.DiscoveryHost = "opcua.demo-this.com"

$dialogResult = $endpointDialog.ShowDialog()
if ($dialogResult -ne [System.Windows.Forms.DialogResult]::OK) {
    return
}

# Display results
Write-Host $endpointDialog.DiscoveryElement

#endregion Example
