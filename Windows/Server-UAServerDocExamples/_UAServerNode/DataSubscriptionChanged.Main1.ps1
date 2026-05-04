# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how to implement own handling of data subscriptions.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace System.Threading
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
$random = New-Object System.Random
$dataVariable = [UADataVariableExtension]::Writable([UADataVariableExtension]::ValueType([UADataVariable]::CreateIn($server.Objects, "SubscribeToThisVariable"), [int]), $false)

$dataVariable.UseDataPolling = $false;    # Recommended, but not strictly necessary.

$DataSubscriptionChanged = {
    param ($sender, $e)
    switch ($e.Action) {
        { $_ -eq [UADataSubscriptionChangedAction]::Add } { 
            # Obtain the sampling interval from the data subscription.
            $samplingInterval = $e.DataSubscription.SamplingInterval
            Write-Host "Data subscription added, sampling interval: $samplingInterval"

            # Create a timer that will provide the data variable with a new data. In a real server the activity
            # may also come from other sources.
            $timer = New-Object Timers.Timer -property @{ 
                AutoReset = $true
                Interval = $samplingInterval
            }
            $e.DataSubscription.State = $timer

            # Set the read attribute data of the data variable to a random value whenever the timer interval elapses.
            Register-ObjectEvent -InputObject $timer -EventName Elapsed -Action { 
                $Event.MessageData.DataSubscription.OnNext($random.Next()) 
            } -MessageData $e

            # Start the subscription timer.
            $timer.Start()
        }

        { $_ -eq [UADataSubscriptionChangedAction]::Remove } {
            Write-Host "Data subscription removed"

            # Dispose of the subscription timer (stopping it too).
            $timer = [Timers.Timer]$e.DataSubscription.State
            $timer.Dispose()
        }

        { $_ -eq [UADataSubscriptionChangedAction]::Modify } {
            $samplingInterval = $e.DataSubscription.SamplingInterval
            Write-Host "Data subscription modified, sampling interval: $samplingInterval"

            # Change the interval of the subscription timer.
            $timer = [Timers.Timer]$e.DataSubscription.State
            $timer.Interval = $samplingInterval
        }
    }
    $e.Handled = $true    # Do not forget to indicate that your code has handled the event.
}

$dataVariable.add_DataSubscriptionChanged([RunspacedDelegateFactory]::NewRunspacedDelegate([UADataSubscriptionChangedEventHandler]$DataSubscriptionChanged))

# The read behavior of the data variable needs to be defined as well, separately from the data subscriptions.
[UADataVariableExtension]::ReadValueFunction($dataVariable, [RunspacedDelegateFactory]::NewRunspacedDelegate([System.Func[int]] { $random.Next() }))

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