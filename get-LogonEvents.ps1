<#
.SYNOPSIS
 Kurzbeschreibung des Skriptes, Abfrage von Logon Events
.DESCRIPTION 
 LAnge Beschreibung der Aufgaben des Skriptes
.PARAMETER EventId
 Definiert welches Event Abgefragt wird. Folgende Eventid sind möglich:
 4624 Anmeldung
 4625 fehlgeschlagene Anmeldung
 4634 Abmeldung
.EXAMPLE
get-LogonEvents.ps1 -EventId 4624


   ProviderName: Microsoft-Windows-Security-Auditing

TimeCreated                     Id LevelDisplayName Message
-----------                     -- ---------------- -------
16.11.2026 13:14:24           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:31           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:31           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:31           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:28           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....

.EXAMPLE
get-LogonEvents.ps1 -EventId 4624 -Verbose
AUSFÜHRLICH: Write-verbose ermöglicht Optionale, Ausführlichere Ausgaben


   ProviderName: Microsoft-Windows-Security-Auditing

TimeCreated                     Id LevelDisplayName Message
-----------                     -- ---------------- -------
16.11.2026 13:14:24           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:31           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:31           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:31           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
16.11.2026 13:13:28           4624 Informationen    Ein Konto wurde erfolgreich angemeldet....
.LINK
https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_comment_based_help?view=powershell-5.1
#>
[cmdletBinding()]
param(
[Parameter(Mandatory=$true)]
[ValidateSet(4624,4625,4634)]
[int]$EventId = 4624,

[ValidateRange(5,10)]
[int]$Newest = 5,

[string]$Computername = "localhost"
)
Write-Debug -Message "Debughaltepunkte: Vor Abfrage."
Write-Verbose -Message "Write-verbose ermöglicht Optionale, Ausführlichere Ausgaben"
Get-WinEvent -LogName Security -ComputerName $Computername | Where-Object Id -eq $EventId | Select-Object -First $Newest