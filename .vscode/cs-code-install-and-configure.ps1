


# Script for batch installing Visual Studio Code extensions
# Specify extensions to be checked & installed by modifying $extensions

$extensions =

## Language support ##
# c#
"ms-vscode.csharp",
# c/c++
"ms-vscode.cpptools",
#PowerShell
"ms-vscode.powershell",
# Python
"ms-python.vscode-pylance",


## Connect To Services ##
# Big MS Azure Pack
"ms-vscode.vscode-node-azure-pack" ,
# SQL
"ms-mssql.mssql",


## Extra functionality ##
#Rainbox CSV
"mechatroner.rainbow-csv",
# Live Server
"ritwickdey.liveserver",
#Thunder APi Client
"rangav.vscode-thunder-client",

## Theme ##
"wesbos.theme-cobalt2",
"vscode-icons-team.vscode-icons"


$cmd = "code --list-extensions"
Invoke-Expression $cmd -OutVariable output | Out-Null
$installed = $output -split "\s"

foreach ($ext in $extensions) {
    if ($installed.Contains($ext)) {
        Write-Host $ext "already installed." -ForegroundColor Gray
    } else {
        Write-Host "Installing" $ext "..." -ForegroundColor White
        code --install-extension $ext
    }
}


####  Extensions not on the favourite list, but busy Testing out #####

# MS Bridge to Kubernetes
"mindaro.mindaro"









