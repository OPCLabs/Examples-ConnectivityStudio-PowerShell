# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to write values, timestamps and qualities into 3 items at once.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace System
using namespace OpcLabs.EasyOpc.DataAccess
using namespace OpcLabs.EasyOpc.DataAccess.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyDAClient

Write-Host "Writing multiple items..."
$resultArray = $client.WriteMultipleItems(@(
    (New-Object DAItemVtqArguments("OPCLabs.KitServer.2", "Simulation.Register_I4", 
        (New-Object DAVtq(23456, [DateTime]::UtcNow, [DAQualities]::GoodNonspecific)))),
    (New-Object DAItemVtqArguments("OPCLabs.KitServer.2", "Simulation.Register_R8", 
        (New-Object DAVtq(2.345667890, [DateTime]::UtcNow, [DAQualities]::GoodNonspecific)))),
    (New-Object DAItemVtqArguments("OPCLabs.KitServer.2", "Simulation.Register_BSTR",
        (New-Object DAVtq("ABC", [DateTime]::UtcNow, [DAQualities]::GoodNonspecific))))
    ))

for ($i = 0; $i -lt $resultArray.Length; $i++) {
    $result = $resultArray[$i]
    if ($result.Succeeded) {
        Write-Host "Result $($i): success"
    }
    else {
        Write-Host "Result $($i) *** Failure: $($result.ErrorMessageBrief)"
    }
}

#endregion Example
