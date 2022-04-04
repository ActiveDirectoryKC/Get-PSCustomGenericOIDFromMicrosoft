# Get-PSCustomGenericOIDFromMicrosoft.ps1
<#
    .SYNOPSIS
    Generates an automated generic Microsoft OID Prefix. 

    .DESCRIPTION
    Generates an automated generic Microsoft OID Prefix from a randomized GUID which is converted 
    to decimal sequences and appended to the automated generic Microsoft OID Range ("1.2.840.113556.1.8000.2554").

    .PARAMETER FilePath
    [System.String] Specify the path of the output file. 

    .PARAMETER SkipSupportInfo
    [switch] Specifies to remove the support information from the console output.

    .PARAMETER EnableSchemaSnapIn
    [switch] Specifies to register the MMC AD Schema Snap-In.

    .OUTPUTS
    System.String. Returns a string with the OID Prefix and support information. -SkipSupportInfo switch 
    removes the support information and only returns the OID.

    File. Default file exported to $env:UserProfile\Documents\GenericOidInfo.txt. User can specify the output file path 
    via the -FilePath switch. 

    .Example
    PS> Get-PSCustomGenericOIDFromMicrosoft
    Returns the OID and the support information.

    .EXAMPLE
    PS> Get-PSCustomGenericOIDFromMicrosoft -FilePath $env:UserProfile\Documents
    Creates the output fule 'GenericOidInfo.txt' in the specified directory. 

    .NOTES
    .COPYRIGHT
    Copyright (c) ActiveDirectoryKC.NET. All Rights Reserved

    Permission is hereby granted, free of charge, to any person obtaining
    a copy of this software and associated documentation files (the
    "Software"), to deal in the Software without restriction, including
    without limitation the rights to use, copy, modify, merge, publish,
    distribute, sublicense, and/or sell copies of the Software, and to
    permit persons to whom the Software is furnished to do so, subject to
    the following conditions:

    The above copyright notice and this permission notice shall be
    included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
    EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
    NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
    LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
    OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
    WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


    The website "ActiveDirectoryKC.NET" or it's administrators, moderators, affiliates, or associates are not affilitated with Microsoft 
    and no support or sustainability guarantee is provided. This script is based off the original 'oidgen.vbs' from Microsoft 
    (https://docs.microsoft.com/en-us/windows/win32/ad/obtaining-an-object-identifier-from-microsoft). The original has been modified to utilize 
    PowerShell and use updated links. 

    .VERSION 1.0

    .LINK 
    https://github.com/ActiveDirectoryKC/Get-PSCustomGenericOIDFromMicrosoft

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$false,HelpMessage="Specify the path of the output file.")]
    [string]$FilePath = "$env:USERPROFILE\Documents",

    [Parameter(Mandatory=$false,HelpMessage="Specifies to remove the support information from the console output.")]
    [switch]$SkipSupportInfo,

    [Parameter(Mandatory=$false,HelpMessage="Specifies to register the MMC AD Schema Snap-In.")]
    [switch]$EnableSchemaSnapIn
)

#region Functions
function New-PSCustomGenericOIDFromMicrosoft
{
    # Variables
    [string]$guidString
    [string]$oidPrefix = "1.2.840.113556.1.8000.2554" # Microsoft OID number used for automated OID Generation
    [string[]]$oidGuidPartList = @()
    [string]$oidOut

    $guidString = [System.Guid]::NewGuid().ToString()

    # Split guidString into 6 hex numbers and convert to UINT64. 
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(0,4).Trim(), "AllowHexSpecifier" )
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(4,4).Trim(), "AllowHexSpecifier" )
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(9,4).Trim(), "AllowHexSpecifier" )
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(14,4).Trim(), "AllowHexSpecifier" )
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(19,4).Trim(), "AllowHexSpecifier" )
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(24,4).Trim(), "AllowHexSpecifier" )
    $oidGuidPartList += [UInt64]::Parse( $guidString.Substring(28,4).Trim(), "AllowHexSpecifier" )

    $oidOut = "$oidPrefix.$($oidGuidPartList -join ".")"
    return $oidOut
}

function Show-PSCustomGenericOIDInfo
{
    param(
        [string]$GenericOid,
        [switch]$SkipSupportInfo
    )

    [string]$oidOutText = "`tYour root oid is: "
    [string]$outInfo = "`n`r`tThis prefix should be used to name your schema attributes and classes. For example: `n`r"
    $outInfo += "`t`t If your prefix is `"ADKC`", you should name schema elements as the following: `"adkc-Custom-Element`". `n`r"
    $outInfo += "`t`t For more information on the prefix, view `"Naming Attributes and Classes`" at the following link. `n`r"
    $outInfo += "`t`t`t https://docs.microsoft.com/en-us/windows/win32/ad/naming-attributes-and-classes `n`r"
    $outInfo += "`n`r" # New Line
    $outInfo += "`t You can create subsequent OIDs for new schema clases and attributes by appending a .N to the OID where N may `n`r"
    $outInfo += "`t be any number you want. A common schema extension convention uses the following general structure: `n`r"
    $outInfo += "`t`t Assigned OID: $genericOID `n`r"
    $outInfo += "`t`t Classes OID Prefix: $genericOID.1 `n`r"
    $outInfo += "`t`t`t Thus the class 'adkc-Custom-Element could have an oid of : $genericOID.1.1 `n`r"
    $outInfo += "`t`t`t Thus the class 'adkc-Custom-Element2 could have an oid of : $genericOID.1.2 `n`r"
    $outInfo += "`t`t Attributes OID Prefix: $genericOID.2 `n`r"
    $outInfo += "`t`t`t Thus the class 'adkc-Custom-Attribute could have an oid of : $genericOID.2.1 `n`r"
    $outInfo += "`t`t`t Thus the class 'adkc-Custom-Attribute2 could have an oid of : $genericOID.2.2 `n`r"
    $outInfo += "`n`r" # New Line
    $outInfo += "`t Other helpful Links: `n`r"
    
    $outInfo += "`t`t Active Directory Schema (AD Schema) `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/windows/win32/adschema/active-directory-schema `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Active Directory Schema `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc739086(v=ws.10) `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Active Directory Schema Technical Reference `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc759402(v=ws.10) `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Understanding Schema `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc759402(v=ws.10) `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Extending the Schema `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/windows/win32/ad/extending-the-schema `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Troubleshooting Schema `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2003/cc778804(v=ws.10) `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Step-by-Step Guide to Using Active Directory Schema and Display Specifiers `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/bb727064(v=technet.10) `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t [THIRD PARTY] Step-by-Step Guide to Create Custom Active Directory Attributes `n`r"
    $outInfo += "`t`t https://www.rebeladmin.com/2017/11/step-step-guide-create-custom-active-directory-attributes/ `n`r"
    $outInfo += "`n`r" # New Line

    $outInfo += "`t`t Obtaining an Object Identifier frojm Microsoft `n`r"
    $outInfo += "`t`t NOTE: This PowerShell script is intended to be an enhancement of the script in the below link. `n`r"
    $outInfo += "`t`t https://docs.microsoft.com/en-us/windows/win32/ad/obtaining-an-object-identifier-from-microsoft `n`r"
    $outInfo += "`n`r" # New Line
    
    # If the -SkipSupportInfo switch is provided, we don't include that information in the output.
    if( !$SkipSupportInfo )
    {
        Write-Host -Object $oidOutText -NoNewline
        Write-Host -Object $GenericOid -ForegroundColor Cyan
        Write-Host -Object $outInfo
    }
    else
    {
        Write-Output -InputObject $GenericOid
    }

    # We always log the data. 
    "$oidOutText $GenericOid " >> $script:OutPath
    "" >> $script:OutPath
    $outInfo >> $script:OutPath
}
#endregion Functions

#region Parameter Validation
if( !(Test-Path -Path $FilePath) )
{
    Try
    {
        $null = (New-Item -Path $FilePath -ItemType Directory -ErrorAction Stop)
    }
    Catch
    {
        Write-Error -Message "Unable to create directory specified by '$FilePath' - $($PSItem.Exception.Message)"
        throw $PSItem
    }
}
#endregion Parameter Validation

# Variables
[string]$OutPath = "$FilePath\GenericOidInfo.txt"

"==== Running Get-PSCustomGenericOidFromMicrosoft.ps1 ====" >> $OutPath
"Started on: $(Get-Date) `n`r" >> $OutPath

$genericOid = New-PSCustomGenericOIDFromMicrosoft
Show-PSCustomGenericOIDInfo -GenericOid $genericOid -SkipSupportInfo $SkipSupportInfo
Write-Host -Object "Script Output Location: $OutPath"

if( $PSBoundParameters.ContainsKey("EnableSchemaSnapIn") -and $EnableSchemaSnapIn )
{
    Write-Host -Object "Registering the MMC AD Schema Snap-In"
    cmd /c "Regsvr32 Schmmgmt.dll"
}