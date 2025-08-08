# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **RAG (Retrieval-Augmented Generation) chatbot application** originally based on tech-trends-chatbot. It's a full-stack application with:
- **Backend**: Python FastAPI with Redis for vector storage, OpenAI GPT-4 for LLM
- **Frontend**: React with Vite, TypeScript, and Tailwind CSS
- **Purpose**: AI chatbot that specializes in answering questions using RAG technology with custom data sources

## Essential Commands

### Service Management
```bash
# Start all services (Redis, Backend, Frontend)
./start.sh

# Stop all services
./stop.sh

# Restart services
./restart.sh

# Check service status
./status.sh

# View logs
./logs.sh
```

### Development Commands

**Backend (Poetry-managed Python):**
```bash
cd backend

# Install dependencies
poetry install

# Load documents into vector DB (Redis must be running)
poetry run load

# Run local console version for testing
poetry run local

# Export chat history to JSON
poetry run export

# Run backend server
poetry shell
fastapi dev app/main.py

# Lint backend code
poetry run pylint app
```

**Frontend (React with Vite):**
```bash
cd frontend

# Install dependencies
npm install

# Run development server
npm run dev

# Build for production
npm run build

# Lint frontend code
npm run lint
```

## Architecture Overview

### Backend Architecture

**Core Components:**
- `app/main.py`: FastAPI application entry point with CORS configuration
- `app/api.py`: REST API endpoints for chat creation and messaging
- `app/config.py`: Pydantic settings management for environment variables
- `app/db.py`: Redis database operations for vector storage and chat persistence

**Assistant System:**
- `app/assistants/assistant.py`: RAGAssistant class implementing the main chatbot logic with tool calling
- `app/assistants/tools.py`: QueryKnowledgeBaseTool for vector database searches
- `app/assistants/prompts.py`: System prompts for chat and RAG contexts
- `app/assistants/local_assistant.py`: Console-based assistant for local testing

**Document Processing:**
- `app/loader.py`: Document loader that processes PDFs, creates embeddings, and stores in Redis
- `app/utils/splitter.py`: Text splitting utilities for chunking documents
- `app/openai.py`: OpenAI API integration for embeddings and chat completions

**Streaming:**
- `app/utils/sse_stream.py`: Server-Sent Events (SSE) implementation for real-time streaming

### Frontend Architecture

**Components:**
- `src/App.jsx`: Main application container
- `src/components/Chatbot.jsx`: Core chatbot component managing state and API calls
- `src/components/ChatMessages.jsx`: Message display with markdown rendering
- `src/components/ChatInput.jsx`: User input handling
- `src/components/Spinner.jsx`: Loading indicator

**API Integration:**
- Uses EventSource for SSE streaming from backend
- Implements eventsource-parser for handling streamed responses

### Data Flow

1. **Document Loading**: PDFs → Text extraction → Chunking → Embeddings → Redis vector storage
2. **Chat Flow**: User message → API → RAGAssistant → Tool calls (vector search) → GPT-4 → SSE stream → Frontend
3. **State Management**: Chat sessions stored in Redis with message history

## Key Configuration

### Environment Variables

**Backend (.env):**
- `OPENAI_API_KEY`: Required for GPT-4 and embeddings
- `MODEL`: Default 'gpt-4.1'
- `EMBEDDING_MODEL`: Default 'text-embedding-3-large'
- `REDIS_HOST`: Default 'localhost'
- `REDIS_PORT`: Default 6379

**Frontend (.env.development):**
- `VITE_API_URL`: Backend API URL (default 'http://localhost:8000')

### Service Ports
- Redis: 6379
- Backend API: 8000
- Frontend: 3000

## Important Technical Details

### RAG Implementation
- Uses Redis as vector database with RediSearch and RedisJSON modules
- Implements semantic search with OpenAI embeddings (1024 dimensions)
- Configurable vector search with top-k results (default: 10)
- Tool-based architecture allowing GPT-4 to query knowledge base

### Streaming Architecture
- Server-Sent Events (SSE) for real-time response streaming
- Async task handling in FastAPI for concurrent operations
- Background tasks for Redis connection cleanup

### Session Management
- UUID-based chat sessions
- Configurable history size (default: 4 messages)
- Message persistence with timestamps

## Customization Points

1. **Data Sources**: Replace PDFs in `backend/data/docs/` and run `poetry run load`
2. **System Prompts**: Modify prompts in `backend/app/assistants/prompts.py`
3. **Search Parameters**: Adjust `VECTOR_SEARCH_TOP_K` in config
4. **UI Theme**: Modify Tailwind classes in React components
5. **Model Selection**: Change `MODEL` and `EMBEDDING_MODEL` in config