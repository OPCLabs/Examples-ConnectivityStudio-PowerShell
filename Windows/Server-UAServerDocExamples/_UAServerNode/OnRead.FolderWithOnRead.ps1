# $Header: $
# Copyright (c) CODE Consulting and Development, s.r.o., Plzen. All rights reserved.

#region Example
# This file is dot-sourced by OnRead.Main1.ps1.

# A folder in the OPC UA address space, with specialized read behavior.
class FolderWithOnRead : UAFolder {
    hidden static [Random] $Random

    static FolderWithOnRead() {
        [FolderWithOnRead]::Random = New-Object Random
    }

    FolderWithOnRead([string] $name) : base($name) {
    }

    # Obtains the data for OPC UA read.
    OnRead([UADataVariableReadEventArgs] $e) {
        # Obtain the state associated with the data variable that is being read.
        # Use it as the offset for the random value, so that each data variable generates values in a unique range.
        $offset = [int]$e.DataVariable.State*100
	# Generate a random value, indicate that the read has been handled, and return the generated value.
        $e.HandleAndReturn([FolderWithOnRead]::Random.Next($offset, $offset + 100))
    }
}
#endregion Example
