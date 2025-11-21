# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to browse objects under the "Objects" node and display notifiers.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard
using namespace OpcLabs.EasyOpc.UA.Navigation.Parsing;
using namespace OpcLabs.EasyOpc.UA.OperationModel


function BrowseNotifiersFrom([UANodeDescriptor]$nodeDescriptor) { 

    # Define which server we will work with.
    [UAEndpointDescriptor]$endpointDescriptor = "opc.tcp://opcua.demo-this.com:62544/Quickstarts/AlarmConditionServer"

    Write-Host
    Write-Host
    Write-Host "Parent node: $($nodeDescriptor)"

    # Instantiate the client object.
    $client = New-Object EasyUAClient

    # Obtain event sources.
    $notifierNodeElementCollection = [IEasyUAClientExtension]::BrowseNotifiers($client,
        $endpointDescriptor, $nodeDescriptor)

    # Display event sources.
    if ($notifierNodeElementCollection.Count -ne 0) {
        Write-Host
        Write-Host "Notifiers:"
        foreach ($notifierNodeElement in $notifierNodeElementCollection) {
            Write-Host $notifierNodeElement
        }
    }

    # Obtain objects.
    $objectNodeElementCollection = [IEasyUAClientExtension]::BrowseObjects($client,
        $endpointDescriptor, $nodeDescriptor)

    # Recurse.
    foreach ($objectNodeElement in $objectNodeElementCollection) {
        BrowseNotifiersFrom($objectNodeElement)
    }
}


# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

# Start browsing from the "Objects" node.
try {
    [UANodeDescriptor]$startingNodeDescriptor = [UAObjectIds]::ObjectsFolder
    BrowseNotifiersFrom $startingNodeDescriptor
}
catch [UAException] {
    Write-Host "*** Failure: $($PSItem.Exception.GetBaseException().Message)"
    return
}

Write-Host
Write-Host "Finished."


# Example output (truncated):
#
#
#Parent node: ObjectsFolder
#
#
#Parent node: Server
#
#Notifiers:
#Green -> nsu=http:#opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=0:/Green (Object)
#Yellow -> nsu=http:#opcfoundation.org/Quickstarts/AlarmCondition ;ns=2;s=0:/Yellow (Object)
#
#
#Parent node: Server_ServerCapabilities
#...

#endregion Example
