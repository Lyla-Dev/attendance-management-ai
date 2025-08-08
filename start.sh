#!/bin/bash

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Simple output without colors for better compatibility

echo "========================================"
echo "  Tech Trends AI Chatbot Starter"
echo "========================================"
echo ""

# Check if Redis is already running
if redis-cli ping > /dev/null 2>&1; then
    echo "⚠️  Redis is already running"
else
    echo "Starting Redis Stack Server..."
    redis-stack-server --daemonize yes
    sleep 2
    if redis-cli ping > /dev/null 2>&1; then
        echo "✅ Redis started successfully"
    else
        echo "❌ Failed to start Redis"
        exit 1
    fi
fi

# Check if Backend is already running
if curl -s http://localhost:8000/health > /dev/null 2>&1; then
    echo "⚠️  Backend is already running"
else
    echo "Starting Backend server..."
    (cd backend && poetry run fastapi dev app/main.py > /tmp/fastapi.log 2>&1 &)
    
    # Wait for backend to start
    for i in {1..10}; do
        if curl -s http://localhost:8000/health > /dev/null 2>&1; then
            echo "✅ Backend started successfully"
            break
        fi
        if [ $i -eq 10 ]; then
            echo "❌ Failed to start Backend"
            echo "   Check logs at: /tmp/fastapi.log"
            exit 1
        fi
        sleep 1
    done
fi

# Check if Frontend is already running
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "⚠️  Frontend is already running"
else
    echo "Starting Frontend server..."
    (cd frontend && npm run dev > /tmp/vite.log 2>&1 &)
    
    # Wait for frontend to start
    for i in {1..10}; do
        if curl -s http://localhost:3000 > /dev/null 2>&1; then
            echo "✅ Frontend started successfully"
            break
        fi
        if [ $i -eq 10 ]; then
            echo "❌ Failed to start Frontend"
            echo "   Check logs at: /tmp/vite.log"
            exit 1
        fi
        sleep 1
    done
fi

echo ""
echo "========================================"
echo "🚀 All services are running!"
echo "========================================"
echo "   Frontend:  http://localhost:3000"
echo "   Backend:   http://localhost:8000"
echo "   Redis:     localhost:6379"
echo ""
echo "📝 Logs:"
echo "   Backend:   /tmp/fastapi.log"
echo "   Frontend:  /tmp/vite.log"
echo ""
echo "💡 Tip: Run ./stop.sh to stop all services"
echo "========================================"
echo ""