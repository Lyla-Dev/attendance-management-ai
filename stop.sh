#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Simple output without colors for better compatibility

echo "========================================"
echo "  Tech Trends AI Chatbot Stopper"
echo "========================================"
echo ""

# Stop Frontend
echo "Stopping Frontend server..."
if pkill -f "vite" 2>/dev/null; then
    echo "✅ Frontend stopped"
else
    if curl -s http://localhost:3000 > /dev/null 2>&1; then
        echo "⚠️  Frontend might still be running on port 3000"
    else
        echo "ℹ️  Frontend was not running"
    fi
fi

# Stop Backend
echo "Stopping Backend server..."
if pkill -f "fastapi dev" 2>/dev/null; then
    echo "✅ Backend stopped"
else
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo "⚠️  Backend might still be running on port 8000"
    else
        echo "ℹ️  Backend was not running"
    fi
fi

# Stop Redis
echo "Stopping Redis server..."
if redis-cli ping > /dev/null 2>&1; then
    redis-cli shutdown > /dev/null 2>&1
    echo "✅ Redis stopped"
else
    echo "ℹ️  Redis was not running"
fi

echo ""
echo "========================================"
echo "🛑 All services stopped!"
echo "========================================"
echo ""

# Check if any service is still running
STILL_RUNNING=false

if redis-cli ping > /dev/null 2>&1; then
    echo "⚠️  Redis is still running"
    STILL_RUNNING=true
fi

if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "⚠️  Backend is still running"
    STILL_RUNNING=true
fi

if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "⚠️  Frontend is still running"
    STILL_RUNNING=true
fi

if [ "$STILL_RUNNING" = true ]; then
    echo ""
    echo "Some services might still be running."
    echo "You can check with:"
    echo "  ps aux | grep -E 'redis|fastapi|vite' | grep -v grep"
    echo ""
    echo "To force kill all processes:"
    echo "  pkill -9 -f 'redis|fastapi|vite'"
else
    echo "All services have been successfully stopped."
fi

echo ""
echo "💡 Tip: Run ./start.sh to start all services again"