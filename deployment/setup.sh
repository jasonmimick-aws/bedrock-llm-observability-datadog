#!/bin/bash
# Setup script for LLM Observability Workshop

set -e

# Parse command line arguments
DEPLOY_TYPE="local"
STACK_NAME="llm-observability-workshop"
INSTANCE_TYPE="ml.t3.medium"

print_usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  --local                  Setup for local development (default)"
  echo "  --sagemaker              Deploy to AWS SageMaker"
  echo "  --stack-name NAME        CloudFormation stack name (default: llm-observability-workshop)"
  echo "  --instance-type TYPE     SageMaker instance type (default: ml.t3.medium)"
  echo "  --help                   Print this help message"
}

while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --local)
      DEPLOY_TYPE="local"
      shift
      ;;
    --sagemaker)
      DEPLOY_TYPE="sagemaker"
      shift
      ;;
    --stack-name)
      STACK_NAME="$2"
      shift
      shift
      ;;
    --instance-type)
      INSTANCE_TYPE="$2"
      shift
      shift
      ;;
    --help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      exit 1
      ;;
  esac
done

# Local setup
if [ "$DEPLOY_TYPE" == "local" ]; then
  echo "Setting up local development environment..."
  
  # Check if Python is installed
  if ! command -v python3 &> /dev/null; then
    echo "Python 3 is required but not installed. Please install Python 3 and try again."
    exit 1
  fi
  
  # Create virtual environment
  echo "Creating virtual environment..."
  python3 -m venv .venv
  
  # Activate virtual environment
  echo "Activating virtual environment..."
  source .venv/bin/activate
  
  # Install dependencies
  echo "Installing dependencies..."
  pip install -r requirements.txt
  
  # Check for .env file
  if [ ! -f .env ]; then
    echo "Creating .env file template..."
    cat > .env << EOT
DD_API_KEY=<YOUR_DATADOG_API_KEY>
DD_SITE=datadoghq.com
DD_LLMOBS_AGENTLESS_ENABLED=1
DD_LLMOBS_ML_APP="onboarding-quickstart"

# AWS credentials (if not using AWS CLI profiles)
# AWS_ACCESS_KEY_ID=<YOUR_AWS_ACCESS_KEY_ID>
# AWS_SECRET_ACCESS_KEY=<YOUR_AWS_SECRET_ACCESS_KEY>
# AWS_REGION=<YOUR_AWS_REGION>
EOT
    echo "Please edit the .env file with your credentials"
  fi
  
  echo "Local setup complete! Run 'source .venv/bin/activate' to activate the environment"
  echo "Then run 'jupyter notebook' to start Jupyter"

# SageMaker setup
elif [ "$DEPLOY_TYPE" == "sagemaker" ]; then
  echo "Deploying to AWS SageMaker..."
  
  # Check if AWS CLI is installed
  if ! command -v aws &> /dev/null; then
    echo "AWS CLI is required but not installed. Please install AWS CLI and try again."
    exit 1
  fi
  
  # Check AWS credentials
  echo "Checking AWS credentials..."
  aws sts get-caller-identity > /dev/null || { echo "AWS credentials not configured. Please run 'aws configure' first."; exit 1; }
  
  # Prompt for Datadog API key
  read -p "Enter your Datadog API key: " DD_API_KEY
  read -p "Enter your Datadog site (default: datadoghq.com): " DD_SITE
  DD_SITE=${DD_SITE:-datadoghq.com}
  
  # Create CloudFormation stack
  echo "Creating CloudFormation stack: $STACK_NAME"
  aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body file://deployment/cloudformation/sagemaker-template.yaml \
    --parameters \
        ParameterKey=DatadogApiKey,ParameterValue="$DD_API_KEY" \
        ParameterKey=DatadogSite,ParameterValue="$DD_SITE" \
        ParameterKey=NotebookInstanceType,ParameterValue="$INSTANCE_TYPE" \
    --capabilities CAPABILITY_IAM
  
  echo "Stack creation initiated. You can check the status in the AWS CloudFormation console."
  echo "Once complete, access your notebook from the SageMaker console."
fi
