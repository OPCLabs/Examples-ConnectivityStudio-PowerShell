# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to item changes and obtain the events by pulling them.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.DataAccess

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyDAClient
# In order to use event pull, you must set a non-zero queue capacity upfront.
$client.PullItemChangedQueueCapacity = 1000

Write-Host "Subscribing item..."
[IEasyDAClientExtension]::SubscribeItem($client, "", "OPCLabs.KitServer.2", "Simulation.Random", 1000)

Write-Host "Processing item changes for 1 minute..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 60) {    
    $eventArgs = [IEasyDAClientExtension]::PullItemChanged($client, 2*1000)
    if ($eventArgs -ne $null) {
        # Handle the notification event
        Write-Host $eventArgs
    }
}

Write-Host "Unsubscribing items..."
$client.UnsubscribeAllItems()

Write-Host "Finished."

#endregion Example
