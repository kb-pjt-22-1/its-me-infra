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

CREATE TABLE common_code_groups (
                                    group_code VARCHAR(30) NOT NULL,
                                    group_name VARCHAR(100) NOT NULL,
                                    description VARCHAR(255) DEFAULT NULL,

                                    PRIMARY KEY (group_code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE common_codes (
                              code VARCHAR(30) NOT NULL,
                              group_code VARCHAR(30) NOT NULL,
                              code_name VARCHAR(100) NOT NULL,
                              sort_order INT NOT NULL DEFAULT 0,
                              is_active TINYINT(1) NOT NULL DEFAULT 1,

                              PRIMARY KEY (code, group_code),
                              UNIQUE KEY UQ_common_codes_code (code),
                              KEY IDX_common_codes_group_code (group_code),

                              CONSTRAINT FK_common_code_groups_TO_common_codes
                                  FOREIGN KEY (group_code)
                                      REFERENCES common_code_groups (group_code)
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


-- =========================================================
-- 사용자
-- =========================================================

CREATE TABLE users (
                       user_id BIGINT NOT NULL AUTO_INCREMENT,
                       login_id VARCHAR(30) NOT NULL,
                       login_password_hash VARCHAR(255) NOT NULL,
                       pin_hash VARCHAR(100) DEFAULT NULL,
                       name VARCHAR(50) NOT NULL,
                       phone_number VARCHAR(20) DEFAULT NULL,
                       birth_date CHAR(8) DEFAULT NULL,
                       role VARCHAR(20) NOT NULL DEFAULT 'USER',
                       di VARCHAR(100) NOT NULL
                           COMMENT '본인확인기관에서 발급한 중복가입 확인정보',
                       ci_encrypted VARCHAR(200) NOT NULL
                           COMMENT '암호화하여 저장한 연계정보',
                       created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       is_deleted TINYINT(1) NOT NULL DEFAULT 0,
                       fcm_token VARCHAR(255) DEFAULT NULL,

                       PRIMARY KEY (user_id),
                       UNIQUE KEY UQ_users_login_id (login_id),
                       UNIQUE KEY UQ_users_di (di),
                       KEY IDX_users_role (role),

                       CONSTRAINT FK_common_codes_TO_users_role
                           FOREIGN KEY (role)
                               REFERENCES common_codes (code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 카드 상품
-- =========================================================

CREATE TABLE card_variants (
                               card_variant_id CHAR(2) NOT NULL,
                               card_network VARCHAR(20) NOT NULL,

                               PRIMARY KEY (card_variant_id),
                               KEY IDX_card_variants_card_network (card_network),

                               CONSTRAINT FK_common_codes_TO_card_variants_network
                                   FOREIGN KEY (card_network)
                                       REFERENCES common_codes (code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE cards (
                       card_id BIGINT NOT NULL AUTO_INCREMENT,
                       card_name VARCHAR(50) NOT NULL,
                       card_type VARCHAR(20) NOT NULL,
                       card_variant_id CHAR(2) NOT NULL,
                       annual_fee BIGINT NOT NULL DEFAULT 0,
                       card_image_url VARCHAR(255) DEFAULT NULL,
                       description TEXT DEFAULT NULL,
                       is_supported TINYINT(1) NOT NULL DEFAULT 1,
                       min_benefit_amount DECIMAL(8, 0) DEFAULT NULL
                           COMMENT '혜택 제공을 위한 최소 전월 이용실적',
                       benefits_info JSON NOT NULL,

                       PRIMARY KEY (card_id),
                       KEY IDX_cards_card_type (card_type),
                       KEY IDX_cards_card_variant_id (card_variant_id),

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
-- =========================================================

CREATE TABLE user_cards (
                            user_card_id BIGINT NOT NULL AUTO_INCREMENT,
                            user_id BIGINT NOT NULL,
                            card_id BIGINT NOT NULL,
                            token_id VARCHAR(36) NOT NULL
                                COMMENT '결제 토큰의 내부 식별자',
                            payment_token VARCHAR(19) NOT NULL
                                COMMENT '실제 카드번호 대신 결제에 사용하는 토큰',
                            token_expiry_date DATE NOT NULL,
                            pan_hash CHAR(64) NOT NULL
                                COMMENT '중복 카드 확인을 위한 카드번호 해시값',
                            pan_last4 CHAR(4) NOT NULL,
                            par CHAR(29) DEFAULT NULL
                                COMMENT '동일 결제계정을 식별하는 Payment Account Reference',
                            status VARCHAR(20) NOT NULL,
                            is_primary TINYINT(1) NOT NULL DEFAULT 0,
                            recommendation_enabled TINYINT(1) NOT NULL DEFAULT 1,
                            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                            updated_at DATETIME DEFAULT NULL,
                            deleted_at DATETIME DEFAULT NULL,

                            PRIMARY KEY (user_card_id),
                            UNIQUE KEY UQ_user_cards_token_id (token_id),
                            UNIQUE KEY UQ_user_cards_payment_token (payment_token),
                            KEY IDX_user_cards_user_id (user_id),
                            KEY IDX_user_cards_card_id (card_id),
                            KEY IDX_user_cards_status (status),
                            KEY IDX_user_cards_pan_hash (pan_hash),

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


CREATE TABLE card_monthly_status (
                                     card_monthly_status_id BIGINT NOT NULL AUTO_INCREMENT,
                                     user_card_id BIGINT NOT NULL,
                                     target_year_month CHAR(6) NOT NULL
                                         COMMENT '조회 대상 연월, YYYYMM 형식',
                                     total_spending_amount DECIMAL(12, 0) NOT NULL DEFAULT 0,
                                     updated_at DATETIME NOT NULL,

                                     PRIMARY KEY (card_monthly_status_id),
                                     UNIQUE KEY UQ_card_monthly_status_card_month (
                                         user_card_id,
                                         target_year_month
                                         ),

                                     CONSTRAINT FK_user_cards_TO_card_monthly_status
                                         FOREIGN KEY (user_card_id)
                                             REFERENCES user_cards (user_card_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 가맹점 브랜드 및 카테고리
-- =========================================================

CREATE TABLE merchant_brands (
                                 brand_id BIGINT NOT NULL AUTO_INCREMENT,
                                 brand_code VARCHAR(30) NOT NULL
                                     COMMENT 'BenePay 내부 브랜드 코드',
                                 brand_name VARCHAR(100) NOT NULL,
                                 brand_logo VARCHAR(255) DEFAULT NULL,

                                 PRIMARY KEY (brand_id),
                                 UNIQUE KEY UQ_merchant_brands_brand_code (brand_code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE merchant_categories (
                                     category_code CHAR(4) NOT NULL
                                         COMMENT 'MCC를 참고하여 정의한 BenePay 대표 카테고리 코드',
                                     category_name VARCHAR(50) NOT NULL,
                                     category_icon VARCHAR(255) DEFAULT NULL,

                                     PRIMARY KEY (category_code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


CREATE TABLE merchants (
                           merchant_id BIGINT NOT NULL AUTO_INCREMENT,
                           brand_id BIGINT DEFAULT NULL,
                           category_code CHAR(4) NOT NULL,
                           merchant_code VARCHAR(50) NOT NULL
                               COMMENT 'BenePay 내부 가맹점 식별 코드',
                           merchant_name VARCHAR(100) NOT NULL,
                           address VARCHAR(255) NOT NULL,
                           latitude DECIMAL(10, 7) NOT NULL,
                           longitude DECIMAL(10, 7) NOT NULL,
                           phone VARCHAR(20) DEFAULT NULL,

                           PRIMARY KEY (merchant_id),
                           UNIQUE KEY UQ_merchants_merchant_code (merchant_code),
                           KEY IDX_merchants_brand_id (brand_id),
                           KEY IDX_merchants_category_code (category_code),

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

CREATE TABLE bookmarked_stores (
                                   bookmark_id BIGINT NOT NULL AUTO_INCREMENT,
                                   user_id BIGINT NOT NULL,
                                   merchant_id BIGINT NOT NULL,
                                   created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                   is_deleted TINYINT(1) NOT NULL DEFAULT 0,

                                   PRIMARY KEY (bookmark_id),
                                   UNIQUE KEY UQ_bookmarked_stores_user_merchant (
                                       user_id,
                                       merchant_id
                                       ),
                                   KEY IDX_bookmarked_stores_merchant_id (merchant_id),

                                   CONSTRAINT FK_users_TO_bookmarked_stores
                                       FOREIGN KEY (user_id)
                                           REFERENCES users (user_id),

                                   CONSTRAINT FK_merchants_TO_bookmarked_stores
                                       FOREIGN KEY (merchant_id)
                                           REFERENCES merchants (merchant_id)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;


-- =========================================================
-- 결제
-- =========================================================

CREATE TABLE payments (
                          payment_id BIGINT NOT NULL AUTO_INCREMENT,
                          merchant_id BIGINT NOT NULL,
                          user_card_id BIGINT NOT NULL,
                          payment_time DATETIME NOT NULL,
                          original_amount DECIMAL(10, 0) NOT NULL,
                          discount_amount DECIMAL(10, 0) NOT NULL DEFAULT 0,
                          final_amount DECIMAL(10, 0) NOT NULL,
                          payment_status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
                          payment_method VARCHAR(20) NOT NULL,

                          PRIMARY KEY (payment_id),
                          KEY IDX_payments_merchant_id (merchant_id),
                          KEY IDX_payments_user_card_id (user_card_id),
                          KEY IDX_payments_payment_status (payment_status),
                          KEY IDX_payments_payment_method (payment_method),

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
-- =========================================================

CREATE TABLE card_issuance_events (
                                      id BIGINT NOT NULL AUTO_INCREMENT,
                                      event_id VARCHAR(36) NOT NULL
                                          COMMENT '카드사 또는 외부 시스템에서 전달받은 이벤트 ID',
                                      ci_hash CHAR(64) NOT NULL
                                          COMMENT '사용자 매칭을 위한 CI 해시값',
                                      card_ref_id VARCHAR(64) NOT NULL
                                          COMMENT '카드사가 전달한 카드 참조 식별자',
                                      card_last4 CHAR(4) DEFAULT NULL,
                                      card_type VARCHAR(20) DEFAULT NULL,
                                      status VARCHAR(20) NOT NULL,
                                      fail_reason VARCHAR(30) DEFAULT NULL,
                                      processed_at DATETIME DEFAULT NULL,

                                      PRIMARY KEY (id),
                                      UNIQUE KEY UQ_card_issuance_events_event_id (event_id),
                                      KEY IDX_card_issuance_events_ci_hash (ci_hash),
                                      KEY IDX_card_issuance_events_card_type (card_type),
                                      KEY IDX_card_issuance_events_status (status),

                                      CONSTRAINT FK_common_codes_TO_card_issuance_events_card_type
                                          FOREIGN KEY (card_type)
                                              REFERENCES common_codes (code),

                                      CONSTRAINT FK_common_codes_TO_card_issuance_events_status
                                          FOREIGN KEY (status)
                                              REFERENCES common_codes (code)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_0900_ai_ci;