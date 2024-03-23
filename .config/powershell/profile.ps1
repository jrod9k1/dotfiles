$execPath = $PSScriptRoot

$PSDefaultParameterValues['Out-Default:OutVariable'] = "__LastResult"

$global:historyFile = "$env:APPDATA\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt"

if(Get-Process -Name vcxsrv,xming -ErrorAction SilentlyContinue){
    $env:DISPLAY = "localhost:0"
}

# here we determine trhe basename of the shell and set the SHELL env var to it because
# powershell does not set this automatically and it needs to be set to fix an obscure
# idiosyncracy with fzf, otherwise fzf will use cmd and add awful backslash escapes and
# string quotes that break execute bindings
# https://github.com/junegunn/fzf/blob/a8f9432a3a10c33cfb0a375cc84bab3500dcc846/src/terminal_windows.go#L25
# https://github.com/junegunn/fzf/issues/2609
$shellBaseName = ([System.Environment]::ProcessPath -split '\\')[-1] -replace '.exe'
$env:SHELL = $shellBaseName

function global:prompt{
    $curPath = Get-Location
    $split = Get-Item -Path $curPath

    $friendlyPath = "oopslol"

    if($split.Parent.Name -eq $null){
        $friendlyPath = $split.Name
    } else{
        $friendlyPath = "$($split.Parent.Name)\$($split.Name)"
    }

    # git stuff
    try{
        $branch = git rev-parse --abbrev-ref HEAD
        if($branch -like "HEAD"){$branch = git rev-parse --short HEAD} # we're in detached head state, display short hash instead

    } catch{
        $branch = $null
    }

    Write-Host "$($env:USERNAME)@$($env:COMPUTERNAME)" -ForegroundColor Magenta -NoNewline
    Write-Host " : " -ForegroundColor White -NoNewline
    Write-Host "$($friendlyPath)" -ForegroundColor Cyan -NoNewline
    if($branch){Write-Host " ($($branch))" -ForegroundColor Green -NoNewline}
    Write-Host " >>" -ForegroundColor Red -NoNewline
    return " "
}

function cfggit {git --git-dir=$HOME/.cfg/ --work-tree=$HOME $args}
function anyonehome {Invoke-Command -ComputerName $args -ScriptBlock {quser}}
function showme {(Get-Command $args).ScriptBlock | gvim -}
function l {ls -Force $args[0]}
function steamdir {cd F:\Steam\steamapps\common}
function steamdiralt {cd 'C:\Program Files (x86)\Steam\steamapps\common'}
function e {explorer $args[0]}
function setpublicmac{
    Get-VM -Name $args[0] | Get-NetworkAdapter | ? NetworkName -like "VM*" | Set-NetworkAdapter -MacAddress $args[1]
}

function dumpcmd { (Get-Command $args).ScriptBlock | bat.exe --paging=never -l powershell }

function lsh {
    Get-ChildItem $args `
    | Select-Object Mode,LastWriteTime,@{Name="SizeMB";Expression={$_.Length / 1MB}},Name
}

New-Alias -Name which -Value Get-Command

function .. {cd ..}
function .. {cd ..\..}

$fzfHelp = "<F1> helix <F2> nvim <F3> gvim <F4> vscode <F9> git log <F10> git diff"
$fzfArgs = @(
    "--bind", "f2:execute(nvim +{2} {1})",
    "--bind", "f3:execute(gvim +{2} {1}",
    "--bind", 'f4:execute(code --goto ("{1}:{2}" -replace "''"))'
    "--bind", "f5:execute(p4 filelog {1} | less -r)",
    "--bind", "f6:execute(p4 edit {1})",
    "--bind", "f9:execute(git lg --color=always {1} | less -r)",
    "--bind", "f10:execute(git diff --color=always {1} | less -r)",
    "--border", "--border-label=$($fzfHelp), --border-label-pos=-3:bottom"
)

function livegrep {
    rg --line-number --no-heading --color=always --smart-case $args `
    | fzf -d ':' -n 1,3.. --ansi --no-sort --preview 'bat --color=always --highlight-line {2} {1}' --preview-window 'right:50%:+{2}+3/3,~3' 
}

function weatheralerts {
    $r = Invoke-RestMethod -Uri "https://api.weather.gov/alerts/active?zone=PAC071"
    $r.features.properties
}

if(Get-Module -Name PSReadline){
    $PSReadlineOptions = @{
        HistorySearchCursorMovesToEnd = $true
        ShowToolTips = $true
        EditMode = "Vi"
    }
    
    Set-PSReadLineOption @PSReadlineOptions
    
    $psrVer = (Get-Module PSReadline).Version
    if($psrVer -ge [version]"2.1"){
        Set-PSReadLineOption -PredictionSource History
    }
    
    Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit
    Set-PSReadLineKeyHandler -Key Ctrl+w -Function BackwardDeleteWord
    Set-PSReadLineKeyHandler -Key Ctrl+a -Function BeginningOfLine
    Set-PSReadLineKeyHandler -Key Ctrl+e -Function EndOfLine 

    if(Get-Command -Name fzf -ErrorAction SilentlyContinue){
        Set-PSReadLineKeyHandler -Chord Ctrl+b -BriefDescription "HistorySearch" -LongDescription "Search history with fzf then insert result to readline buffer" -ScriptBlock {
            $bufferInput = $null
            [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$bufferInput, [ref]$null, [ref]$null, [ref]$null)
            $hist = cat $historyFile
            [array]::Reverse($hist)
            $r = $hist | fzf --no-sort --query="$bufferInput" --preview '{} | bat --color=always -l powershell -n -' --preview-window 'up:7:wrap' --border --border-label='History searchr thingy' --border-label-pos=3:bottom
            [Microsoft.PowerShell.PSConsoleReadLine]::Insert($r)
        }
    }
}

Set-Location ~

Write-Host "jrod PS profile loaded!"