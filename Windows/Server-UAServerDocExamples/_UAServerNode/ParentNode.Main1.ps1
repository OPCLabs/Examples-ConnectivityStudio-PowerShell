# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how data from parent node can be used in the read event handler.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.BaseLib.NodeSpace
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.EasyOpc.UA.OperationModel
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

$Random = New-Object Random

# Event handler for the read event on the data variable.
[UADataVariableReadEventHandler]$MyDataVariableOnRead = {
    param ($sender, $e)
    # Obtain the parent folder of the data variable that is being read.
    $parentNode = $e.DataVariable.ParentNode

    # Obtain the state associated with the folder, where the data variable is located.
    # Use it as the offset for the random value, so that each data variable generates values in a unique range.
    $offset = [int]$parentNode.State*100

    # Generate a random value, indicate that the read has been handled, and return the generated value.
    $e.HandleAndReturn($Random.Next($offset, $offset + 100))
}

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Create multiple folder nodes, each with a data variable in it. Distinguish the folders by their state, however
# the data variables are constructed the same, and use the same read event handler.

$MyDataVariableOnReadRunspaceDelegate = [RunspacedDelegateFactory]::NewRunspacedDelegate($MyDataVariableOnRead)

$myFolder1 = [NodeExtension]::SetState([UAFolder]::CreateIn($server.Objects, "MyFolder1"), 1)
([UADataVariable]::CreateIn($myFolder1, "MyDataVariable")).add_Read($MyDataVariableOnReadRunspaceDelegate)

$myFolder2 = [NodeExtension]::SetState([UAFolder]::CreateIn($server.Objects, "MyFolder2"), 2)
([UADataVariable]::CreateIn($myFolder2, "MyDataVariable")).add_Read($MyDataVariableOnReadRunspaceDelegate)

$myFolder3 = [NodeExtension]::SetState([UAFolder]::CreateIn($server.Objects, "MyFolder3"), 3)
([UADataVariable]::CreateIn($myFolder3, "MyDataVariable")).add_Read($MyDataVariableOnReadRunspaceDelegate)

$myFolder4 = [NodeExtension]::SetState([UAFolder]::CreateIn($server.Objects, "MyFolder4"), 4)
([UADataVariable]::CreateIn($myFolder4, "MyDataVariable")).add_Read($MyDataVariableOnReadRunspaceDelegate)

$myFolder5 = [NodeExtension]::SetState([UAFolder]::CreateIn($server.Objects, "MyFolder5"), 5)
([UADataVariable]::CreateIn($myFolder5, "MyDataVariable")).add_Read($MyDataVariableOnReadRunspaceDelegate)

# Start the server.
Write-Host "The server is starting..."
$server.Start()

Write-Host "The server is started."
Write-Host

# Let the user decide when to stop.
Write-Host "Press Enter to stop the server..."
Read-Host

# Stop the server.
Write-Host "The server is stopping..."
$server.Stop()

Write-Host "The server is stopped."
#endregion Example
