# Microsoft-Teams-Connector

Powershell script for sending in information to Microsoft Teams via incoming web-hook, for example, when a build has succeeded. See the [official instructions]("https://docs.microsoft.com/en-us/microsoftteams/platform/concepts/connectors/connectors-using") for how to send more complicated "cards" into MS Teams.

## Preparation

Create a file called `MSTeamsWebhook.ps1` with this content:

```Powershell
$teamsWebhookUrl = 'https://outlook.office.com/webhook/<myTeamsIncommingWebHookURL>'
```

## Running the script

Call this script with:

```Powershell
message-send.ps1 "BuildNumber" "Environment"
```

e.g.

```Powershell
message-send.ps1 "1.2" "PROD"
```
