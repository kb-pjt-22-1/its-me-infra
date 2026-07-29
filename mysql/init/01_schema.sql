 DROP DATABASE IF EXISTS benepay;
CREATE DATABASE benepay;
USE benepay;

-- ===== Tables (structure: "Copy of IT'S ME.sql" / constraints: existing database.sql) =====

CREATE TABLE `merchant_categories` (
    `category_id`        BIGINT        NOT NULL,
    `category_code`      VARCHAR(30)   NOT NULL,
    `category_name`      VARCHAR(50)   NOT NULL
);

CREATE TABLE `cards` (
    `card_id`             BIGINT         NOT NULL,
    `card_name`           VARCHAR(50)    NOT NULL,
    `card_type`           VARCHAR(20)    NOT NULL    COMMENT 'CREDIT / CHECK',
    `card_image_url`      VARCHAR(255)   NULL,
    `description`         TEXT           NULL,
    `is_supported`        BOOLEAN        NOT NULL    DEFAULT TRUE,
    `min_benefit_amount`  DECIMAL(8,0)   NULL
);

CREATE TABLE `card_variants` (
    `card_variant_id`  BIGINT        NOT NULL,
    `card_id`          BIGINT        NOT NULL,
    `card_network`     VARCHAR(20)   NOT NULL    COMMENT '국내전용, visa',
    `annual_fee`       DECIMAL(8,0)  NOT NULL    DEFAULT 0
);

CREATE TABLE `users` (
    `user_id`        BIGINT        NOT NULL,
    `login_id`       VARCHAR(30)   NULL,
    `password_hash`  VARCHAR(100)  NOT NULL,
    `pin_hash`       VARCHAR(100)  NULL,
    `name`           VARCHAR(50)   NOT NULL,
    `phone_number`   VARCHAR(20)   NULL,
    `role`           VARCHAR(20)   NOT NULL    DEFAULT 'USER',
    `di`             VARCHAR(255)  NULL        COMMENT '포트원 DI, SHA-256+salt 해시',
    `ci_hash`        VARCHAR(255)  NULL        COMMENT '포트원 CI, bcrypt 해시',
    `created_at`     DATETIME      NOT NULL,
    `is_deleted`     BOOLEAN       NOT NULL    DEFAULT FALSE
);

CREATE TABLE `card_benefits` (
    `benefit_id`      BIGINT        NOT NULL,
    `card_id`         BIGINT        NOT NULL,
    `benefit_type`    VARCHAR(20)   NOT NULL    COMMENT '환급, 청구, 현장',
    `benefit_name`    VARCHAR(100)  NULL,
    `description`     TEXT          NULL,
    `benefits_info`   JSON          NOT NULL
);

CREATE TABLE `benefit_per_user_card` (
    `user_card_id`  BIGINT  NOT NULL,
    `benefit_id`    BIGINT  NOT NULL
);

CREATE TABLE `user_cards` (
    `user_card_id`             BIGINT        NOT NULL,
    `user_id`                  BIGINT        NOT NULL,
    `card_variant_id`          BIGINT        NOT NULL,
    `card_token`               VARCHAR(255)  NOT NULL,
    `card_last4`               CHAR(4)       NOT NULL,
    `is_primary`               BOOLEAN       NOT NULL    DEFAULT FALSE,
    `recommendation_enabled`   BOOLEAN       NOT NULL    DEFAULT TRUE,
    `registered_at`            DATETIME      NOT NULL,
    `card_status`              VARCHAR(20)   NOT NULL    DEFAULT 'ACTIVE'    COMMENT 'ACTIVE / SUSPENDED / UNLINKED'
);

CREATE TABLE `payments` (
    `payment_id`       BIGINT         NOT NULL,
    `user_card_id`     BIGINT         NOT NULL,
    `merchant_id`      BIGINT         NOT NULL,
    `payment_time`     DATETIME       NOT NULL,
    `original_amount`  DECIMAL(10,0)  NOT NULL,
    `discount_amount`  DECIMAL(10,0)  NOT NULL    DEFAULT 0,
    `final_amount`     DECIMAL(10,0)  NOT NULL,
    `payment_status`   VARCHAR(20)    NOT NULL    DEFAULT 'PENDING'    COMMENT 'APPROVED / CANCELED',
    `payment_method`   VARCHAR(20)    NOT NULL    COMMENT 'BARCODE / QR'
);

CREATE TABLE `card_monthly_status` (
    `card_monthly_status_id`  BIGINT         NOT NULL,
    `user_card_id`            BIGINT         NOT NULL,
    `target_year_month`       CHAR(6)        NOT NULL,
    `total_spending_amount`   DECIMAL(12,0)  NOT NULL,
    `updated_at`              DATETIME       NOT NULL    COMMENT '해당 월별 실적 데이터가 마지막으로 변경된 시간'
);

CREATE TABLE `merchants` (
    `merchant_id`    BIGINT         NOT NULL,
    `category_id`    BIGINT         NOT NULL,
    `merchant_code`  VARCHAR(50)    NOT NULL,
    `merchant_name`  VARCHAR(100)   NOT NULL,
    `brand_name`     VARCHAR(255)   NULL,
    `address`        VARCHAR(255)   NOT NULL,
    `latitude`       DECIMAL(10,7)  NOT NULL,
    `longitude`      DECIMAL(10,7)  NOT NULL,
    `phone`          VARCHAR(20)    NULL
);

CREATE TABLE `bookmarked_stores` (
    `user_id`      BIGINT    NOT NULL,
    `merchant_id`  BIGINT    NOT NULL,
    `created_at`   DATETIME  NOT NULL,
    `is_deleted`   BOOLEAN   NOT NULL    DEFAULT FALSE
);

-- ===== Primary Keys =====

ALTER TABLE `merchant_categories` ADD CONSTRAINT `PK_MERCHANT_CATEGORIES` PRIMARY KEY (`category_id`);
ALTER TABLE `cards` ADD CONSTRAINT `PK_CARDS` PRIMARY KEY (`card_id`);
ALTER TABLE `card_variants` ADD CONSTRAINT `PK_CARD_VARIANTS` PRIMARY KEY (`card_variant_id`);
ALTER TABLE `users` ADD CONSTRAINT `PK_USERS` PRIMARY KEY (`user_id`);
ALTER TABLE `card_benefits` ADD CONSTRAINT `PK_CARD_BENEFITS` PRIMARY KEY (`benefit_id`);
ALTER TABLE `benefit_per_user_card` ADD CONSTRAINT `PK_BENEFIT_PER_USER_CARD` PRIMARY KEY (`user_card_id`, `benefit_id`);
ALTER TABLE `user_cards` ADD CONSTRAINT `PK_USER_CARDS` PRIMARY KEY (`user_card_id`);
ALTER TABLE `payments` ADD CONSTRAINT `PK_PAYMENTS` PRIMARY KEY (`payment_id`);
ALTER TABLE `card_monthly_status` ADD CONSTRAINT `PK_CARD_MONTHLY_STATUS` PRIMARY KEY (`card_monthly_status_id`);
ALTER TABLE `merchants` ADD CONSTRAINT `PK_MERCHANTS` PRIMARY KEY (`merchant_id`);
ALTER TABLE `bookmarked_stores` ADD CONSTRAINT `PK_BOOKMARKED_STORES` PRIMARY KEY (`user_id`, `merchant_id`);

-- ===== Foreign Keys =====

ALTER TABLE `card_variants` ADD CONSTRAINT `FK_cards_TO_card_variants_1` FOREIGN KEY (`card_id`) REFERENCES `cards` (`card_id`);
ALTER TABLE `card_benefits` ADD CONSTRAINT `FK_cards_TO_card_benefits_1` FOREIGN KEY (`card_id`) REFERENCES `cards` (`card_id`);
ALTER TABLE `merchants` ADD CONSTRAINT `FK_merchant_categories_TO_merchants_1` FOREIGN KEY (`category_id`) REFERENCES `merchant_categories` (`category_id`);
ALTER TABLE `user_cards` ADD CONSTRAINT `FK_users_TO_user_cards_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `user_cards` ADD CONSTRAINT `FK_card_variants_TO_user_cards_1` FOREIGN KEY (`card_variant_id`) REFERENCES `card_variants` (`card_variant_id`);
ALTER TABLE `card_monthly_status` ADD CONSTRAINT `FK_user_cards_TO_card_monthly_status_1` FOREIGN KEY (`user_card_id`) REFERENCES `user_cards` (`user_card_id`);
ALTER TABLE `benefit_per_user_card` ADD CONSTRAINT `FK_user_cards_TO_benefit_per_user_card_1` FOREIGN KEY (`user_card_id`) REFERENCES `user_cards` (`user_card_id`);
ALTER TABLE `benefit_per_user_card` ADD CONSTRAINT `FK_card_benefits_TO_benefit_per_user_card_1` FOREIGN KEY (`benefit_id`) REFERENCES `card_benefits` (`benefit_id`);
ALTER TABLE `payments` ADD CONSTRAINT `FK_user_cards_TO_payments_1` FOREIGN KEY (`user_card_id`) REFERENCES `user_cards` (`user_card_id`);
ALTER TABLE `payments` ADD CONSTRAINT `FK_merchants_TO_payments_1` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`merchant_id`);
ALTER TABLE `bookmarked_stores` ADD CONSTRAINT `FK_users_TO_bookmarked_stores_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
ALTER TABLE `bookmarked_stores` ADD CONSTRAINT `FK_merchants_TO_bookmarked_stores_1` FOREIGN KEY (`merchant_id`) REFERENCES `merchants` (`merchant_id`);

-- ===== Auto Increment =====

SET FOREIGN_KEY_CHECKS = 0;

ALTER TABLE `merchant_categories` MODIFY `category_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `cards` MODIFY `card_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `card_variants` MODIFY `card_variant_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `users` MODIFY `user_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `card_benefits` MODIFY `benefit_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `user_cards` MODIFY `user_card_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `payments` MODIFY `payment_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `card_monthly_status` MODIFY `card_monthly_status_id` BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE `merchants` MODIFY `merchant_id` BIGINT NOT NULL AUTO_INCREMENT;

SET FOREIGN_KEY_CHECKS = 1;

-- ===== Unique Constraints =====

ALTER TABLE `users` ADD CONSTRAINT `UQ_users_login_id` UNIQUE (`login_id`);
ALTER TABLE `users` ADD CONSTRAINT `UQ_users_phone_number` UNIQUE (`phone_number`);
ALTER TABLE `users` ADD CONSTRAINT `UQ_users_di` UNIQUE (`di`);
ALTER TABLE `user_cards` ADD CONSTRAINT `UQ_user_cards_card_token` UNIQUE (`card_token`);
ALTER TABLE `merchants` ADD CONSTRAINT `UQ_merchants_merchant_code` UNIQUE (`merchant_code`);
ALTER TABLE `merchant_categories` ADD CONSTRAINT `UQ_merchant_categories_category_code` UNIQUE (`category_code`);
