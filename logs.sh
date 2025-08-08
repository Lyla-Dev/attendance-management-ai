#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  Tech Trends AI Chatbot Logs${NC}"
    echo -e "${BLUE}========================================${NC}\n"
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ${GREEN}./logs.sh backend${NC}     - Show backend logs"
    echo -e "  ${GREEN}./logs.sh frontend${NC}    - Show frontend logs"
    echo -e "  ${GREEN}./logs.sh all${NC}         - Show all logs"
    echo -e "  ${GREEN}./logs.sh tail${NC}        - Tail all logs (live)"
    echo -e "  ${GREEN}./logs.sh clear${NC}       - Clear all log files"
    echo -e "\n${YELLOW}Options:${NC}"
    echo -e "  Add ${CYAN}-f${NC} to tail logs: ${GREEN}./logs.sh backend -f${NC}"
    exit 0
fi

# Function to show log file
show_log() {
    local log_file=$1
    local service_name=$2
    
    if [ -f "$log_file" ]; then
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}  $service_name Logs${NC}"
        echo -e "${BLUE}========================================${NC}"
        echo -e "${YELLOW}File:${NC} $log_file"
        SIZE=$(ls -lh "$log_file" | awk '{print $5}')
        LINES=$(wc -l < "$log_file" | tr -d ' ')
        echo -e "${YELLOW}Size:${NC} $SIZE | ${YELLOW}Lines:${NC} $LINES"
        echo -e "${BLUE}----------------------------------------${NC}"
        
        if [ "$3" = "-f" ]; then
            tail -f "$log_file"
        else
            tail -n 50 "$log_file"
            echo -e "${BLUE}----------------------------------------${NC}"
            echo -e "${CYAN}(Showing last 50 lines)${NC}"
        fi
    else
        echo -e "${RED}❌ $service_name log file not found:${NC} $log_file"
    fi
}

# Handle different arguments
case "$1" in
    backend)
        show_log "/tmp/fastapi.log" "Backend" "$2"
        ;;
    frontend)
        show_log "/tmp/vite.log" "Frontend" "$2"
        ;;
    all)
        show_log "/tmp/fastapi.log" "Backend" "$2"
        echo ""
        show_log "/tmp/vite.log" "Frontend" "$2"
        ;;
    tail)
        echo -e "${BLUE}========================================${NC}"
        echo -e "${BLUE}  Tailing All Logs (Ctrl+C to stop)${NC}"
        echo -e "${BLUE}========================================${NC}\n"
        
        # Use tail with multiple files
        if [ -f "/tmp/fastapi.log" ] && [ -f "/tmp/vite.log" ]; then
            tail -f /tmp/fastapi.log /tmp/vite.log
        elif [ -f "/tmp/fastapi.log" ]; then
            echo -e "${YELLOW}Only backend log available${NC}"
            tail -f /tmp/fastapi.log
        elif [ -f "/tmp/vite.log" ]; then
            echo -e "${YELLOW}Only frontend log available${NC}"
            tail -f /tmp/vite.log
        else
            echo -e "${RED}❌ No log files found${NC}"
        fi
        ;;
    clear)
        echo -e "${YELLOW}Clearing log files...${NC}"
        
        if [ -f "/tmp/fastapi.log" ]; then
            > /tmp/fastapi.log
            echo -e "${GREEN}✅ Backend log cleared${NC}"
        else
            echo -e "${YELLOW}ℹ️  Backend log not found${NC}"
        fi
        
        if [ -f "/tmp/vite.log" ]; then
            > /tmp/vite.log
            echo -e "${GREEN}✅ Frontend log cleared${NC}"
        else
            echo -e "${YELLOW}ℹ️  Frontend log not found${NC}"
        fi
        
        echo -e "${GREEN}✨ Log files cleared${NC}"
        ;;
    *)
        echo -e "${RED}❌ Unknown option:${NC} $1"
        echo -e "Run ${GREEN}./logs.sh${NC} without arguments for usage"
        ;;
esac