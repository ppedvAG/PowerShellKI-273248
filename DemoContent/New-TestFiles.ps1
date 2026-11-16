<#
.SYNOPSIS
    Erstellt einen Testordner mit Dateien und Unterordnern.

.DESCRIPTION
    Erstellt unter Path einen Ordner mit Name. Im neuen Ordner werden
    FileCount Dateien und DirCount Unterordner angelegt. In jedem Unterordner
    wird ebenfalls versucht, FileCount Dateien anzulegen.

    Hinweis für Teilnehmende: Die innere Dateischleife erhöht derzeit $i
    statt $j. Dadurch wird der Dateiname nicht weitergezählt und die Schleife
    verändert außerdem den Zähler der äußeren Unterordnerschleife. Die
    tatsächlichen Ergebnisse können deshalb von der Beschreibung abweichen.

.PARAMETER Path
    Zielpfad, unter dem der neue Ordner erstellt wird.

.PARAMETER Name
    Name des zu erstellenden Ordners.

.PARAMETER FileCount
    Anzahl der Dateien, die im Hauptordner angelegt werden.

.PARAMETER DirCount
    Anzahl der Unterordner, die im Hauptordner angelegt werden.

.PARAMETER Force
    Wenn gesetzt und der Zielordner bereits existiert, wird dieser samt
    sämtlichem Inhalt rekursiv gelöscht und anschließend neu erstellt.
    Vorsicht: Die Löschung ist destruktiv.

.EXAMPLE
    .\MoeglicheLoesung.ps1 -Path "C:\Temp" -Name "Demo" -FileCount 5 -DirCount 2

    Erstellt unter C:\Temp einen Ordner "Demo" mit 5 Dateien und 2 Unterordnern.

.EXAMPLE
    .\MoeglicheLoesung.ps1 -Path "C:\Temp" -Name "Demo" -FileCount 3 -DirCount 1 -Force

    Löscht ggf. einen vorhandenen Ordner "Demo" und erstellt ihn neu.

.NOTES
    Author: Stefan Ober
    Version: 1.0

    Lernhinweis: In der inneren for-Schleife am Ende des Skripts wird $i
    statt $j erhöht. Die Schleifenvariable $j bleibt dadurch unverändert;
    es wird wiederholt derselbe Dateiname verwendet. Das ist ein Fehler in
    der bestehenden Logik und wird hier bewusst nicht geändert.
#>
[cmdletBinding()]
param(
# Nur ein vorhandenes Verzeichnis ist als Zielpfad zulässig.
[ValidateScript({Test-Path -Path $PSItem -PathType Container})]
[Parameter(Mandatory=$true)]
[string]$Path,

# Validatelength begrenzt die Länge des Ordnernamens auf 5 bis 20 Zeichen.
[Validatelength(5,20)]
[string]$Name = "TestFiles2",

# Die Anzahl der Dateien muss zwischen 1 und 99 liegen.
[ValidateRange(1,99)]
[int]$FileCount = 9,

# Null Unterordner sind erlaubt; maximal werden 99 angelegt.
[ValidateRange(0,99)]
[int]$DirCount = 2,

[switch]$Force
)

$TestDirPath = Join-Path -Path $Path -ChildPath $Name
# Ohne -Force wird ein vorhandener Zielordner als Fehler gemeldet.
if(Test-Path -Path $TestDirPath  -PathType Container)
{
    if($Force)
    {
        # Achtung: -Recurse entfernt den Ordner und alle darin enthaltenen Daten.
        Remove-Item -Path $TestDirPath -Recurse 
    }
    else
    {# Wenn der Ordner vorhanden ist soll ein terminierender Fehler geworfen werden 
        Write-Error -Message "Ordner bereits vorhanden" -Category ResourceExists -CategoryActivity "Dir Creation" -CategoryReason "REsource vorhandne" -CategoryTargetName $TestDirPath -ErrorId "FC12" -TargetObject (Get-Item -Path $TestDirPath) -RecommendedAction "Verwenden Sie -Force oder löschen Sie den Ordner" -ErrorAction Stop
    }
}

$TestDir = New-Item -Path $Path -Name $Name -ItemType Directory

# Dateien im neu erstellten Hauptordner nummerieren und anlegen.
for($i = 1; $i -le $FileCount; $i++)
{
    $FileName = "File" + ("{0:D2}" -f $i) + ".txt"
    New-Item -Path $TestDir.FullName -Name $FileName -ItemType File
}

# Unterordner anlegen und darin Dateien erzeugen.
for($i = 1; $i -le $DirCount; $i++)
{
    $DirName = "Dir" + ("{0:D2}" -f $i)
    $subdir = New-Item -Path $TestDir.FullName -Name $DirName -ItemType Directory

    for($j = 1; $j -le $FileCount; $j++)
    {
        $FileName = "File" + ("{0:D2}" -f $j) + ".txt"
        New-Item -Path $subdir.FullName -Name $FileName -ItemType File  
    }
}