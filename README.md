# itsme-infra

itsme 프로젝트의 로컬 개발용 인프라(MySQL, Redis 등) 설정 모음입니다.

## MySQL

```bash
cd mysql
cp .env.example .env   # 값 채우기
docker compose up -d
```

- 스키마: [`mysql/init/01_schema.sql`](mysql/init/01_schema.sql)
- 접속: `localhost:3306`, DB `benepay`
