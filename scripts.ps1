function GetLatestSlackVersionFolder {
    $versions = 
        { [int]($_.Name -replace '.*?-(\d+)\.(\d+)\.(\d+)', '$1') }, 
        { [int]($_.Name -replace '.*?-(\d+)\.(\d+)\.(\d+)', '$2') }, 
        { [int]($_.Name -replace '.*?-(\d+)\.(\d+)\.(\d+)', '$3') }

    $latestVersionFolder = Get-ChildItem $env:LOCALAPPDATA\slack\app-* | Sort-Object $versions -Descending | Select-Object -First 1 -ExpandProperty Name
    return $latestVersionFolder
}

function StartSlack {
    [System.Environment]::SetEnvironmentVariable('SLACK_DEVELOPER_MENU', 'true', 'Process')

    $latestVersionFolder = GetLatestSlackVersionFolder

    & $env:LOCALAPPDATA\slack\$latestVersionFolder\slack.exe
}

function InstallSlackPatch() {
    $latestVersionFolder = GetLatestSlackVersionFolder
    $slackFolder = "$env:LOCALAPPDATA\slack\$latestVersionFolder\resources\app.asar.unpacked\src\static"

    Copy-Item -Path $slackFolder\index.js -Destination $slackFolder\index.js.bak
    Copy-Item -Path $slackFolder\ssb-interop.js -Destination $slackFolder\ssb-interop.js.bak

    # TODO - insert patches
}

function UninstallSlackPatch() {
    $latestVersionFolder = GetLatestSlackVersionFolder
    $slackFolder = "$env:LOCALAPPDATA\slack\$latestVersionFolder\resources\app.asar.unpacked\src\static"

    if(Test-Path -Path $slackFolder\index.js.bak) {
        Move-Item -Path $slackFolder\index.js.bak -Destination $slackFolder\index.js -Force
    }
    if(Test-Path -Path $slackFolder\ssb-interop.js.bak) {
        Move-Item -Path $slackFolder\ssb-interop.js.bak -Destination $slackFolder\ssb-interop.js -Force
    }
}