#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Tech Trends AI Chatbot Restarter${NC}"
echo -e "${BLUE}========================================${NC}\n"

echo -e "${YELLOW}📋 Stopping all services...${NC}\n"

# Run stop script
./stop.sh

echo -e "\n${YELLOW}⏳ Waiting for services to fully stop...${NC}"
sleep 2

echo -e "\n${YELLOW}🚀 Starting all services...${NC}\n"

# Run start script
./start.sh