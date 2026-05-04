# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to search for nodes in the server by their node Id.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.NodeSpace

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Define some nodes in the server.
$constantDataVariable = [UADataVariableExtension]::ConstantValue([UADataVariable]::CreateIn($server.Objects, "Constant"), "abc")
$nestedConstantDataVariable = [UADataVariableExtension]::ConstantValue([UADataVariable]::CreateIn($constantDataVariable, "NestedConstant"), 42)

# Try to find the nested constant data variable. It will be found.
$serverNode1 = [IEasyUAServerExtension]::FindServerNode($server, "nsu=http://opclabs.com/OpcUA/Custom/Objects ;s=Constant.NestedConstant")
Write-Host $serverNode1.ToString()

# Try to find an unknown server node. A null reference will be returned.
$serverNode2 = [IEasyUAServerExtension]::FindServerNode($server, "nsu=http://opclabs.com/OpcUA/Custom/Objects ;s=Unknown")
Write-Host $(if ($serverNode2 -eq $null) { "" } else { $serverNode2.ToString() })
#endregion Example
