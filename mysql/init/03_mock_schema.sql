SET NAMES utf8mb4;

DROP DATABASE IF EXISTS kb_card_mock;

CREATE DATABASE kb_card_mock
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_0900_ai_ci;

USE kb_card_mock;


-- =========================================================
-- 목 카드사 고객
-- =========================================================

CREATE TABLE mock_customers
(
    mock_customer_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '목 카드사 고객 ID',

    ci_hash CHAR(64) NOT NULL
        COMMENT 'BenePay 사용자와 목 카드사 고객을 매칭하기 위한 CI 해시값',

    customer_reference_id VARCHAR(255) NOT NULL
        COMMENT '카드사가 부여한 고객 참조 식별값',

    customer_name VARCHAR(100) NOT NULL
        COMMENT '고객명',

    customer_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        COMMENT '고객 상태: ACTIVE, WITHDRAWN',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '고객 등록 일시',

    updated_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
        COMMENT '고객 정보 수정 일시',

    PRIMARY KEY (mock_customer_id),

    UNIQUE KEY UQ_mock_customers_ci_hash
        (ci_hash),

    UNIQUE KEY UQ_mock_customers_customer_reference
        (customer_reference_id),

    KEY IDX_mock_customers_status
        (customer_status)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 목 카드사 카드 상품
-- =========================================================

CREATE TABLE mock_card_products
(
    mock_card_product_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '목 카드 상품 ID',

    product_code VARCHAR(50) NOT NULL
        COMMENT '카드사가 사용하는 카드 상품 코드',

    card_name VARCHAR(100) NOT NULL
        COMMENT '카드 상품명',

    card_type VARCHAR(20) NOT NULL
        COMMENT '카드 유형: CREDIT, CHECK',

    card_network VARCHAR(20) NOT NULL
        COMMENT '카드 결제망: DOMESTIC, VISA, MASTER 등',

    product_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        COMMENT '카드 상품 상태: ACTIVE, DISCONTINUED',

    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '상품 등록 일시',

    updated_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
        COMMENT '상품 정보 수정 일시',

    PRIMARY KEY (mock_card_product_id),

    UNIQUE KEY UQ_mock_card_products_product_code
        (product_code),

    KEY IDX_mock_card_products_card_type
        (card_type),

    KEY IDX_mock_card_products_card_network
        (card_network),

    KEY IDX_mock_card_products_product_status
        (product_status)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 목 카드사 고객 보유 카드
--
-- 고객별 카드 보유 수:
-- 2장 보유 고객 3명
-- 3장 보유 고객 4명
-- 4장 보유 고객 3명
--
-- 같은 고객에게 카드명은 같고 결제망만 다른 상품은 배정하지 않는다.
-- 한 고객 보유 카드당 결제 토큰 하나를 사용하는 것으로 가정한다.
--
-- payment_token 생성 규칙:
-- '947500000000' + pan_last4
--
-- 카드 유효기간이 202812이면
-- 결제 토큰 만료일은 2028-12-31로 설정한다.
-- =========================================================

CREATE TABLE mock_customer_cards
(
    mock_customer_card_id BIGINT NOT NULL AUTO_INCREMENT
        COMMENT '목 카드사 고객 보유 카드 ID',

    mock_customer_id BIGINT NOT NULL
        COMMENT '목 카드사 고객 ID',

    mock_card_product_id BIGINT NOT NULL
        COMMENT '목 카드 상품 ID',

    card_reference_id VARCHAR(100) NOT NULL
        COMMENT '카드사가 부여한 발급 카드 고유 식별값',

    pan_last4 CHAR(4) NOT NULL
        COMMENT '실제 카드번호 마지막 4자리',

    card_expiry_year_month CHAR(6) NOT NULL
        COMMENT '발급 카드 유효기간 YYYYMM',

    card_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE'
        COMMENT '카드 상태: ACTIVE, SUSPENDED, EXPIRED, CANCELED',

    issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        COMMENT '카드 발급 일시',

    token_reference_id VARCHAR(100) DEFAULT NULL
        COMMENT '목 카드사가 발급한 결제 토큰 참조 식별값',

    payment_token VARCHAR(19) DEFAULT NULL
        COMMENT '실제 카드번호 대신 사용하는 프로젝트용 결제 토큰',

    token_expiry_date DATE DEFAULT NULL
        COMMENT '결제 토큰 만료일',

    token_status VARCHAR(20) DEFAULT NULL
        COMMENT '토큰 상태: ACTIVE, SUSPENDED, EXPIRED, DEACTIVATED',

    updated_at DATETIME NOT NULL
        DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
        COMMENT '카드 및 토큰 정보 수정 일시',

    PRIMARY KEY (mock_customer_card_id),

    UNIQUE KEY UQ_mock_customer_cards_card_reference
        (card_reference_id),

    UNIQUE KEY UQ_mock_customer_cards_token_reference
        (token_reference_id),

    UNIQUE KEY UQ_mock_customer_cards_payment_token
        (payment_token),

    KEY IDX_mock_customer_cards_customer_id
        (mock_customer_id),

    KEY IDX_mock_customer_cards_product_id
        (mock_card_product_id),

    KEY IDX_mock_customer_cards_card_status
        (card_status),

    KEY IDX_mock_customer_cards_token_status
        (token_status),

    CONSTRAINT FK_mock_customers_TO_mock_customer_cards
        FOREIGN KEY (mock_customer_id)
            REFERENCES mock_customers (mock_customer_id),

    CONSTRAINT FK_mock_card_products_TO_mock_customer_cards
        FOREIGN KEY (mock_card_product_id)
            REFERENCES mock_card_products (mock_card_product_id)

) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;