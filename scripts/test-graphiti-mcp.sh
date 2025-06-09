#!/bin/bash

# Test Graphiti MCP Server
echo "Testing Graphiti MCP Server..."

# Create a test initialization request
cat << 'EOF' | /opt/homebrew/bin/uv run --isolated --directory /Users/recondite/Documents/GitHub/graphiti/mcp_server --project . graphiti_mcp_server.py --transport stdio
{"jsonrpc": "2.0", "method": "initialize", "params": {"capabilities": {}}, "id": 1}
{"jsonrpc": "2.0", "method": "tools/list", "params": {}, "id": 2}
EOF 