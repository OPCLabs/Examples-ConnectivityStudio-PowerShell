# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to specify host name(s) for the server. This is useful when the server is running on a 
# computer that has multiple host names, and you want to make the server accessible under them.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.Application
using namespace OpcLabs.EasyOpc.UA.Application.Extensions
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.EasyOpc.UA.OperationModel
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAPrimitives.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUACore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

# Obtain the application interface.
$application = [EasyUAApplication]::Instance

# Remove the own application certificate pack. This assures that, when needed, the server will create a new one
# with the parameters we want and specify.
try {
    Write-Host "Removing the own application certificate pack..."
    $application.RemoveOwnCertificatePack()
    Write-Host "The application certificate pack has been removed."
}
catch {
    Write-Host "*** Failure: {0}" -f $_.$Exception.GetBaseException().Message
}

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Specify a host name for the server (and its application certificate).
$server.HostNames.Add("mycomputer.mycompany.example")

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
