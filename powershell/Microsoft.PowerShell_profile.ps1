Import-Module Posh-Git
Import-Module Terminal-Icons
zoxide init --hook 'pwd' powershell | Out-String | Invoke-Expression
oh-my-posh init pwsh --config "~/Documents/PowerShell/my.omp.json" | Invoke-Expression

$OnViModeChange = [scriptblock]{
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

Set-PSReadLineOption `
    -EditMode Vi `
    -ViModeIndicator Script -ViModeChangeHandler $OnViModeChange `
    -PredictionViewStyle ListView `
    -Colors @{
        member = "`e[96m"
        operator = "blue"
        Parameter  = "blue"
    }

$env:EDITOR='nvim'

Set-PSReadLineKeyHandler -Chord Ctrl+i -ViMode Insert -Function PossibleCompletions

#psstyle
$psstyle.Formatting.TableHeader = "`e[3;38;5;195m"
$env:FZF_DEFAULT_OPTS='--color=bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD --color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96 --color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD'

#alias
Set-Alias base 'C:\Users\fadei\Desktop\Learn\Python\Base\Scripts\Activate.ps1'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias vim nvim
function fzfv{fzf --preview 'bat --color \"always\" {}'}
function which ($Command) {
	Get-Command -Name $Command -ErrorAction SilentlyContinue |
		Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
