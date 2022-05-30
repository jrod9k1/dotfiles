# this is to redirect the default windows PowerShell 7 profile location
# to match the nix equivalent in service on making my dotfiles simpler across
# systems
if(! $HOME){throw "\$HOME variable no available"}
$redirProfile = "$HOME\.config\powershell\profile.ps1"
$PROFILE.CurrentUserAllHosts = $redirProfile
. $redirProfile