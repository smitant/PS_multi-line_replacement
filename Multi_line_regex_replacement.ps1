<#
.Synopsis
    Script that does multi-line replacement for any type of file in ascii
    Useful in mass replacement across multiple files.
    
.Notes
    Author: Anthony Smith - smitant920@gmail.com - 10/19/2017

    Use https://regex101.com/ to test if your regular expression matches what you want to replace.
    Be careful when using this script. It will change the file's content that you have selecte, and not save 

.Example
    Example: 

.ReturnValue
    0 if the regular expression matched anything in the document
    -1 if no match for regular expression


#>
#######################################Parameters#######################################################################
param(
    
    [Parameter(Mandatory=$True)]
    [string]
    $baseDirectory
    ,
    [Parameter(Mandatory=$True)]
    [string]
    $regularExpression
    ,
    [string]
    $filter
    ,
    [int]
    $Process_id

);
############################Start of Main################################################################################
#dont forget you cannot have '' inside your replacement string. Use \ to escape those bad characters.

$files = Get-ChildItem -Path 'E:\GDM_changes\address\transform\run' -Filter *address_load.ps1| Select-Object -ExpandProperty FullName

Write-Host "Are you sure you want to search and replace for these listed files?"
$files|Write-Host
$answer = Read-Host "Enter 'yes' to continue"


if($answer -eq "yes"){
    foreach ($file in $files)
    {

        $fileContent = [io.file]::ReadAllText($file)
        #(?smi) -> this portion of the regex allows for line endings to be ignored n stuff
        #put the begining of the entire string and a portion of the end and use that. double check with https://regex101.com/
        $fileContent = ($fileContent -replace '(?smi)log-message -Messag -InsertToD6
    echo\.', '') 
   
      Set-Content -Path $file -Value $fileContent
    }
}


#Goes through each line of the input file.
$files = Get-ChildItem -Path 'E:\GDM_changes\address\transform\run' -Filter *.ps1| 
Select-Object -ExpandProperty FullName
foreach ($file in $files)
{
    Set-ItemProperty $file -Name IsReadOnly -Value $false
        
    (Get-Content -LiteralPath $file) |
    Foreach-Object { $_ -replace 'Import-Module -Name \.\\common\\message_log\.psm1', 'Import-Module -Name .\common\message_log.psm1 -DisableNameChecking'} |
    Set-Content $file
        

}


#Rename files
$files = Get-ChildItem -Path 'E:\GDM_changes\address\transform\run' -Filter *_address_load.bat
foreach ($file in $files)
{

    $newFileName=$file.Name.Replace(".bat",".ps1")   
    Rename-Item $file $newFileName

}
