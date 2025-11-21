# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to get value of multiple OPC properties, and handle errors.
#
# Note that some properties may not have a useful value initially (e.g. until the item is activated in a group), which also the
# case with Timestamp property as implemented by the demo server. This behavior is server-dependent, and normal. You can run 
# IEasyDAClient.ReadMultipleItemValues.Main.vbs shortly before this example, in order to obtain better property values. Your 
# code may also subscribe to the items in order to assure that they remain active.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.OperationModel
using namespace OpcLabs.EasyOpc
using namespace OpcLabs.EasyOpc.DataAccess
using namespace OpcLabs.EasyOpc.DataAccess.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicCore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassic.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcClassicComponents.dll"

# Instantiate the client object.
$client = New-Object EasyDAClient

$serverDescriptor = New-Object ServerDescriptor("OPCLabs.KitServer.2")

# Get the values of Timestamp and AccessRights properties of two items.
$results = $client.GetMultiplePropertyValues(@(
    (New-Object DAPropertyArguments($serverDescriptor, "Simulation.Random", [DAPropertyDescriptor]::Timestamp)),
    (New-Object DAPropertyArguments($serverDescriptor, "Simulation.Random", [DAPropertyDescriptor]::AccessRights)),
    (New-Object DAPropertyArguments($serverDescriptor, "Trends.Ramp (1 min)", [DAPropertyDescriptor]::Timestamp)),
    (New-Object DAPropertyArguments($serverDescriptor, "Trends.Ramp (1 min)", [DAPropertyDescriptor]::AccessRights))
    ))

for ($i = 0; $i -lt $results.Length; $i++) {
    $valueResult = $results[$i]
    if ($valueResult.Exception -eq $null) {
        Write-Host "results($($i)).Value: $($valueResult.Value)"
    }
    else {
        Write-Host "results($($i)).Exception.Message: $($valueResult.Exception.Message)"
    }
}

#endregion Example
