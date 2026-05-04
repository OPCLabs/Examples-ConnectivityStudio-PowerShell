# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to handle the read event on a folder, providing a way to implement reading of multiple data
# variables using a single handler.
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

# Event handler for the read event on the folder.
[UADataVariableReadEventHandler]$MyFolderOnRead = {
    param ($sender, $e)
    # Obtain the state associated with the data variable that is being read.
    # Use it as the offset for the random value, so that each data variable generates values in a unique range.
    $offset = [int]$e.DataVariable.State*100

    # Generate a random value, indicate that the read has been handled, and return the generated value.
    $e.HandleAndReturn($Random.Next($offset, $offset + 100))
}

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Create a folder node.
$myFolder = [UAFolder]::CreateIn($server.Objects, "MyFolder")

# Create data variables in the folder. Distinguish them by their state.
$myFolder.Add([NodeExtension]::SetState([UADataVariableExtension]::ValueType((New-Object UADataVariable("MyDataVariable1")), [int]), 1))
$myFolder.Add([NodeExtension]::SetState([UADataVariableExtension]::ValueType((New-Object UADataVariable("MyDataVariable2")), [int]), 2))
$myFolder.Add([NodeExtension]::SetState([UADataVariableExtension]::ValueType((New-Object UADataVariable("MyDataVariable3")), [int]), 3))
$myFolder.Add([NodeExtension]::SetState([UADataVariableExtension]::ValueType((New-Object UADataVariable("MyDataVariable4")), [int]), 4))
$myFolder.Add([NodeExtension]::SetState([UADataVariableExtension]::ValueType((New-Object UADataVariable("MyDataVariable5")), [int]), 5))

# Handle the read event for the folder.
$myFolder.add_Read([RunspacedDelegateFactory]::NewRunspacedDelegate($MyFolderOnRead))

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
