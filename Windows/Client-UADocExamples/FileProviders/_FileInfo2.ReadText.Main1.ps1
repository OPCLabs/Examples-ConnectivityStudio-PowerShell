# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# Shows how to open a file stream for reading, and read its content using a text reader object, using OPC UA file provider
# model.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace System.IO
using namespace OpcLabs.BaseLib.Extensions.FileProviders
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.FileTransfer

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

# Unified Automation .NET based demo server (UaNETServer/UaServerNET.exe)
[UAEndpointDescriptor]$endpointDescriptor = "opc.tcp://localhost:48030"

# A node that represents an instance of OPC UA FileType object.
[UANodeDescriptor]$fileNodeDescriptor = "nsu=http://www.unifiedautomation.com/DemoServer/ ;s=Demo.Files.TextFile"

# Instantiate the file transfer client object.
$fileTransferClient = New-Object EasyUAFileTransferClient

Write-Host "Getting file info..."
[IFileInfo2]$fileInfo2 = [IEasyUAFileTransferExtension]::GetFileInfo2($fileTransferClient, 
    $endpointDescriptor, $fileNodeDescriptor)
# From this point onwards, the code is independent of the concrete realization of the file provider, and would
# be identical e.g. for files in the physical file system, if the corresponding file provider was used.

try {
    # Get a stream reader object that corresponds to an OPC UA file.
    Write-Host "Opening the file for reading..."

    # We know that the file contains text, so we read it using a stream reader. If the file content was
    # binary, you would process the stream according to the data format.
    try {
        [StreamReader]$streamReader = [IFileInfoExtension]::CreateStreamReader($fileInfo2)

        # Read in the text from the file and display it line by line.
        Write-Host 
        Write-Host "Reading text lines:"

        $i = 0
        while (-not $streamReader.EndOfStream) {
            $line = $streamReader.ReadLine()
            Write-Host "[$($i)] $($line)"
            $i++
        }
    }
    finally {
        if ($streamReader -ne $null) {
            $streamReader.Dispose()
        }
    }
}
# Methods in the file provider model throw IOException and other exceptions, but not UAException.
catch [Exception] {
    Write-Host "*** Failure: $($PSItem.Exception.GetBaseException().Message)"
    return
}

Write-Host 
Write-Host "Finished."

#endregion Example
