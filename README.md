# OpenAIMultiModel
Deploys an Azure AI Service with multiple OpenAI models (Dall-E, GPT-4o, GPT-35-turbo)

This scenario is relying on [Azure Developer CLI - AZD](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/) to run the deployment.

If you already have AZD installed, run the following to initialize the scenario (=what this does is running a 'git clone' to download the deployment artifacts to your local development machine)

```
azd init -t petender/OpenAIMultiModel
```

Followed by:

```
azd up
``` 

to trigger the actual deployment. You will be asked for your Azure subscription and desired location to deploy the Resource Group, Azure AI Service and the different AI models.

