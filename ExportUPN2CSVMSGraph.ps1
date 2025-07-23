#fill in the groupname
$DisplayName = "groupname"

#gets the GroupId
$Group = Get-mggroup -Filter "DisplayName eq '$DisplayName'" | Select-Object -ExpandProperty Id

#Specify your CSV location
$PathCSV = "c:\temp\" + $DisplayName + ".csv"

#Tests if CSV exists and if it exists delete the old CSV and creates a fresh one
$TestPath = Test-Path -Path $PathCSV

if ($TestPath -eq "True") 
{
    Remove-Item $PathCSV
}
else
{
    New-Item $PathCSV
}

#Gets UserID of every member, selects the UPN, export it to a CSV
$users = Get-MgGroupMember -GroupId $Group -All | Select-Object -ExpandProperty Id
foreach ($user in $users)
{
    get-mguser -userId $user | Select-Object UserPrincipalName | Export-Csv $PathCSV -NoTypeInformation -Append
}
