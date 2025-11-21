# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This example shows different ways of constructing the EasyUAServer object.
# You can use any OPC UA client, including our Connectivity Explorer and OpcCmd utility, to connect to the server. 
#
# Find all latest examples here: https://opclabs.doc-that.com/files/onlinedocs/OPCLabs-OpcStudio/Latest/examples.html .
# OPC client, server and subscriber examples in C# on GitHub: https://github.com/OPCLabs/Examples-ConnectivityStudio-CSharp .
# Missing some example? Ask us for it on our Online Forums, https://www.opclabs.com/forum/index ! You do not have to own
# a commercial license in order to use Online Forums, and we reply to every post.

#requires -Version 5.1
using namespace OpcLabs.EasyOpc.UA
using namespace OpcLabs.EasyOpc.UA.Engine
using namespace OpcLabs.EasyOpc.UA.NodeSpace

# The path below assumes that the current directory is [ProductDir]/Examples-NET/PowerShell/Windows .
Add-Type -Path "../../../Components/Opclabs.QuickOpc/net472/OpcLabs.ServerOpcUAComponents.dll"

# The toolkit provides a ready-made shared instance of the server object which you can use without even having
# to construct it. Not recommended for use in library code, because it is a shared instance, and its usage may
# therefore conflict with other code using the same instance.
$server0 = [OpcLabs.EasyOpc.UA.EasyUAServer]::SharedInstance


# The simplest way to construct the server object is to use the default constructor. The server will run on its
# default endpoint URL "opc.tcp://localhost:48040/".
$server1 = New-Object EasyUAServer


# The server object can be constructed with a specific single endpoint URL string passed as an argument to the
# constructor.
$server2 = New-Object EasyUAServer("opc.tcp://localhost:38444")


# The server object can also be constructed with multiple endpoint URL strings passed as an array to the
# constructor.
$server3 = New-Object EasyUAServer(@(
	"opc.tcp://localhost:38444", "opc.tcp://localhost:38445", "opc.tcp://localhost:38446"
))


# If the language supports variable number of arguments (such as C# or VB.NET), the multiple endpoint URL
# strings can be passed to it as separate arguments, instead of having to create an array of them.
$server4 = New-Object EasyUAServer(
	"opc.tcp://localhost:38444", "opc.tcp://localhost:38445", "opc.tcp://localhost:38446")


# The server object can be constructed with specific message security modes.
$server5 = New-Object EasyUAServer([UAMessageSecurityModes]::Secure)


# The message security modes can be combined with the endpoint URL string.
$server6 = New-Object EasyUAServer([UAMessageSecurityModes]::Secure, "opc.tcp://localhost:38444")


# The message security modes can also be combined with multiple endpoint URL strings in an array.
$server7 = New-Object EasyUAServer([UAMessageSecurityModes]::Secure,
    [string[]]@(
        "opc.tcp://localhost:38444", "opc.tcp://localhost:38445", "opc.tcp://localhost:38446"
    ))


# If the language supports variable number of arguments (such as C# or VB.NET), the message security modes can
# be combined with multiple endpoint URL strings passed to it as separate arguments, instead of having to create
# an array of them.
$server8 = New-Object EasyUAServer([UAMessageSecurityModes]::Secure,
        "opc.tcp://localhost:38444", "opc.tcp://localhost:38445", "opc.tcp://localhost:38446")


# The endpoint can be specified using the Uri object.
$server9 = New-Object EasyUAServer(New-Object Uri("opc.tcp://localhost:38444"))


# The server object can also be constructed with multiple Uri objects for server endpoints, passed as an array
# to the constructor.
$server10 = New-Object EasyUAServer(@(
    (New-Object Uri("opc.tcp://localhost:38444")), 
    (New-Object Uri("opc.tcp://localhost:38445")), 
    (New-Object Uri("opc.tcp://localhost:38446"))
))


# If the language supports variable number of arguments (such as C# or VB.NET), the multiple endpoint Uri
# objects can be passed to it as separate arguments, instead of having to create an array of them.
$server11 = New-Object EasyUAServer(
    (New-Object Uri("opc.tcp://localhost:38444")), 
    (New-Object Uri("opc.tcp://localhost:38445")), 
    (New-Object Uri("opc.tcp://localhost:38446"))
)


# The message security modes can be combined with the endpoint Uri object.
$server12 = New-Object EasyUAServer([UAMessageSecurityModes]::Secure, (New-Object Uri("opc.tcp://localhost:38444")))


# The message security modes can also be combined with multiple endpoint Uri objects in an array.
$server13 = New-Object EasyUAServer([UAMessageSecurityModes]::Secure, [Uri[]]@(
    (New-Object Uri("opc.tcp://localhost:38444")), 
    (New-Object Uri("opc.tcp://localhost:38445")), 
    (New-Object Uri("opc.tcp://localhost:38446"))
))


# If the language supports variable number of arguments (such as C# or VB.NET), the message security modes can
# be combined with multiple endpoint Uri objects passed to it as separate arguments, instead of having to create
# an array of them.
$server14 = New-Object EasyUAServer(
    [UAMessageSecurityModes]::Secure,
    (New-Object Uri("opc.tcp://localhost:38444")), 
    (New-Object Uri("opc.tcp://localhost:38445")), 
    (New-Object Uri("opc.tcp://localhost:38446"))
)


# The message security modes and the endpoint URL string can be set after the server object is constructed.
$server15 = New-Object EasyUAServer
$server15.MessageSecurityModes = [UAMessageSecurityModes]::Secure
$server15.EndpointUrlString = "opc.tcp://localhost:38444"


# If the language supports property initializers (such as C# or VB.NET), the above code can be written more
# concisely.
$server16 = New-Object EasyUAServer -Property @{
    MessageSecurityModes = [UAMessageSecurityModes]::Secure
    EndpointUrlString = "opc.tcp://localhost:38444"
}


# If the language supports collection initializers (such as C# or VB.NET), the server object can be constructed
# with the contents of the Objects folder, such as the data variables, in a single statement.
# *** not implemented in PowerShell ***
#endregion Example
