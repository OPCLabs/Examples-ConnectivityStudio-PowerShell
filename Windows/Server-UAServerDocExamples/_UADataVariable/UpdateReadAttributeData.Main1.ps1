# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to update the read value in the push data provision model. In this model, your code pushes the
# data into the server, and the server then makes the data available to OPC clients.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Create a read-only data variable.
$dataVariable = [UADataVariableExtension]::Writable([UADataVariableExtension]::ValueType([UADataVariable]::CreateIn($server.Objects, "ReadThisVariable"), [int]), $false)

# Create a timer for pushing the data for OPC reads. In a real server the activity may also come from other
# sources.
$timer = New-Object Timers.Timer -property @{
    Interval = 1000
    AutoReset = $true
}

# Set the read attribute data of the data variable to a random value whenever the timer interval elapses.
$random = New-Object System.Random
$timer.add_Elapsed([RunspacedDelegateFactory]::NewRunspacedDelegate([System.Timers.ElapsedEventHandler] { param ($sender, $e) $dataVariable.UpdateReadAttributeData($random.Next()) }))
$timer.Start()

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

# Stop the timer.
$timer.Stop()

Write-Host "The server is stopped."
#endregion Example
