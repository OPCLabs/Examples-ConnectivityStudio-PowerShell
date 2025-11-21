# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# Attempts to parse an absolute OPC-UA browse path and displays its starting node and elements.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client and subscriber examples in PowerShell on GitHub: https://github.com/OPCLabs/Examples-QuickOPC-PowerShell .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.BaseLib
using namespace OpcLabs.EasyOpc.UA.Navigation
using namespace OpcLabs.EasyOpc.UA.Navigation.Parsing;

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"

$browsePathParser = New-Object UABrowsePathParser
[UABrowsePath] $browsePath = $null
[IStringParsingError]$stringParsingError = $browsePathParser.TryParse("[ObjectsFolder]/Data/Static/UserScalar", [ref] $browsePath)

# Display results
if ($stringParsingError -ne $null) {
    Write-Host ("*** Error: {0}" -f $stringParsingError)
    return
}

Write-Host ("StartingNodeId: {0}" -f $browsePath.StartingNodeId)

foreach ($browsePathElement in $browsePath.Elements) {
    Write-Host $browsePathElement
}

# Example output:
# StartingNodeId: ObjectsFolder
# /Data
# /Static
# /UserScalar
#endregion Example
