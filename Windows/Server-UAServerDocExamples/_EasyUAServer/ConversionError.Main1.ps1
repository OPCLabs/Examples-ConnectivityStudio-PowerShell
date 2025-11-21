# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to handle conversion errors on the server level.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.EasyOpc.UA.OperationModel
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

[UADataVariableConversionErrorEventHandler]$ServerOnConversionError = {
    param($sender, $e)
    Write-Host
    Write-Host "*** $e"

    # Following are some useful properties in the event notification:
    #   e.DataVariable
    #   e.Action
    #   e.ServiceResult

    switch ($e.Action) {
        { $_ -eq [UADataVariableConversionAction]::Read } {
            Write-Host "The conversion error occurred during a Read operation."
        }
        { $_ -eq [UADataVariableConversionAction]::Write } {
        Write-Host "The conversion error occurred during a Write operation."
        }
        { $_ -eq [UADataVariableConversionAction]::Update } {
        Write-Host "The conversion error occurred during an Update operation."
        }
    }

    Write-Host "It occured on the data variable: $($e.DataVariable)."
    Write-Host "The service result was: $($e.ServiceResult.Message)"
}

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Define a data variable of type Byte.
$dataVariable = [UADataVariableExtension]::ValueType([UADataVariable]::CreateIn($server.Objects, "MyDataVariable"), [byte])

# Add a Read handler that returns random values between 0 and 511. Those greater than 255 will cause conversion
# errors.
$random = New-Object System.Random

$dataVariable.add_Read([RunspacedDelegateFactory]::NewRunspacedDelegate([UADataVariableReadEventHandler]{ param ($sender, $e) $e.HandleAndReturn($random.Next(0, 512)) }))

# Hook events to the server.
# Note that the conversion error event can also be handled on the data variable or folder level, if that's what
# you requirements call for.
$server.add_ConversionError([RunspacedDelegateFactory]::NewRunspacedDelegate($ServerOnConversionError))

# Start the server.
Write-Host "The server is starting..."
$server.Start()

Write-Host "The server is started."
Write-Host

# Let the user decide when to stop.
Write-Host "Press Enter to stop the server..."
while(![System.Console]::KeyAvailable) { Start-Sleep -Milliseconds 20 }
[void][System.Console]::ReadKey()

# Stop the server.
Write-Host "The server is stopping..."
$server.Stop()

Write-Host "The server is stopped."
#endregion Example
