# LLM Observability Workshop Guide

This guide provides instructions for running a workshop or immersion day using the LLM Observability project with Amazon Bedrock and Datadog.

## Workshop Prerequisites

### For Instructors

1. **AWS Account Setup**:
   - Ensure Amazon Bedrock is enabled in your AWS account
   - Verify model access for Claude models
   - Consider using AWS Organizations for multi-account workshops

2. **Datadog Setup**:
   - Create a Datadog organization or use an existing one
   - Generate API keys for participants
   - Set up a dashboard template for the workshop

3. **Repository Preparation**:
   - Fork or clone this repository
   - Update the CloudFormation template with your repository URL
   - Test the deployment process end-to-end

### For Participants

1. **AWS Console Access**:
   - AWS account credentials (provided by instructor)
   - Basic familiarity with AWS console

2. **Datadog Access**:
   - Datadog account credentials (provided by instructor)
   - Datadog API key (provided by instructor)

## Workshop Setup Options

### Option 1: Pre-provisioned Environment (Recommended for Workshops)

As an instructor, deploy the environment for all participants:

1. **Deploy CloudFormation Stack for Each Participant**:
   ```bash
   aws cloudformation create-stack \
     --stack-name llm-observability-participant-{ID} \
     --template-body file://deployment/cloudformation/sagemaker-template.yaml \
     --parameters ParameterKey=DatadogApiKey,ParameterValue={DD_API_KEY} \
                  ParameterKey=DatadogSite,ParameterValue={DD_SITE} \
     --capabilities CAPABILITY_IAM
   ```

2. **Provide Access Instructions to Participants**:
   - Share AWS console login details
   - Direct participants to the SageMaker notebook instance
   - Provide Datadog login information

### Option 2: Self-Service Deployment

Participants deploy their own environments:

1. **Clone Repository**:
   ```bash
   git clone https://github.com/yourusername/llm-observability-datadog.git
   cd llm-observability-datadog
   ```

2. **Run Setup Script**:
   ```bash
   chmod +x deployment/setup.sh
   ./deployment/setup.sh --sagemaker
   ```

3. **Access SageMaker Notebook**:
   - Navigate to SageMaker in the AWS Console
   - Open the notebook instance
   - Follow the workshop notebooks

## Workshop Agenda (3 hours)

1. **Introduction (30 minutes)**
   - Overview of LLM observability
   - Introduction to Datadog's LLM monitoring capabilities
   - Amazon Bedrock overview

2. **Hands-on Lab 1: Simple LLM Call (30 minutes)**
   - Complete the `1-llm-span.ipynb` notebook
   - Explore the generated traces in Datadog

3. **Hands-on Lab 2: LLM Workflow (30 minutes)**
   - Complete the `2-workflow-span.ipynb` notebook
   - Analyze workflow traces and metrics

4. **Break (15 minutes)**

5. **Hands-on Lab 3: LLM Agent (45 minutes)**
   - Complete the `3-agent-span.ipynb` notebook
   - Understand agent decision-making observability

6. **Hands-on Lab 4: RAG Evaluation (45 minutes)**
   - Complete the `4-custom-evaluations.ipynb` notebook
   - Learn about evaluating RAG workflows

7. **Wrap-up and Q&A (15 minutes)**
   - Best practices discussion
   - Next steps for production deployment

## Clean-up Instructions

### For Self-Deployed Environments

Participants should delete their CloudFormation stacks:

```bash
aws cloudformation delete-stack --stack-name llm-observability-workshop
```

### For Instructor-Managed Environments

Instructors should delete all participant stacks:

```bash
aws cloudformation delete-stack --stack-name llm-observability-participant-{ID}
```

## Additional Resources

- [Datadog LLM Observability Documentation](https://docs.datadoghq.com/llm_observability/)
- [Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)
- [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)
- [SageMaker Documentation](https://docs.aws.amazon.com/sagemaker/)
