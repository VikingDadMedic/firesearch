# MCP Integration Plan for Firesearch

## 1. Architecture Changes

### A. Create MCP Service Layer
```typescript
// lib/mcp-service.ts
export interface MCPTool {
  name: string;
  description: string;
  execute: (params: any) => Promise<MCPResult>;
}

export class MCPService {
  private tools: Map<string, MCPTool>;
  
  constructor() {
    this.tools = new Map();
    this.registerTools();
  }
  
  registerTool(tool: MCPTool) {
    this.tools.set(tool.name, tool);
  }
  
  async callTool(toolName: string, params: any): Promise<MCPResult> {
    const tool = this.tools.get(toolName);
    if (!tool) throw new Error(`Tool ${toolName} not found`);
    return tool.execute(params);
  }
}
```

### B. Extend SearchStateAnnotation
```typescript
// In lib/langgraph-search-engine.ts
const SearchStateAnnotation = Annotation.Root({
  // ... existing fields ...
  
  // New MCP-related fields
  mcpTools: Annotation<string[]>({
    reducer: (x, y) => y ?? x,
    default: () => []
  }),
  mcpResults: Annotation<MCPResult[]>({
    reducer: (existing, update) => [...existing, ...update],
    default: () => []
  }),
  dataSourceStrategy: Annotation<'web' | 'mcp' | 'hybrid'>({
    reducer: (x, y) => y ?? x,
    default: () => 'hybrid'
  })
});
```

### C. Add MCP Research Node
```typescript
// In buildGraph() method
.addNode("mcpResearch", async (state: SearchState, config?: GraphConfig) => {
  const eventCallback = config?.configurable?.eventCallback;
  
  if (eventCallback) {
    eventCallback({
      type: 'mcp-research',
      message: 'Querying specialized data sources...'
    });
  }
  
  const mcpService = new MCPService();
  const results: MCPResult[] = [];
  
  // Example: Use different MCP tools based on query type
  if (state.query.includes('code') || state.query.includes('github')) {
    const gitResult = await mcpService.callTool('git-search', {
      query: state.query,
      repositories: ['popular-repos']
    });
    results.push(gitResult);
  }
  
  if (state.query.includes('data') || state.query.includes('database')) {
    const dbResult = await mcpService.callTool('database-query', {
      query: state.understanding,
      sources: ['public-datasets']
    });
    results.push(dbResult);
  }
  
  // Convert MCP results to Source format
  const mcpSources: Source[] = results.map(result => ({
    url: `mcp://${result.tool}/${result.id}`,
    title: result.title,
    content: result.content,
    quality: result.confidence || 0.8,
    summary: result.summary
  }));
  
  return {
    sources: mcpSources,
    mcpResults: results
  };
})
```

### D. Update Workflow Logic
```typescript
// Add conditional edges in buildGraph()
.addConditionalEdges("plan", 
  (state: SearchState) => {
    if (state.dataSourceStrategy === 'mcp') {
      return "mcpResearch";
    } else if (state.dataSourceStrategy === 'hybrid') {
      return "parallelResearch";
    }
    return "search";
  },
  {
    "mcp": "mcpResearch",
    "hybrid": "parallelResearch", 
    "web": "search"
  }
)

// Add parallel research node for hybrid approach
.addNode("parallelResearch", async (state, config) => {
  // Run both web search and MCP research in parallel
  const [webResults, mcpResults] = await Promise.all([
    this.runWebSearch(state, config),
    this.runMCPResearch(state, config)
  ]);
  
  return {
    sources: [...webResults.sources, ...mcpResults.sources],
    mcpResults: mcpResults.mcpResults
  };
})
```

## 2. Example MCP Tool Implementations

### Code Search Tool
```typescript
export const codeSearchTool: MCPTool = {
  name: 'code-search',
  description: 'Search code repositories and documentation',
  async execute(params) {
    // Integration with GitHub API, GitLab, etc.
    const { query, language, repositories } = params;
    
    // Search logic here
    return {
      tool: 'code-search',
      id: generateId(),
      title: `Code results for: ${query}`,
      content: codeSnippets,
      summary: extractedDocumentation,
      confidence: 0.9
    };
  }
};
```

### Database Query Tool
```typescript
export const databaseQueryTool: MCPTool = {
  name: 'database-query',
  description: 'Query structured databases and datasets',
  async execute(params) {
    // Integration with SQL databases, APIs, etc.
    const { query, sources } = params;
    
    // Query execution logic
    return {
      tool: 'database-query',
      id: generateId(),
      title: `Data results for: ${query}`,
      content: queryResults,
      summary: dataInsights,
      confidence: 0.85
    };
  }
};
```

### Academic Search Tool
```typescript
export const academicSearchTool: MCPTool = {
  name: 'academic-search',
  description: 'Search academic papers and research',
  async execute(params) {
    // Integration with arXiv, PubMed, Google Scholar APIs
    const { query, fields, yearRange } = params;
    
    // Academic search logic
    return {
      tool: 'academic-search',
      id: generateId(),
      title: `Research papers on: ${query}`,
      content: papers,
      summary: abstractSummaries,
      confidence: 0.95
    };
  }
};
```

## 3. Integration Points

1. **Query Analysis Enhancement**: Modify `analyzeQuery` to determine optimal data sources
2. **Source Scoring**: Update `scoreContent` to handle MCP-specific quality metrics
3. **Content Processing**: Extend `ContextProcessor` to handle different content types
4. **UI Updates**: Add indicators for MCP sources in `SearchDisplay`

## 4. Configuration

```typescript
// lib/config.ts
export const MCP_CONFIG = {
  ENABLED_TOOLS: ['code-search', 'database-query', 'academic-search'],
  TOOL_TIMEOUT: 30000, // 30 seconds
  MAX_PARALLEL_TOOLS: 3,
  FALLBACK_TO_WEB: true,
  TOOL_WEIGHTS: {
    'code-search': 0.9,
    'database-query': 0.85,
    'academic-search': 0.95
  }
};
```

## 5. Benefits

- **Specialized Data**: Access to code repos, databases, academic papers
- **Higher Quality**: More authoritative sources for specific domains
- **Flexibility**: Easy to add new MCP tools
- **Performance**: Parallel execution of multiple data sources
- **Fallback**: Graceful degradation to web search if MCP fails 