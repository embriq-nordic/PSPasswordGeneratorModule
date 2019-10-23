function New-Keyspace {
    [CmdletBinding()]
    param (
        [Parameter()]
        [hashtable]
        $Options
    )
    
    begin {
        If ($Options.Count -eq 0) {
            Throw "Can't generate keyspace without any options specified."
        }

        $Keyspace = ""
    }
    
    process {
        If ($Options.Uppercase) {
            $Keyspace += "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        }

        If ($Options.Lowercase) {
            $Keyspace += "abcdefghijklmnopqrstuvwxyz"
        }

        If ($Options.Digits) {
            $Keyspace += "0123456789"
        }

        If ($Options.Symbols) {
            $Keyspace += "!@#|_-*"
        }
    }
    
    end {
        return ($Keyspace -split "" | Sort-Object {Get-Random}) -join ""
    }
}