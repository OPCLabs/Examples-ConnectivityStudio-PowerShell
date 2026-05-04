# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# Attempts to parse a relative OPC-UA browse path and displays its elements.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-QuickOPC-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://forum.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.BaseLib
using namespace OpcLabs.EasyOpc.UA.Navigation
using namespace OpcLabs.EasyOpc.UA.Navigation.Parsing;

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAPrimitives.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUACore.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"

$browsePathElements = New-Object UABrowsePathElementCollection

$browsePathParser = New-Object UABrowsePathParser
[IStringParsingError] $stringParsingError = $browsePathParser.TryParseRelative("/Data.Dynamic.Scalar.CycleComplete", $browsePathElements)

# Display results
if ($stringParsinError -ne $null) {
    Write-Host ("*** Error: {0}" -f $stringParsinError)
    return
}

foreach ($browsePathElement in $browsePathElements) {
    Write-Host $browsePathElement
}

# Example output:
# /Data
# .Dynamic
# .Scalar
# .CycleComplete
#endregion Example
