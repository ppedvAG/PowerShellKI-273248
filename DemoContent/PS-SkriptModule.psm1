function New-SecretMessage
{
[cmdletBinding()]
param(
    [ValidateScript({Test-Path -Path $PSItem -PAthtype Container})]
    [Parameter(MAndatory=$true)]
    [string]$Path,

    [Parameter(Mandatory=$true)]
    [Validatelength(5,200)]
    [string]$Message
 )   

 Get-ChildItem -Path $Path -Recurse -File | Get-Random | Set-Content -Value $Message

}