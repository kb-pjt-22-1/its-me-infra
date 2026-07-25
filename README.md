# itsme-infra

itsme 프로젝트의 인프라(로컬 개발 환경 + 운영 배포)를 관리하는 레포입니다.
애플리케이션 이미지(`its-me-backend`, `its-me-frontend`)는 각자의 레포에서 빌드해서
GHCR에 push하고, 이 레포는 그 이미지를 **어떻게 실행/배포할지**만 책임집니다.

```
its-me-infra/
├── docker-compose.yml         # 실행 파일 (local / prod profile)
├── .env.example                # 값 채우고 .env로 복사해서 사용
├── nginx/
│   ├── local.conf              # --profile local 용 (TLS 없음)
│   └── user_conf.d/benepay.conf # --profile prod 용 (Let's Encrypt)
├── mysql/init/database.sql     # MySQL 스키마 + 목 데이터
└── .github/workflows/deploy.yml # EC2 배포 워크플로우
```

## 로컬 개발

```bash
cd its-me-infra
cp .env.example .env   # 값 채우기
docker compose --profile local up -d
# 접속: http://localhost:8080  (/api/* -> app, 그 외 -> frontend)
```

- MySQL: 접속 `localhost:3306` / DB `benepay` (스키마: [`mysql/init/database.sql`](mysql/init/database.sql))
- Redis: 접속 `localhost:6379`
- `app`/`frontend`는 GHCR에서 `${IMAGE_TAG:-latest}` / `${FRONTEND_IMAGE_TAG:-latest}` 태그를 pull합니다.
  패키지가 private면 최초 1회 `docker login ghcr.io` 로그인이 필요합니다 (PAT에 `read:packages` 스코프 필요).
- `dev` 브랜치에 push되면 `its-me-backend`/`its-me-frontend`의 CI가 `dev`, `dev-<sha>` 태그로 이미지를 올립니다.
  자동 배포 대상은 아니고, 개발자가 로컬에서 `.env`의 `IMAGE_TAG=dev`/`FRONTEND_IMAGE_TAG=dev`로 pull해서 확인하는 용도입니다.

새 이미지가 올라온 뒤 다시 받아 재시작하려면:

```bash
docker compose pull app
docker compose --profile local up -d
```

## 운영 배포 (EC2)

`docker compose --profile prod up -d` 로 nginx(Let's Encrypt) + app + frontend + mysql + redis 전체 스택을 띄웁니다.
배포 자체는 `.github/workflows/deploy.yml`이 담당하며, 두 가지 방식으로 트리거됩니다.

1. **자동**: `its-me-backend`/`its-me-frontend`의 배포 워크플로우가 이미지를 GHCR에 push한 뒤,
   `repository_dispatch`(type: `deploy`)로 이 레포의 워크플로우를 호출 (이미지 태그를 payload로 전달)
2. **수동**: Actions 탭에서 `Deploy to EC2` 워크플로우를 `workflow_dispatch`로 직접 실행

필요한 GitHub Secrets (이 레포에 등록):
`EC2_HOST`, `EC2_USERNAME`, `EC2_SSH_KEY`, `EC2_PORT`, `EC2_APP_DIR`, `GHCR_PAT`, `GHCR_ACTOR`

## GHCR 이미지 관리

- 이미지는 `its-me-backend`, `its-me-frontend` 레포의 CI가 빌드해서 push합니다 (이 레포는 빌드하지 않음).
- 태그 규칙: `dev`, `dev-<sha>` (dev 브랜치) / `latest`, `main-<sha>` (main 브랜치)
- 패키지가 private라면, GHCR 패키지 설정 → *Manage Actions access*에서 이 레포(`its-me-infra`)를
  추가해야 Actions에서 `GITHUB_TOKEN`만으로도 pull이 가능합니다. EC2 호스트에서 직접 pull할 땐
  계속 PAT(`read:packages`)를 사용합니다.
- 오래된 `dev-<sha>`/`main-<sha>` 이미지가 쌓이므로, 주기적인 정리(cleanup) 워크플로우를 추가하는 것을 권장합니다.
