# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to configure the namespace URI of the custom nodes, using a URL string.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
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

# Set custom value for the namespace URI of our nodes under the Objects folder, using a URL string.
$server.ObjectsNamespaceUriString = "http://mynamespace.example"

# Create some data variable and a folder in the Objects folder.
$dataVariable1 = [UADataVariable]::CreateIn($server.Objects, "DataVariable1")
$folder1 = [UAFolder]::CreateIn($server.Objects, "Folder1")

# Display the node Ids (including the namespace URI).
Write-Host ([UANodeId]::op_Implicit($server.Objects.EffectiveNodeDescriptor.NodeId))
Write-Host ([UANodeId]::op_Implicit($dataVariable1.EffectiveNodeDescriptor.NodeId))
Write-Host ([UANodeId]::op_Implicit($folder1.EffectiveNodeDescriptor.NodeId))
#endregion Example
