# DESCRIPTION
Generates an automated generic Microsoft OID Prefix from a randomized GUID which is converted 
to decimal sequences and appended to the automated generic Microsoft OID Range ("1.2.840.113556.1.8000.2554").

Version 1.0

LINK TO CHANGE LOG: https://github.com/ActiveDirectoryKC/Get-PSCustomGenericOIDFromMicrosoft/blob/main/CHANGELOG.md

LINK TO LICENSE: https://github.com/ActiveDirectoryKC/Get-PSCustomGenericOIDFromMicrosoft/blob/main/LICENSE.md

# PARAMETERS
## PARAMETER FilePath
[System.String] Specify the path of the output file. 

## PARAMETER SkipSupportInfo
[switch] Specifies to remove the support information from the console output.

## PARAMETER EnableSchemaSnapIn
[switch] Specifies to register the MMC AD Schema Snap-In.

# OUTPUTS
System.String. Returns a string with the OID Prefix and support information. -SkipSupportInfo switch 
removes the support information and only returns the OID.

File. Default file exported to $env:UserProfile\Documents\GenericOidInfo.txt. User can specify the output file path 
via the -FilePath switch. 

# EXAMPLES
## Example
PS> Get-PSCustomGenericOIDFromMicrosoft
Returns the OID and the support information.

## EXAMPLE
PS> Get-PSCustomGenericOIDFromMicrosoft -FilePath $env:UserProfile\Documents
Creates the output fule 'GenericOidInfo.txt' in the specified directory. 

# NOTES
## COPYRIGHT
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
