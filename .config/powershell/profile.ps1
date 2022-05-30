$execPath = $PSScriptRoot

function global:prompt{
    $curPath = Get-Location
    $split = Get-Item -Path $curPath

    $friendlyPath = "oopslol"

    if($split.Parent.Name -eq $null){
        $friendlyPath = $split.Name
    } else{
        $friendlyPath = "$($split.Parent.Name)\$($split.Name)"
    }

    Write-Host "$($env:USERNAME)@$($env:COMPUTERNAME)" -ForegroundColor Magenta -NoNewline
    Write-Host " : " -ForegroundColor White -NoNewline
    Write-Host "$($friendlyPath)" -ForegroundColor Cyan -NoNewline
    Write-Host " >>" -ForegroundColor Red -NoNewline
    return " "
}

function global:cfggit {git --git-dir=$HOME/.cfg/ --work-tree=$HOME $args}
function global:anyonehome{Invoke-Command -ComputerName $args -ScriptBlock {quser}}
function global:showme{(Get-Command $args).ScriptBlock | gvim -}
function global:l{ls -Force $args[0]}
function global:steamdir{cd F:\Steam\steamapps\common}
function global:steamdiralt{cd 'C:\Program Files (x86)\Steam\steamapps\common'}
function global:e{explorer $args[0]}
function global:setpublicmac{
    Get-VM -Name $args[0] | Get-NetworkAdapter | ? NetworkName -like "VM*" | Set-NetworkAdapter -MacAddress $args[1]
}

if(Get-Module -Name PSReadline){
    $PSReadlineOptions = @{
        HistorySearchCursorMovesToEnd = $true
        ShowToolTips = $true
        EditMode = "Vi"
    }
    
    Set-PSReadLineOption @PSReadlineOptions
    
    $psrVer = (Get-Module PSReadline).Version
    
    if($psrVer.Major -eq 2 -and $psrVer.Minor -gt 0){
        Set-PSReadLineOption -PredictionSource History
    }
    
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
    Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
    Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine 
}

Set-Location ~

Write-Host "jrod PS profile loaded!"