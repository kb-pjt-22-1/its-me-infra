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
-- 실제 서비스에서는 본인확인기관에서 발급한 CI(연계정보)를 이용해
-- 동일한 사용자를 식별한다.
--
-- 본 프로젝트에서는 실제 본인인증기관을 연동하지 않으므로, 이름+생년월일+전화번호를
-- 이어붙인 문자열을 UTF-8로 변환한 뒤 SHA-256으로 해시한 값을 ci_hash로 사용한다
-- (Sha256Util.hash, SignupIdentityServiceImpl.buildCiHash와 동일한 조합).
--
-- 이름만 이용한 해시는 동명이인을 구분할 수 없으므로,
-- 테스트 데이터의 사용자 이름은 중복되지 않는 것을 전제로 한다.
--
-- 카드 자동 연동을 위해 목 카드사의 ci_hash와
-- BenePay users.ci_hash는 반드시 동일해야 한다.
--
-- 예시 (users.02_seed.sql 김태희: 생년월일 19990101, 전화번호 01011111111):
-- SHA-256(UTF-8("김태희" + "19990101" + "01011111111"))
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
        '2b92044316c10e218dc902edb4cfe3992dbaaa1a549fbac6cdb2a4e530113dcb',
        'KB-CUSTOMER-0001',
        '김태희',
        'ACTIVE'
    ),
    (
        2,
        'd2cee81d9680e2ace464e43ecabb0fb9e4d452b0dce9440facf6a0227a752114',
        'KB-CUSTOMER-0002',
        '김세영',
        'ACTIVE'
    ),
    (
        3,
        '13e3ee895e4686fa465628808ea21d584240fb07d4660882b845b3820d05eac5',
        'KB-CUSTOMER-0003',
        '김수민',
        'ACTIVE'
    ),
    (
        4,
        '57855f557abbea833881334f3df9001eb432f2ccefe19409189d92480f150a2e',
        'KB-CUSTOMER-0004',
        '박종현',
        'ACTIVE'
    ),
    (
        5,
        '5da90e454910659d1921f91cd557a7411d78e4c7f1e930e57d3239207b7a3912',
        'KB-CUSTOMER-0005',
        '이상준',
        'ACTIVE'
    ),
    (
        6,
        'c67b096d5435a39461dad7250ab7a81b416e76f1aa96831b5e3491ddc1d51d65',
        'KB-CUSTOMER-0006',
        '심혜근',
        'ACTIVE'
    ),
    (
        7,
        '11164864b8f300ac8d18ad5ba8a69dae712a17809a8ea6525596189c7bfca717',
        'KB-CUSTOMER-0007',
        '배승호',
        'ACTIVE'
    ),
    (
        8,
        'a036a0ae6974380cb6538e2f5372d44b92c49ac20ec074e34952f3afc10fbccc',
        'KB-CUSTOMER-0008',
        '정을용',
        'ACTIVE'
    ),
    (
        9,
        '4ffa3335230e5c09dec608e1871fcbfd12be718045c023e67bd5aa1d75144f5b',
        'KB-CUSTOMER-0009',
        '김혁준',
        'ACTIVE'
    ),
    (
        10,
        '38f5aab647de1b456e92fd1cdff2f57a39a824bdb93596cbf8167dd77023ade0',
        'KB-CUSTOMER-0010',
        '김민지',
        'ACTIVE'
    );


-- =========================================================
-- 목 카드 상품
--
-- 목 카드사가 보유하고 있는 카드 상품 정보이다.
-- 같은 카드라도 결제망에 따라 서로 다른 상품 코드로 관리한다.
--
-- product_code는 카드 자동 연동 시 BenePay의 카드 상품을 찾기 위해
-- BenePay cards.issuer_product_code와 반드시 동일해야 한다.
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
    (1,  'KB-PRODUCT-001-DOMESTIC', '샘 쏘영 체크카드',          'CHECK',  'DOMESTIC', 'ACTIVE'),
    (2,  'KB-PRODUCT-002-DOMESTIC', '노리 체크카드',             'CHECK',  'DOMESTIC', 'ACTIVE'),
    (3,  'KB-PRODUCT-003-DOMESTIC', '직장인 보너스 체크카드',     'CHECK',  'DOMESTIC', 'ACTIVE'),
    (4,  'KB-PRODUCT-004-JCB',      '청춘대로 톡톡카드',          'CREDIT', 'JCB',      'ACTIVE'),
    (5,  'KB-PRODUCT-005-MASTER',   'WE:SH All+ 카드',           'CREDIT', 'MASTER',   'ACTIVE'),
    (6,  'KB-PRODUCT-001-UPI',      '샘 쏘영 체크카드',          'CHECK',  'UPI',      'ACTIVE'),
    (7,  'KB-PRODUCT-002-MASTER',   '노리 체크카드',             'CHECK',  'MASTER',   'ACTIVE'),
    (8,  'KB-PRODUCT-002-VISA',     '노리 체크카드',             'CHECK',  'VISA',     'ACTIVE'),
    (9,  'KB-PRODUCT-002-UPI',      '노리 체크카드',             'CHECK',  'UPI',      'ACTIVE'),
    (10, 'KB-PRODUCT-003-MASTER',   '직장인 보너스 체크카드',     'CHECK',  'MASTER',   'ACTIVE'),
    (11, 'KB-PRODUCT-003-VISA',     '직장인 보너스 체크카드',     'CHECK',  'VISA',     'ACTIVE'),
    (12, 'KB-PRODUCT-004-MASTER',   '청춘대로 톡톡카드',          'CREDIT', 'MASTER',   'ACTIVE'),
    (13, 'KB-PRODUCT-005-DOMESTIC', 'WE:SH All+ 카드',           'CREDIT', 'DOMESTIC', 'ACTIVE'),
    (14, 'KB-PRODUCT-006-DOMESTIC', 'ALL 카드',                  'CREDIT', 'DOMESTIC', 'ACTIVE'),
    (15, 'KB-PRODUCT-006-VISA',     'ALL 카드',                  'CREDIT', 'VISA',     'ACTIVE'),
    (16, 'KB-PRODUCT-007-DOMESTIC', 'NEED Global 카드',          'CREDIT', 'DOMESTIC', 'ACTIVE'),
    (17, 'KB-PRODUCT-007-MASTER',   'NEED Global 카드',          'CREDIT', 'MASTER',   'ACTIVE'),
    (18, 'KB-PRODUCT-008-DOMESTIC', '마이핏카드(할인형)',         'CREDIT', 'DOMESTIC', 'ACTIVE'),
    (19, 'KB-PRODUCT-008-MASTER',   '마이핏카드(할인형)',         'CREDIT', 'MASTER',   'ACTIVE'),
    (20, 'KB-PRODUCT-009-DOMESTIC', '굿데이카드',                 'CREDIT', 'DOMESTIC', 'ACTIVE'),
    (21, 'KB-PRODUCT-009-VISA',     '굿데이카드',                 'CREDIT', 'VISA',     'ACTIVE'),
    (22, 'KB-PRODUCT-009-MASTER',   '굿데이카드',                 'CREDIT', 'MASTER',   'ACTIVE'),
    (23, 'KB-PRODUCT-009-JCB',      '굿데이카드',                 'CREDIT', 'JCB',      'ACTIVE'),
    (24, 'KB-PRODUCT-009-AMEX',     '굿데이카드',                 'CREDIT', 'AMEX',     'ACTIVE'),
    (25, 'KB-PRODUCT-009-UPI',      '굿데이카드',                 'CREDIT', 'UPI',      'ACTIVE'),
    (26, 'KB-PRODUCT-010-UPI',      '굿데이올림카드',             'CREDIT', 'UPI',      'ACTIVE'),
    (27, 'KB-PRODUCT-010-VISA',     '굿데이올림카드',             'CREDIT', 'VISA',     'ACTIVE'),
    (28, 'KB-PRODUCT-010-MASTER',   '굿데이올림카드',             'CREDIT', 'MASTER',   'ACTIVE'),
    (29, 'KB-PRODUCT-010-AMEX',     '굿데이올림카드',             'CREDIT', 'AMEX',     'ACTIVE'),
    (30, 'KB-PRODUCT-011-MASTER',   '굿데이 플래티늄카드',        'CREDIT', 'MASTER',   'ACTIVE'),
    (31, 'KB-PRODUCT-011-VISA',     '굿데이 플래티늄카드',        'CREDIT', 'VISA',     'ACTIVE'),
    (32, 'KB-PRODUCT-011-AMEX',     '굿데이 플래티늄카드',        'CREDIT', 'AMEX',     'ACTIVE'),
    (33, 'KB-PRODUCT-012-DOMESTIC', 'On the Go 체크카드',        'CHECK',  'DOMESTIC', 'ACTIVE'),
    (34, 'KB-PRODUCT-012-MASTER',   'On the Go 체크카드',        'CHECK',  'MASTER',   'ACTIVE'),
    (35, 'KB-PRODUCT-013-DOMESTIC', 'Youth Club 체크카드',       'CHECK',  'DOMESTIC', 'ACTIVE'),
    (36, 'KB-PRODUCT-013-MASTER',   'Youth Club 체크카드',       'CHECK',  'MASTER',   'ACTIVE'),
    (37, 'KB-PRODUCT-014-DOMESTIC', '노리2 체크카드(KB Pay)',     'CHECK',  'DOMESTIC', 'ACTIVE'),
    (38, 'KB-PRODUCT-014-MASTER',   '노리2 체크카드(KB Pay)',     'CHECK',  'MASTER',   'ACTIVE'),
    (39, 'KB-PRODUCT-014-VISA',     '노리2 체크카드(KB Pay)',     'CHECK',  'VISA',     'ACTIVE'),
    (40, 'KB-PRODUCT-015-DOMESTIC', '노리2 체크카드(Play)',       'CHECK',  'DOMESTIC', 'ACTIVE'),
    (41, 'KB-PRODUCT-015-MASTER',   '노리2 체크카드(Play)',       'CHECK',  'MASTER',   'ACTIVE'),
    (42, 'KB-PRODUCT-015-VISA',     '노리2 체크카드(Play)',       'CHECK',  'VISA',     'ACTIVE'),
    (43, 'KB-PRODUCT-016-DOMESTIC', '노리2 체크카드(Global)',     'CHECK',  'DOMESTIC', 'ACTIVE'),
    (44, 'KB-PRODUCT-016-MASTER',   '노리2 체크카드(Global)',     'CHECK',  'MASTER',   'ACTIVE'),
    (45, 'KB-PRODUCT-017-DOMESTIC', '첵첵 체크카드',              'CHECK',  'DOMESTIC', 'ACTIVE'),
    (46, 'KB-PRODUCT-017-MASTER',   '첵첵 체크카드',              'CHECK',  'MASTER',   'ACTIVE'),
    (47, 'KB-PRODUCT-017-VISA',     '첵첵 체크카드',              'CHECK',  'VISA',     'ACTIVE'),
    (48, 'KB-PRODUCT-018-DOMESTIC', '가온체크카드',               'CHECK',  'DOMESTIC', 'ACTIVE'),
    (49, 'KB-PRODUCT-018-MASTER',   '가온체크카드',               'CHECK',  'MASTER',   'ACTIVE'),
    (50, 'KB-PRODUCT-019-DOMESTIC', '가온 올포인트 체크카드',      'CHECK',  'DOMESTIC', 'ACTIVE'),
    (51, 'KB-PRODUCT-019-MASTER',   '가온 올포인트 체크카드',      'CHECK',  'MASTER',   'ACTIVE'),
    (52, 'KB-PRODUCT-019-VISA',     '가온 올포인트 체크카드',      'CHECK',  'VISA',     'ACTIVE'),
    (53, 'KB-PRODUCT-019-UPI',      '가온 올포인트 체크카드',      'CHECK',  'UPI',      'ACTIVE');


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
    -- =====================================================
    -- 고객 1: 김태희 / 총 2장
    -- 노리 체크카드(DOMESTIC)
    -- 청춘대로 톡톡카드(MASTER)
    -- =====================================================
    (1, 1, 2, 'KB-CARD-0001', '1842', '202812', 'ACTIVE', '2024-03-15 10:00:00', 'KB-TOKEN-0001', '9475000000001842', '2028-12-31', 'ACTIVE'),
    (2, 1, 12, 'KB-CARD-0002', '5371', '202909', 'ACTIVE', '2025-01-10 11:30:00', 'KB-TOKEN-0002', '9475000000005371', '2029-09-30', 'ACTIVE'),

    -- =====================================================
    -- 고객 2: 김세영 / 총 2장
    -- 샘 쏘영 체크카드(DOMESTIC)
    -- ALL 카드(VISA)
    -- =====================================================
    (3, 2, 1, 'KB-CARD-0003', '2915', '202811', 'ACTIVE', '2024-02-08 09:20:00', 'KB-TOKEN-0003', '9475000000002915', '2028-11-30', 'ACTIVE'),
    (4, 2, 15, 'KB-CARD-0004', '6408', '202906', 'ACTIVE', '2024-12-12 15:40:00', 'KB-TOKEN-0004', '9475000000006408', '2029-06-30', 'ACTIVE'),

    -- =====================================================
    -- 고객 3: 김수민 / 총 2장
    -- 직장인 보너스 체크카드(MASTER)
    -- NEED Global 카드(MASTER)
    -- =====================================================
    (5, 3, 10, 'KB-CARD-0005', '3157', '202810', 'ACTIVE', '2023-11-25 10:10:00', 'KB-TOKEN-0005', '9475000000003157', '2028-10-31', 'ACTIVE'),
    (6, 3, 17, 'KB-CARD-0006', '7489', '202907', 'ACTIVE', '2024-09-03 16:25:00', 'KB-TOKEN-0006', '9475000000007489', '2029-07-31', 'ACTIVE'),

    -- =====================================================
    -- 고객 4: 박종현 / 총 3장
    -- 굿데이카드(MASTER)
    -- On the Go 체크카드(MASTER)
    -- 첵첵 체크카드(MASTER)
    -- =====================================================
    (7, 4, 22, 'KB-CARD-0007', '8053', '202809', 'ACTIVE', '2023-10-14 14:00:00', 'KB-TOKEN-0007', '9475000000008053', '2028-09-30', 'ACTIVE'),
    (8, 4, 34, 'KB-CARD-0008', '1268', '202904', 'ACTIVE', '2024-06-19 11:45:00', 'KB-TOKEN-0008', '9475000000001268', '2029-04-30', 'ACTIVE'),
    (9, 4, 46, 'KB-CARD-0009', '5947', '202912', 'ACTIVE', '2025-02-11 10:30:00', 'KB-TOKEN-0009', '9475000000005947', '2029-12-31', 'ACTIVE'),

    -- =====================================================
    -- 고객 5: 이상준 / 총 3장
    -- 굿데이올림카드(MASTER)
    -- Youth Club 체크카드(MASTER)
    -- 가온체크카드(MASTER)
    -- =====================================================
    (10, 5, 28, 'KB-CARD-0010', '2376', '202807', 'ACTIVE', '2023-08-21 09:10:00', 'KB-TOKEN-0010', '9475000000002376', '2028-07-31', 'ACTIVE'),
    (11, 5, 36, 'KB-CARD-0011', '6814', '202905', 'ACTIVE', '2024-07-26 13:50:00', 'KB-TOKEN-0011', '9475000000006814', '2029-05-31', 'ACTIVE'),
    (12, 5, 49, 'KB-CARD-0012', '9540', '203004', 'ACTIVE', '2025-07-08 15:15:00', 'KB-TOKEN-0012', '9475000000009540', '2030-04-30', 'ACTIVE'),

    -- =====================================================
    -- 고객 6: 심혜근 / 총 3장
    -- 굿데이 플래티늄카드(MASTER)
    -- 노리2 체크카드 Play(MASTER)
    -- 가온 올포인트 체크카드(VISA)
    -- =====================================================
    (13, 6, 30, 'KB-CARD-0013', '4139', '202808', 'ACTIVE', '2023-09-18 10:40:00', 'KB-TOKEN-0013', '9475000000004139', '2028-08-31', 'ACTIVE'),
    (14, 6, 41, 'KB-CARD-0014', '7625', '202910', 'ACTIVE', '2024-11-05 12:35:00', 'KB-TOKEN-0014', '9475000000007625', '2029-10-31', 'ACTIVE'),
    (15, 6, 52, 'KB-CARD-0015', '0984', '203005', 'ACTIVE', '2025-08-01 09:25:00', 'KB-TOKEN-0015', '9475000000000984', '2030-05-31', 'ACTIVE'),

    -- =====================================================
    -- 고객 7: 배승호 / 총 3장
    -- 샘 쏘영 체크카드(UPI)
    -- 굿데이카드(VISA)
    -- 노리2 체크카드 Global(MASTER)
    -- =====================================================
    (16, 7, 6, 'KB-CARD-0016', '3462', '202806', 'ACTIVE', '2023-07-12 11:00:00', 'KB-TOKEN-0016', '9475000000003462', '2028-06-30', 'ACTIVE'),
    (17, 7, 21, 'KB-CARD-0017', '7193', '202903', 'ACTIVE', '2024-05-16 14:45:00', 'KB-TOKEN-0017', '9475000000007193', '2029-03-31', 'ACTIVE'),
    (18, 7, 44, 'KB-CARD-0018', '5806', '202911', 'ACTIVE', '2025-01-22 16:10:00', 'KB-TOKEN-0018', '9475000000005806', '2029-11-30', 'ACTIVE'),

    -- =====================================================
    -- 고객 8: 정을용 / 총 4장
    -- 노리 체크카드(VISA)
    -- ALL 카드(DOMESTIC)
    -- On the Go 체크카드(DOMESTIC)
    -- 마이핏카드 할인형(MASTER)
    -- =====================================================
    (19, 8, 8, 'KB-CARD-0019', '1427', '202805', 'ACTIVE', '2023-06-09 10:15:00', 'KB-TOKEN-0019', '9475000000001427', '2028-05-31', 'ACTIVE'),
    (20, 8, 14, 'KB-CARD-0020', '6935', '202902', 'ACTIVE', '2024-04-04 13:30:00', 'KB-TOKEN-0020', '9475000000006935', '2029-02-28', 'ACTIVE'),
    (21, 8, 33, 'KB-CARD-0021', '8571', '202908', 'ACTIVE', '2024-10-28 15:55:00', 'KB-TOKEN-0021', '9475000000008571', '2029-08-31', 'ACTIVE'),
    (22, 8, 19, 'KB-CARD-0022', '4863', '203002', 'ACTIVE', '2025-05-14 11:20:00', 'KB-TOKEN-0022', '9475000000004863', '2030-02-28', 'ACTIVE'),

    -- =====================================================
    -- 고객 9: 김혁준 / 총 4장
    -- 직장인 보너스 체크카드(VISA)
    -- WE:SH All+ 카드(DOMESTIC)
    -- 마이핏카드 할인형(DOMESTIC)
    -- 노리2 체크카드 KB Pay(MASTER)
    -- =====================================================
    (23, 9, 11, 'KB-CARD-0023', '2749', '202804', 'ACTIVE', '2023-05-17 09:35:00', 'KB-TOKEN-0023', '9475000000002749', '2028-04-30', 'ACTIVE'),
    (24, 9, 13, 'KB-CARD-0024', '6312', '202901', 'ACTIVE', '2024-03-11 12:20:00', 'KB-TOKEN-0024', '9475000000006312', '2029-01-31', 'ACTIVE'),
    (25, 9, 18, 'KB-CARD-0025', '9058', '202907', 'ACTIVE', '2024-09-24 14:05:00', 'KB-TOKEN-0025', '9475000000009058', '2029-07-31', 'ACTIVE'),
    (26, 9, 38, 'KB-CARD-0026', '4576', '203003', 'ACTIVE', '2025-06-12 10:45:00', 'KB-TOKEN-0026', '9475000000004576', '2030-03-31', 'ACTIVE'),

    -- =====================================================
    -- 고객 10: 김민지 / 총 4장
    -- 청춘대로 톡톡카드(JCB)
    -- NEED Global 카드(DOMESTIC)
    -- 가온 올포인트 체크카드(DOMESTIC)
    -- WE:SH All+ 카드(MASTER)
    -- =====================================================
    (27, 10, 4, 'KB-CARD-0027', '3685', '202803', 'ACTIVE', '2023-04-13 10:50:00', 'KB-TOKEN-0027', '9475000000003685', '2028-03-31', 'ACTIVE'),
    (28, 10, 16, 'KB-CARD-0028', '7246', '202812', 'ACTIVE', '2024-02-27 13:40:00', 'KB-TOKEN-0028', '9475000000007246', '2028-12-31', 'ACTIVE'),
    (29, 10, 50, 'KB-CARD-0029', '5190', '202906', 'ACTIVE', '2024-08-30 16:30:00', 'KB-TOKEN-0029', '9475000000005190', '2029-06-30', 'ACTIVE'),
    (30, 10, 5, 'KB-CARD-0030', '8361', '203001', 'ACTIVE', '2025-04-18 09:55:00', 'KB-TOKEN-0030', '9475000000008361', '2030-01-31', 'ACTIVE');