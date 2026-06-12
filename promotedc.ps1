Start-Transcript -Path C:\promote-dc.log

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools

$Password = ConvertTo-SecureString 'P@ssw0rd123!' -AsPlainText -Force

Install-ADDSForest `
    -DomainName 'nathlabs.local' `
    -DomainNetbiosName 'NATH' `
    -InstallDNS `
    -SafeModeAdministratorPassword $Password `
    -Force

Stop-Transcript
