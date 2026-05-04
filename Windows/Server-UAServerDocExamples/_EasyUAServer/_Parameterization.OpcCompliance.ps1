# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to set the OPC Wizard parameters for best OPC compliance.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.Engine
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

# You need to set both the shared parameters and instance parameters of the EasyUAServer to the values preset
# for OPC compliance, as shown in the code below. The main difference from the default ("Interoperability")
# settings is that the OPC compliance settings do not allow insecure connections, but there are other
# differences as well.
#
# You will need to establish mutual trust between the OPC UA server and the client in order to successfully
# establish a secure connection.

# Set the shared parameters for OPC compliance.
[EasyUAServer]::SharedParameters = ([EasyUAServerSharedParameters]::OpcCompliance)

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Hook event handler for the EndpointStateChanged event. It simply prints out the event.
$server.add_EndpointStateChanged([RunspacedDelegateFactory]::NewRunspacedDelegate([EasyUAServerEndpointStateChangedEventHandler]{ param($sender, $e) Write-Host $e }))

# Set the instance parameters for OPC compliance.
$server.InstanceParameters = [EasyUAServerInstanceParameters]::OpcCompliance

# Define a data variable providing random integers.
$random = New-Object System.Random
$server.Add(([UADataVariableExtension]::ReadValueFunction(
    (New-Object UADataVariable("MyDataVariable")), 
    [RunspacedDelegateFactory]::NewRunspacedDelegate([System.Func[int]] { $random.Next() })
)))

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
