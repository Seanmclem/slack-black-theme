Import-Module -Force $PSScriptRoot\scripts.ps1

Describe 'Slack Scripts' {
    
    Context 'Test' { 

        It 'Should return 3.4.2' {
            GetLatestSlackVersionFolder | Should be 'app-3.4.2'
        }

    }
}
