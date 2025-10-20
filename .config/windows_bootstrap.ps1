# bootstrap windows dotfiles / profile

# this file's purpose is to add some hacky redirects
# and symbolic links to redirect windows config locations
# to more sane 'nix location equivalents

# PSv7
New-Item -Path $HOME\Documents -Name PowerShell -ItemType Directory -Force
Copy-Item -Path $PSScriptRoot\profile_redirect.ps1 -Destination $HOME\Documents\PowerShell\profile.ps1 -Force

# PSv5
New-Item -Path $HOME\Documents -Name WindowsPowerShell -ItemType Directory -Force
Copy-Item -Path $PSScriptRoot\profile_redirect.ps1 -Destination $HOME\Documents\WindowsPowerShell\profile.ps1 -Force

$localAdminCheck = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if($localAdminCheck){
    New-Item -Path "$HOME\AppData\Roaming" -Name "alacritty" -ItemType Directory -Force
    New-Item -Path "$HOME\Appdata\Roaming\alacritty\alacritty.yml" -Value "$HOME\.alacritty.yml" -ItemType SymbolicLink -Force
    New-Item -Path "$env:APPDATA\helix\config.toml" -Value "$HOME\.config\helix\config.toml" -ItemType SymbolicLink -Force
    Remove-Item -Recurse -Force -Path "$env:APPDATA\dystroy"
    New-Item -Path "$env:APPDATA" -Name "dystroy" -ItemType Directory -Force
    New-Item -Path "$env:APPDATA\dystroy\" -Name "broot" -ItemType SymbolicLink -Value "$HOME\.config\broot"
    New-Item -Path "$env:LOCALAPPDATA\" -Name "nvim" -ItemType SymbolicLink -Value "$HOME\.config\nvim"
} else{
    Write-Error "This script must be run with local admin rights to symlink the alacritty config. Otherwise you must copy or symlink it manually."
}
