# itsme-infra

itsme 프로젝트의 인프라(로컬 개발 환경 + 운영 배포)를 관리하는 레포입니다.
애플리케이션 이미지(`its-me-backend`, `its-me-frontend`)는 각자의 레포에서 빌드해서
GHCR에 push하고, 이 레포는 그 이미지를 **어떻게 실행/배포할지**만 책임집니다.

```
its-me-infra/
├── docker-compose.yml         # 실행 파일 (local / prod profile)
├── .env                        # 로컬 전용, git에는 없음 (아래 변수 참고). prod는 GitHub Secrets 사용, 파일 없음
├── nginx/
│   ├── local.conf              # --profile local 용 (TLS 없음)
│   └── benepay.conf            # --profile prod 용 (Let's Encrypt)
├── mysql/init/
│   ├── 01_schema.sql            # DDL (테이블/PK/FK/AUTO_INCREMENT/UNIQUE)
│   └── 02_seed.sql              # 목 데이터 (INSERT)
└── .github/workflows/
    ├── deploy.yml               # backend/frontend 배포 (앱 레포가 dispatch)
    └── infra-deploy.yml         # nginx/mysql/redis 배포 (이 레포 main push)
```

## 로컬 개발

```bash
cd its-me-infra
docker compose --profile local up -d
# 접속: http://localhost:8080  (/api/* -> backend, 그 외 -> frontend)
```

- MySQL: 접속 `localhost:${MYSQL_PORT:-3306}` / DB `benepay` (스키마: [`01_schema.sql`](mysql/init/01_schema.sql), 목데이터: [`02_seed.sql`](mysql/init/02_seed.sql))
- Redis: 접속 `localhost:${REDIS_PORT:-6379}`
- `.env`에 `MYSQL_PORT`/`REDIS_PORT`를 안 채우면 기본 포트(3306/6379)로 열립니다. 로컬은 인터넷에
  노출되지 않으니 편의상 기본값을 써도 되지만, prod와 동일하게 맞추고 싶으면 값을 채워두세요.
- `backend`/`frontend`는 GHCR에서 `${IMAGE_TAG:-latest}` / `${FRONTEND_IMAGE_TAG:-latest}` 태그를 pull합니다.
  패키지가 private면 최초 1회 `docker login ghcr.io` 로그인이 필요합니다 (PAT에 `read:packages` 스코프 필요).
- `dev` 브랜치에 push되면 `its-me-backend`/`its-me-frontend`의 CI가 `dev`, `dev-<sha>` 태그로 이미지를 올립니다.
  자동 배포 대상은 아니고, 개발자가 로컬에서 `.env`의 `IMAGE_TAG=dev`/`FRONTEND_IMAGE_TAG=dev`로 pull해서 확인하는 용도입니다.

새 이미지가 올라온 뒤 다시 받아 재시작하려면:

```bash
docker compose pull backend
docker compose --profile local up -d
```

## 운영 배포 (EC2)

`docker compose --profile prod up -d` 로 nginx(Let's Encrypt) + backend + frontend + mysql + redis 전체 스택을 띄웁니다.
EC2에 SSH로 접속하는 워크플로우는 **이 레포에 두 개**이고, 서로 책임이 나뉘어 있습니다.

### 1. `deploy.yml` — backend/frontend 컨테이너

`its-me-backend`/`its-me-frontend`는 이미지만 만들어 push한 뒤 이 워크플로우를 호출합니다.

- **자동**: 각 앱 레포의 `main` push → 이미지를 GHCR에 push한 뒤
  `repository_dispatch`(type: `deploy`)로 이 워크플로우를 호출.
  payload의 `service`(`backend` | `frontend`)로 **자기 컨테이너만** pull/재기동합니다.

  | 호출자 | payload |
  |---|---|
  | its-me-backend | `{"service": "backend", "image_tag": "main-<sha>"}` |
  | its-me-frontend | `{"service": "frontend", "frontend_image_tag": "main-<sha>"}` |

- **수동**: Actions 탭에서 `Deploy to EC2` 워크플로우를 `workflow_dispatch`로 직접 실행.
  `service`를 비워두면 prod 스택 전체를 pull/재기동합니다 (nginx/mysql/redis 포함, 새 EC2 최초 세팅용).

### 2. `infra-deploy.yml` — nginx/mysql/redis

이 레포 자신의 `main`에 `docker-compose.yml`, `nginx/**`, `mysql/init/**`가 push되면 자동으로 실행됩니다.
backend/frontend 컨테이너는 건드리지 않습니다.

- **nginx/redis**: `down` 후 `up`으로 완전히 재기동 — 바인드 마운트된 conf 파일 내용은
  compose가 변경 감지를 못 하므로, 재기동해야 새 설정이 실제로 적용됩니다.
- **mysql**: `docker-compose.yml`의 mysql 설정(이미지 태그, 환경변수 등)이 바뀐 경우에만
  nginx/redis와 동일하게 `down` 후 `up`으로 재기동합니다. `mysql-data`는 named volume이라
  컨테이너를 내려도 지워지지 않으니 데이터는 유지됩니다. 그 외의 경우엔 컨테이너 기동만 보장합니다.
  `docker-entrypoint-initdb.d`는 데이터 볼륨이 비어있을 때 **딱 한 번만** 실행되기 때문에,
  재기동만으로는 스키마/시드 변경이 반영되지 않습니다 — 대신 컨테이너가 떠 있는 채로
  `01_schema.sql` → `02_seed.sql`을 직접 실행합니다.

  ⚠️ `01_schema.sql`이 `DROP DATABASE IF EXISTS`로 시작하므로, **이 워크플로우가 돌 때마다
  `benepay` DB를 통째로 지우고 다시 만듭니다.** 목데이터 단계에서만 쓰는 방식이며, 실 사용자
  데이터가 쌓이기 시작하면 증분 마이그레이션 도구(Flyway 등)로 바꿔야 합니다.

**EC2에는 `.env` 파일을 두지 않습니다.** `docker-compose.yml`이 참조하는 `${VAR}` 값들은
`deploy.yml`이 이 레포의 GitHub Secrets에서 읽어 SSH 세션 환경변수로 주입합니다
(`envs:` 목록으로 원격 셸에 전달 → `docker compose`가 그 셸 환경을 보고 치환).
Secret 값을 바꾸면 다음 배포 때 바로 반영되고, 서버에 평문 비밀 파일이 남지 않습니다.

필요한 GitHub Secrets:

- **이 레포 (EC2 접속)**: `EC2_HOST`, `EC2_USERNAME`, `EC2_SSH_KEY`, `EC2_PORT`, `EC2_APP_DIR`, `GHCR_PAT`, `GHCR_ACTOR`
- **이 레포 (앱 설정값, `docker-compose.yml`이 참조)**:
  `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `MYSQL_ROOT_PASSWORD`, `MYSQL_PORT`, `REDIS_PORT`,
  `CERTBOT_EMAIL`, `JWT_SECRET`, `PORTONE_IMP_KEY`, `PORTONE_IMP_SECRET`, `DI_HASH_SALT`,
  `OPENAI_API_KEY`, `FIREBASE_CREDENTIALS_JSON`

  `MYSQL_PORT`/`REDIS_PORT`는 mysql/redis를 host에 노출할 포트 번호입니다. 기본 포트(3306/6379)를
  그대로 안 쓰고 secret으로 관리해서, 자동 스캔으로 뻔한 포트가 바로 발견되는 걸 줄입니다.
  (EC2 보안그룹에서 아예 안 열어두는 게 더 안전하지만, 값을 아는 사람만 접근 가능하게 하는
  최소한의 보완책입니다.)
- **앱 레포(backend/frontend)**: `INFRA_DISPATCH_PAT` — 이 레포에 `repository_dispatch`를 보낼 수 있는
  `repo` 스코프 PAT. 앱 레포는 더 이상 EC2 접속 정보(`EC2_*`, `GHCR_PAT`)를 갖고 있을 필요가 없습니다.

### 새 EC2 최초 세팅 (한 번만)

서비스 단위 배포(`service=backend` / `frontend`)는 **nginx를 기동하지 않습니다.**
compose의 의존 방향이 `nginx → backend/frontend`라서, `up -d backend`는 `backend`+`mysql`+`redis`까지만 띄웁니다.
따라서 새로 만든 EC2에서는 아래 순서를 거쳐야 합니다.

1. 위 Secrets를 모두 등록합니다 (특히 앱 설정값 11개 — 하나라도 빠지면 해당 서비스가 빈 값으로 뜹니다).
2. GHCR 패키지가 private면 `docker login ghcr.io` (PAT에 `read:packages`).
3. Actions 탭 → `Deploy to EC2` → `workflow_dispatch`로 **`service`를 비운 채 실행**.
   nginx 포함 전체 스택이 올라오고 Let's Encrypt 인증서가 발급됩니다.

이후부터는 각 앱 레포의 `main` push가 자기 컨테이너만 재배포합니다.

## GHCR 이미지 관리

- 이미지는 `its-me-backend`, `its-me-frontend` 레포의 CI가 빌드해서 push합니다 (이 레포는 빌드하지 않음).
- 태그 규칙: `dev`, `dev-<sha>` (dev 브랜치) / `latest`, `main-<sha>` (main 브랜치)
- **`dev` push는 이미지 빌드/push까지만** 하고 배포하지 않습니다. 운영 배포는 `main` push에서만 일어납니다.
- 패키지가 private라면, GHCR 패키지 설정 → *Manage Actions access*에서 이 레포(`its-me-infra`)를
  추가해야 Actions에서 `GITHUB_TOKEN`만으로도 pull이 가능합니다. EC2 호스트에서 직접 pull할 땐
  계속 PAT(`read:packages`)를 사용합니다.
- 오래된 `dev-<sha>`/`main-<sha>` 이미지가 쌓이므로, 주기적인 정리(cleanup) 워크플로우를 추가하는 것을 권장합니다.
