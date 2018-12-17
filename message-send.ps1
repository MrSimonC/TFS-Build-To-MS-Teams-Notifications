Set-StrictMode -Version Latest

function Get-ScriptDirectory
{
    Split-Path $script:MyInvocation.MyCommand.Path
}

# Microsoft Incomming Webhook
# $teamsWebhookUrl should be included in the below .ps1 file
. (Get-ScriptDirectory | Join-Path -ChildPath MSTeamsWebhook.ps1)

function Send-Message {
    param (
        [string]$BuildBuildNumber,
        [string]$BuildDefinitionName,
        [string]$AgentJobStatus,
        [string]$BuildTriggeredBy,
        [string]$BuildBuildUri
    )
    $message = [pscustomobject]@{
        '@type' = "MessageCard"
        '@context' = "https://schema.org/extensions"
        "themeColor" = if ($AgentJobStatus -eq "Succeeded") {"008000"} else {"ff0000"}
        "title" = "$BuildDefinitionName $BuildBuildNumber`: **$AgentJobStatus**"
        "text" = "Triggered by $BuildTriggeredBy"
        "potentialAction" = @(@{
            '@type' = "OpenUri"
            "name" = "Open Build Summary"
            "targets" = @(@{
                "os" = "default"
                "uri" = $BuildBuildUri
            })
        })
    }
    Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body (ConvertTo-Json -Compress -Depth 5 -InputObject $message) -Uri $teamsWebhookUrl
    # Write-Output -Method post -ContentType 'Application/Json' -Body (ConvertTo-Json -Compress -Depth 5 -InputObject $message) -Uri $teamsWebhookUrl
}

# Azure DevOps Variables
# https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=vsts
$BuildBuildNumber = if ($args[0]) {$args[0]} else {$Env:BUILD_BUILDNUMBER}
$BuildDefinitionName = if ($args[1]) {$args[1]} else {$env:BUILD_DEFINITIONNAME}
$AgentJobStatus = if ($args[2]) {$args[2]} else {$env:AGENT_JOBSTATUS}
$BuildTriggeredBy = if ($args[3]) {$args[3]} else {$env:BUILD_TRIGGEREDBY}
$BuildBuildUri = if ($args[4]) {$args[4]} else {$env:BUILD_BUILDURI}

# Run
Send-Message `
-BuildBuildNumber $BuildBuildNumber `
-BuildDefinitionName $BuildDefinitionName `
-AgentJobStatus $AgentJobStatus `
-BuildTriggeredBy $BuildTriggeredBy `
-BuildBuildUri $BuildBuildUri