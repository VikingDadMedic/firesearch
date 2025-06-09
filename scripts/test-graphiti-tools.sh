#!/bin/bash

# Test Graphiti MCP Server Tools
echo "Testing Graphiti MCP Server Tools..."

# Create a temporary file with test commands
cat > /tmp/graphiti-test-commands.txt << 'EOF'
{"jsonrpc": "2.0", "method": "initialize", "params": {"capabilities": {}}, "id": 1}
{"jsonrpc": "2.0", "method": "tools/list", "params": {}, "id": 2}
EOF

# Run the test
echo "Sending initialization and tools/list requests..."
cat /tmp/graphiti-test-commands.txt | /Users/recondite/Documents/GitHub/firesearch/scripts/graphiti-mcp-wrapper.sh

# Clean up
rm -f /tmp/graphiti-test-commands.txt

echo ""
echo "Check /tmp/graphiti-mcp-debug.log for any error messages" 