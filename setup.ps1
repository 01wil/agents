# Install this repo for every agent harness on this machine (Windows PowerShell).
#
# Usage (may require an elevated shell or Developer Mode for symlinks):
#   pwsh -File .\setup.ps1
#
# Skills are linked into ~\.claude\skills: Claude Code reads that as its personal skills dir, and
# opencode reads the same path as its Claude-compatible global location, so one link serves both.
# The instruction file is linked into each harness's config dir under the name it looks for.
#
# Re-runnable. Existing non-symlink items are backed up to <name>.bak-<timestamp>.

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $MyInvocation.MyCommand.Path
$home_ = $env:USERPROFILE

if ($repo -ne (Join-Path $home_ 'agents')) {
    Write-Host "WARNING: this clone is at $repo, but AGENTS.md resolves wiki/ and skills/ paths"
    Write-Host "         against ~/agents. Either clone to ~/agents, or edit the path rule at the"
    Write-Host "         top of AGENTS.md to match."
    Write-Host ""
}

function Link-Path($src, $dst) {
    $parent = Split-Path -Parent $dst
    New-Item -ItemType Directory -Force -Path $parent | Out-Null
    $item = Get-Item -LiteralPath $dst -Force -ErrorAction SilentlyContinue
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

# Legacy links from the opencode-only layout. wiki/ is now reached by absolute path, and a second
# skills location would register every skill twice. Only ever removes a symlink, never real files.
foreach ($legacy in @((Join-Path $home_ '.config\opencode\wiki'), (Join-Path $home_ '.config\opencode\skills'))) {
    $item = Get-Item -LiteralPath $legacy -Force -ErrorAction SilentlyContinue
    if ($item -and $item.LinkType) {
        Remove-Item -LiteralPath $legacy -Force
        Write-Host "removed legacy link $legacy"
    }
}

# Universal: the one skills location both Claude Code and opencode read.
Link-Path (Join-Path $repo 'skills')    (Join-Path $home_ '.claude\skills')
Link-Path (Join-Path $repo 'AGENTS.md') (Join-Path $home_ '.claude\CLAUDE.md')

# Per-harness instruction file, only where that harness is already set up.
$harnesses = @(
    @{ Dir = '.config\opencode'; File = '.config\opencode\AGENTS.md' },
    @{ Dir = '.codex';           File = '.codex\AGENTS.md'           },
    @{ Dir = '.gemini';          File = '.gemini\GEMINI.md'          }
)
foreach ($h in $harnesses) {
    if (Test-Path -LiteralPath (Join-Path $home_ $h.Dir)) {
        Link-Path (Join-Path $repo 'AGENTS.md') (Join-Path $home_ $h.File)
    }
}

Write-Host ""
Write-Host "Done. Instructions and skills now come from $repo."
