# Railway 배포 가이드 (초보자용 상세 설명)

이 문서는 Railway를 처음 사용하는 분도 쉽게 따라할 수 있도록 작성된 **학교 출결 규정 상담 챗봇** 배포 가이드입니다.

## 📋 사전 준비 사항

### 필수 준비물
1. **Railway 계정**: https://railway.app 에서 GitHub으로 회원가입
2. **OpenAI API Key**: https://platform.openai.com/api-keys 에서 발급
   - 💰 비용 주의: API 사용량에 따라 비용 발생
3. **GitHub 저장소 접근 권한**: `Lyla-Dev/attendance-management-ai` 

## 🚀 Railway 배포 단계별 가이드

### 📍 Step 1: Railway 프로젝트 생성

1. **Railway 대시보드 접속**
   - https://railway.app 로그인
   - 우측 상단 "New Project" 버튼 클릭

2. **빈 프로젝트 생성**
   - ⚠️ 중요: "Empty Project" 선택 (GitHub repo 선택 아님!)
   - 프로젝트 이름 자동 생성됨 (예: "fuzzy-lamp-production")

### 📍 Step 2: Redis Stack 데이터베이스 추가

⚠️ **중요**: 일반 Redis가 아닌 **Redis Stack**이 필요합니다 (Vector Search 기능 때문)

#### 옵션 A: Docker Image 사용 (권장)
1. **프로젝트 대시보드**에서 "+ New" 버튼 클릭
2. **"Docker Image"** 선택
3. Image 입력: `redis/redis-stack-server:latest`
4. **"Deploy"** 클릭
5. 배포 완료 후 **Settings** 탭에서:
   - Service Name을 `redis`로 변경
   - **Variables** 탭에서 다음 추가:
     ```
     REDIS_ARGS=--port 6379
     ```

#### 옵션 B: 일반 Redis 사용 (제한적)
1. **프로젝트 대시보드**에서 "+ New" 버튼 클릭
2. **"Database"** 선택 → **"Add Redis"** 클릭
3. ⚠️ **경고**: Vector Search가 작동하지 않을 수 있음
4. 이 경우 다른 Vector DB 서비스 사용 고려

### 📍 Step 3: Backend 서비스 추가

1. **프로젝트 대시보드**에서 다시 "+ New" 버튼 클릭
2. **"GitHub Repo"** 선택
3. **저장소 검색**: `attendance-management-ai` 입력
4. **`Lyla-Dev/attendance-management-ai`** 선택
5. **즉시 Settings 탭으로 이동** (배포 시작 전에!)

#### Backend Settings 설정 (순서대로!)

**Settings 탭에서:**

1. **Service Name** 
   - `backend`로 변경

2. **Build Command**
   ```
   cd backend && pip install poetry && poetry install
   ```

3. **Start Command**
   ```
   cd backend && poetry run uvicorn app.main:app --host 0.0.0.0 --port $PORT
   ```

4. **Root Directory**
   - 비워두기 (프로젝트 루트 사용)

5. **Watch Paths**
   - `backend/**` 추가

6. 하단의 **"Save"** 버튼 클릭

#### Backend 환경 변수 설정

**Variables 탭으로 이동:**

1. **"RAW Editor"** 버튼 클릭
2. 사용한 Redis 옵션에 따라 설정:

   **옵션 A (Redis Stack Docker)를 사용한 경우:**
   ```
   OPENAI_API_KEY=sk-proj-여기에_실제_API_키_입력
   REDIS_HOST=redis.railway.internal
   REDIS_PORT=6379
   ```

   **옵션 B (일반 Redis)를 사용한 경우:**
   ```
   OPENAI_API_KEY=sk-proj-여기에_실제_API_키_입력
   REDIS_HOST=redis.railway.internal
   REDIS_PORT=6379
   ```
   ⚠️ 주의: Vector Search 오류 발생 가능

3. **"Save"** 버튼 클릭
4. 자동으로 배포 시작됨

### 📍 Step 4: Frontend 서비스 추가

1. **프로젝트 대시보드**에서 "+ New" 버튼 클릭
2. **"GitHub Repo"** 선택
3. **같은 저장소** 다시 선택 (`Lyla-Dev/attendance-management-ai`)
4. **즉시 Settings 탭으로 이동**

#### Frontend Settings 설정

**Settings 탭에서:**

1. **Service Name**
   - `frontend`로 변경

2. **Build Command**
   ```
   cd frontend && npm install && npm run build
   ```

3. **Start Command**
   ```
   cd frontend && npx vite preview --port $PORT --host 0.0.0.0
   ```

4. **Root Directory**
   - 비워두기

5. **Watch Paths**
   - `frontend/**` 추가

6. **"Save"** 버튼 클릭

#### Frontend 환경 변수 설정

**Variables 탭으로 이동:**

1. **"New Variable"** 클릭
2. 추가할 변수:
   - Name: `VITE_API_URL`
   - Value: Backend의 Public URL 입력
     - Backend 서비스 클릭 → Settings → Public Networking에서 URL 복사
     - 예: `https://backend-production-xxxx.up.railway.app`

3. **"Add"** 버튼 클릭

### 📍 Step 5: 배포 확인 (약 5-10분 소요)

각 서비스의 상태 확인:
- 🟢 초록색 점: 정상 실행 중
- 🟡 노란색 점: 빌드/배포 중
- 🔴 빨간색 점: 오류 발생

**각 서비스 클릭 → "Logs" 탭에서 실시간 로그 확인**

### 📍 Step 6: PDF 문서 로드 (중요!)

⚠️ **반드시 Backend가 성공적으로 배포된 후 실행**

1. **Backend 서비스** 클릭
2. 우측 상단 **"..."** 메뉴 클릭
3. **"Run a command"** 선택
4. 다음 명령어 입력:
   ```
   cd backend && poetry run load
   ```
5. **"Run"** 클릭
6. 로그에서 다음 메시지 확인:
   ```
   Loading documents
   Loaded 1 PDF documents
   ...
   Knowledge base loaded
   ```

### 📍 Step 7: 챗봇 접속

1. **Frontend 서비스** 클릭
2. **Settings** 탭 → **Public Networking**
3. 생성된 URL 클릭 (예: `https://frontend-production-xxxx.up.railway.app`)
4. 챗봇 페이지가 열리면 성공! 🎉

## 🔧 문제 해결 가이드

### ❌ Backend 배포 실패
**증상**: Backend 서비스가 빨간색
**해결**:
1. Logs 확인
2. 일반적인 원인:
   - `OPENAI_API_KEY` 미설정 → Variables에서 추가
   - Poetry 설치 실패 → Build Command 확인
   - 포트 설정 오류 → Start Command에 `$PORT` 확인

### ❌ Frontend 접속 시 API 연결 실패
**증상**: 챗봇이 응답하지 않음
**해결**:
1. `VITE_API_URL`이 Backend의 Public URL과 일치하는지 확인
2. Backend Public URL 확인 방법:
   - Backend 서비스 → Settings → Public Networking → Generated Domain
3. Frontend Variables에서 `VITE_API_URL` 수정 후 재배포

### ❌ Redis 연결 실패
**증상**: Backend 로그에 Redis connection error
**해결**:
1. Redis 서비스가 실행 중인지 확인 (초록색 점)
2. Backend Variables에서 `REDIS_HOST`가 `redis.railway.internal`인지 확인
3. Redis를 재시작: Redis 서비스 → Settings → Restart

### ❌ Vector Index 생성 실패
**증상**: "unknown command 'FT.CREATE'" 오류
**원인**: 일반 Redis 사용 (Redis Stack이 아님)
**해결**:
1. Redis 서비스 삭제
2. Step 2의 "옵션 A: Docker Image" 방식으로 Redis Stack 재설치
3. Backend 재배포

### ❌ "Knowledge base not found" 오류
**증상**: 챗봇이 질문에 답변하지 못함
**해결**:
1. Step 6의 PDF 문서 로드를 실행했는지 확인
2. 다시 실행: Backend → Run a command → `cd backend && poetry run load`

### ❌ 빌드가 너무 오래 걸림 (10분 이상)
**해결**:
1. 서비스 재시작: Settings → Restart
2. 그래도 안 되면: Remove Service 후 다시 추가

## 💰 예상 비용

### Railway 비용
- **Hobby Plan**: $5/월 (크레딧 포함)
- **예상 월 사용량**:
  - Backend: ~$3-5
  - Frontend: ~$2-3
  - Redis: ~$3-5
  - **총: 약 $8-13/월**

### OpenAI API 비용
- GPT-4: 입력 $0.03/1K 토큰, 출력 $0.06/1K 토큰
- 예상: 일 100회 질문 시 약 $5-10/월

## 📝 운영 관리

### 로그 모니터링
- 각 서비스 → Logs 탭에서 실시간 확인
- 오류 발생 시 빨간색으로 표시됨

### 서비스 재시작
- 서비스 → Settings → Restart

### 코드 업데이트
1. GitHub에 새 코드 push
2. Railway가 자동으로 감지하고 재배포
3. 약 3-5분 후 반영 완료

### 백업
- Redis 데이터는 Railway가 자동 백업
- 중요 데이터는 주기적으로 Export:
  ```
  cd backend && poetry run export
  ```

## 🆘 도움말

### Railway 문서
- 공식 문서: https://docs.railway.app
- 커뮤니티: https://discord.gg/railway

### 이 프로젝트 관련
- GitHub Issues: https://github.com/Lyla-Dev/attendance-management-ai/issues
- 개발자 연락처: [프로젝트 관리자에게 문의]

## ✅ 최종 체크리스트

배포 완료 후 확인:
- [ ] Backend 서비스 초록색 점 확인
- [ ] Frontend 서비스 초록색 점 확인
- [ ] Redis 서비스 초록색 점 확인
- [ ] PDF 문서 로드 완료
- [ ] Frontend URL 접속 가능
- [ ] 테스트 질문 응답 확인 (예: "조부모 상은 며칠?")

---

**작성일**: 2025-08-08
**프로젝트**: 학교 출결 규정 상담 챗봇
**배포 플랫폼**: Railway