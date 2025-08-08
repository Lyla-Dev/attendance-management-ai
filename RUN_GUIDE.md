# 실행 및 종료 가이드

이 문서는 Tech Trends AI Chatbot 프로젝트의 실행 및 종료 방법을 설명합니다.

## 📋 사전 요구사항

- Python 3.11+
- Node.js 18+
- Poetry (Python 패키지 관리자)
- Redis Stack Server
- OpenAI API Key

## 🚀 전체 실행 방법

### 방법 1: 각각 터미널에서 실행 (추천)

3개의 터미널을 열어 각각 실행합니다.

**터미널 1 - Redis 실행:**
```bash
redis-stack-server
```

**터미널 2 - Backend 실행:**
```bash
cd backend
poetry shell
fastapi dev app/main.py
```

**터미널 3 - Frontend 실행:**
```bash
cd frontend
npm run dev
```

### 방법 2: 백그라운드에서 한번에 실행

하나의 터미널에서 모든 서비스를 백그라운드로 실행합니다.

```bash
# 1. Redis 시작
redis-stack-server --daemonize yes

# 2. Backend 디렉토리에서
cd backend
poetry run fastapi dev app/main.py > /tmp/fastapi.log 2>&1 &

# 3. Frontend 디렉토리에서
cd ../frontend
npm run dev > /tmp/vite.log 2>&1 &
```

## 🛑 전체 종료 방법

### 방법 1: 각 터미널에서 실행한 경우
각 터미널에서 `Ctrl + C`를 눌러 종료합니다.

### 방법 2: 백그라운드 프로세스 종료

```bash
# FastAPI 종료
pkill -f "fastapi dev"

# Vite 종료  
pkill -f "vite"

# Redis 종료
redis-cli shutdown
```

### 방법 3: 한번에 모두 종료하는 스크립트

```bash
# 모든 관련 프로세스 종료
pkill -f "fastapi dev" && pkill -f "vite" && redis-cli shutdown
```

## 📝 주의사항

### 1. 최초 실행 시 필수 작업

Backend 문서를 Vector DB에 로드해야 합니다 (Redis가 실행 중이어야 함):

```bash
cd backend
poetry run load
```

### 2. 환경 변수 확인

- **Backend**: `.env` 파일에 `OPENAI_API_KEY` 설정
  ```
  OPENAI_API_KEY=your-api-key-here
  ```

- **Frontend**: `.env.development` 파일에 API URL 확인
  ```
  VITE_API_URL='http://localhost:8000'
  ```

### 3. 실행 순서

올바른 실행 순서를 따라야 합니다:
1. Redis Stack Server (필수)
2. Backend FastAPI
3. Frontend React

### 4. 포트 사용

다음 포트들이 사용됩니다:
- **Redis**: 6379
- **Backend**: 8000  
- **Frontend**: 3000

### 5. 프로세스 확인

실행 중인 서비스를 확인하려면:

```bash
# 실행 중인 서비스 확인
ps aux | grep -E "redis|fastapi|vite" | grep -v grep
```

### 6. 서비스 상태 확인

각 서비스가 정상적으로 실행 중인지 확인:

```bash
# Redis 확인
redis-cli ping
# 응답: PONG

# Backend 확인
curl http://localhost:8000/health
# 응답: "ok"

# Frontend 확인
curl http://localhost:3000
# 응답: HTML 콘텐츠
```

## 🔧 문제 해결

### Redis 연결 오류
```bash
# Redis가 실행 중인지 확인
redis-cli ping

# Redis 재시작
redis-cli shutdown
redis-stack-server --daemonize yes
```

### Backend 실행 오류
```bash
# Poetry 가상환경 활성화 확인
poetry shell

# 의존성 재설치
poetry install
```

### Frontend 실행 오류
```bash
# Node 모듈 재설치
cd frontend
rm -rf node_modules
npm install
```

### 포트 충돌
```bash
# 사용 중인 포트 확인
lsof -i :8000  # Backend
lsof -i :3000  # Frontend
lsof -i :6379  # Redis

# 프로세스 종료
kill -9 <PID>
```

## 📊 로그 확인

백그라운드 실행 시 로그 파일 위치:
- **Backend**: `/tmp/fastapi.log`
- **Frontend**: `/tmp/vite.log`

로그 실시간 확인:
```bash
# Backend 로그
tail -f /tmp/fastapi.log

# Frontend 로그
tail -f /tmp/vite.log
```

## 🎯 빠른 시작 스크립트

### start.sh
```bash
#!/bin/bash
echo "Starting Tech Trends Chatbot..."

# Start Redis
redis-stack-server --daemonize yes
echo "✅ Redis started"

# Start Backend
cd backend
poetry run fastapi dev app/main.py > /tmp/fastapi.log 2>&1 &
echo "✅ Backend started"
sleep 3

# Start Frontend
cd ../frontend
npm run dev > /tmp/vite.log 2>&1 &
echo "✅ Frontend started"

echo "🚀 All services running!"
echo "   - Frontend: http://localhost:3000"
echo "   - Backend: http://localhost:8000"
echo "   - Redis: localhost:6379"
```

### stop.sh
```bash
#!/bin/bash
echo "Stopping Tech Trends Chatbot..."

pkill -f "fastapi dev"
echo "✅ Backend stopped"

pkill -f "vite"
echo "✅ Frontend stopped"

redis-cli shutdown
echo "✅ Redis stopped"

echo "🛑 All services stopped!"
```

## 📚 추가 명령어

### 데이터 관련
```bash
# 채팅 기록 내보내기
cd backend
poetry run export

# 문서 다시 로드
poetry run load

# 로컬 콘솔 버전 실행 (테스트용)
poetry run local
```

### 개발 관련
```bash
# Backend 린트
cd backend
poetry run pylint app

# Frontend 린트
cd frontend
npm run lint

# Frontend 빌드
npm run build
```