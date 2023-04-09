$orehome = $Env:ORE
$filelists = @(@(
"OREAnalytics\orea\",
"OREAnalytics\test\",
"OREData\ored\",
"OREData\test\",
"QuantExt\qle\",
"QuantExt\test\",
"QuantLib\ql\",
""),
@(
"OREAnalytics",
"OREAnalyticsTestSuite",
"OREData",
"OREDataTestSuite",
"QuantExt",
"QuantExtTestSuite",
"QuantLib",
""))

for (($i = 0); $i -lt $filelists[0].count-1; $i++)
{
    $templProj = ""
    $templFilter = ""
    $cmakelistpath = $filelists[0][$i]
    $fileinflt = $filelists[1][$i]+".vcxproj.filters.template"
    $fileoutflt = $filelists[1][$i]+".vcxproj.filters"
    $fileinproj = $filelists[1][$i]+".vcxproj.template"
    $fileoutproj = $filelists[1][$i]+".vcxproj"
    Write-Host "getting source files from $cmakelistpath into project file $fileoutproj and filter file $fileoutflt"
    Get-Content $orehome\$cmakelistpath\CMakeLists.txt | ForEach-Object {
        if($_ -match 'set\(.*'){
            if ($cmakelistpath -eq "QuantLib\ql\") {
                if (($_ -match 'set\(QL_SOURCES') -or ($_ -match 'set\(QL_HEADERS')) {
                    $doParse = $true
                }
            } else {
                $doParse = $true
            }
            $stopParse = $false
            $_ = $_ -replace 'set\(.*? ',''
        }
        if($_ -match '.*\)'){
            $stopParse = $true
            $_ = $_ -replace '\)',''
        }
        $_ = $_ -replace '\/','\' -replace ' ',''
    
        if($doParse){
            if($_ -match '\.hpp$'){
                Write-Host "adding source file $_"
                $templProj = $templProj+'<ClInclude Include="$(ORE)\'+$cmakelistpath+$_+'" />'+"`n"
                $testPatExist = $_ -match '(?<p>.*)\\(.*?)'
                if ($testPatExist) {
                    $templFilter = $templFilter+'<ClInclude Include="$(ORE)\'+$cmakelistpath+$_+'"><Filter>'+$Matches.p+'</Filter></ClInclude>'+"`n"
                } else {
                    $templFilter = $templFilter+'<ClInclude Include="$(ORE)\'+$cmakelistpath+$_+'" />'+"`n"
                }
            }
            if($_ -match '\.cpp$'){
                Write-Host "adding source file $_"
                $templProj = $templProj+'<ClCompile Include="$(ORE)\'+$cmakelistpath+$_+'" />'+"`n"
                $testPatExist = $_ -match '(?<p>.*)\\(.*?)'
                if ($testPatExist) {
                    $templFilter = $templFilter+'<ClInclude Include="$(ORE)\'+$cmakelistpath+$_+'"><Filter>'+$Matches.p+'</Filter></ClInclude>'+"`n"
                } else {
                    $templFilter = $templFilter+'<ClInclude Include="$(ORE)\'+$cmakelistpath+$_+'" />'+"`n"
                }
            }
            if ($stopParse) {$doParse = $false}
        }
    }
    (Get-Content $PSScriptRoot'\templates\'$fileinflt).Replace("<IncludeFileTemplate>", $templFilter) |  Out-File $PSScriptRoot'\'$fileoutflt
    (Get-Content $PSScriptRoot'\templates\'$fileinproj).Replace("<IncludeFileTemplate>", $templProj) |  Out-File $PSScriptRoot'\'$fileoutproj
}
$null = Read-Host 'finished recreating project and filter files, to continue press ENTER'