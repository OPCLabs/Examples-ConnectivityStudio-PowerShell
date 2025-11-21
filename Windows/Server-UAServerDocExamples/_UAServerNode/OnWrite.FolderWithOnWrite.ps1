# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This file is dot-sourced by OnWrite.Main1.ps1.

# A folder in the OPC UA address space, with specialized write behavior.
class FolderWithOnWrite : UAFolder {

    FolderWithOnWrite([string] $name) : base($name) {
    }

    # Processes the supplied OPC UA write data.
    OnWrite([UADataVariableWriteEventArgs] $e) {
        # Obtain the state associated with the data variable that is being written, and display it on the console
        # together with the new value.
        Write-Host "Data variable $($e.DataVariable.State), value written: $($e.AttributeData.Value)"
    }
}
#endregion Example
