# LLM Observability Demo Script

This script provides a step-by-step guide for demonstrating the LLM Observability project with both local and SageMaker deployment options.

## Setup Before Demo

1. Ensure you have:
   - AWS account with Bedrock access
   - Datadog account with API key
   - Git installed
   - AWS CLI configured

2. Clone the repository:
   ```bash
   git clone https://github.com/jasonmimick-aws/bedrock-llm-observability-datadog.git
   cd bedrock-llm-observability-datadog
   ```

## Demo Part 1: Introduction (5 minutes)

### Script:
"Today I'll demonstrate how to deploy and use LLM observability with Amazon Bedrock and Datadog. This project provides Jupyter notebooks that show you how to instrument LLM applications for comprehensive observability.

What makes this project special is its flexible deployment options - you can run it locally for quick experimentation or deploy it to AWS SageMaker for a managed, scalable environment. Both options are fully automated with our setup scripts.

Let me show you how it works."

## Demo Part 2: Local Deployment (10 minutes)

### Script:
"First, let's look at the local deployment option. This is perfect for individual developers who want to experiment with LLM observability on their own machines."

### Actions:
1. Show the repository structure:
   ```bash
   ls -la
   ```

2. Highlight the deployment directory:
   ```bash
   ls -la deployment/
   ```

3. Run the local setup script:
   ```bash
   chmod +x deployment/setup.sh
   ./deployment/setup.sh --local
   ```

4. Show the created virtual environment and .env file:
   ```bash
   ls -la .venv/
   cat .env
   ```

5. Activate the environment and start Jupyter:
   ```bash
   source .venv/bin/activate
   jupyter notebook
   ```

6. Open and briefly explain notebook 1 (1-llm-span.ipynb)
   - Show the imports and setup
   - Highlight the Datadog instrumentation
   - Run a simple LLM call
   - Show the generated trace

## Demo Part 3: SageMaker Deployment (15 minutes)

### Script:
"Now, let's look at the SageMaker deployment option. This is ideal for teams, workshops, or production environments where you want a managed, scalable solution."

### Actions:
1. Show the CloudFormation template:
   ```bash
   cat deployment/cloudformation/sagemaker-template.yaml
   ```
   Highlight:
   - IAM role creation
   - SageMaker notebook instance
   - Lifecycle configuration

2. Run the SageMaker setup script:
   ```bash
   ./deployment/setup.sh --sagemaker
   ```

3. While it's deploying, explain the benefits:
   - Managed environment
   - IAM-based authentication
   - Pre-configured dependencies
   - Consistent experience for all users

4. Once deployed, open the AWS Console and navigate to SageMaker
   - Show the notebook instance
   - Open JupyterLab
   - Navigate to the cloned repository
   - Open and run a notebook

5. Show the Datadog dashboard with traces from both environments

## Demo Part 4: Workshop Capabilities (5 minutes)

### Script:
"This project is also designed for workshops and immersion days. Let me show you how it supports educational use cases."

### Actions:
1. Show the workshop guide:
   ```bash
   cat deployment/workshop-guide.md
   ```

2. Highlight key features:
   - Pre-provisioned environments
   - Step-by-step instructions
   - Comprehensive agenda
   - Cleanup procedures

## Demo Part 5: Production Considerations (5 minutes)

### Script:
"Finally, let's look at how this project supports production deployments."

### Actions:
1. Show the production deployment guide:
   ```bash
   cat deployment/production-deployment.md
   ```

2. Highlight key recommendations:
   - SageMaker endpoints
   - AWS Lambda options
   - Container deployments
   - Well-Architected considerations

## Demo Part 6: Q&A (10 minutes)

Open the floor for questions and discussion.

## Cleanup After Demo

1. For local deployment:
   ```bash
   deactivate
   ```

2. For SageMaker deployment:
   ```bash
   aws cloudformation delete-stack --stack-name llm-observability-workshop
   ```
