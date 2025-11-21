# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows how the OPC UA status codes are formatted to a string containing their symbolic name.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-ConnectivityStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"

$internalValueArray = [long[]] @( 0, "0x80010000", 2147614720, "0x80340000" )

Foreach ($internalValue in $internalValueArray) {
    Write-Host "$($internalValue): $(New-Object UAStatusCode($internalValue))"
}

# Example output:
#0: Good
#2147549184: BadUnexpectedError
#2147614720: BadInternalError
#2150891520: BadNodeIdUnknown

#endregion Example
