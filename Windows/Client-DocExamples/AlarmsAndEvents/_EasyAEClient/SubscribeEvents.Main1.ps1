# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to subscribe to events and display the event message with each notification. It also shows how to 
# unsubscribe afterwards.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.AlarmsAndEvents

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyAEClient

# Notification event handler
Register-ObjectEvent -InputObject $client -EventName Notification -Action { 
    if (-not $EventArgs.Succeeded) {
        Write-Host "*** Failure: $($EventArgs.ErrorMessageBrief)"
        #return
    }
    if ($EventArgs.EventData -ne $null) {
        Write-Host $EventArgs.EventData.Message
    }
}

Write-Host "Subscribing events..."
$handle = [IEasyAEClientExtension]::SubscribeEvents($client, "", "OPCLabs.KitEventServer.2", 1000)

Write-Host "Processing event notifications for 1 minute..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 60) {    
    Start-Sleep -Seconds 1
}

Write-Host "Unsubscribing events..."
$client.UnsubscribeEvents($handle)

Write-Host "Finished."

#endregion Example
