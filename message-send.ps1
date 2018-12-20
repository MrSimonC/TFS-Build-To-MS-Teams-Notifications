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
        [string]$BuildNumber,
        [string]$DefinitionName,
        [string]$AgentJobStatus,
        [string]$BuildTriggeredBy,
        [string]$BuildBuildUri
    )
    $message = [pscustomobject]@{
        '@type' = "MessageCard"
        '@context' = "https://schema.org/extensions"
        "themeColor" = if ($AgentJobStatus -eq "Succeeded") {"008000"} else {"ff0000"}
        "title" = "$DefinitionName $BuildNumber`: **$AgentJobStatus**"
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
# Build variables
# https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables?view=vsts
# Release variables
# https://docs.microsoft.com/en-us/azure/devops/pipelines/release/variables?view=vsts&tabs=batch#view-vars

if ($args[0]) {
    $BuildNumber = $args[0]
    $DefinitionName = $args[1]
    $AgentJobStatus = $args[2]
    $BuildTriggeredBy = $args[3]
    $BuildBuildUri = $args[4]
}
elseif ($env:RELEASE_DEFINITIONNAME) {
    $BuildNumber = $Env:RELEASE_RELEASEID  # blank in tfs 2015
    $DefinitionName = $env:RELEASE_DEFINITIONNAME
    $AgentJobStatus = $env:AGENT_JOBSTATUS
    $BuildTriggeredBy = $env:RELEASE_RELEASEDESCRIPTION
    $BuildBuildUri = $env:RELEASE_RELEASEURI
}
else {
    $BuildNumber = $Env:BUILD_BUILDNUMBER
    $DefinitionName = $env:BUILD_DEFINITIONNAME
    $AgentJobStatus = $env:AGENT_JOBSTATUS
    $BuildTriggeredBy = $env:BUILD_TRIGGEREDBY
    $BuildBuildUri = $env:BUILD_BUILDURI
}

# Run
Send-Message `
-BuildBuildNumber $BuildNumber `
-BuildDefinitionName $DefinitionName `
-AgentJobStatus $AgentJobStatus `
-BuildTriggeredBy $BuildTriggeredBy `
-BuildBuildUri $BuildBuildUri