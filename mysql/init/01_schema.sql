CREATE TABLE `card_benefits` (
	`benefit_id`	BIGINT	NOT NULL,
	`card_id`	BIGINT	NOT NULL,
	`benefit_type`	VARCHAR(20)	NOT NULL	COMMENT '환급, 청구, 현장',
	`benefit_name`	VARCHAR(100)	NULL,
	`description`	TEXT	NULL,
	`benefits_info`	JSON	NOT NULL
);

CREATE TABLE `merchants` (
	`merchant_id`	BIGINT	NOT NULL,
	`category_id`	BIGINT	NOT NULL,
	`merchant_code`	VARCHAR(50)	NOT NULL,
	`merchant_name`	VARCHAR(100)	NOT NULL,
	`brand_name`	VARCHAR(255)	NULL,
	`address`	VARCHAR(255)	NOT NULL,
	`latitude`	DECIMAL(10,7)	NOT NULL,
	`longitude`	DECIMAL(10,7)	NOT NULL,
	`phone`	VARCHAR(20)	NULL
);

CREATE TABLE `payments` (
	`payment_id`	BIGINT	NOT NULL,
	`user_card_id`	BIGINT	NOT NULL,
	`merchant_id`	BIGINT	NOT NULL,
	`payment_time`	DATETIME	NOT NULL,
	`original_amount`	DECIMAL(10,0)	NOT NULL,
	`discount_amount`	DECIMAL(10,0)	NOT NULL	DEFAULT 0,
	`final_amount`	DECIMAL(10,0)	NOT NULL,
	`payment_status`	VARCHAR(20)	NOT NULL	DEFAULT 'PENDING'	COMMENT 'APPROVED
CANCELED'
);

CREATE TABLE `merchant_categories` (
	`category_id`	BIGINT	NOT NULL,
	`category_code`	VARCHAR(30)	NOT NULL,
	`category_name`	VARCHAR(50)	NOT NULL
);

CREATE TABLE `user_cards` (
	`user_card_id`	BIGINT	NOT NULL,
	`user_id`	BIGINT	NOT NULL,
	`card_id`	BIGINT	NOT NULL,
	`card_token`	VARCHAR(255)	NOT NULL,
	`card_last4`	CHAR(4)	NOT NULL,
	`is_primary`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`recommendation_enabled`	BOOLEAN	NOT NULL	DEFAULT TRUE,
	`registered_at`	DATETIME	NOT NULL,
	`is_deleted`	BOOLEAN	NOT NULL	DEFAULT FALSE,
	`annual_fee`	DECIMAL(8,0)	NOT NULL	DEFAULT 0
);

CREATE TABLE `card_monthly_status` (
	`card_monthly_status_id`	BIGINT	NOT NULL,
	`user_card_id`	BIGINT	NOT NULL,
	`total_spending_amount`	DECIMAL(12,0)	NOT NULL,
	`is_benefit_eligible`	BOOLEAN	NULL,
	`updated_at`	DATETIME	NOT NULL	COMMENT '해당 월별 실적 데이터가 마지막으로 변경된 시간',
	`target_year_month`	CHAR(6)	NOT NULL
);

CREATE TABLE `benefit_per_user_card` (
	`user_card_id`	BIGINT	NOT NULL,
	`benefit_id`	BIGINT	NOT NULL
);

CREATE TABLE `users` (
	`user_id`	BIGINT	NOT NULL,
	`email`	VARCHAR(255)	NOT NULL	COMMENT 'UNIQUE',
	`login_id`	VARCHAR(30)	NULL,
	`password_hash`	VARCHAR(100)	NOT NULL,
	`pin_hash`	VARCHAR(100)	NULL,
	`name`	VARCHAR(50)	NOT NULL,
	`phone_number`	VARCHAR(20)	NULL,
	`role`	VARCHAR(20)	NOT NULL	DEFAULT 'USER',
	`di`	VARCHAR(255)	NULL,
	`created_at`	DATETIME	NOT NULL,
	`is_deleted`	BOOLEAN	NOT NULL	DEFAULT FALSE
);

CREATE TABLE `cards` (
	`card_id`	BIGINT	NOT NULL,
	`card_name`	VARCHAR(50)	NOT NULL,
	`card_type`	VARCHAR(20)	NOT NULL	COMMENT 'CREDIT
CHECK',
	`card_image_url`	VARCHAR(255)	NULL,
	`description`	TEXT	NULL,
	`is_supported`	BOOLEAN	NOT NULL	DEFAULT TRUE,
	`card_company_name`	VARCHAR(30)	NOT NULL,
	`min_benefit_amount`	DECIMAL(8,0)	NULL
);

CREATE TABLE `bookmarked_stores` (
	`bookmark_id`	BIGINT	NOT NULL,
	`user_id`	BIGINT	NOT NULL,
	`merchant_id`	BIGINT	NOT NULL,
	`created_at`	DATETIME	NOT NULL,
	`is_deleted`	BOOLEAN	NOT NULL	DEFAULT FALSE
);

ALTER TABLE `card_benefits` ADD CONSTRAINT `PK_CARD_BENEFITS` PRIMARY KEY (
	`benefit_id`
);

ALTER TABLE `merchants` ADD CONSTRAINT `PK_MERCHANTS` PRIMARY KEY (
	`merchant_id`
);

ALTER TABLE `payments` ADD CONSTRAINT `PK_PAYMENTS` PRIMARY KEY (
	`payment_id`
);

ALTER TABLE `merchant_categories` ADD CONSTRAINT `PK_MERCHANT_CATEGORIES` PRIMARY KEY (
	`category_id`
);

ALTER TABLE `user_cards` ADD CONSTRAINT `PK_USER_CARDS` PRIMARY KEY (
	`user_card_id`
);

ALTER TABLE `card_monthly_status` ADD CONSTRAINT `PK_CARD_MONTHLY_STATUS` PRIMARY KEY (
	`card_monthly_status_id`
);

ALTER TABLE `benefit_per_user_card` ADD CONSTRAINT `PK_BENEFIT_PER_USER_CARD` PRIMARY KEY (
	`user_card_id`,
	`benefit_id`
);

ALTER TABLE `users` ADD CONSTRAINT `PK_USERS` PRIMARY KEY (
	`user_id`
);

ALTER TABLE `cards` ADD CONSTRAINT `PK_CARDS` PRIMARY KEY (
	`card_id`
);

ALTER TABLE `bookmarked_stores` ADD CONSTRAINT `PK_BOOKMARKED_STORES` PRIMARY KEY (
	`bookmark_id`
);

ALTER TABLE `benefit_per_user_card` ADD CONSTRAINT `FK_user_cards_TO_benefit_per_user_card_1` FOREIGN KEY (
	`user_card_id`
)
REFERENCES `user_cards` (
	`user_card_id`
);

ALTER TABLE `benefit_per_user_card` ADD CONSTRAINT `FK_card_benefits_TO_benefit_per_user_card_1` FOREIGN KEY (
	`benefit_id`
)
REFERENCES `card_benefits` (
	`benefit_id`
);
