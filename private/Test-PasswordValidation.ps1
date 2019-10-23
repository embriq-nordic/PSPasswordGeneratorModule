function Test-PasswordValidation {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $InputString,

        [Parameter(Mandatory = $true, Position = 1)]
        [hashtable]
        $InputOptions
    )
    
    begin {
        If ($InputOptions.Count -eq 0) {
            Throw "Can't validate password without options"
        }

        $IsValid = $true
    }
    
    process {
        
        If ($InputOptions.Uppercase -and -not($InputString -cmatch "[A-Z]")) {
            $IsValid = $false
        }

        If ($InputOptions.Lowercase -and -not($InputString -cmatch "[a-z]")) {
            $IsValid = $false
        }

        If ($InputOptions.Digits -and -not($InputString -cmatch "[0-9]")) {
            $IsValid = $false
        }

        If ($InputOptions.Symbols -and -not($InputString -cmatch "[!@#|_\-*]")) {
            $IsValid = $false
        }
    }
    
    end {
        return $IsValid
    }
}