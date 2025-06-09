#!/bin/bash
export ENV=local
export TOKENIZERS_PARALLELISM=false

# 🔗 Embedding Config (OpenAI)
export EMBEDDING_PROVIDER="openai"
export EMBEDDING_MODEL="text-embedding-3-small"
export EMBEDDING_DIMENSIONS=1536
export EMBEDDING_MAX_TOKENS=8191

# 🔐 OpenAI Key (required for embeddings + LLM)
export LLM_API_KEY="${OPENAI_API_KEY:-}"

# 🚀 Launch MCP server with stdio transport (default)
cd /Users/recondite/cognee/cognee-mcp
source .venv/bin/activate
python src/server.py 