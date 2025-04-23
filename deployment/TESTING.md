# Testing Guide: SageMaker Deployment

This guide provides step-by-step instructions for testing the SageMaker deployment option and scaling it up for broader use cases such as workshops or production environments.

## Prerequisites

Before you begin testing, ensure you have:

- AWS CLI installed and configured with appropriate credentials
- Permissions to create SageMaker resources and IAM roles
- A Datadog account with an API key
- Access to Amazon Bedrock models (Claude)

## Phase 1: Initial Testing

### Step 1: Single Instance Deployment

1. Clone the repository (if you haven't already):
   ```bash
   git clone https://github.com/jasonmimick-aws/bedrock-llm-observability-datadog.git
   cd bedrock-llm-observability-datadog
   ```

2. Make the setup script executable:
   ```bash
   chmod +x deployment/setup.sh
   ```

3. Run the setup script with SageMaker option:
   ```bash
   ./deployment/setup.sh --sagemaker
   ```
   
   When prompted:
   - Enter your Datadog API key
   - Specify your Datadog site (default: datadoghq.com)

4. Monitor the CloudFormation stack creation:
   ```bash
   aws cloudformation describe-stacks --stack-name llm-observability-workshop --query "Stacks[0].StackStatus"
   ```

5. Once the stack status is `CREATE_COMPLETE` (typically 5-10 minutes), access your notebook:
   - Go to the AWS Console
   - Navigate to SageMaker
   - Find your notebook instance (named "llm-observability-workshop" by default)
   - Click "Open JupyterLab" when the instance status is "InService"

### Step 2: Verify Functionality

1. In JupyterLab, navigate to the cloned repository folder

2. Open and run `1-llm-span.ipynb`:
   - Execute all cells
   - Verify that the LLM call to Bedrock succeeds
   - Check that traces appear in your Datadog account

3. Test the remaining notebooks:
   - `2-workflow-span.ipynb`
   - `3-agent-span.ipynb`
   - `4-custom-evaluations.ipynb`

4. Verify in Datadog:
   - Navigate to the LLM Observability section in Datadog
   - Confirm that traces are appearing
   - Check that metadata and tags are correctly applied

### Step 3: Clean Up Test Resources

When you're done testing, clean up the resources:

```bash
aws cloudformation delete-stack --stack-name llm-observability-workshop
```

## Phase 2: Scaling for Workshops

### Step 1: Customize the CloudFormation Template

For workshops with multiple participants, you may want to customize the template:

1. Edit `deployment/cloudformation/sagemaker-template.yaml`:
   - Adjust instance types for expected workload
   - Add additional parameters if needed
   - Consider adding resource tags for cost tracking

2. Create a parameter file for consistent deployments:
   ```bash
   cat > workshop-parameters.json << EOF
   [
     {
       "ParameterKey": "NotebookInstanceType",
       "ParameterValue": "ml.t3.medium"
     },
     {
       "ParameterKey": "DatadogSite",
       "ParameterValue": "datadoghq.com"
     }
   ]
   EOF
   ```

### Step 2: Deploy Multiple Instances

For workshops, you can deploy multiple instances with unique names:

```bash
# Create a script to deploy multiple instances
cat > deploy-workshop.sh << 'EOF'
#!/bin/bash

# Number of participants
PARTICIPANT_COUNT=10

# Datadog API key
DD_API_KEY="your-datadog-api-key"

# Deploy for each participant
for i in $(seq 1 $PARTICIPANT_COUNT); do
  STACK_NAME="llm-workshop-participant-$i"
  
  aws cloudformation create-stack \
    --stack-name "$STACK_NAME" \
    --template-body file://deployment/cloudformation/sagemaker-template.yaml \
    --parameters \
        ParameterKey=DatadogApiKey,ParameterValue="$DD_API_KEY" \
        ParameterKey=DatadogSite,ParameterValue="datadoghq.com" \
        ParameterKey=NotebookInstanceType,ParameterValue="ml.t3.medium" \
        ParameterKey=MlAppName,ParameterValue="workshop-participant-$i" \
    --capabilities CAPABILITY_IAM
    
  echo "Deployed stack $STACK_NAME"
done
EOF

chmod +x deploy-workshop.sh
```

### Step 3: Monitor Workshop Deployments

Create a script to monitor the status of all workshop deployments:

```bash
cat > monitor-workshop.sh << 'EOF'
#!/bin/bash

# Number of participants
PARTICIPANT_COUNT=10

# Check status for each participant
for i in $(seq 1 $PARTICIPANT_COUNT); do
  STACK_NAME="llm-workshop-participant-$i"
  
  STATUS=$(aws cloudformation describe-stacks --stack-name "$STACK_NAME" --query "Stacks[0].StackStatus" --output text 2>/dev/null || echo "NOT_FOUND")
  
  echo "Participant $i: $STATUS"
done
EOF

chmod +x monitor-workshop.sh
```

### Step 4: Clean Up Workshop Resources

Create a cleanup script:

```bash
cat > cleanup-workshop.sh << 'EOF'
#!/bin/bash

# Number of participants
PARTICIPANT_COUNT=10

# Delete stacks for each participant
for i in $(seq 1 $PARTICIPANT_COUNT); do
  STACK_NAME="llm-workshop-participant-$i"
  
  aws cloudformation delete-stack --stack-name "$STACK_NAME"
  
  echo "Deleting stack $STACK_NAME"
done
EOF

chmod +x cleanup-workshop.sh
```

## Phase 3: Scaling for Production

### Step 1: Create a Production-Ready Template

For production use, consider these enhancements:

1. Create a production-specific CloudFormation template:
   ```bash
   cp deployment/cloudformation/sagemaker-template.yaml deployment/cloudformation/production-template.yaml
   ```

2. Edit the production template to add:
   - VPC configuration for enhanced security
   - KMS encryption for notebook storage
   - Resource tagging for cost allocation
   - Larger instance types for better performance

### Step 2: Deploy Production Environment

Deploy the production environment:

```bash
aws cloudformation create-stack \
  --stack-name "llm-observability-production" \
  --template-body file://deployment/cloudformation/production-template.yaml \
  --parameters \
      ParameterKey=DatadogApiKey,ParameterValue="your-datadog-api-key" \
      ParameterKey=DatadogSite,ParameterValue="datadoghq.com" \
      ParameterKey=NotebookInstanceType,ParameterValue="ml.m5.xlarge" \
      ParameterKey=MlAppName,ParameterValue="llm-production" \
  --capabilities CAPABILITY_IAM
```

### Step 3: Convert Notebooks to Production Services

For production use, consider converting notebooks to SageMaker endpoints:

1. Create a model deployment script:
   ```python
   import boto3
   import sagemaker
   from sagemaker.model import Model
   
   role = "your-sagemaker-execution-role"
   
   # Create a model from your container
   model = Model(
       image_uri="your-container-image",
       model_data="s3://your-bucket/model-artifacts/",
       role=role,
       env={
           "DD_API_KEY": "your-datadog-api-key",
           "DD_SITE": "datadoghq.com",
           "DD_LLMOBS_AGENTLESS_ENABLED": "1",
           "DD_LLMOBS_ML_APP": "llm-production"
       }
   )
   
   # Deploy the model to an endpoint
   predictor = model.deploy(
       initial_instance_count=1,
       instance_type="ml.m5.xlarge",
       endpoint_name="llm-observability-endpoint"
   )
   ```

2. Set up auto-scaling for your endpoint:
   ```python
   client = boto3.client('application-autoscaling')
   
   client.register_scalable_target(
       ServiceNamespace='sagemaker',
       ResourceId='endpoint/llm-observability-endpoint/variant/AllTraffic',
       ScalableDimension='sagemaker:variant:DesiredInstanceCount',
       MinCapacity=1,
       MaxCapacity=5
   )
   
   client.put_scaling_policy(
       PolicyName='LlmScalingPolicy',
       ServiceNamespace='sagemaker',
       ResourceId='endpoint/llm-observability-endpoint/variant/AllTraffic',
       ScalableDimension='sagemaker:variant:DesiredInstanceCount',
       PolicyType='TargetTrackingScaling',
       TargetTrackingScalingPolicyConfiguration={
           'TargetValue': 70.0,
           'PredefinedMetricSpecification': {
               'PredefinedMetricType': 'SageMakerVariantInvocationsPerInstance'
           },
           'ScaleInCooldown': 300,
           'ScaleOutCooldown': 60
       }
   )
   ```

## Troubleshooting

### Common Issues and Solutions

1. **CloudFormation Stack Creation Fails**:
   - Check IAM permissions
   - Verify service quotas for SageMaker instances
   - Look at CloudFormation events for specific errors

2. **Notebook Instance Fails to Start**:
   - Check the lifecycle configuration logs
   - Verify network connectivity
   - Ensure Bedrock service is available in your region

3. **Bedrock API Calls Fail**:
   - Verify Bedrock model access
   - Check IAM permissions for Bedrock
   - Ensure region supports the requested models

4. **Datadog Traces Not Appearing**:
   - Verify API key is correct
   - Check network connectivity to Datadog
   - Ensure environment variables are properly set

### Getting Support

If you encounter issues:

1. Check the CloudFormation stack events:
   ```bash
   aws cloudformation describe-stack-events --stack-name llm-observability-workshop
   ```

2. Check SageMaker notebook logs:
   ```bash
   aws logs get-log-events --log-group-name /aws/sagemaker/NotebookInstances --log-stream-name [notebook-name]/[log-stream]
   ```

3. Open an issue on the GitHub repository with:
   - Detailed error description
   - Steps to reproduce
   - CloudFormation stack events (if applicable)
   - Notebook logs (if applicable)
