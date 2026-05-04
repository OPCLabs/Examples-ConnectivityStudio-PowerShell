# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to add nodes (data variables and folders) to the Objects folder in the address space.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.NodeSpace

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Create a data variable and a folder in the Objects folder, and a data variable under the custom folder.
$constantDataVariable = [UADataVariableExtension]::ConstantValue([UADataVariable]::CreateIn($server.Objects, "Constant"), "abc")
$folder = [UAFolder]::CreateIn($server.Objects, "Folder")
$readWriteDataVariable = [UADataVariableExtension]::ReadWriteValue([UADataVariable]::CreateIn($folder, "ReadWrite"), 0); # read-write register

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
