Import-Module Posh-Git
Import-Module Terminal-Icons
Import-Module '~\scoop\apps\gsudo\current\gsudoModule.psd1'
Import-Module Catppuccin
$Flavor = $Catppuccin['Mocha']

# oh-my-posh init pwsh --config "~/Documents/PowerShell/my.omp.json" | Invoke-Expression
Invoke-Expression (&starship init powershell)
zoxide init --hook 'pwd' powershell | Out-String | Invoke-Expression
# vimode
$OnViModeChange = [scriptblock] {
    if ($args[0] -eq 'Command') {
        # Set the cursor to a blinking block.
        Write-Host -NoNewLine "`e[1 q"
    }
    else {
        # Set the cursor to a blinking line.
        Write-Host -NoNewLine "`e[5 q"
    }
}

$Colors = @{
	# Largely based on the Code Editor style guide
	# Emphasis, ListPrediction and ListPredictionSelected are inspired by the Catppuccin fzf theme
	
	# Powershell colours
	ContinuationPrompt     = $Flavor.Teal.Foreground()
	Emphasis               = $Flavor.Red.Foreground()
	Selection              = $Flavor.Surface0.Background()
	
	# PSReadLine prediction colours
	InlinePrediction       = $Flavor.Overlay0.Foreground()
	ListPrediction         = $Flavor.Mauve.Foreground()
	ListPredictionSelected = $Flavor.Surface0.Background()

	# Syntax highlighting
	Command                = $Flavor.Blue.Foreground()
	Comment                = $Flavor.Overlay0.Foreground()
	Default                = $Flavor.Text.Foreground()
	Error                  = $Flavor.Red.Foreground()
	Keyword                = $Flavor.Mauve.Foreground()
	Member                 = $Flavor.Rosewater.Foreground()
	Number                 = $Flavor.Peach.Foreground()
	Operator               = $Flavor.Sky.Foreground()
	Parameter              = $Flavor.Pink.Foreground()
	String                 = $Flavor.Green.Foreground()
	Type                   = $Flavor.Yellow.Foreground()
	Variable               = $Flavor.Lavender.Foreground()
}
$env:EDITOR='nvim'

# Set-PSReadLineKeyHandler -Chord Ctrl+i -ViMode Insert -Function PossibleCompletions
Set-PsReadLineOption  `
    -EditMode Vi -ViModeIndicator Script `
    -ViModeChangeHandler $OnViModeChange `
    -PredictionViewStyle ListView `
    -Colors $Colors

$env:EDITOR = 'nvim'
$ENV:FZF_DEFAULT_OPTS = @"
--color=bg+:$($Flavor.Surface0),bg:$($Flavor.Base),spinner:$($Flavor.Rosewater)
--color=hl:$($Flavor.Red),fg:$($Flavor.Text),header:$($Flavor.Red)
--color=info:$($Flavor.Mauve),pointer:$($Flavor.Rosewater),marker:$($Flavor.Rosewater)
--color=fg+:$($Flavor.Text),prompt:$($Flavor.Mauve),hl+:$($Flavor.Red)
--color=border:$($Flavor.Surface2)
"@


# alias
Set-Alias base '~\Desktop\Learn\Python\Base\Scripts\Activate.ps1'
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias tig 'C:\Program Files\Git\usr\bin\tig.exe'
Set-Alias vim nvim
function fzfv{fzf --preview 'bat --color \"always\" {}'}
function which ($Command) {
	Get-Command -Name $Command -ErrorAction SilentlyContinue |
		Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
