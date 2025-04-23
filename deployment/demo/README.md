# LLM Observability Demo Materials

This directory contains materials for demonstrating the LLM Observability project with Amazon Bedrock and Datadog.

## Contents

- **presentation.md**: Markdown-based presentation slides
- **demo-script.md**: Step-by-step script for live demonstrations
- **screenshots/**: Directory containing demo screenshots (to be added)

## Running the Demo

### Prerequisites

- AWS account with Bedrock access
- Datadog account with API key
- Git installed
- AWS CLI configured

### Presentation Options

1. **Markdown Presentation**:
   - Use a markdown presentation tool like [Marp](https://marp.app/) or [Slidev](https://sli.dev/) to convert presentation.md to slides
   - Example: `marp --pdf presentation.md`

2. **Live Demo**:
   - Follow the demo-script.md for a step-by-step walkthrough
   - Prepare both local and SageMaker environments beforehand

### Demo Flow

The recommended demo flow is:

1. Introduction to the project (5 minutes)
2. Local deployment demonstration (10 minutes)
3. SageMaker deployment demonstration (15 minutes)
4. Workshop capabilities overview (5 minutes)
5. Production considerations (5 minutes)
6. Q&A (10 minutes)

Total time: Approximately 50 minutes

## Customizing the Demo

Feel free to customize the demo materials for your specific audience:

- For developers: Focus on the instrumentation code and observability features
- For operations teams: Emphasize deployment options and monitoring capabilities
- For executives: Highlight business benefits and cost optimization
- For workshops: Concentrate on the hands-on learning experience

## Screenshots

To add screenshots to your presentation:

1. Create a screenshots directory:
   ```bash
   mkdir -p deployment/demo/screenshots
   ```

2. Capture relevant screenshots:
   - Datadog LLM traces
   - SageMaker notebook instance
   - CloudFormation deployment
   - Running notebooks

3. Reference them in your presentation:
   ```markdown
   ![Datadog Trace](./screenshots/datadog-trace.png)
   ```

## Additional Resources

- [Datadog LLM Observability Documentation](https://docs.datadoghq.com/llm_observability/)
- [Amazon Bedrock Documentation](https://docs.aws.amazon.com/bedrock/)
- [AWS SageMaker Documentation](https://docs.aws.amazon.com/sagemaker/)
