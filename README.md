# itsme-infra

itsme 프로젝트의 로컬 개발용 인프라(MySQL, Redis 등) 스키마/설정과 `docker-compose.yml`을 관리하는 레포입니다.

```
its-me-infra/
├── docker-compose.yml   # 실행 파일
├── .env.example         # 값 채우고 .env로 복사해서 사용
└── mysql/init/           # MySQL 스키마
```

```bash
cd its-me-infra
cp .env.example .env   # 값 채우기
docker compose up -d
```

- MySQL 스키마: [`mysql/init/01_schema.sql`](mysql/init/01_schema.sql), 접속 `localhost:3306` / DB `benepay`
- Redis: 접속 `localhost:6379`, 비밀번호 인증(`requirepass`) 필수
