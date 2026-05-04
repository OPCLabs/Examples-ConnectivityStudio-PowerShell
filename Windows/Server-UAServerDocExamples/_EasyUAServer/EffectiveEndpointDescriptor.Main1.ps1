# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to obtain the effective endpoint descriptor of the server, and use it together with effective node
# descriptor of data variable to operate on the server using an OPC UA client object.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAPrimitives.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUACore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Define data variables providing random integers.
$random = New-Object System.Random
$myDataVariable1 = [UADataVariableExtension]::ReadValueFunction([UADataVariable]::CreateIn($server.Objects, "MyDataVariable1"), 
    [RunspacedDelegateFactory]::NewRunspacedDelegate([System.Func[int]] { $random.Next(0, 100) }) )
$myDataVariable2 = [UADataVariableExtension]::ReadValueFunction([UADataVariable]::CreateIn($server.Objects, "MyDataVariable2"), 
    [RunspacedDelegateFactory]::NewRunspacedDelegate([System.Func[int]] { $random.Next(100, 200) }) )

# Start the server.
Write-Host "The server is starting..."
$server.Start()

# Give the server some time to make its endpoints ready to accept client connections. For precise determination,
# you can use IEasyUAServerEndpointMonitoring.EndpointStateChanged event on the server object.
Start-Sleep -Milliseconds 1000

# Instantiate the client object.
$client = New-Object EasyUAClient

Write-Host "Subscribing to data changes..."

# Subscribe to data changes of our first data variable. Display the data changes on the console.
[void][IEasyUAClientExtension]::SubscribeDataChange($client, $server.EffectiveEndpointDescriptor, $myDataVariable1.EffectiveNodeDescriptor, 1000,
                [RunspacedDelegateFactory]::NewRunspacedDelegate([EasyUADataChangeNotificationEventHandler]{ param ($sender, $e) Write-Host "$e" }), 1)

# Subscribe to data changes of our second data variable. Display the data changes on the console.
# Passing the server object as the first argument makes an implicit conversion to the endpoint descriptor.
# Passing the data variable object as the second argument makes an implicit conversion to the node descriptor.
# We are doing an equivalent of the previous call, but in a more compact way.
[void][IEasyUAClientExtension]::SubscribeDataChange($client, $server.EffectiveEndpointDescriptor, $myDataVariable2.EffectiveNodeDescriptor, 1000,
                [RunspacedDelegateFactory]::NewRunspacedDelegate([EasyUADataChangeNotificationEventHandler]{ param($sender, $e) Write-Host "$e" }), 2)

# Let the user decide when to stop.
Write-Host "Press Enter to stop the server..."
Read-Host

Write-Host "Unsubscribing all items..."
$client.UnsubscribeAllMonitoredItems()

# Stop the server.
Write-Host "The server is stopping..."
$server.Stop()

Write-Host "The server is stopped."
#endregion Example
