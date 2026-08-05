SET NAMES utf8mb4;

USE kb_card_mock;

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE mock_customer_cards;
TRUNCATE TABLE mock_card_products;
TRUNCATE TABLE mock_customers;

SET FOREIGN_KEY_CHECKS = 1;


-- =========================================================
-- 목 카드사 고객
--
-- ci_hash는 BenePay users.ci_hash와 동일해야 한다.
-- =========================================================

INSERT INTO mock_customers
(
    mock_customer_id,
    ci_hash,
    customer_reference_id,
    customer_name,
    customer_status
)
VALUES
    (
        1,
        '1111111111111111111111111111111111111111111111111111111111111111',
        'KB-CUSTOMER-0001',
        '김개발',
        'ACTIVE'
    ),
    (
        2,
        '2222222222222222222222222222222222222222222222222222222222222222',
        'KB-CUSTOMER-0002',
        '이테스트',
        'ACTIVE'
    ),
    (
        3,
        '3333333333333333333333333333333333333333333333333333333333333333',
        'KB-CUSTOMER-0003',
        '박베네',
        'ACTIVE'
    ),
    (
        4,
        '4444444444444444444444444444444444444444444444444444444444444444',
        'KB-CUSTOMER-0004',
        '최페이',
        'WITHDRAWN'
    );


-- =========================================================
-- 목 카드 상품
--
-- product_code는 BenePay cards.issuer_product_code와 동일해야 한다.
-- =========================================================

INSERT INTO mock_card_products
(
    mock_card_product_id,
    product_code,
    card_name,
    card_type,
    card_network,
    product_status
)
VALUES
    (
        1,
        'KB-PRODUCT-002-DOMESTIC',
        '노리 체크카드',
        'CHECK',
        'DOMESTIC',
        'ACTIVE'
    ),
    (
        2,
        'KB-PRODUCT-004-MASTER',
        '청춘대로 톡톡카드',
        'CREDIT',
        'MASTER',
        'ACTIVE'
    ),
    (
        3,
        'KB-PRODUCT-004-JCB',
        '청춘대로 톡톡카드',
        'CREDIT',
        'JCB',
        'ACTIVE'
    ),
    (
        4,
        'KB-PRODUCT-001-DOMESTIC',
        '샘 쏘영 체크카드',
        'CHECK',
        'DOMESTIC',
        'ACTIVE'
    ),
    (
        5,
        'KB-PRODUCT-005-MASTER',
        'WE:SH All+ 카드',
        'CREDIT',
        'MASTER',
        'DISCONTINUED'
    );


-- =========================================================
-- 목 카드사 고객 보유 카드
--
-- 회원가입 자동 연동 테스트를 위해 일부 카드는 토큰 발급 완료 상태,
-- 일부 카드는 토큰 미발급 상태로 구성한다.
-- =========================================================

INSERT INTO mock_customer_cards
(
    mock_customer_card_id,
    mock_customer_id,
    mock_card_product_id,
    card_reference_id,
    pan_last4,
    card_expiry_year_month,
    card_status,
    issued_at,
    token_reference_id,
    payment_token,
    token_expiry_date,
    token_status
)
VALUES
    -- 김개발: 정상 카드 2장, 토큰 발급 완료
    (
        1,
        1,
        1,
        'KB-CARD-0001',
        '1234',
        '203012',
        'ACTIVE',
        '2024-03-15 10:00:00',
        'KB-TOKEN-0001',
        '9475000000001234',
        '2030-12-31',
        'ACTIVE'
    ),
    (
        2,
        1,
        2,
        'KB-CARD-0002',
        '5678',
        '202911',
        'ACTIVE',
        '2025-01-10 11:30:00',
        'KB-TOKEN-0002',
        '9475000000005678',
        '2029-11-30',
        'ACTIVE'
    ),

    -- 이테스트: 정상 카드 1장, 토큰 발급 완료
    (
        3,
        2,
        3,
        'KB-CARD-0003',
        '2222',
        '203108',
        'ACTIVE',
        '2025-07-20 14:00:00',
        'KB-TOKEN-0003',
        '9475000000002222',
        '2031-08-31',
        'ACTIVE'
    ),

    -- 이테스트: 이용 정지 카드
    (
        4,
        2,
        1,
        'KB-CARD-0004',
        '3333',
        '202812',
        'SUSPENDED',
        '2024-08-11 09:00:00',
        'KB-TOKEN-0004',
        '9475000000003333',
        '2028-12-31',
        'SUSPENDED'
    ),

    -- 박베네: 신규 발급 카드
    -- 웹훅 수신 후 BenePay가 토큰 발급 API를 호출하는 상황을 테스트하기 위해
    -- 토큰 관련 값은 NULL로 둔다.
    (
        5,
        3,
        4,
        'KB-CARD-0005',
        '7777',
        '203207',
        'ACTIVE',
        '2026-08-04 16:30:00',
        NULL,
        NULL,
        NULL,
        NULL
    ),

    -- 박베네: 만료 카드
    (
        6,
        3,
        5,
        'KB-CARD-0006',
        '8888',
        '202506',
        'EXPIRED',
        '2020-06-10 10:20:00',
        'KB-TOKEN-0006',
        '9475000000008888',
        '2025-06-30',
        'EXPIRED'
    );