# TFS-Build-To-MS-Teams-Notifications

Powershell script for sending in information to Microsoft Teams via incoming web-hook, customised for an Azure DevOps / TFVC build server. For example, a success message is sent into Teams when a build has succeeded. It will determine some automatically created Azure variables and populate a message into Teams.

## Build Definition

In the build definition, add powershell step with:

* Script filename: `$(Agent.HomeDirectory)\message-teams.ps1`
* Arguments: `'https://outlook.office.com/webhook/<myTeamsIncommingWebHookURL>'`

## Screenshot

Example build success message:

![screenshot](screenshot%20of%20alert.png)


## More reading

* [Legacy actionable message card reference](https://docs.microsoft.com/en-gb/outlook/actionable-messages/message-card-reference) - only card reference which works for MS Teams!!!
* [Card Design Playground](https://messagecardplayground.azurewebsites.net/)
* [Build definition variables](https://docs.microsoft.com/en-us/azure/devops/pipelines/build/variables)
* [Using Connectors](https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/connectors/connectors-using)
