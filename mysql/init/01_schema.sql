-- Docker에서 MySQL 띄울 시 한글 깨짐 문제 해결 설정 --
SET NAMES utf8mb4;

DROP DATABASE IF EXISTS benepay;

CREATE DATABASE benepay
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE benepay;


-- =========================================================
-- 공통 코드
-- =========================================================

CREATE TABLE common_code_groups
(
    group_code VARCHAR(30) NOT NULL
        COMMENT '공통 코드 그룹 식별값',

    group_name VARCHAR(100) NOT NULL
        COMMENT '공통 코드 그룹명',

    description VARCHAR(255) DEFAULT NULL
        COMMENT '공통 코드 그룹 설명',

    PRIMARY KEY (group_code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE common_codes
(
    code VARCHAR(30) NOT NULL
        COMMENT '공통 코드값',

    group_code VARCHAR(30) NOT NULL
        COMMENT '공통 코드 그룹',

    code_name VARCHAR(100) NOT NULL
        COMMENT '공통 코드 표시명',

    sort_order INT NOT NULL DEFAULT 0
        COMMENT '정렬 순서',

    is_active TINYINT(1) NOT NULL DEFAULT 1
        COMMENT '사용 여부',

    PRIMARY KEY (code, group_code),

    /*
     * 다른 테이블에서 common_codes.code 하나만 참조하기 위해
     * code를 전체 공통 코드에서 유일하게 관리한다.
     */
    UNIQUE KEY UQ_common_codes_code
        (code),

    KEY IDX_common_codes_group_code
        (group_code),

    CONSTRAINT FK_common_code_groups_TO_common_codes
        FOREIGN KEY (group_code)
            REFERENCES common_code_groups (group_code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 사용자
-- =========================================================

CREATE TABLE users
(
    user_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '사용자 ID',

    login_id VARCHAR(30) NOT NULL
        COMMENT '로그인 ID',

    login_password_hash VARCHAR(255) NOT NULL
        COMMENT '로그인 비밀번호 해시값',

    pin_hash VARCHAR(100) DEFAULT NULL
        COMMENT '결제 PIN 해시값',

    name VARCHAR(50) NOT NULL
        COMMENT '사용자명',

    phone_number VARCHAR(20) DEFAULT NULL
        COMMENT '휴대전화번호',

    birth_date CHAR(8) DEFAULT NULL
        COMMENT '생년월일 YYYYMMDD',

    role VARCHAR(20) NOT NULL DEFAULT 'USER'
        COMMENT '사용자 권한',

    di VARCHAR(100) NOT NULL
        COMMENT '본인확인기관에서 발급한 중복가입 확인정보',

    ci_hash CHAR(64) NOT NULL
        COMMENT '목 카드사 및 카드 발급 이벤트 사용자 매칭용 CI 해시값',

    ci_encrypted VARCHAR(200) NOT NULL
        COMMENT '암호화하여 저장한 연계정보 CI',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '가입 일시',

    is_deleted TINYINT(1) NOT NULL DEFAULT 0
        COMMENT '탈퇴 여부',

    fcm_token VARCHAR(255) DEFAULT NULL
        COMMENT '푸시 알림용 FCM 토큰',

    PRIMARY KEY (user_id),

    UNIQUE KEY UQ_users_login_id
        (login_id),

    UNIQUE KEY UQ_users_di
        (di),

    UNIQUE KEY UQ_users_ci_hash
        (ci_hash),

    KEY IDX_users_role
        (role),

    CONSTRAINT FK_common_codes_TO_users_role
        FOREIGN KEY (role)
            REFERENCES common_codes (code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 카드 결제망
-- =========================================================

CREATE TABLE card_variants
(
    card_variant_id CHAR(2) NOT NULL
        COMMENT '카드 결제망 유형 ID',

    card_network VARCHAR(20) NOT NULL
        COMMENT '카드 결제망: DOMESTIC, VISA, MASTER, JCB, AMEX, UPI',

    PRIMARY KEY (card_variant_id),

    KEY IDX_card_variants_card_network
        (card_network),

    CONSTRAINT FK_common_codes_TO_card_variants_network
        FOREIGN KEY (card_network)
            REFERENCES common_codes (code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 카드 상품
-- =========================================================

CREATE TABLE cards
(
    card_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT 'BenePay 카드 상품 ID',

    issuer_product_code VARCHAR(50) NOT NULL
        COMMENT '카드사가 사용하는 카드 상품 코드',

    card_name VARCHAR(50) NOT NULL
        COMMENT '카드 상품명',

    card_type VARCHAR(20) NOT NULL
        COMMENT '카드 유형: CREDIT, CHECK',

    card_variant_id CHAR(2) NOT NULL
        COMMENT '카드 결제망 유형 ID',

    annual_fee BIGINT NOT NULL DEFAULT 0
        COMMENT '연회비',

    card_image_url VARCHAR(255) DEFAULT NULL
        COMMENT '카드 이미지 URL',

    description TEXT DEFAULT NULL
        COMMENT '카드 설명',

    is_supported TINYINT(1) NOT NULL DEFAULT 1
        COMMENT 'BenePay 지원 여부',

    min_benefit_amount DECIMAL(8, 0) DEFAULT NULL
        COMMENT '혜택 제공을 위한 최소 전월 이용실적',

    benefits_info JSON NOT NULL
        COMMENT '카드 혜택 정보',

    PRIMARY KEY (card_id),

    UNIQUE KEY UQ_cards_issuer_product_code
        (issuer_product_code),

    KEY IDX_cards_card_type
        (card_type),

    KEY IDX_cards_card_variant_id
        (card_variant_id),

    CONSTRAINT FK_common_codes_TO_cards_card_type
        FOREIGN KEY (card_type)
            REFERENCES common_codes (code),

    CONSTRAINT FK_card_variants_TO_cards
        FOREIGN KEY (card_variant_id)
            REFERENCES card_variants (card_variant_id)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 사용자 보유 카드
--
-- 한 사용자 보유 카드당 결제 토큰 하나를 사용하는 것으로 가정
-- 회원가입 연동 또는 웹훅 처리 후 토큰까지 발급된 카드만 저장
-- =========================================================

CREATE TABLE user_cards
(
    user_card_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '사용자 보유 카드 ID',

    user_id BIGINT NOT NULL
        COMMENT '사용자 ID',

    card_id BIGINT NOT NULL
        COMMENT 'BenePay 카드 상품 ID',

    issuer_card_reference_id VARCHAR(100) NOT NULL
        COMMENT '카드사가 부여한 발급 카드 고유 식별값',

    issuer_token_reference_id VARCHAR(100) NOT NULL
        COMMENT '카드사가 발급한 결제 토큰 참조 식별값',

    payment_token VARCHAR(19) NOT NULL
        COMMENT '카드사가 발급한 프로젝트용 결제 토큰',

    card_expiry_year_month CHAR(6) NOT NULL
        COMMENT '발급 카드 유효기간 YYYYMM',

    token_expiry_date DATE NOT NULL
        COMMENT '결제 토큰 만료일',

    pan_last4 CHAR(4) NOT NULL
        COMMENT '실제 카드번호 마지막 4자리',

    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        COMMENT '카드 상태: ACTIVE, SUSPENDED, EXPIRED, UNLINKED, DELETED',

    is_primary TINYINT(1) NOT NULL DEFAULT 0
        COMMENT '대표 카드 여부',

    recommendation_enabled TINYINT(1) NOT NULL DEFAULT 1
        COMMENT '카드 추천 포함 여부',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '카드 등록 일시',

    updated_at DATETIME DEFAULT NULL
        ON UPDATE CURRENT_TIMESTAMP
    COMMENT '카드 정보 수정 일시',

    deleted_at DATETIME DEFAULT NULL
        COMMENT '카드 삭제 일시',

    PRIMARY KEY (user_card_id),

    UNIQUE KEY UQ_user_cards_issuer_reference
        (user_id, issuer_card_reference_id),

    UNIQUE KEY UQ_user_cards_token_reference
        (issuer_token_reference_id),

    UNIQUE KEY UQ_user_cards_payment_token
        (payment_token),

    KEY IDX_user_cards_user_id
        (user_id),

    KEY IDX_user_cards_card_id
        (card_id),

    KEY IDX_user_cards_status
        (status),

    CONSTRAINT FK_users_TO_user_cards
        FOREIGN KEY (user_id)
            REFERENCES users (user_id),

    CONSTRAINT FK_cards_TO_user_cards
        FOREIGN KEY (card_id)
            REFERENCES cards (card_id),

    CONSTRAINT FK_common_codes_TO_user_cards_status
        FOREIGN KEY (status)
            REFERENCES common_codes (code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 카드 월별 실적
-- =========================================================

CREATE TABLE card_monthly_status
(
    card_monthly_status_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '카드 월별 실적 ID',

    user_card_id BIGINT NOT NULL
        COMMENT '사용자 보유 카드 ID',

    target_year_month CHAR(6) NOT NULL
        COMMENT '실적 대상 연월 YYYYMM',

    total_spending_amount DECIMAL(12, 0) NOT NULL DEFAULT 0
        COMMENT '해당 월 총 실적 인정 금액',

    updated_at DATETIME NOT NULL
                                                  DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
        COMMENT '월별 실적 최종 변경 일시',

    PRIMARY KEY (card_monthly_status_id),

    UNIQUE KEY UQ_card_monthly_status_card_month
        (user_card_id, target_year_month),

    CONSTRAINT FK_user_cards_TO_card_monthly_status
        FOREIGN KEY (user_card_id)
            REFERENCES user_cards (user_card_id)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 가맹점 브랜드
-- =========================================================

CREATE TABLE merchant_brands
(
    brand_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '가맹점 브랜드 ID',

    brand_code VARCHAR(30) NOT NULL
        COMMENT 'BenePay 내부 브랜드 코드',

    brand_name VARCHAR(100) NOT NULL
        COMMENT '브랜드명',

    brand_logo VARCHAR(255) DEFAULT NULL
        COMMENT '브랜드 로고 URL',

    PRIMARY KEY (brand_id),

    UNIQUE KEY UQ_merchant_brands_brand_code
        (brand_code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 가맹점 카테고리
-- =========================================================

CREATE TABLE merchant_categories
(
    category_code CHAR(4) NOT NULL
        COMMENT 'MCC를 참고하여 정의한 BenePay 대표 카테고리 코드',

    category_name VARCHAR(50) NOT NULL
        COMMENT '카테고리명',

    category_icon VARCHAR(255) DEFAULT NULL
        COMMENT '카테고리 아이콘 URL',

    PRIMARY KEY (category_code),

    UNIQUE KEY UQ_merchant_categories_category_name
        (category_name)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 가맹점
-- =========================================================

CREATE TABLE merchants
(
    merchant_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '가맹점 ID',

    brand_id BIGINT DEFAULT NULL
        COMMENT '가맹점 브랜드 ID, 개인 매장은 NULL 가능',

    category_code CHAR(4) NOT NULL
        COMMENT '가맹점 카테고리 코드',

    merchant_code VARCHAR(50) NOT NULL
        COMMENT 'BenePay 내부 가맹점 식별 코드',

    merchant_name VARCHAR(100) NOT NULL
        COMMENT '가맹점명',

    address VARCHAR(255) NOT NULL
        COMMENT '가맹점 주소',

    latitude DECIMAL(10, 7) NOT NULL
        COMMENT '위도',

    longitude DECIMAL(10, 7) NOT NULL
        COMMENT '경도',

    phone VARCHAR(20) DEFAULT NULL
        COMMENT '가맹점 전화번호',

    PRIMARY KEY (merchant_id),

    UNIQUE KEY UQ_merchants_merchant_code
        (merchant_code),

    KEY IDX_merchants_brand_id
        (brand_id),

    KEY IDX_merchants_category_code
        (category_code),

    CONSTRAINT FK_merchant_brands_TO_merchants
        FOREIGN KEY (brand_id)
            REFERENCES merchant_brands (brand_id),

    CONSTRAINT FK_merchant_categories_TO_merchants
        FOREIGN KEY (category_code)
            REFERENCES merchant_categories (category_code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 저장 매장
-- =========================================================

CREATE TABLE bookmarked_merchants (
                                   bookmark_id BIGINT NOT NULL AUTO_INCREMENT,
                                   user_id BIGINT NOT NULL,
                                   merchant_id BIGINT NOT NULL,
                                   created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   is_deleted TINYINT(1) NOT NULL DEFAULT 0,

                                   PRIMARY KEY (bookmark_id),
                                   UNIQUE KEY UQ_bookmarked_merchants_user_merchant (
                                       user_id,
                                       merchant_id
                                       ),
                                   KEY IDX_bookmarked_merchants_merchant_id (merchant_id),

                                   CONSTRAINT FK_users_TO_bookmarked_merchants
                                       FOREIGN KEY (user_id)
                                           REFERENCES users (user_id),

                                   CONSTRAINT FK_merchants_TO_bookmarked_merchants
                                       FOREIGN KEY (merchant_id)
                                           REFERENCES merchants (merchant_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 결제
-- =========================================================

CREATE TABLE payments
(
    payment_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '결제 ID',

    merchant_id BIGINT NOT NULL
        COMMENT '가맹점 ID',

    user_card_id BIGINT NOT NULL
        COMMENT '결제에 사용한 사용자 보유 카드 ID',

    payment_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '결제 일시',

    original_amount DECIMAL(10, 0) NOT NULL
        COMMENT '할인 전 결제 금액',

    discount_amount DECIMAL(10, 0) NOT NULL DEFAULT 0
        COMMENT '할인 금액',

    final_amount DECIMAL(10, 0) NOT NULL
        COMMENT '최종 결제 금액',

    benefit_service_name VARCHAR(100) DEFAULT NULL
        COMMENT '이 결제에 적용된 혜택의 serviceName. 감사/재계산용 - 집계 테이블이 깨지면 여기서 다시 만들 수 있다.',

    payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING'
        COMMENT '결제 상태: PENDING, APPROVED, CANCELED, PAYMENT_FAILED',

    payment_method VARCHAR(20) NOT NULL
        COMMENT '결제 방식: BARCODE, QR',

    PRIMARY KEY (payment_id),

    KEY IDX_payments_merchant_id
        (merchant_id),

    KEY IDX_payments_user_card_id
        (user_card_id),

    KEY IDX_payments_payment_status
        (payment_status),

    KEY IDX_payments_payment_method
        (payment_method),

    CONSTRAINT FK_merchants_TO_payments
        FOREIGN KEY (merchant_id)
            REFERENCES merchants (merchant_id),

    CONSTRAINT FK_user_cards_TO_payments
        FOREIGN KEY (user_card_id)
            REFERENCES user_cards (user_card_id),

    CONSTRAINT FK_common_codes_TO_payments_status
        FOREIGN KEY (payment_status)
            REFERENCES common_codes (code),

    CONSTRAINT FK_common_codes_TO_payments_method
        FOREIGN KEY (payment_method)
            REFERENCES common_codes (code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 카드 발급 이벤트
--
-- 신규 카드 발급 웹훅 수신 내용과 처리 결과를 저장한다.
-- 결제 토큰은 이 테이블에 저장하지 않고,
-- card_reference_id로 목서버를 다시 호출하여 발급받는다.
-- =========================================================

CREATE TABLE card_issuance_events
(
    id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '카드 발급 이벤트 내부 ID',

    event_id VARCHAR(36) NOT NULL
        COMMENT '목 카드사가 전달한 이벤트 고유 ID',

    ci_hash CHAR(64) NOT NULL
        COMMENT 'BenePay 사용자 매칭용 CI 해시값',

    card_reference_id VARCHAR(100) NOT NULL
        COMMENT '목 카드사가 전달한 발급 카드 고유 식별값',

    issuer_product_code VARCHAR(50) NOT NULL
        COMMENT '목 카드사가 전달한 카드 상품 코드',

    card_last4 CHAR(4) DEFAULT NULL
        COMMENT '카드번호 마지막 4자리',

    card_type VARCHAR(20) DEFAULT NULL
        COMMENT '카드 유형: CREDIT, CHECK',

    card_status VARCHAR(20) NOT NULL
        COMMENT '카드 상태: ACTIVE, SUSPENDED, EXPIRED, CANCELED',

    processing_status VARCHAR(20) NOT NULL DEFAULT 'RECEIVED'
        COMMENT '이벤트 처리 상태: RECEIVED, PROCESSED, FAILED',

    fail_reason VARCHAR(255) DEFAULT NULL
        COMMENT '이벤트 처리 실패 사유',

    received_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '웹훅 수신 일시',

    processed_at DATETIME DEFAULT NULL
        COMMENT '웹훅 처리 완료 일시',

    PRIMARY KEY (id),

    UNIQUE KEY UQ_card_issuance_events_event_id
        (event_id),

    KEY IDX_card_issuance_events_ci_hash
        (ci_hash),

    KEY IDX_card_issuance_events_card_reference
        (card_reference_id),

    KEY IDX_card_issuance_events_product_code
        (issuer_product_code),

    KEY IDX_card_issuance_events_processing_status
        (processing_status),

    CONSTRAINT FK_common_codes_TO_card_events_card_type
        FOREIGN KEY (card_type)
            REFERENCES common_codes (code),

    CONSTRAINT FK_common_codes_TO_card_events_card_status
        FOREIGN KEY (card_status)
            REFERENCES common_codes (code),

    CONSTRAINT FK_common_codes_TO_card_events_processing_status
        FOREIGN KEY (processing_status)
            REFERENCES common_codes (code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

-- =========================================================
-- 사용자 카드 카테고리별 월 혜택 사용 현황
-- =========================================================

CREATE TABLE user_card_benefit_monthly_status
(
    user_card_benefit_monthly_status_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '사용자 카드 혜택 월별 현황 ID',

    user_card_id BIGINT NOT NULL
        COMMENT '사용자 보유 카드 ID',

    category_code CHAR(4) NOT NULL
        COMMENT '혜택 카테고리 코드',

    target_year_month CHAR(6) NOT NULL
        COMMENT '대상 연월 YYYYMM',

    used_benefit_amount DECIMAL(10, 0) NOT NULL DEFAULT 0
        COMMENT '해당 월 카테고리 혜택 사용 금액',

    usage_count INT NOT NULL DEFAULT 0
        COMMENT '해당 월 카테고리 혜택 사용 횟수',

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
        COMMENT '혜택 사용 현황 최종 수정 일시',

    PRIMARY KEY (user_card_benefit_monthly_status_id),

    UNIQUE KEY UQ_user_card_benefit_monthly_status
        (user_card_id, category_code, target_year_month),

    KEY IDX_user_card_benefit_monthly_category
        (category_code),

    CONSTRAINT FK_user_cards_TO_user_card_benefit_monthly_status
        FOREIGN KEY (user_card_id)
            REFERENCES user_cards (user_card_id),

    CONSTRAINT FK_merchant_categories_TO_user_card_benefit_monthly_status
        FOREIGN KEY (category_code)
            REFERENCES merchant_categories (category_code)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

-- =========================================================
-- 카드 추천(모드 1) 혜택 소진액
--
-- 한도소진/횟수소진 판정을 위한 혜택별 월/연 사용액 집계 테이블.
-- 키는 performanceTiers[].benefitNodeId(구간 id)가 아니라 개별 혜택의
-- serviceName이다 - benefits_info JSON에서 구간 하나에 여러 혜택이 들어있고,
-- 한도/횟수 제한은 혜택 하나하나에 걸리기 때문이다.
-- =========================================================

CREATE TABLE card_benefit_monthly_usage
(
    card_benefit_monthly_usage_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '카드 혜택 월별 소진액 ID',

    user_card_id BIGINT NOT NULL
        COMMENT '사용자 보유 카드 ID',

    benefit_service_name VARCHAR(100) NOT NULL
        COMMENT 'benefits_info JSON의 benefit.serviceName',

    target_year INT NOT NULL
        COMMENT 'annualCountLimit 집계용 - target_year_month에서 매번 파싱하지 않도록 별도 컬럼으로 둠',

    target_year_month CHAR(6) NOT NULL
        COMMENT '대상 연월 YYYYMM',

    used_amount DECIMAL(12, 0) NOT NULL DEFAULT 0
        COMMENT '해당 월 혜택 사용 금액',

    used_count INT NOT NULL DEFAULT 0
        COMMENT '해당 월 혜택 사용 횟수',

    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
        COMMENT '혜택 소진액 최종 수정 일시',

    PRIMARY KEY (card_benefit_monthly_usage_id),

    UNIQUE KEY UQ_card_benefit_monthly_usage
        (user_card_id, benefit_service_name, target_year_month),

    KEY IDX_card_benefit_monthly_usage_year
        (user_card_id, target_year),

    CONSTRAINT FK_user_cards_TO_card_benefit_monthly_usage
        FOREIGN KEY (user_card_id)
            REFERENCES user_cards (user_card_id)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;

-- =========================================================
-- 암호화 키
-- 개발·운영 환경별 키 데이터는 별도로 주입
-- =========================================================

CREATE TABLE encryption_keys (
                                 key_id BIGINT NOT NULL AUTO_INCREMENT,
                                 key_alias VARCHAR(50) NOT NULL,
                                 key_value VARCHAR(255) NOT NULL
                                     COMMENT 'Base64로 인코딩된 대칭키',
                                 algorithm VARCHAR(30) NOT NULL DEFAULT 'AES256',
                                 is_active TINYINT(1) NOT NULL DEFAULT 1,
                                 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

                                 PRIMARY KEY (key_id),
                                 UNIQUE KEY UQ_encryption_keys_key_alias (key_alias)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;
