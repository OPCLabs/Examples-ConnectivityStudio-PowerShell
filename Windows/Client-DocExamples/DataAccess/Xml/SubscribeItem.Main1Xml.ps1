# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how subscribe to changes of a single item in an OPC XML-DA server and display the value of the item 
# with each change, using a callback method specified using lambda expression.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc
using namespace OpcLabs.EasyOpc.DataAccess

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyDAClient

$serverDescriptor = New-Object ServerDescriptor -Property @{
    UrlString = "http://opcxml.demo-this.com/XmlDaSampleServer/Service.asmx"
}

# Item changed event handler
Register-ObjectEvent -InputObject $client -EventName ItemChanged -Action { 
    if ($EventArgs.Succeeded) {
        Write-Host $EventArgs.Vtq
    }
    else {
        Write-Host "*** Failure: $($EventArgs.ErrorMessageBrief)"
    }
}

Write-Host "Subscribing item..."
[IEasyDAClientExtension]::SubscribeItem($client, $serverDescriptor, "Dynamic/Analog Types/Int", 1000, $null)

Write-Host "Processing item changes for 30 seconds..."
$stopwatch =  [System.Diagnostics.Stopwatch]::StartNew() 
while ($stopwatch.Elapsed.TotalSeconds -lt 30) {    
    Start-Sleep -Seconds 1
}

Write-Host "Unsubscribing items..."
$client.UnsubscribeAllItems()

Write-Host "Waiting for 2 seconds..."
Start-Sleep -Seconds 2

Write-Host "Finished."

#endregion Example
