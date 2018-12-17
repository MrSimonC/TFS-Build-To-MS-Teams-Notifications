# Microsoft-Teams-Connector

Powershell script for sending in information to Microsoft Teams via incoming web-hook, customised for an Azure DevOps / TFVC build server. For example, a success message is sent into Teams when a build has succeeded.

## Preparation

Create a file called `MSTeamsWebhook.ps1` with this content:

```Powershell
$teamsWebhookUrl = 'https://outlook.office.com/webhook/<myTeamsIncommingWebHookURL>'
```

## Running the script (Azure DevOps / VSTS)

Either simply add a build definition step of "Powershell" and point it to `message-send.ps1` (and the file will work out the Azure variables automatically), or call manually with:

```Powershell
message-send.ps1 "BuildBuildNumber" "BuildDefinitionName" "AGENTJOB_STATUS" "BuildTriggeredBy" "BuildBuildUri"
```

e.g.

```Powershell
message-send.ps1 "1.2" "Test definition" "Succeeded" "API" "http://yahoo.com"
```

## Screenshot

Example build success message:

![screenshot](screenshot%20of%20alert.png)

## Script Testing

You can output the card json (which would be sent to Teams) with:

```batch
Powershell.exe -executionpolicy remotesigned -File message-send.ps1 "1.2" "Test definition" "Succeeded" "API" "http://yahoo.com"
```

## More reading

* [Legacy actionable message card reference](https://docs.microsoft.com/en-gb/outlook/actionable-messages/message-card-reference) - only card reference which works for MS Teams!!!
* [Card Design Playground](https://messagecardplayground.azurewebsites.net/)
* [Build definition variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables)
* [Using Connectors]("https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/connectors/connectors-using")