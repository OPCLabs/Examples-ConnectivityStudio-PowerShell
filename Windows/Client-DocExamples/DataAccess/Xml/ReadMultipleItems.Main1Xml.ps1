# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to read 4 items from an OPC XML-DA server at once, and display their values, timestamps 
# and qualities.
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

$vtqResults = [IEasyDAClientExtension]::ReadMultipleItems($client, 
    $serverDescriptor, 
    @(
        (New-Object DAItemDescriptor("Dynamic/Analog Types/Double")),
        (New-Object DAItemDescriptor("Dynamic/Analog Types/Double[]")),
        (New-Object DAItemDescriptor("Dynamic/Analog Types/Int")),
        (New-Object DAItemDescriptor("SomeUnknownItem"))
        ))

for ($i = 0; $i -lt $vtqResults.Length; $i++) {
    $vtqResult = $vtqResults[$i]
    if ($vtqResult.Succeeded) {
        Write-Host "vtqResults[$($i)].Vtq: $($vtqResult.Vtq)"
    }
    else {
        Write-Host "vtqResults[$($i)] *** Failure: $($vtqResult.ErrorMessageBrief)"
    }
}

#endregion Example
