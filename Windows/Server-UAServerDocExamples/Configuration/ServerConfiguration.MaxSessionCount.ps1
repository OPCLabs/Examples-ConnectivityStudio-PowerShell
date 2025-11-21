# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to limit the maximum number of sessions the OPC UA clients can open with the server.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.Engine
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

# Get the shared engine parameters object
$engineParameters = [EasyUAServer]::SharedParameters.EngineParameters

# Set the maximum number of open session to 2.
# This particular property is documented here:
# https://www.opclabs.com/files/onlinedocs/UA-.NETStandard/Latest/Browser%20Help/webframe.html#Opc.Ua.Core~Opc.Ua.ServerConfiguration~MaxSessionCount.html
$engineParameters.ConfigurationPropertyOverrides["ServerConfiguration.MaxSessionCount"] = 2

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Define a data variable providing random integers.
$random = New-Object System.Random
$server.Add(([UADataVariableExtension]::ReadValueFunction((New-Object UADataVariable("MyDataVariable")), [RunspacedDelegateFactory]::NewRunspacedDelegate([System.Func[int]] { $random.Next() }) )))

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