<#
.SYNOPSIS
    A simple password generator
.DESCRIPTION
    This is a cmdlet for generating either random strings or word-based password. Currently it only supports norwegian words.
.PARAMETER Type
    The type of password to generate (Word || String)
.PARAMETER Uppercase
    If type is 'String', include UPPERCASE letters
.PARAMETER Lowercase
    If type is 'String', include lowercase letters
.PARAMETER Digits
    If type is 'String', include digits
.PARAMETER Symbols
    If type is 'String', include symbols
.PARAMETER Prefix
    Adds 4 digits to the start of password
.PARAMETER Suffix
    Adds 4 digits to the end of password
.PARAMETER Length
    If this is 'String', sets the length of password
.PARAMETER Count
    Sets how many passwords to generate
.PARAMETER Delimiter
    If type is 'Word', set the delimiter between words
.PARAMETER NumberOfWords
    If type is 'Word', sets how many words to include in password
.EXAMPLE
    PS> New-Password -Word -NumberOfWords 3 -Suffix
    Sliper-Dryste-Skoften-5957
.EXAMPLE
    PS> New-Password -NumberOfWords 3 -Suffix
    Sliper-Dryste-Skoften-5957
.EXAMPLE
    PS> New-Password -String -Uppercase -Lowercase -Digits -Symbols -Length 32
    nijgiuzcXwCYProb_RhPtsNF3gxtYKNd
.EXAMPLE
    PS> New-Password -String -Uppercase -Lowercase -Length 16 -Count 3
    LMcalAHgLxUolZdf
    YrTwuUGxwNuucWzZ
    ArsUAFVwPHSuJqjZ
.OUTPUTS
    String
.LINK
    https://github.com/rejlersembriq/PSPasswordGeneratorModule
.NOTES
    General notes

#>
function New-Password {
    [CmdletBinding(DefaultParameterSetName="Word")]
    Param (
        # Parameter help description
        [Parameter(ParameterSetName="Word")]
        [switch]
        $Word,

        [Parameter(ParameterSetName="String")]
        [switch]
        $String,

        [Parameter(ParameterSetName="String")]
        [switch]
        $Uppercase,

        [Parameter(ParameterSetName="String")]
        [switch]
        $Lowercase,

        [Parameter(ParameterSetName="String")]
        [switch]
        $Digits,

        [Parameter(ParameterSetName="String")]
        [switch]
        $Symbols,
        
        [Parameter(ParameterSetName="String")]
        [int]
        $Length = 12,

        [switch]
        $Prefix,

        [switch]
        $Suffix,

        [int]
        $Count = 1,

        [Parameter(ParameterSetName="Word")]
        [string]
        $Delimiter = '-',

        [Parameter(ParameterSetName="Word")]
        [int]
        $NumberOfWords = 2
    )
    
    begin {
        If ($PSCmdlet.ParameterSetName -eq "Word") {
            $Wordlist = Get-Content -Encoding UTF8 -Path (Join-Path $PSScriptRoot "..\data\wordlist.txt")
        } Else {
            If (-not ($Uppercase -or $Lowercase -or $Digits -or $Symbols)) {
                Throw "When type is 'String' one of the following must be specified: Uppercase, Lowercase, Digits, Symbols"
            }
        }

        $Passwords = @()
    }
    
    process {
        If ($PSCmdlet.ParameterSetName -eq "String") {

            $KeyspaceOptions = @{
                Uppercase = $false
                Lowercase = $false
                Digits = $false
                Symbols = $false
            }

            If ($Uppercase) {
                $KeyspaceOptions.Uppercase = $true
            }

            If ($Lowercase) {
                $KeyspaceOptions.Lowercase = $true
            }

            If ($Digits) {
                $KeyspaceOptions.Digits = $true
            }

            If ($Symbols) {
                $KeyspaceOptions.Symbols = $true
            }

            Foreach ($i in 1..$Count) {
                $Keyspace = Get-Keyspace $KeyspaceOptions
                $Password = @()
    
                If ($Prefix) {
                    $Password += (Get-Random -Minimum 1111 -Maximum 9999).ToString()
                }
    
                do {
                    $temp = ""
                    Foreach ($j in 1..$Length) {
                        $temp += $Keyspace[(Get-Random -Maximum ($Keyspace.Length - 1))]
                    }
                } while (-not(Test-PasswordValidation $temp $KeyspaceOptions))
                
                $Password += $temp
    
                If ($Suffix) {
                    $Password += (Get-Random -Minimum 1111 -Maximum 9999).ToString()
                }
    
                $Passwords += $Password
            }

        } Else {
            Foreach ($i in 1..$Count) {
                $Password = @()

                If ($Prefix) {
                    $Password += (Get-Random -Minimum 1111 -Maximum 9999).ToString()
                }

                Foreach ($j in 1..$NumberOfWords) {
                    $temp = $Wordlist[(Get-Random -Maximum ($Wordlist.Count - 1))]
                    $Password += "{0}{1}" -f ($temp.Substring(0, 1).ToUpper(), $temp.Substring(1))
                }

                If ($Suffix) {
                    $Password += (Get-Random -Minimum 1111 -Maximum 9999).ToString()
                }

                $Passwords += $Password -join $Delimiter
            }
        }
    }
    
    end {
        $Passwords
    }
}