# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to indicate that the write operation completes asynchronously. This is an example of the push
# data consumption model.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace System.Threading
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.Generic
using namespace OpcLabs.EasyOpc.UA.NodeSpace
using namespace OpcLabs.PowerShellManagement

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.PowerShellManagement.dll"

# Instantiate the server object.
# By default, the server will run on endpoint URL "opc.tcp://localhost:48040/".
$server = New-Object EasyUAServer

# Create a writable data variable and add a function that will be called when the data variable is written to.
# The function returns a status code that indicates the outcome of the Write operation. Since we do not know the
# true outcome of the write operation at the time of the function call, we return status code
# "GoodCompletesAsynchronously".
$server.Add([UADataVariableExtension]::WriteFunction((New-Object UADataVariable("WriteToThisVariable")), 
    [RunspacedDelegateFactory]::NewRunspacedDelegate([System.Func[UAAttributeData[int], UAStatusCode]]{ 
        param($data)
        # The actual write operation is performed asynchronously, on a separate thread.
        $timer = New-Object Timers.Timer -property @{ 
                AutoReset = $false
                Interval = 10
        }
        Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action { 
            Write-Host "Attribute data written: $($Event.MessageData)"
        } -MessageData $data
        $timer.Start()
        return [UACodeBits]::GoodCompletesAsynchronously
    })))

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
