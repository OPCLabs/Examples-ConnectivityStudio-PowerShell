# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to retrieve the attribute data in the pull data consumption model. In this model, the data that
# OPC clients write to the server is pulled and processed by your code when needed.
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

# Create a read-write data variable with an initial value.
$dataVariable = [UADataVariableExtension]::ReadWriteValue([UADataVariable]::CreateIn($server.Objects, "WriteToThisVariable"), 0)

# Create a timer for pulling the data from OPC writes. In a real server the activity may also come from other
# sources.
$timer = New-Object Timers.Timer -property @{
    Interval = 1000
    AutoReset = $true
}

# Periodically display the value of the data variable on the console.
$timer.add_Elapsed([RunspacedDelegateFactory]::NewRunspacedDelegate([System.Timers.ElapsedEventHandler] { param ($sender, $e) Write-Host "  $($dataVariable.WriteAttributeData.Value)" }))
$timer.Start()
Write-Host "Values of the example data variable are displayed on the console periodically."

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
