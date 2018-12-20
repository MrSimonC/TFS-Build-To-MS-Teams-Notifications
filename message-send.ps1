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
        [string]$Number,
        [string]$DefinitionName,
        [string]$AgentJobStatus,
        [string]$TriggeredBy,
        [string]$SummaryUri
    )
    $message = [pscustomobject]@{
        '@type' = "MessageCard"
        '@context' = "https://schema.org/extensions"
        "themeColor" = if ($AgentJobStatus -eq "Succeeded") {"008000"} else {"ff0000"}
        "title" = "$DefinitionName $Number`: **$AgentJobStatus**"
        "text" = "Triggered by $TriggeredBy"
        "potentialAction" = @(@{
            '@type' = "OpenUri"
            "name" = "Open Summary"
            "targets" = @(@{
                "os" = "default"
                "uri" = $SummaryUri
            })
        })
    }
    Invoke-RestMethod -Method post -ContentType 'Application/Json' -Body (ConvertTo-Json -Compress -Depth 5 -InputObject $message) -Uri $teamsWebhookUrl
    # Write-Output -Method post -ContentType 'Application/Json' -Body (ConvertTo-Json -Compress -Depth 5 -InputObject $message) -Uri $teamsWebhookUrl
}

# Azure DevOps Variables
# Build variables
# https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=vsts
# Release variables
# https://docs.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=vsts&tabs=batch#view-vars

if ($args[0]) {
    $Number = $args[0]
    $DefinitionName = $args[1]
    $AgentJobStatus = $args[2]
    $TriggeredBy = $args[3]
    $SummaryUri = $args[4]
}
elseif ($env:RELEASE_DEFINITIONNAME) {
    $Number = $Env:RELEASE_RELEASEID  # blank in tfs 2015
    $DefinitionName = $env:RELEASE_DEFINITIONNAME
    $AgentJobStatus = $env:AGENT_JOBSTATUS
    $TriggeredBy = $env:RELEASE_RELEASEDESCRIPTION
    $SummaryUri = $env:RELEASE_RELEASEURI
}
else {
    $Number = $Env:BUILD_BUILDNUMBER
    $DefinitionName = $env:BUILD_DEFINITIONNAME
    $AgentJobStatus = $env:AGENT_JOBSTATUS
    $TriggeredBy = $env:BUILD_TRIGGEREDBY
    $SummaryUri = $env:BUILD_BUILDURI
}

# Run
Send-Message `
-BuildBuildNumber $Number `
-BuildDefinitionName $DefinitionName `
-AgentJobStatus $AgentJobStatus `
-BuildTriggeredBy $TriggeredBy `
-BuildBuildUri $SummaryUri