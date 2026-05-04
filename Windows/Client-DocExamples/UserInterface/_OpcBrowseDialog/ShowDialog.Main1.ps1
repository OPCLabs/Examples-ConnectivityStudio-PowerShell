# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example

# This example shows how to let the user browse for an OPC Data Access node in a dialog.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcForms.dll"

$browseDialog = New-Object OpcLabs.EasyOpc.Forms.Browsing.OpcBrowseDialog

$dialogResult = $browseDialog.ShowDialog()
if ($dialogResult -ne [System.Windows.Forms.DialogResult]::OK) {
    return
}

# Display results
Write-Host $browseDialog.Outputs.CurrentNodeElement.DANodeElement

#endregion Example
