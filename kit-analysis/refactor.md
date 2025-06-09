# Firesearch Refactoring and Developer Guide

This document provides a comprehensive overview of the Firesearch application, its architecture, and a plan for refactoring. It also serves as a guide for developers looking to understand and contribute to the codebase.

---

## 1. Codebase Analysis & Structure

The Firesearch application is a well-structured Next.js 15 project that leverages a modern technology stack to provide a sophisticated AI-powered search experience.

### 1.1. Key Frameworks and Libraries

*   **Frontend**:
    *   **Next.js 15**: The core framework, utilizing the App Router and React Server Components.
    *   **React 19**: The underlying UI library.
    *   **shadcn/ui**: A collection of reusable UI components built on top of Radix UI.
    *   **Tailwind CSS**: The utility-first CSS framework for styling.
    *   **Lucide React**: For icons.
    *   **`ai` (Vercel AI SDK)**: For streaming AI responses to the frontend.

*   **Backend & Core Logic**:
    *   **LangGraph**: The state machine for orchestrating the multi-step search, analysis, and synthesis process.
    *   **Firecrawl**: The web scraping and content extraction service.
    *   **OpenAI API (GPT-4o & GPT-4o-mini)**: For AI-powered search planning, summarization, answer generation, and follow-up questions.

*   **Tooling**:
    *   **TypeScript**: For static typing and improved developer experience.
    *   **ESLint**: For code linting.
    *   **pnpm**: As the package manager.

### 1.2. Architecture & File Structure

The application follows a clear client-server architecture. Here's a breakdown of the key directories:

*   **`app/`**: Contains all the routing and UI pages, following the Next.js App Router structure.
    *   **`page.tsx`**: The main entry point and landing page for the application.
    *   **`chat.tsx`**: The primary component that manages the chat interface, user input, and messages.
    *   **`search.tsx`**: A Next.js Server Action that acts as the bridge between the frontend and the backend search logic.
    *   **`search-display.tsx`**: A client component that visualizes the real-time progress of the search operation.
    *   **`api/`**: For any serverless functions or API routes.

*   **`components/`**: Houses all reusable React components.
    *   **`ui/`**: Contains the `shadcn/ui` components like `Button`, `Dialog`, `Input`, etc. These are the building blocks of the UI.

*   **`lib/`**: This is where the core application logic resides.
    *   **`langgraph-search-engine.ts`**: The heart of the application. This file defines the LangGraph state machine, orchestrating the entire search and synthesis process.
    *   **`firecrawl.ts`**: A client for interacting with the Firecrawl API.
    *   **`context-processor.ts`**: Handles the processing and summarization of scraped content.
    *   **`config.ts`**: Contains all the configuration parameters for the search engine and models.

*   **`public/`**: For all static assets like images, logos, and favicons.

---

## 2. Developer Guidance

This section provides high-level guidance for common development tasks.

### If you want to...

*   **Change the overall search logic or flow**:
    *   **Where to look**: `lib/langgraph-search-engine.ts`.
    *   **Considerations**: This file defines the `StateGraph`. You'll need to understand the nodes (`understand`, `plan`, `search`, `analyze`, `synthesize`) and the conditional edges that control the flow between them. Modifying this requires an understanding of LangGraph's state management.

*   **Modify the main chat UI**:
    *   **Where to look**: `app/chat.tsx`.
    *   **Considerations**: This is a large component that manages the state of the conversation. It's a prime candidate for refactoring into smaller, more manageable components. For now, this is where you'll find the main input form and the message rendering loop.

*   **Adjust the AI's prompts or behavior**:
    *   **Where to look**: The prompts are defined within the methods of `lib/langgraph-search-engine.ts` (e.g., `analyzeQuery`, `checkAnswersInSources`). The model parameters (like temperature) are in `lib/config.ts`.
    *   **Considerations**: Prompt engineering is key to the quality of the results. Small changes can have a significant impact.

*   **Change the styling, theme, or add custom animations**:
    *   **Where to look**: `app/globals.css` for global styles and CSS variables. `tailwind.config.ts` for theme configuration (colors, fonts, etc.).
    *   **Considerations**: The project uses CSS variables for theming, which are defined in `app/globals.css`. New animations can also be added there.

*   **Improve how web content is processed or summarized**:
    *   **Where to look**: `lib/context-processor.ts`.
    *   **Considerations**: This class is responsible for taking the raw content from Firecrawl and preparing it for the AI. You can adjust the summarization prompts and logic here to extract different types of information.

*   **Add a new UI component**:
    *   **Where to look**: `components/ui/`.
    *   **Considerations**: It's best to use the `shadcn/ui` CLI to add new components to maintain consistency with the existing component set.

---

## 3. Refactoring Plan

The following sections outline the plan for refactoring the codebase to improve its structure and maintainability.

### 3.1. Refactoring Goals

*   **Improve Modularity**: Decouple the core logic from the UI.
*   **Enhance Scalability**: Prepare the codebase for future features.
*   **Standardize State Management**: Implement a more robust state management solution.
*   **Improve Developer Experience**: Make the codebase easier to understand and contribute to.

### 3.2. Proposed Changes

*   **Component-Based Architecture**:
    *   Break down `app/chat.tsx` into smaller, focused components (e.g., `MessageList`, `MessageInput`, `Suggestions`, `ApiKeyModal`).
    *   Create a more organized directory structure under `app/components/` for different categories of components.

*   **State Management**:
    *   Introduce a lightweight state management library like **Zustand** or **Jotai** to replace the `useState`-based logic in `app/chat.tsx`.

*   **Backend and Core Logic**:
    *   Refactor `lib/langgraph-search-engine.ts` to separate the prompt definitions from the graph structure, making both easier to manage.

### 3.3. Step-by-Step Plan

1.  **Component Refactoring**:
    *   Create new component files under `app/components/chat/` for the different parts of the chat UI.
    *   Move the relevant JSX and logic from `app/chat.tsx` into these new components.
    *   Create `app/components/modals/ApiKeyModal.tsx`.

2.  **State Management Refactoring**:
    *   Add a state management library (e.g., `pnpm add zustand`).
    *   Create a global store in `lib/store.ts` to manage application state (messages, API key, etc.).
    *   Refactor the `Chat` component and its new children to use the global store.

3.  **Backend Refactoring**:
    *   Create a new file `lib/prompts.ts` to store all the system and user prompts used in the `LangGraphSearchEngine`.
    *   Import these prompts into `lib/langgraph-search-engine.ts`.

---

## 4. Future Considerations

*   **User Authentication**: Add user accounts to save search history and preferences.
*   **Search History**: Implement a feature to save and revisit previous searches.
*   **Caching**: Implement a caching layer for API responses to improve performance and reduce costs.
*   **Testing**: Add a comprehensive suite of unit and integration tests. 