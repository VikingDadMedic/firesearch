# Firesearch Project Continuity Prompt

## 🔄 Quick Context Restore

I'm continuing work on the **Firesearch** project, an AI-powered search engine built with:
- **Next.js 15** (App Router) + **React 19** + **TypeScript**
- **LangGraph** state machine for search orchestration
- **Firecrawl** for web scraping
- **OpenAI GPT-4o** for AI capabilities
- **Tailwind CSS** + **shadcn/ui** for styling

## 📁 Load Project Artifacts

Please load and use these artifacts for context:
- `project.schema.json` - Project structure and conventions
- `project.summary.json` - High-level project overview
- `repo_index.json` - Enhanced search index
- `project.memory.json` - Component relationships and memory graph
- `task_plan.json` - Current task planning
- `schema.report.json` - Detailed schema analysis
- `component.graph.json` - Visual component dependencies

## 🏗️ Architecture Summary

### Core Engine: LangGraphSearchEngine
- **Location**: `lib/langgraph-search-engine.ts` (49KB - needs refactoring)
- **Purpose**: Orchestrates 6-phase search workflow using LangGraph state machine
- **Workflow**: understand → plan → search → scrape → analyze → synthesize
- **Dependencies**: FirecrawlClient, ContextProcessor

### Key Components:
1. **FirecrawlClient** (`lib/firecrawl.ts`) - Web scraping service
2. **ContextProcessor** (`lib/context-processor.ts`) - Content analysis
3. **Chat** (`app/chat.tsx` - 30KB) - Main UI interface
4. **SearchDisplay** (`app/search-display.tsx` - 37KB) - Search visualization

### State Management:
- Uses LangGraph `SearchStateAnnotation` with reducers
- Event-driven architecture with `SearchEvent` union types
- Streaming responses via Vercel AI SDK

## 🚨 Known Technical Debt

### High Priority:
1. **Large files needing refactoring**:
   - `lib/langgraph-search-engine.ts` (49KB)
   - `app/chat.tsx` (30KB)
   - `app/search-display.tsx` (37KB)

2. **Missing infrastructure**:
   - No test coverage
   - No centralized state management
   - API keys handled client-side

### Schema Compliance:
- **File naming**: kebab-case ✅
- **Components**: PascalCase ✅
- **Functions**: camelCase ✅
- **Constants**: UPPER_SNAKE_CASE ✅

## 🎯 Current Focus Areas

1. **Refactoring**: Break down large components into smaller modules
2. **Testing**: Implement unit and integration tests
3. **State Management**: Consider Redux/Zustand for centralized state
4. **Security**: Move API keys to server-side management
5. **Documentation**: Improve inline documentation and API docs

## 🔧 Development Guidelines

### When making changes:
1. Check `.cursorrules` for project-specific rules
2. Follow existing patterns in the codebase
3. Maintain schema alignment (see `project.schema.json`)
4. Use the memory graph to avoid redundancy
5. Keep files under 500 lines when possible

### Component Creation:
- Place new pages in `/app`
- Core logic goes in `/lib`
- Reusable UI in `/components/ui`
- Custom hooks in `/hooks`

### Search Workflow Modifications:
- Workflow nodes are in `buildGraph()` method
- Each node should emit appropriate `SearchEvent`
- State updates use SearchStateAnnotation reducers
- Maintain event streaming for UI updates

## 🔗 Key Relationships

```
Home (page.tsx)
  └─> Chat (chat.tsx)
       ├─> LangGraphSearchEngine (search orchestration)
       │    ├─> FirecrawlClient (web scraping)
       │    └─> ContextProcessor (content analysis)
       └─> SearchDisplay (visualization)
            └─> Events from SearchEngine
```

## 💾 Memory References

- **Memory ID 6988930818301892112**: Project overview
- **Memory ID 2757139130182453925**: LangGraphSearchEngine architecture

## 📋 Next Steps

Refer to `task_plan.json` for current task progress and pending items. Key areas:
- Component refactoring (Phase 1-3 of large files)
- Test infrastructure setup
- API security improvements
- Performance optimizations

---

*Use this prompt to quickly restore context when returning to the Firesearch project. All artifacts should be loaded to maintain continuity and architectural consistency.* 