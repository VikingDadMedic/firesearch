#!/bin/bash

# Graphiti MCP Server Wrapper Script
# This script ensures proper environment setup and logging

# Set up environment variables
export NEO4J_URI="${NEO4J_URI:-bolt://localhost:7687}"
export NEO4J_USER="${NEO4J_USER:-neo4j}"
export NEO4J_PASSWORD="${NEO4J_PASSWORD:-}"
export OPENAI_API_KEY="${OPENAI_API_KEY:-}"
export MODEL_NAME="${MODEL_NAME:-gpt-4o}"
export SMALL_MODEL_NAME="${SMALL_MODEL_NAME:-gpt-4o-mini}"
export EMBEDDER_MODEL_NAME="${EMBEDDER_MODEL_NAME:-text-embedding-3-large}"
export LLM_TEMPERATURE="${LLM_TEMPERATURE:-0.1}"
export SEMAPHORE_LIMIT="${SEMAPHORE_LIMIT:-40}"
export MAX_REFLEXION_ITERATIONS="${MAX_REFLEXION_ITERATIONS:-3}"

# Log file for debugging
LOG_FILE="/tmp/graphiti-mcp-debug.log"

echo "[$(date)] Starting Graphiti MCP Server" >> "$LOG_FILE"
echo "[$(date)] Environment variables set" >> "$LOG_FILE"

# Change to the correct directory
cd /Users/recondite/Documents/GitHub/graphiti/mcp_server

# Run the server with logging
exec /opt/homebrew/bin/uv run --isolated --directory . --project . graphiti_mcp_server.py --transport stdio 2>> "$LOG_FILE" 