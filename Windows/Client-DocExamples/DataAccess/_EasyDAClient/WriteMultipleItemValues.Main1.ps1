# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# Shows how to write into multiple OPC items using a single method call, and read multiple item values back.
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

Write-Host "Writing multiple item values..."
$resultArray = $client.WriteMultipleItemValues(@(
    (New-Object DAItemValueArguments("", "OPCLabs.KitServer.2", "Simulation.Register_I4", 12345)),
    (New-Object DAItemValueArguments("", "OPCLabs.KitServer.2", "Simulation.Register_BOOL", $true)),
    (New-Object DAItemValueArguments("", "OPCLabs.KitServer.2", "Simulation.Register_R4", 234.56))
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

Write-Host 
Write-Host "Reading multiple item values..."
$valueResultArray = [IEasyDAClientExtension]::ReadMultipleItemValues($client, 
    "OPCLabs.KitServer.2", @(
        (New-Object DAItemDescriptor("Simulation.Register_I4")),
        (New-Object DAItemDescriptor("Simulation.Register_BOOL")),
        (New-Object DAItemDescriptor("Simulation.Register_R4"))
        ))

for ($i = 0; $i -lt $valueResultArray.Length; $i++) {
    $valueResult = $valueResultArray[$i]
    Write-Host "valueResultArray[$($i)]: $($valueResult)"
}


# Example output:
#
#Writing multiple item values...
#Result 0: success
#Result 1: success
#Result 2: success
#
#Reading multiple item values...
#valueResultArray[0]: Success; 12345 {System.Int32}
#valueResultArray[1]: Success; True {System.Boolean}
#valueResultArray[2]: Success; 234.56 {System.Single}

#endregion Example
