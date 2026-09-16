# Symlink this repo into the opencode config dir (Windows PowerShell).
# The repo is canonical; the config dir just points at it.
#
# Usage (may require an elevated shell or Developer Mode for symlinks):
#   pwsh -File .\setup.ps1
# Re-runnable. Existing non-symlink items are backed up to <name>.bak-<timestamp>.

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$cfg  = Join-Path $env:USERPROFILE '.config\opencode'
New-Item -ItemType Directory -Force -Path $cfg | Out-Null

function Link-Item($name) {
    $src = Join-Path $repo $name
    $dst = Join-Path $cfg  $name
    $item = Get-Item -LiteralPath $dst -ErrorAction SilentlyContinue
    if ($item) {
        if ($item.LinkType) {
            Remove-Item -LiteralPath $dst -Force
        } else {
            $stamp = Get-Date -Format 'yyyyMMddHHmmss'
            Move-Item -LiteralPath $dst -Destination "$dst.bak-$stamp"
            Write-Host "backed up existing $dst"
        }
    }
    New-Item -ItemType SymbolicLink -Path $dst -Target $src | Out-Null
    Write-Host "linked $dst -> $src"
}

Link-Item 'AGENTS.md'
Link-Item 'wiki'
Link-Item 'skills'

Write-Host "Done. opencode will now read AGENTS.md, wiki/, and skills/ from $repo."
