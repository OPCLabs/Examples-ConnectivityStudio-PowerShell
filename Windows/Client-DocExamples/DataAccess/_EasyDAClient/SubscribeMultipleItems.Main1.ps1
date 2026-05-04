# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how subscribe to changes of multiple items and display the value of the item with each change.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.DataAccess
using namespace OpcLabs.EasyOpc.DataAccess.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyDAClient

# Item changed event handler
Register-ObjectEvent -InputObject $client -EventName ItemChanged -Action { 
    if ($EventArgs.Succeeded) {
        Write-Host "$($EventArgs.Arguments.ItemDescriptor.ItemId): $($EventArgs.Vtq)"
    }
    else {
        Write-Host "$($EventArgs.Arguments.ItemDescriptor.ItemId) *** Failure: $($EventArgs.ErrorMessageBrief)"
    }
}

Write-Host "Subscribing item changes..."
$handleArray = [IEasyDAClientExtension]::SubscribeMultipleItems($client, @(
    (New-Object DAItemGroupArguments("", "OPCLabs.KitServer.2", "Simulation.Random", 1000, $null)),
    (New-Object DAItemGroupArguments("", "OPCLabs.KitServer.2", "Trends.Ramp (1 min)", 1000, $null)),
    (New-Object DAItemGroupArguments("", "OPCLabs.KitServer.2", "Trends.Sine (1 min)", 1000, $null)),
    (New-Object DAItemGroupArguments("", "OPCLabs.KitServer.2", "Simulation.Register_I4", 1000, $null))
    ))

Write-Host "Processing item changed events for 1 minute..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 30) {    
    Start-Sleep -Seconds 1
}

Write-Host "Unsubscribing item changes..."
$client.UnsubscribeAllItems()

Write-Host "Finished."

#endregion Example
