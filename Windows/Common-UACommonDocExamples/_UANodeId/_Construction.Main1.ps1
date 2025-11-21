# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows different ways of constructing OPC UA node IDs.
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.




#requires -Version 5.1
using namespace OpcLabs.BaseLib
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.AddressSpace
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Parsing
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Parsing.Extensions
using namespace OpcLabs.EasyOpc.UA.AddressSpace.Standard
using namespace OpcLabs.EasyOpc.UA.OperationModel

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUA.dll"
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.EasyOpcUAComponents.dll"

# A node ID specifies a namespace (either by an URI or by an index), and an identifier.
# The identifier can be numeric (an integer), string, GUID, or opaque.


# A node ID can be specified in string form (so-called expanded text).
# The code below specifies a namespace URI (nsu=...), and an integer identifier (i=...).
$nodeId1 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;i=10853")
Write-Host ([UANodeId]::op_Implicit($nodeId1))


# Similarly, with a string identifier (s=...).
$nodeId2 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;s=someIdentifier")
Write-Host ([UANodeId]::op_Implicit($nodeId2))


# Actually, "s=" can be omitted (not recommended, though).
$nodeId3 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;someIdentifier")
Write-Host ([UANodeId]::op_Implicit($nodeId3))
# Notice that the output is normalized - the "s=" is added again.


# Similarly, with a GUID identifier (g=...).
$nodeId4 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;g=BAEAF004-1E43-4A06-9EF0-E52010D5CD10")
Write-Host ([UANodeId]::op_Implicit($nodeId4))
# Notice that the output is normalized - uppercase letters in the GUI are converted to lowercase, etc.


# Similarly, with an opaque identifier (b=..., in Base64 encoding).
$nodeId5 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;b=AP8=")
Write-Host ([UANodeId]::op_Implicit($nodeId5))


# Namespace index can be used instead of namespace URI. The server is allowed to change the namespace 
# indices between sessions (except for namespace 0), and for this reason, you should avoid the use of
# namespace indices, and rather use the namespace URIs whenever possible.
$nodeId6 = New-Object UANodeId("ns=2;i=10853")
Write-Host ([UANodeId]::op_Implicit($nodeId6))


# Namespace index can be also specified together with namespace URI. This is still safe, but may be 
# a bit quicker to perform, because the client can just verify the namespace URI instead of looking 
# it up.
$nodeId7 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;ns=2;i=10853")
Write-Host ([UANodeId]::op_Implicit($nodeId7))


# When neither namespace URI nor namespace index are given, the node ID is assumed to be in namespace
# with index 0 and URI "http://opcfoundation.org/UA/", which is reserved by OPC UA standard. There are 
# many standard nodes that live in this reserved namespace, but no nodes specific to your servers will 
# be in the reserved namespace, and hence the need to specify the namespace with server-specific nodes.
$nodeId8 = New-Object UANodeId("i=2254")
Write-Host ([UANodeId]::op_Implicit($nodeId8))


# If you attempt to pass in a string that does not conform to the syntax rules, 
# a UANodeIdFormatException is thrown.
try {
    $nodeId9 = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;i=notAnInteger")
    Write-Host ([UANodeId]::op_Implicit($nodeId9))
}
catch [UANodeIdFormatException] {
    Write-Host "*** Failure: $($_.Exception.Message)"
}


# There is a parser object that can be used to parse the expanded texts of node IDs. 
$nodeIdParser10 = New-Object UANodeIdParser
$nodeId10 = [IUANodeIdParserExtension]::Parse($nodeIdParser10, "nsu=http://test.org/UA/Data/ ;i=10853")
Write-Host ([UANodeId]::op_Implicit($nodeId10))


# The parser can be used if you want to parse the expanded text of the node ID but do not want 
# exceptions be thrown.
$nodeIdParser11 = New-Object UANodeIdParser
$nodeId11 = $null
[IStringParsingError] $stringParsingError =
    [IUANodeIdParserExtension]::TryParse($nodeIdParser11, "nsu=http://test.org/UA/Data/ ;i=notAnInteger", [ref] $nodeId11)
if ($stringParsingError -eq $null) {
    Write-Host ([UANodeId]::op_Implicit($nodeId11))
}
else {
    Write-Host "*** Failure: $($stringParsingError.Message)"
}


# You can also use the parser if you have node IDs where you want the default namespace be different 
# from the standard "http://opcfoundation.org/UA/".
$nodeIdParser12 = New-Object UANodeIdParser("http://test.org/UA/Data/")
$nodeId12 = [IUANodeIdParserExtension]::Parse($nodeIdParser12, "i=10853")
Write-Host ([UANodeId]::op_Implicit($nodeId12))


# The namespace URI string (or the namespace index, or both) and the identifier can be passed to the
# constructor separately.
$nodeId13 = New-Object UANodeId("http://test.org/UA/Data/", 10853)
Write-Host ([UANodeId]::op_Implicit($nodeId13))


# You can create a "null" node ID. Such node ID does not actually identify any valid node in OPC UA, but 
# is useful as a placeholder or as a starting point for further modifications of its properties.
$nodeId14 = New-Object UANodeId
Write-Host ([UANodeId]::op_Implicit($nodeId14))


# Properties of a node ID can be modified individually. The advantage of this approach is that you do 
# not have to care about syntax of the node ID expanded text.
$nodeId15 = New-Object UANodeId
$nodeId15.NamespaceUriString = "http://test.org/UA/Data/"
$nodeId15.Identifier = 10853
Write-Host ([UANodeId]::op_Implicit($nodeId15))


# The same as above, but using an object initializer list.
$nodeId16 = New-Object UANodeId @{
    NamespaceUriString = "http://test.org/UA/Data/"
    Identifier = 10853
}
Write-Host ([UANodeId]::op_Implicit($nodeId16))


# If you know the type of the identifier upfront, it is safer to use typed properties that correspond 
# to specific types of identifier. Here, with an integer identifier.
$nodeId17 = New-Object UANodeId
$nodeId17.NamespaceUriString = "http://test.org/UA/Data/"
$nodeId17.NumericIdentifier = 10853
Write-Host ([UANodeId]::op_Implicit($nodeId17))


# Similarly, with a string identifier.
$nodeId18 = New-Object UANodeId
$nodeId18.NamespaceUriString = "http://test.org/UA/Data/"
$nodeId18.StringIdentifier = "someIdentifier"
Write-Host ([UANodeId]::op_Implicit($nodeId18))


# Similarly, with a GUID identifier.
$nodeId19 = New-Object UANodeId
$nodeId19.NamespaceUriString = "http://test.org/UA/Data/"
$nodeId19.GuidIdentifier = [Guid]::Parse("BAEAF004-1E43-4A06-9EF0-E52010D5CD10")
Write-Host ([UANodeId]::op_Implicit($nodeId19))


# If you have GUID in its string form, the node ID object can parse it for you.
$nodeId20 = New-Object UANodeId
$nodeId20.NamespaceUriString = "http://test.org/UA/Data/"
$nodeId20.GuidIdentifierString = "BAEAF004-1E43-4A06-9EF0-E52010D5CD10"
Write-Host ([UANodeId]::op_Implicit($nodeId20))


# And, with an opaque identifier.
$nodeId21 = New-Object UANodeId
$nodeId21.NamespaceUriString = "http://test.org/UA/Data/"
$nodeId21.OpaqueIdentifier = @(0x00, 0xFF)
Write-Host ([UANodeId]::op_Implicit($nodeId21))


# Assigning an expanded text to a node ID parses the value being assigned and sets all corresponding
# properties accordingly.
$nodeId22 = New-Object UANodeId
$nodeId22.ExpandedText = "nsu=http://test.org/UA/Data/ ;i=10853"
Write-Host ([UANodeId]::op_Implicit($nodeId22))


# There is an implicit conversion from a string (representing the expanded text) to a node ID.
# You can therefore use the expanded text (string) in place of any node ID object directly.
$nodeId23 = "nsu=http://test.org/UA/Data/ ;i=10853"
Write-Host ([UANodeId]::op_Implicit($nodeId23))


# There is a copy constructor as well, creating a clone of an existing node ID.
$nodeId24a = New-Object UANodeId("nsu=http://test.org/UA/Data/ ;i=10853")
Write-Host ([UANodeId]::op_Implicit($nodeId24a))
$nodeId24b = New-Object UANodeId($nodeId24a)
Write-Host ([UANodeId]::op_Implicit($nodeId24b))


# We have provided static classes with properties that correspond to all standard nodes specified by 
# OPC UA. You can simply refer to these node IDs in your code.
# The class names are UADataTypeIds, UAMethodIds, UAObjectIds, UAObjectTypeIds, UAReferenceTypeIds, 
# UAVariableIds and UAVariableTypeIds.
$nodeId25 = [UAObjectIds]::TypesFolder;
Write-Host ([UANodeId]::op_Implicit($nodeId25))
# When the UANodeId equals to one of the standard nodes, it is output in the shortened form - as the standard
# name only.


# You can also refer to any standard node using its name (in a string form).
# Note that assigning a non-existing standard name is not allowed, and throws ArgumentException.
$nodeId26 = New-Object UANodeId
$nodeId26.StandardName = "TypesFolder"
Write-Host ([UANodeId]::op_Implicit($nodeId26))


# When you browse for nodes in the OPC UA server, every returned node element contains a node ID that
# you can use further.
$client27 = New-Object EasyUAClient
try {
    $nodeElementCollection27 = [IEasyUAClientExtension]::Browse($client27,
        "opc.tcp://opcua.demo-this.com:51210/UA/SampleServer",
        [UAObjectIds]::Server,
        (New-Object UABrowseParameters([UANodeClass]::All, [UANodeId[]] @( [UAReferenceTypeIds]::References ))))
    if ($nodeElementCollection27.Count -ne 0) {
        $nodeId27 = $nodeElementCollection27[0].NodeId
        Write-Host ([UANodeId]::op_Implicit($nodeId27))
    }
}
catch [UAException] {
    Write-Host ("Failure: {0}" -f  $_.Exception.GetBaseException().Message)
}


# As above, but using a constructor that takes a node element as an input.
$client28 = New-Object EasyUAClient
try {
    $nodeElementCollection28 = [IEasyUAClientExtension]::Browse($client28,
        "opc.tcp://opcua.demo-this.com:51210/UA/SampleServer",
        [UAObjectIds]::Server,
        (New-Object UABrowseParameters([UANodeClass]::All, [UANodeId[]] @( [UAReferenceTypeIds]::References ))))
    if ($nodeElementCollection28.Count -ne 0) {
        $nodeId28 = New-Object UANodeId($nodeElementCollection28[0]);
        Write-Host ([UANodeId]::op_Implicit($nodeId28))
    }
}
catch [UAException] {
    Write-Host ("Failure: {0}" -f  $_.Exception.GetBaseException().Message)
}


# Or, there is an explicit conversion from a node descriptor as well.
$client29 = New-Object EasyUAClient
try {
    $nodeElementCollection29 = [IEasyUAClientExtension]::Browse($client29,
        "opc.tcp://opcua.demo-this.com:51210/UA/SampleServer",
        [UAObjectIds]::Server,
        (New-Object UABrowseParameters([UANodeClass]::All, [UANodeId[]] @( [UAReferenceTypeIds]::References ))))
    if ($nodeElementCollection29.Count -ne 0) {
        $nodeId29 = [UaNodeId]$nodeElementCollection29[0]
        Write-Host ([UANodeId]::op_Implicit($nodeId29))
    }
}
catch [UAException] {
    Write-Host ("Failure: {0}" -f  $_.Exception.GetBaseException().Message)
}
#endregion Example
