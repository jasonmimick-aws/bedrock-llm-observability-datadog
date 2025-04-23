# LLM Observability with Amazon Bedrock and Datadog
## Deployment Options Demo

---

## Introduction

This presentation demonstrates how to deploy and run LLM observability notebooks using:
- Amazon Bedrock for LLM capabilities
- Datadog for observability
- Multiple deployment options (local or SageMaker)

---

## Project Overview

- **Purpose**: Demonstrate LLM observability with Datadog's SDK
- **Models**: Amazon Bedrock (Claude)
- **Notebooks**: Progressive learning path from basic to advanced
- **Deployment**: Flexible options for different use cases

---

## Why This Matters

- **Visibility**: Gain insights into LLM performance and behavior
- **Optimization**: Identify areas for improvement
- **Governance**: Track usage, costs, and compliance
- **Flexibility**: Run anywhere - locally or on AWS

---

## Deployment Options

### Option 1: Local Development
- Quick setup for individual exploration
- Minimal requirements
- Great for learning and experimentation

### Option 2: AWS SageMaker
- Managed environment with scalable resources
- IAM-based authentication (no credential management)
- Perfect for workshops and team collaboration

---

## Demo: Local Deployment

```bash
# Clone the repository
git clone https://github.com/jasonmimick-aws/bedrock-llm-observability-datadog.git
cd bedrock-llm-observability-datadog

# Run the setup script
chmod +x deployment/setup.sh
./deployment/setup.sh --local

# Launch Jupyter
jupyter notebook
```

---

## Demo: SageMaker Deployment

```bash
# Clone the repository
git clone https://github.com/jasonmimick-aws/bedrock-llm-observability-datadog.git
cd bedrock-llm-observability-datadog

# Deploy to SageMaker
chmod +x deployment/setup.sh
./deployment/setup.sh --sagemaker

# Access notebooks via SageMaker console
```

---

## Architecture: SageMaker Deployment

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │     │                 │
│  SageMaker      │────▶│  Amazon         │────▶│  Datadog        │
│  Notebook       │     │  Bedrock        │     │  Observability  │
│                 │     │                 │     │                 │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

---

## Well-Architected Benefits

- **Security**: IAM roles with least privilege
- **Reliability**: Consistent, automated setup
- **Performance**: Right-sized resources
- **Cost**: Pay only for what you use
- **Operational Excellence**: Infrastructure as Code

---

## Notebook 1: Simple LLM Call

- Basic LLM call with Claude
- Trace generation and visualization
- Performance metrics

![LLM Span](../images/llm-span.png)

---

## Notebook 2: LLM Workflow

- Multi-step LLM workflow
- Tool integration
- Tracing complex operations

![Workflow Span](../images/workflow-span.png)

---

## Notebook 3: LLM Agent

- Agent-based decision making
- Dynamic tool selection
- Observability for complex reasoning

![Agent Span](../images/agent-span.png)

---

## Notebook 4: RAG Evaluation

- Retrieval Augmented Generation
- Custom evaluations
- Quality metrics

![RAG Span](../images/rag-span.png)

---

## Workshop Capabilities

- **Pre-provisioned environments**: Quick start for participants
- **Guided exercises**: Progressive learning path
- **Shared infrastructure**: Consistent experience
- **Cleanup automation**: Easy teardown

---

## Production Considerations

- **Scaling**: From notebooks to endpoints
- **Monitoring**: Comprehensive observability
- **Security**: Enterprise-grade controls
- **Cost optimization**: Right-sized resources

---

## Next Steps

- Try both deployment options
- Explore the notebooks
- Customize for your use cases
- Contribute improvements

---

## Resources

- [GitHub Repository](https://github.com/jasonmimick-aws/bedrock-llm-observability-datadog)
- [Datadog LLM Observability](https://docs.datadoghq.com/llm_observability/)
- [Amazon Bedrock](https://aws.amazon.com/bedrock/)
- [AWS SageMaker](https://aws.amazon.com/sagemaker/)

---

## Q&A

Thank you for your attention!
