# Amazon Q Integration

This project has been updated to use Amazon Bedrock instead of OpenAI for LLM integration. The changes include:

1. Updated prerequisites in README.md to require AWS credentials and Amazon Bedrock access
2. Modified environment variable setup to use AWS credentials instead of OpenAI API key
3. Updated notebook examples to use Amazon Bedrock's Claude models
4. Maintained all Datadog integration and observability features

## Key Changes

- Replaced OpenAI client with Amazon Bedrock client
- Updated model references from GPT to Claude
- Modified API call formats to match Amazon Bedrock requirements
- Updated documentation to reflect Amazon Bedrock usage

## Benefits

- Leverages AWS's secure and scalable infrastructure
- Provides access to Anthropic's Claude models
- Maintains full compatibility with Datadog's LLM Observability features
- Simplifies AWS customer experience by using services within their ecosystem

## Next Steps

Consider enhancing the examples with additional Amazon Bedrock features such as:
- Knowledge bases
- Model customization
- Guardrails
- Batch inference
