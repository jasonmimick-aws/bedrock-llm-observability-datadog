# Deployment Options

This guide provides instructions for running the LLM Observability project both locally and on AWS SageMaker, following AWS Well-Architected best practices.

## Local Development (Quick Start)

Follow these steps to run the notebooks locally:

1. **Set up your environment**:
   ```bash
   # Create and activate virtual environment
   python -m venv .venv
   source .venv/bin/activate  # On Windows: .venv\Scripts\activate
   
   # Install dependencies
   pip install -r requirements.txt
   ```

2. **Configure environment variables**:
   Create a `.env` file with:
   ```
   DD_API_KEY=<YOUR_DATADOG_API_KEY>
   DD_SITE=<YOUR_DATADOG_SITE>
   DD_LLMOBS_AGENTLESS_ENABLED=1
   DD_LLMOBS_ML_APP="onboarding-quickstart"
   
   # AWS credentials (if not using AWS CLI profiles)
   AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
   AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
   AWS_REGION=<YOUR_AWS_REGION>
   ```

3. **Launch Jupyter**:
   ```bash
   jupyter notebook
   ```

4. Open and run the notebooks in order.

## AWS SageMaker Deployment

### Option 1: Manual Setup

1. **Create an IAM Role for SageMaker**:
   - Navigate to IAM in the AWS Console
   - Create a new role with `AmazonSageMakerFullAccess`
   - Add these additional policies:
     - `AmazonBedrockFullAccess` (or a custom policy with `bedrock:InvokeModel`)
     - `AmazonS3ReadOnlyAccess` (or appropriate S3 permissions)

2. **Launch a SageMaker Notebook Instance**:
   - Navigate to SageMaker in the AWS Console
   - Create a new notebook instance
   - Select the IAM role created above
   - Choose an appropriate instance type (ml.t3.medium recommended)
   - Under "Additional configuration", add these environment variables:
     ```
     DD_API_KEY=<YOUR_DATADOG_API_KEY>
     DD_SITE=<YOUR_DATADOG_SITE>
     DD_LLMOBS_AGENTLESS_ENABLED=1
     DD_LLMOBS_ML_APP="onboarding-quickstart"
     ```
   - Create the instance

3. **Clone the Repository**:
   - Open JupyterLab
   - Open a terminal and run:
     ```bash
     git clone https://github.com/yourusername/llm-observability-datadog.git
     cd llm-observability-datadog
     pip install -r requirements.txt
     ```

4. Run the notebooks.

### Option 2: Automated Deployment with CloudFormation

For repeatable deployments (workshops, immersion days), use the provided CloudFormation template:

1. **Deploy the Stack**:
   ```bash
   aws cloudformation create-stack \
     --stack-name llm-observability-workshop \
     --template-body file://deployment/cloudformation/sagemaker-template.yaml \
     --parameters ParameterKey=DatadogApiKey,ParameterValue=<YOUR_DD_API_KEY> \
                  ParameterKey=DatadogSite,ParameterValue=<YOUR_DD_SITE> \
     --capabilities CAPABILITY_IAM
   ```

2. Once deployed, access the SageMaker notebook instance from the AWS Console.

## Workshop/Immersion Day Setup

For running workshops:

1. **Instructor Setup**:
   - Deploy using CloudFormation template
   - Provide participants with temporary AWS accounts
   - Pre-configure Datadog API keys

2. **Participant Instructions**:
   - Log into provided AWS account
   - Navigate to SageMaker
   - Open the pre-configured notebook instance
   - Follow the workshop guide

## Well-Architected Considerations

This deployment follows AWS Well-Architected best practices:

- **Security**: IAM roles with least privilege, no hardcoded credentials
- **Reliability**: Isolated environments, dependency management
- **Performance**: Right-sized SageMaker instances
- **Cost Optimization**: Auto-shutdown of notebook instances when idle
- **Operational Excellence**: Infrastructure as Code for repeatable deployments
