# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how sub-nodes of server nodes can be accessed by their node name using an indexer.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.NodeSpace

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Define some nodes in the server.
$constantDataVariable = [UADataVariableExtension]::ConstantValue([UADataVariable]::CreateIn($server.Objects, "Constant"), "abc")
$nestedConstantDataVariable = [UADataVariableExtension]::ConstantValue([UADataVariable]::CreateIn($constantDataVariable, "NestedConstant"), 42)

# Get the nested constant data variable.
$serverNode1 = $server.Objects["Constant"]["NestedConstant"]
Write-Host $serverNode1.ToString()
#endregion Example
