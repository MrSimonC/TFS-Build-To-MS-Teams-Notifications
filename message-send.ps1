Set-StrictMode -Version Latest

# Microsoft Incomming Webhook
# $teamsWebhookUrl should be included in the below .ps1 file
. (Get-ScriptDirectory | Join-Path -ChildPath MSTeamsWebhook.ps1)

function Send-Message {
    param (
        [string]$buildNumber,
        [string]$environment
    )
    $message = @{"text" = "Hello, build number $buildNumber succeeded under $environment"}
    Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body (ConvertTo-Json -Compress -InputObject $message) -Uri $teamsWebhookUrl
}

Send-Message -buildNumber $args[0] -environment $args[1]
