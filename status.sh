#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Tech Trends AI Chatbot Status${NC}"
echo -e "${BLUE}========================================${NC}\n"

# Check Redis
echo -e "${YELLOW}Redis Stack Server:${NC}"
if redis-cli ping > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ Running${NC} on port 6379"
    REDIS_INFO=$(redis-cli info server | grep redis_version | cut -d: -f2 | tr -d '\r')
    echo -e "  Version: $REDIS_INFO"
else
    echo -e "  ${RED}❌ Not running${NC}"
fi

# Check Backend
echo -e "\n${YELLOW}Backend (FastAPI):${NC}"
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ Running${NC} at http://localhost:8000"
    # Check if we can get API docs
    if curl -s http://localhost:8000/docs > /dev/null 2>&1; then
        echo -e "  API Docs: ${BLUE}http://localhost:8000/docs${NC}"
    fi
else
    echo -e "  ${RED}❌ Not running${NC}"
fi

# Check Frontend
echo -e "\n${YELLOW}Frontend (React/Vite):${NC}"
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo -e "  ${GREEN}✅ Running${NC} at ${BLUE}http://localhost:3000${NC}"
else
    echo -e "  ${RED}❌ Not running${NC}"
fi

# Show running processes
echo -e "\n${YELLOW}Running Processes:${NC}"
PROCESSES=$(ps aux | grep -E "redis-server|fastapi dev|vite" | grep -v grep | wc -l | tr -d ' ')

if [ "$PROCESSES" -gt 0 ]; then
    echo -e "  Found ${GREEN}$PROCESSES${NC} related process(es):"
    ps aux | grep -E "redis-server|fastapi dev|vite" | grep -v grep | while read line; do
        PID=$(echo $line | awk '{print $2}')
        CMD=$(echo $line | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}' | cut -c1-60)
        echo -e "  ${BLUE}PID $PID${NC}: $CMD..."
    done
else
    echo -e "  ${YELLOW}No related processes found${NC}"
fi

# Check log files
echo -e "\n${YELLOW}Log Files:${NC}"
if [ -f /tmp/fastapi.log ]; then
    SIZE=$(ls -lh /tmp/fastapi.log | awk '{print $5}')
    LINES=$(wc -l < /tmp/fastapi.log | tr -d ' ')
    echo -e "  Backend:  /tmp/fastapi.log (${SIZE}, ${LINES} lines)"
else
    echo -e "  Backend:  ${YELLOW}No log file${NC}"
fi

if [ -f /tmp/vite.log ]; then
    SIZE=$(ls -lh /tmp/vite.log | awk '{print $5}')
    LINES=$(wc -l < /tmp/vite.log | tr -d ' ')
    echo -e "  Frontend: /tmp/vite.log (${SIZE}, ${LINES} lines)"
else
    echo -e "  Frontend: ${YELLOW}No log file${NC}"
fi

# Summary
echo -e "\n${BLUE}========================================${NC}"
ALL_RUNNING=true
if ! redis-cli ping > /dev/null 2>&1; then
    ALL_RUNNING=false
fi
if ! curl -s http://localhost:8000/health > /dev/null 2>&1; then
    ALL_RUNNING=false
fi
if ! curl -s http://localhost:3000 > /dev/null 2>&1; then
    ALL_RUNNING=false
fi

if [ "$ALL_RUNNING" = true ]; then
    echo -e "${GREEN}✅ All services are running!${NC}"
    echo -e "${GREEN}   Open ${BLUE}http://localhost:3000${GREEN} in your browser${NC}"
else
    echo -e "${YELLOW}⚠️  Some services are not running${NC}"
    echo -e "${YELLOW}   Run ${BLUE}./start.sh${YELLOW} to start all services${NC}"
fi
echo -e "${BLUE}========================================${NC}\n"