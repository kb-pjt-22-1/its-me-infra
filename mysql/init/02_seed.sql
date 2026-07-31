USE benepay;

-- ===== Mock Data =====

-- BenePay 개발용 전체 목데이터
-- DDL 실행 후 아래 순서대로 실행
-- category_code는 MCC를 참고한 BenePay 대표 카테고리 코드

START TRANSACTION;

INSERT INTO common_code_groups (group_code, group_name, description) VALUES
                                                                         ('CARD_ISSUANCE_STATUS', '카드 발급 이벤트 처리 상태', NULL),
                                                                         ('CARD_NETWORK', '카드 결제망', NULL),
                                                                         ('CARD_STATUS', '등록카드 상태', NULL),
                                                                         ('CARD_TYPE', '카드 종류', NULL),
                                                                         ('PAYMENT_METHOD', '결제 수단', NULL),
                                                                         ('PAYMENT_STATUS', '결제 상태', NULL),
                                                                         ('USER_ROLE', '사용자 권한', NULL);

INSERT INTO common_codes (code, group_code, code_name, sort_order, is_active) VALUES
                                                                                  ('RECEIVED', 'CARD_ISSUANCE_STATUS', '수신됨', 1, 1),
                                                                                  ('PROCESSED', 'CARD_ISSUANCE_STATUS', '처리 완료', 2, 1),
                                                                                  ('PENDING_USER', 'CARD_ISSUANCE_STATUS', '사용자 확인 대기', 3, 1),
                                                                                  ('FAILED', 'CARD_ISSUANCE_STATUS', '처리 실패', 4, 1),
                                                                                  ('DOMESTIC', 'CARD_NETWORK', '국내전용', 1, 1),
                                                                                  ('VISA', 'CARD_NETWORK', 'VISA', 2, 1),
                                                                                  ('MASTER', 'CARD_NETWORK', 'Mastercard', 3, 1),
                                                                                  ('ACTIVE', 'CARD_STATUS', '정상 사용', 1, 1),
                                                                                  ('SUSPENDED', 'CARD_STATUS', '정지', 2, 1),
                                                                                  ('EXPIRED', 'CARD_STATUS', '만료', 3, 1),
                                                                                  ('UNLINKED', 'CARD_STATUS', '연동 해제', 4, 1),
                                                                                  ('DELETED', 'CARD_STATUS', '사용자가 삭제', 5, 1),
                                                                                  ('CREDIT', 'CARD_TYPE', '신용카드', 1, 1),
                                                                                  ('CHECK', 'CARD_TYPE', '체크카드', 2, 1),
                                                                                  ('BARCODE', 'PAYMENT_METHOD', '바코드', 1, 1),
                                                                                  ('QR', 'PAYMENT_METHOD', 'QR코드', 2, 1),
                                                                                  ('PENDING', 'PAYMENT_STATUS', '대기', 1, 1),
                                                                                  ('APPROVED', 'PAYMENT_STATUS', '승인', 2, 1),
                                                                                  ('CANCELED', 'PAYMENT_STATUS', '취소', 3, 1),
                                                                                  ('USER', 'USER_ROLE', '일반 사용자', 1, 1),
                                                                                  ('ADMIN', 'USER_ROLE', '관리자', 2, 1);

INSERT INTO `encryption_keys` VALUES (1,'CI','ZHsppXZssP/iNxL0DhGMYRpfzs9ksDslBH+j1E8UeVU=','AES256',1,'2026-07-28 17:45:12');

INSERT INTO card_variants (card_variant_id, card_network) VALUES
                                                              ('01', 'DOMESTIC'),
                                                              ('02', 'VISA'),
                                                              ('03', 'MASTER');

INSERT INTO merchant_categories (category_code, category_name, category_icon) VALUES
                                                                                  ('5812', '음식점', 'https://cdn.benepay.com/icons/restaurant.svg'),
                                                                                  ('5813', '카페', 'https://cdn.benepay.com/icons/cafe.svg'),
                                                                                  ('5499', '편의점', 'https://cdn.benepay.com/icons/convenience-store.svg'),
                                                                                  ('7832', '영화관', 'https://cdn.benepay.com/icons/cinema.svg'),
                                                                                  ('5814', '패스트푸드', 'https://cdn.benepay.com/icons/fast-food.svg'),
                                                                                  ('5541', '주유소', 'https://cdn.benepay.com/icons/gas-station.svg'),
                                                                                  ('7523', '주차장', 'https://cdn.benepay.com/icons/parking.svg'),
                                                                                  ('8062', '병원', 'https://cdn.benepay.com/icons/hospital.svg'),
                                                                                  ('5912', '약국', 'https://cdn.benepay.com/icons/pharmacy.svg'),
                                                                                  ('7994', '여가', 'https://cdn.benepay.com/icons/leisure.svg'),
                                                                                  ('7230', '뷰티', 'https://cdn.benepay.com/icons/beauty.svg'),
                                                                                  ('5462', '빵집', 'https://cdn.benepay.com/icons/bakery.svg'),
                                                                                  ('5411', '마트', 'https://cdn.benepay.com/icons/mart.svg'),
                                                                                  ('5311', '백화점', 'https://cdn.benepay.com/icons/department-store.svg'),
                                                                                  ('5943', '문구점', 'https://cdn.benepay.com/icons/stationery.svg'),
                                                                                  ('7299', '독서실', 'https://cdn.benepay.com/icons/study-room.svg'),
                                                                                  ('8299', '학원', 'https://cdn.benepay.com/icons/academy.svg'),
                                                                                  ('7997', '피트니스센터', 'https://cdn.benepay.com/icons/fitness.svg'),
                                                                                  ('7011', '숙박', 'https://cdn.benepay.com/icons/accommodation.svg');

INSERT INTO merchant_brands (brand_id, brand_code, brand_name, brand_logo) VALUES
                                                                               (1, 'STARBUCKS', '스타벅스', 'https://cdn.benepay.com/brands/starbucks.png'),
                                                                               (2, 'GS25', 'GS25', 'https://cdn.benepay.com/brands/gs25.png'),
                                                                               (3, 'EMART24', '이마트24', 'https://cdn.benepay.com/brands/emart24.png'),
                                                                               (4, 'CU', 'CU', 'https://cdn.benepay.com/brands/cu.png'),
                                                                               (5, 'CGV', 'CGV', 'https://cdn.benepay.com/brands/cgv.png'),
                                                                               (6, 'OLIVE_YOUNG', '올리브영', 'https://cdn.benepay.com/brands/olive-young.png'),
                                                                               (7, 'EMART', '이마트', 'https://cdn.benepay.com/brands/emart.png'),
                                                                               (8, 'LOTTE_MART', '롯데마트', 'https://cdn.benepay.com/brands/lotte-mart.png'),
                                                                               (9, 'HOMEPLUS', '홈플러스', 'https://cdn.benepay.com/brands/homeplus.png');


-- 일반 사용자 목데이터
INSERT INTO users
(
    user_id,
    login_id,
    login_password_hash,
    pin_hash,
    name,
    phone_number,
    birth_date,
    role,
    di,
    ci_encrypted,
    created_at,
    is_deleted,
    fcm_token
)
VALUES
    (
        1,
        'hong123',
        '$2a$10$mockHashValueForHongGildong0000000000000000000000000',
        '$2a$10$mockPinHash1',
        '홍길동',
        '01012345678',
        '19900101',
        'USER',
        'di_mock_0000000000000000000000000000000000000000000000000000000000000000000000000000000000',
        'ci_encrypted_mock_AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNN',
        '2026-01-10 09:00:00',
        FALSE,
        'fcm_token_mock_device_a1b2c3'
    ),
    (
        2,
        'kim456',
        '$2a$10$mockHashValueForKimYuna00000000000000000000000000000',
        NULL,
        '김유나',
        '01098765432',
        '19950505',
        'USER',
        'di_mock_1111111111111111111111111111111111111111111111111111111111111111111111111111111111',
        'ci_encrypted_mock_ZZZZYYYYXXXXWWWWVVVVUUUUTTTTSSSSRRRRQQQQPPPPOOOONNNN',
        '2026-02-15 14:30:00',
        FALSE,
        'fcm_token_mock_device_x9y8z7'
    )
    ON DUPLICATE KEY UPDATE
                         login_id = VALUES(login_id),
                         name = VALUES(name),
                         phone_number = VALUES(phone_number),
                         is_deleted = VALUES(is_deleted);


-- 개발자 로그인용 계정
INSERT INTO users
(
    login_id,
    login_password_hash,
    pin_hash,
    name,
    phone_number,
    birth_date,
    role,
    di,
    ci_encrypted,
    created_at,
    is_deleted,
    fcm_token
)
VALUES
    (
        'dev1',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자1',
        NULL,
        '19900101',
        'USER',
        'dev_di_slot_1',
        'dev_ci_slot_1',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev2',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자2',
        NULL,
        '19900102',
        'USER',
        'dev_di_slot_2',
        'dev_ci_slot_2',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev3',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자3',
        NULL,
        '19900103',
        'USER',
        'dev_di_slot_3',
        'dev_ci_slot_3',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev4',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자4',
        NULL,
        '19900104',
        'USER',
        'dev_di_slot_4',
        'dev_ci_slot_4',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev5',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자5',
        NULL,
        '19900105',
        'USER',
        'dev_di_slot_5',
        'dev_ci_slot_5',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev6',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자6',
        NULL,
        '19900106',
        'USER',
        'dev_di_slot_6',
        'dev_ci_slot_6',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev7',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자7',
        NULL,
        '19900107',
        'USER',
        'dev_di_slot_7',
        'dev_ci_slot_7',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev8',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자8',
        NULL,
        '19900108',
        'USER',
        'dev_di_slot_8',
        'dev_ci_slot_8',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev9',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자9',
        NULL,
        '19900109',
        'USER',
        'dev_di_slot_9',
        'dev_ci_slot_9',
        NOW(),
        FALSE,
        NULL
    ),
    (
        'dev10',
        '!DEV-ACCOUNT-NO-PASSWORD-LOGIN!',
        NULL,
        '개발자10',
        NULL,
        '19900110',
        'USER',
        'dev_di_slot_10',
        'dev_ci_slot_10',
        NOW(),
        FALSE,
        NULL
    )
    ON DUPLICATE KEY UPDATE
                         name = VALUES(name),
                         is_deleted = FALSE;

INSERT INTO cards
(card_id, card_name, card_type, card_variant_id, annual_fee, card_image_url,
 description, is_supported, min_benefit_amount, benefits_info)
VALUES
    (1, '샘쏘영 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-1.png', '샘쏘영 체크카드 혜택 정보', 1, 0, CAST('{"performanceTiers":[{"benefitNodeId":"SOME_SO_YOUNG_TIER_1","tierName":"기본","minimumSpending":0,"maximumSpending":null,"benefits":[{"categoryCodes":["5813"],"categoryName":"카페","discountMethod":"CASHBACK","discountRate":10,"description":"카페 이용금액 10% 환급할인"},{"categoryCodes":["5499"],"categoryName":"편의점","discountMethod":"CASHBACK","discountRate":5,"description":"편의점 이용금액 5% 환급할인"}]}]}' AS JSON)),
    (2, '노리 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-2.png', '노리 체크카드 혜택 정보', 1, 200000, CAST('{"performanceTiers":[{"benefitNodeId":"NORI_CHECK_TIER_1","tierName":"기본","minimumSpending":200000,"maximumSpending":null,"benefits":[{"categoryCodes":["5813"],"categoryName":"카페","brandCodes":["STARBUCKS"],"discountMethod":"CASHBACK","discountRate":10,"description":"스타벅스 등 카페 업종 환급할인"},{"categoryCodes":["7832"],"categoryName":"영화관","brandCodes":["CGV"],"discountMethod":"CASHBACK","discountAmount":4000,"description":"CGV 정액 환급할인"}]}]}' AS JSON)),
    (3, '직장인 보너스 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-3.png', '직장인 보너스 체크카드 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"WORKER_BONUS_TIER_1","tierName":"기본","minimumSpending":300000,"maximumSpending":null,"benefits":[{"categoryCodes":["5541"],"categoryName":"주유소","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"description":"주유소 이용금액 5% 청구할인"},{"categoryCodes":["5411"],"categoryName":"마트","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"description":"마트 이용금액 5% 청구할인"}]}]}' AS JSON)),
    (4, '청춘대로 톡톡카드', 'CREDIT', '02', 10000, 'https://cdn.benepay.com/cards/card-4.png', '청춘대로 톡톡카드 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"YOUTH_TOKTOK_TIER_1","tierName":"기본","minimumSpending":300000,"maximumSpending":null,"benefits":[{"categoryCodes":["5813"],"categoryName":"카페","brandCodes":["STARBUCKS"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"description":"카페 이용금액 청구할인"},{"categoryCodes":["5499"],"categoryName":"편의점","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"description":"편의점 이용금액 청구할인"}]}]}' AS JSON)),
    (5, 'WE:SH All+ 카드', 'CREDIT', '01', 55000, 'https://cdn.benepay.com/cards/card-5.png', 'WE:SH All+ 카드 혜택 정보', 1, 400000, CAST('{"performanceTiers":[{"benefitNodeId":"WESH_ALLPLUS_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":400000,"totalMonthlyLimit":0,"description":"전월 이용실적 40만원 미만으로 할인서비스 미제공","benefits":[]},{"benefitNodeId":"WESH_ALLPLUS_TIER_1","tierName":"1구간","minimumSpending":400000,"maximumSpending":null,"totalMonthlyLimit":null,"description":"전월 이용실적 40만원 이상 시 할인서비스 제공, 한도 없음","benefits":[{"categoryName":"국내 가맹점","merchantType":"ALL","discountMethod":"STATEMENT_DISCOUNT","discountRate":1,"monthlyLimit":null,"description":"국내 전 가맹점 이용금액 1% 청구할인, 한도 없음"}]}]}' AS JSON)),
    (6, 'ALL 카드', 'CREDIT', '02', 20000, 'https://cdn.benepay.com/cards/card-6.png', 'ALL 카드 혜택 정보', 1, 0, CAST('{"performanceTiers":[{"benefitNodeId":"ALL_CARD_TIER_1","tierName":"기본","minimumSpending":0,"maximumSpending":null,"totalMonthlyLimit":null,"description":"전월 이용실적 조건 없이 제공","benefits":[{"categoryName":"국내 가맹점","merchantType":"ALL","discountMethod":"STATEMENT_DISCOUNT","discountRate":1,"monthlyLimit":null,"description":"국내 전 가맹점 이용금액 1% 청구할인, 실적조건 및 한도 없음"}]}]}' AS JSON)),
    (7, 'NEED Global 카드', 'CREDIT', '03', 30000, 'https://cdn.benepay.com/cards/card-7.png', 'NEED Global 카드 혜택 정보', 1, 0, CAST('{"performanceTiers":[{"benefitNodeId":"NEED_GLOBAL_TIER_1","tierName":"기본","minimumSpending":0,"maximumSpending":null,"totalMonthlyLimit":null,"description":"실적조건 없이 제공","benefits":[{"categoryName":"국내 가맹점","merchantType":"ALL","discountMethod":"STATEMENT_DISCOUNT","discountRate":0.5,"monthlyLimit":null,"description":"국내 가맹점 이용금액 0.5% 청구할인"}]}]}' AS JSON)),
    (8, '마이핏카드(할인형)', 'CREDIT', '03', 10000, 'https://cdn.benepay.com/cards/card-8.png', '마이핏카드(할인형) 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"MYFIT_DISCOUNT_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":300000,"totalMonthlyLimit":0,"description":"전월 이용실적 30만원 미만으로 할인서비스 미제공","benefits":[]},{"benefitNodeId":"MYFIT_DISCOUNT_TIER_1","tierName":"1구간(30만원 이상 50만원 미만)","minimumSpending":300000,"maximumSpending":500000,"benefits":[{"categoryName":"푸드","representativeMerchants":["외식","커피"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"외식·커피 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 2천원"},{"categoryName":"편의","representativeMerchants":["편의점","뷰티"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"편의점·뷰티 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 2천원"},{"categoryName":"생활","representativeMerchants":["마트","주유"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"마트·주유 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 2천원"}]},{"benefitNodeId":"MYFIT_DISCOUNT_TIER_2","tierName":"2구간(50만원 이상 100만원 미만)","minimumSpending":500000,"maximumSpending":1000000,"benefits":[{"categoryName":"푸드","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":5000,"description":"외식·커피 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 5천원"},{"categoryName":"편의","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":5000,"description":"편의점·뷰티 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 5천원"},{"categoryName":"생활","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":5000,"description":"마트·주유 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 5천원"}]},{"benefitNodeId":"MYFIT_DISCOUNT_TIER_3","tierName":"3구간(100만원 이상)","minimumSpending":1000000,"maximumSpending":null,"benefits":[{"categoryName":"푸드","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":10000,"description":"외식·커피 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 1만원"},{"categoryName":"편의","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":10000,"description":"편의점·뷰티 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 1만원"},{"categoryName":"생활","discountMethod":"STATEMENT_DISCOUNT","discountRate":5,"minimumPaymentAmount":10000,"monthlyLimit":10000,"description":"마트·주유 건당 1만원 이상 이용 시 5% 청구할인, 월 한도 1만원"}]}]}' AS JSON)),
    (9, '굿데이카드', 'CREDIT', '01', 5000, 'https://cdn.benepay.com/cards/card-9.png', '굿데이카드 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"GOODDAY_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":300000,"totalMonthlyLimit":0,"description":"전월 이용실적 30만원 미만으로 할인서비스 미제공","benefits":[]},{"benefitNodeId":"GOODDAY_TIER_1","tierName":"1구간(30만원 이상)","minimumSpending":300000,"maximumSpending":600000,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":200000,"description":"주유 리터당 60원 할인, 월 20만원 이용금액까지 적용","categoryCodes":["5541"]}]},{"benefitNodeId":"GOODDAY_TIER_2","tierName":"2구간(60만원 이상)","minimumSpending":600000,"maximumSpending":1200000,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":400000,"description":"주유 리터당 60원 할인, 월 40만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"음식/커피/편의점/약국","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"음식/커피/편의점/약국 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5812","5813","5499","5912"]}]},{"benefitNodeId":"GOODDAY_TIER_3","tierName":"3구간(120만원 이상)","minimumSpending":1200000,"maximumSpending":null,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":400000,"description":"주유 리터당 60원 할인, 월 40만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"음식/커피/편의점/약국","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"음식/커피/편의점/약국 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5812","5813","5499","5912"]},{"categoryName":"학원/휘트니스센터","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":300000,"description":"학원/휘트니스센터 10% 할인, 월 30만원 이용금액까지 적용","categoryCodes":["8299","7997"]}]}]}' AS JSON)),
    (10, '굿데이카드 플래티늄', 'CREDIT', '02', 100000, 'https://cdn.benepay.com/cards/card-10.png', '굿데이카드 플래티늄 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"GOODDAY_PLATINUM_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":300000,"totalMonthlyLimit":0,"description":"전월 이용실적 30만원 미만으로 할인서비스 미제공","benefits":[]},{"benefitNodeId":"GOODDAY_PLATINUM_TIER_1","tierName":"1구간(30만원 이상)","minimumSpending":300000,"maximumSpending":600000,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":200000,"description":"주유 리터당 60원 할인, 월 20만원 이용금액까지 적용","categoryCodes":["5541"]}]},{"benefitNodeId":"GOODDAY_PLATINUM_TIER_2","tierName":"2구간(60만원 이상)","minimumSpending":600000,"maximumSpending":1200000,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":400000,"description":"주유 리터당 60원 할인, 월 40만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"음식/커피/편의점/약국","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"음식/커피/편의점/약국 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5812","5813","5499","5912"]}]},{"benefitNodeId":"GOODDAY_PLATINUM_TIER_3","tierName":"3구간(120만원 이상)","minimumSpending":1200000,"maximumSpending":null,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":400000,"description":"주유 리터당 60원 할인, 월 40만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"음식/커피/편의점/약국","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"음식/커피/편의점/약국 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5812","5813","5499","5912"]},{"categoryName":"학원/휘트니스센터","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":300000,"description":"학원/휘트니스센터 10% 할인, 월 30만원 이용금액까지 적용","categoryCodes":["8299","7997"]}]}]}' AS JSON)),
    (11, '굿데이올림카드', 'CREDIT', '02', 20000, 'https://cdn.benepay.com/cards/card-11.png', '굿데이올림카드 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"GOODDAY_OLLIM_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":300000,"totalMonthlyLimit":0,"description":"전월 이용실적 30만원 미만으로 할인서비스 미제공","benefits":[]},{"benefitNodeId":"GOODDAY_OLLIM_TIER_1","tierName":"1구간(30만원 이상)","minimumSpending":300000,"maximumSpending":600000,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":200000,"description":"주유 리터당 60원 할인, 월 20만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"대형마트","merchants":["이마트","롯데마트","홈플러스"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":30000,"description":"대형마트 10% 할인, 월 3만원 이용금액까지 적용","categoryCodes":["5411"]}]},{"benefitNodeId":"GOODDAY_OLLIM_TIER_2","tierName":"2구간(60만원 이상)","minimumSpending":600000,"maximumSpending":1200000,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":400000,"description":"주유 리터당 60원 할인, 월 40만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"대형마트","merchants":["이마트","롯데마트","홈플러스"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"대형마트 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5411"]},{"categoryName":"음식/커피/편의점/약국","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"음식/커피/편의점/약국 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5812","5813","5499","5912"]}]},{"benefitNodeId":"GOODDAY_OLLIM_TIER_3","tierName":"3구간(120만원 이상)","minimumSpending":1200000,"maximumSpending":null,"benefits":[{"categoryName":"주유","discountMethod":"AMOUNT_PER_LITER","discountAmountPerLiter":60,"monthlyEligiblePaymentAmount":400000,"description":"주유 리터당 60원 할인, 월 40만원 이용금액까지 적용","categoryCodes":["5541"]},{"categoryName":"대형마트","merchants":["이마트","롯데마트","홈플러스"],"discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":100000,"description":"대형마트 10% 할인, 월 10만원 이용금액까지 적용","categoryCodes":["5411"]},{"categoryName":"음식/커피/편의점/약국","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":50000,"description":"음식/커피/편의점/약국 10% 할인, 월 5만원 이용금액까지 적용","categoryCodes":["5812","5813","5499","5912"]},{"categoryName":"학원/휘트니스센터","discountMethod":"STATEMENT_DISCOUNT","discountRate":10,"monthlyEligiblePaymentAmount":300000,"description":"학원/휘트니스센터 10% 할인, 월 30만원 이용금액까지 적용","categoryCodes":["8299","7997"]}]}]}' AS JSON)),
    (12, 'On the Go 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-12.png', 'On the Go 체크카드 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"ONTHEGO_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":300000,"totalMonthlyLimit":0,"benefits":[]},{"benefitNodeId":"ONTHEGO_TIER_1","tierName":"1구간(30만원 이상)","minimumSpending":300000,"maximumSpending":600000,"totalMonthlyLimit":10000,"benefits":[{"categoryName":"주유소","discountMethod":"CASHBACK","discountRate":3,"monthlyLimit":3000,"description":"주유소 업종 3% 환급할인, 월 한도 3천원","categoryCodes":["5541"]},{"categoryName":"커피/음료전문점","discountMethod":"CASHBACK","discountRate":3,"monthlyLimit":3000,"description":"커피/음료전문점 업종 3% 환급할인, 월 한도 3천원","categoryCodes":["5813"]},{"categoryName":"패스트푸드","discountMethod":"CASHBACK","discountRate":3,"monthlyLimit":3000,"description":"패스트푸드 업종 3% 환급할인, 월 한도 3천원","categoryCodes":["5814"]}]},{"benefitNodeId":"ONTHEGO_TIER_2","tierName":"2구간(60만원 이상)","minimumSpending":600000,"maximumSpending":null,"totalMonthlyLimit":20000,"benefits":[{"categoryName":"주유소","discountMethod":"CASHBACK","discountRate":3,"monthlyLimit":6000,"description":"주유소 업종 3% 환급할인, 월 한도 6천원","categoryCodes":["5541"]},{"categoryName":"커피/음료전문점","discountMethod":"CASHBACK","discountRate":3,"monthlyLimit":6000,"description":"커피/음료전문점 업종 3% 환급할인, 월 한도 6천원","categoryCodes":["5813"]},{"categoryName":"패스트푸드","discountMethod":"CASHBACK","discountRate":3,"monthlyLimit":6000,"description":"패스트푸드 업종 3% 환급할인, 월 한도 6천원","categoryCodes":["5814"]}]}]}' AS JSON)),
    (13, 'Youth Club 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-13.png', 'Youth Club 체크카드 혜택 정보', 1, 200000, CAST('{"performanceTiers":[{"benefitNodeId":"YOUTHCLUB_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":200000,"totalMonthlyLimit":0,"benefits":[]},{"benefitNodeId":"YOUTHCLUB_TIER_1_PACK_A","tierName":"1구간 - A팩","packCode":"A","minimumSpending":200000,"maximumSpending":null,"benefits":[{"categoryName":"여가","merchants":["노래방","PC방"],"discountMethod":"CASHBACK","discountRate":20,"minimumPaymentAmount":5000,"monthlyLimit":2000,"description":"노래방·PC방 건당 5천원 이상 이용 시 20% 환급, 월 한도 2천원","categoryCodes":["7994"]},{"categoryName":"편의점","merchants":["GS25","CU"],"requiredPaymentMethod":"KB_PAY","discountMethod":"CASHBACK","discountRate":20,"monthlyLimit":2000,"description":"GS25·CU에서 KB Pay 결제 시 20% 환급, 월 한도 2천원","categoryCodes":["5499"]},{"categoryName":"영화관","merchants":["CGV","메가박스","롯데시네마"],"discountMethod":"CASHBACK","discountAmount":4000,"minimumPaymentAmount":15000,"monthlyCountLimit":1,"description":"영화관 건당 1만5천원 이상 이용 시 4천원 정액 환급, 월 1회","categoryCodes":["7832"]}]},{"benefitNodeId":"YOUTHCLUB_TIER_1_PACK_B","tierName":"1구간 - B팩","packCode":"B","minimumSpending":200000,"maximumSpending":null,"benefits":[{"categoryName":"뷰티","merchants":["올리브영"],"discountMethod":"CASHBACK","discountRate":20,"monthlyLimit":2000,"description":"올리브영 20% 환급, 월 한도 2천원","categoryCodes":["7230"]},{"categoryName":"편의점","merchants":["GS25","CU"],"requiredPaymentMethod":"KB_PAY","discountMethod":"CASHBACK","discountRate":20,"monthlyLimit":2000,"description":"GS25·CU에서 KB Pay 결제 시 20% 환급, 월 한도 2천원","categoryCodes":["5499"]},{"categoryName":"식당/놀이공원","merchants":["아웃백스테이크하우스","VIPS","에버랜드","롯데월드"],"discountMethod":"CASHBACK","discountAmount":4000,"minimumPaymentAmount":10000,"monthlyCountLimit":1,"description":"건당 1만원 이상 이용 시 4천원 정액 환급, 월 1회","categoryCodes":["7994"]}]}],"commonConditions":{"packSelection":"가입 시 A팩 또는 B팩 중 1개 선택"}}' AS JSON)),
    (14, '노리2 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-14.png', '노리2 체크카드 혜택 정보', 1, 200000, CAST('{"performanceTiers":[{"benefitNodeId":"NORI2_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":200000,"totalMonthlyLimit":0,"benefits":[]},{"benefitNodeId":"NORI2_TIER_1","tierName":"1구간(20만원 이상)","minimumSpending":200000,"maximumSpending":400000,"totalMonthlyLimit":20000,"benefits":[{"categoryName":"커피","merchants":["스타벅스","커피빈"],"discountMethod":"CASHBACK","discountRate":10,"monthlyLimit":3000,"description":"스타벅스·커피빈 10% 환급, 월 한도 3천원","categoryCodes":["5813"]},{"categoryName":"뷰티","merchants":["올리브영"],"representativeMerchants":["미용실 업종"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"올리브영·미용실 업종 5% 환급, 월 한도 2천원","categoryCodes":["7230"]},{"categoryName":"편의점","merchants":["GS25","CU"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"GS25·CU 5% 환급, 월 한도 2천원","categoryCodes":["5499"]},{"categoryName":"영화","merchants":["CGV"],"discountMethod":"CASHBACK","discountAmount":4000,"monthlyCountLimit":2,"monthlyLimit":8000,"description":"CGV 4천원 정액 환급, 월 2회(월 한도 8천원)","categoryCodes":["7832"]},{"categoryName":"놀이공원","merchants":["에버랜드","롯데월드"],"discountMethod":"CASHBACK","discountAmount":15000,"monthlyCountLimit":1,"monthlyLimit":15000,"description":"에버랜드·롯데월드 1만5천원 정액 환급, 월 1회(월 한도 1만5천원)","categoryCodes":["7994"]}]},{"benefitNodeId":"NORI2_TIER_2","tierName":"2구간(40만원 이상)","minimumSpending":400000,"maximumSpending":600000,"totalMonthlyLimit":30000,"note":"개별 서비스 조건은 1구간과 동일, 통합한도만 3만원으로 상향","benefits":[{"categoryName":"커피","merchants":["스타벅스","커피빈"],"discountMethod":"CASHBACK","discountRate":10,"monthlyLimit":3000,"description":"스타벅스·커피빈 10% 환급, 월 한도 3천원","categoryCodes":["5813"]},{"categoryName":"뷰티","merchants":["올리브영"],"representativeMerchants":["미용실 업종"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"올리브영·미용실 업종 5% 환급, 월 한도 2천원","categoryCodes":["7230"]},{"categoryName":"편의점","merchants":["GS25","CU"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"GS25·CU 5% 환급, 월 한도 2천원","categoryCodes":["5499"]},{"categoryName":"영화","merchants":["CGV"],"discountMethod":"CASHBACK","discountAmount":4000,"monthlyCountLimit":2,"monthlyLimit":8000,"description":"CGV 4천원 정액 환급, 월 2회(월 한도 8천원)","categoryCodes":["7832"]},{"categoryName":"놀이공원","merchants":["에버랜드","롯데월드"],"discountMethod":"CASHBACK","discountAmount":15000,"monthlyCountLimit":1,"monthlyLimit":15000,"description":"에버랜드·롯데월드 1만5천원 정액 환급, 월 1회(월 한도 1만5천원)","categoryCodes":["7994"]}]},{"benefitNodeId":"NORI2_TIER_3","tierName":"3구간(60만원 이상)","minimumSpending":600000,"maximumSpending":800000,"totalMonthlyLimit":40000,"note":"개별 서비스 조건은 1구간과 동일, 통합한도만 4만원으로 상향","benefits":[{"categoryName":"커피","merchants":["스타벅스","커피빈"],"discountMethod":"CASHBACK","discountRate":10,"monthlyLimit":3000,"description":"스타벅스·커피빈 10% 환급, 월 한도 3천원","categoryCodes":["5813"]},{"categoryName":"뷰티","merchants":["올리브영"],"representativeMerchants":["미용실 업종"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"올리브영·미용실 업종 5% 환급, 월 한도 2천원","categoryCodes":["7230"]},{"categoryName":"편의점","merchants":["GS25","CU"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"GS25·CU 5% 환급, 월 한도 2천원","categoryCodes":["5499"]},{"categoryName":"영화","merchants":["CGV"],"discountMethod":"CASHBACK","discountAmount":4000,"monthlyCountLimit":2,"monthlyLimit":8000,"description":"CGV 4천원 정액 환급, 월 2회(월 한도 8천원)","categoryCodes":["7832"]},{"categoryName":"놀이공원","merchants":["에버랜드","롯데월드"],"discountMethod":"CASHBACK","discountAmount":15000,"monthlyCountLimit":1,"monthlyLimit":15000,"description":"에버랜드·롯데월드 1만5천원 정액 환급, 월 1회(월 한도 1만5천원)","categoryCodes":["7994"]}]},{"benefitNodeId":"NORI2_TIER_4","tierName":"4구간(80만원 이상)","minimumSpending":800000,"maximumSpending":null,"totalMonthlyLimit":50000,"note":"개별 서비스 조건은 1구간과 동일, 통합한도만 5만원으로 상향","benefits":[{"categoryName":"커피","merchants":["스타벅스","커피빈"],"discountMethod":"CASHBACK","discountRate":10,"monthlyLimit":3000,"description":"스타벅스·커피빈 10% 환급, 월 한도 3천원","categoryCodes":["5813"]},{"categoryName":"뷰티","merchants":["올리브영"],"representativeMerchants":["미용실 업종"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"올리브영·미용실 업종 5% 환급, 월 한도 2천원","categoryCodes":["7230"]},{"categoryName":"편의점","merchants":["GS25","CU"],"discountMethod":"CASHBACK","discountRate":5,"monthlyLimit":2000,"description":"GS25·CU 5% 환급, 월 한도 2천원","categoryCodes":["5499"]},{"categoryName":"영화","merchants":["CGV"],"discountMethod":"CASHBACK","discountAmount":4000,"monthlyCountLimit":2,"monthlyLimit":8000,"description":"CGV 4천원 정액 환급, 월 2회(월 한도 8천원)","categoryCodes":["7832"]},{"categoryName":"놀이공원","merchants":["에버랜드","롯데월드"],"discountMethod":"CASHBACK","discountAmount":15000,"monthlyCountLimit":1,"monthlyLimit":15000,"description":"에버랜드·롯데월드 1만5천원 정액 환급, 월 1회(월 한도 1만5천원)","categoryCodes":["7994"]}]}]}' AS JSON)),
    (15, '트래블러스 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-15.png', '트래블러스 체크카드 혜택 정보', 1, 200000, CAST('{"performanceTiers":[{"benefitNodeId":"TRAVELERS_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":200000,"totalMonthlyLimit":0,"benefits":[]},{"benefitNodeId":"TRAVELERS_TIER_1","tierName":"1구간(20만원 이상)","minimumSpending":200000,"maximumSpending":null,"benefits":[{"categoryName":"카페","representativeMerchants":["커피음료전문점 업종"],"discountMethod":"CASHBACK","discountAmount":1000,"minimumPaymentAmount":5000,"monthlyCountLimit":1,"monthlyLimit":1000,"description":"커피음료전문점 업종 5천원 이상 결제 시 1천원 환급, 월 1회(한도 1천원)","categoryCodes":["5813"]},{"categoryName":"빵집","representativeMerchants":["제과아이스크림 업종"],"discountMethod":"CASHBACK","discountAmount":2000,"minimumPaymentAmount":10000,"monthlyCountLimit":1,"monthlyLimit":2000,"description":"제과아이스크림 업종 1만원 이상 결제 시 2천원 환급, 월 1회(한도 2천원)","categoryCodes":["5462"]},{"categoryName":"주차장","discountMethod":"CASHBACK","discountAmount":500,"minimumPaymentAmount":1000,"monthlyCountLimit":6,"monthlyLimit":3000,"description":"주차장 업종 1천원 이상 결제 시 500원 환급, 월 6회(한도 3천원)","categoryCodes":["7523"]}]}]}' AS JSON)),
    (16, '첵첵 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-16.png', '첵첵 체크카드 혜택 정보', 1, 300000, CAST('{"performanceTiers":[{"benefitNodeId":"CHEKCHEK_TIER_0","tierName":"0구간","minimumSpending":0,"maximumSpending":300000,"totalMonthlyLimit":0,"benefits":[]},{"benefitNodeId":"CHEKCHEK_TIER_1","tierName":"1구간(30만원 이상 60만원 미만)","minimumSpending":300000,"maximumSpending":600000,"totalMonthlyLimit":10000,"benefits":[{"categoryName":"편의점","merchants":["CU"],"discountMethod":"CASHBACK","discountAmount":1000,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"CU편의점 건당 1만원 이상 결제 시 1천원 환급, 영역별 한도 2천원","categoryCodes":["5499"]},{"categoryName":"커피","merchants":["스타벅스"],"discountMethod":"CASHBACK","discountAmount":1000,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"스타벅스 건당 1만원 이상 결제 시 1천원 환급, 영역별 한도 2천원","categoryCodes":["5813"]},{"categoryName":"영화","merchants":["CGV"],"discountMethod":"CASHBACK","discountAmount":1000,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"CGV 건당 1만원 이상 결제 시 1천원 환급, 영역별 한도 2천원","categoryCodes":["7832"]},{"categoryName":"쇼핑","merchants":["텐바이텐"],"discountMethod":"CASHBACK","discountAmount":1000,"minimumPaymentAmount":10000,"monthlyLimit":2000,"description":"텐바이텐 건당 1만원 이상 결제 시 1천원 환급, 영역별 한도 2천원","categoryCodes":["5943"]},{"categoryName":"뷰티","merchants":["올리브영"],"representativeMerchants":["안경(렌즈)점"],"discountMethod":"CASHBACK","discountAmount":1000,"minimumPaymentAmount":20000,"monthlyLimit":2000,"description":"올리브영·안경(렌즈)점 건당 2만원 이상 결제 시 1천원 환급, 영역별 한도 2천원","categoryCodes":["7230"]}]},{"benefitNodeId":"CHEKCHEK_TIER_2","tierName":"2구간(60만원 이상)","minimumSpending":600000,"maximumSpending":null,"totalMonthlyLimit":20000,"benefits":[{"categoryName":"편의점","merchants":["CU"],"discountMethod":"CASHBACK","discountAmount":2000,"minimumPaymentAmount":10000,"monthlyLimit":4000,"description":"CU편의점 건당 1만원 이상 결제 시 2천원 환급, 영역별 한도 4천원","categoryCodes":["5499"]},{"categoryName":"커피","merchants":["스타벅스"],"discountMethod":"CASHBACK","discountAmount":2000,"minimumPaymentAmount":10000,"monthlyLimit":4000,"description":"스타벅스 건당 1만원 이상 결제 시 2천원 환급, 영역별 한도 4천원","categoryCodes":["5813"]},{"categoryName":"영화","merchants":["CGV"],"discountMethod":"CASHBACK","discountAmount":2000,"minimumPaymentAmount":10000,"monthlyLimit":4000,"description":"CGV 건당 1만원 이상 결제 시 2천원 환급, 영역별 한도 4천원","categoryCodes":["7832"]},{"categoryName":"쇼핑","merchants":["텐바이텐"],"discountMethod":"CASHBACK","discountAmount":2000,"minimumPaymentAmount":10000,"monthlyLimit":4000,"description":"텐바이텐 건당 1만원 이상 결제 시 2천원 환급, 영역별 한도 4천원","categoryCodes":["5943"]},{"categoryName":"뷰티","merchants":["올리브영"],"representativeMerchants":["안경(렌즈)점"],"discountMethod":"CASHBACK","discountAmount":2000,"minimumPaymentAmount":20000,"monthlyLimit":4000,"description":"올리브영·안경(렌즈)점 건당 2만원 이상 결제 시 2천원 환급, 영역별 한도 4천원","categoryCodes":["7230"]}]}]}' AS JSON)),
    (17, '가온 올포인트 체크카드', 'CHECK', '01', 0, 'https://cdn.benepay.com/cards/card-17.png', '가온 올포인트 체크카드 혜택 정보', 1, 0, CAST('{"performanceTiers":[{"benefitNodeId":"GAON_ALLPOINT_BASE","tierName":"기본적립","minimumSpending":0,"maximumSpending":null,"benefits":[{"categoryName":"전 가맹점","discountMethod":"POINT","pointRate":0.2,"description":"전 가맹점 0.2% 포인트 적립, 실적조건·한도 없음"}]},{"benefitNodeId":"GAON_ALLPOINT_ADD_TIER1","tierName":"추가적립(10만원 이상)","minimumSpending":100000,"maximumSpending":null,"benefits":[{"categoryName":"커피/제과아이스크림/GS25편의점","merchants":["GS25"],"discountMethod":"POINT","pointRate":0.2,"description":"커피/제과아이스크림 업종, GS25편의점 0.2% 추가 적립, 한도 없음","categoryCodes":["5813","5499","5462"]}]},{"benefitNodeId":"GAON_ALLPOINT_ADD_TIER2","tierName":"추가적립(30만원 이상)","minimumSpending":300000,"maximumSpending":null,"benefits":[{"categoryName":"대형마트","merchants":["이마트","롯데마트","홈플러스"],"discountMethod":"POINT","pointRate":0.8,"minimumPaymentAmount":30000,"monthlyEligiblePaymentAmount":500000,"description":"대형마트 건당 3만원 이상 이용 시 0.8% 추가 적립, 월 50만원 이용금액까지 적용","categoryCodes":["5411"]},{"categoryName":"주유소","merchants":["GS칼텍스"],"discountMethod":"POINT","pointRate":0.8,"minimumPaymentAmount":30000,"monthlyEligiblePaymentAmount":300000,"description":"GS칼텍스 주유소 건당 3만원 이상 이용 시 0.8% 추가 적립, 월 30만원 이용금액까지 적용","categoryCodes":["5541"]}]}]}' AS JSON));

INSERT INTO user_cards
(user_card_id, user_id, card_id, token_id, payment_token, token_expiry_date,
 pan_hash, pan_last4, par, status, is_primary, recommendation_enabled,
 created_at, updated_at, deleted_at)
VALUES
    (1, 1, 2, 'tok_5f9a1b2c3d4e5f6a7b8c9d0e1f2a3b4c', '9876543210981234', '2028-12-31',
     'a1b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef1234', '1234',
     'H1234567890123456789012345678', 'ACTIVE', 1, 1, '2026-03-01 10:00:00', NULL, NULL),
    (2, 1, 12, 'tok_7c2a9f1b3e5d6a7b8c9d0e1f2a3b4c5d', '9876543210985678', '2027-11-30',
     'b2c3d4e5f6789012345678901234567890abcdef1234567890abcdef123456', '5678',
     'H2345678901234567890123456789', 'ACTIVE', 0, 1, '2026-03-05 11:20:00', NULL, NULL),
    (3, 2, 4, 'tok_3d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a', '9876543210989012', '2029-06-30',
     'c3d4e5f6789012345678901234567890abcdef1234567890abcdef12345678', '9012',
     'H3456789012345678901234567890', 'SUSPENDED', 1, 0, '2026-01-20 08:45:00', '2026-06-01 09:00:00', NULL);

INSERT INTO card_monthly_status
(card_monthly_status_id, user_card_id, target_year_month, total_spending_amount, updated_at)
VALUES
    (1, 1, '202607', 105400, '2026-07-10 15:05:00'),
    (2, 2, '202607', 11400, '2026-07-02 19:30:00'),
    (3, 3, '202607', 0, '2026-07-01 00:00:00');

INSERT INTO merchants
(merchant_id, brand_id, category_code, merchant_code, merchant_name, address, latitude, longitude, phone)
VALUES
    (1, 1, '5813', 'MC-0000001', '스타벅스 강남점', '서울특별시 강남구 테헤란로 123', 37.4980000, 127.0276000, '02-1234-5678'),
    (2, 2, '5499', 'MC-0000002', 'GS25 역삼역점', '서울특별시 강남구 역삼동 456', 37.5006000, 127.0364000, '02-2345-6789'),
    (3, NULL, '5411', 'MC-0000003', '동네마트 역삼점', '서울특별시 강남구 역삼동 789', 37.5010000, 127.0370000, NULL),
    (4, NULL, '5541', 'MC-0000004', 'SK주유소 삼성점', '서울특별시 강남구 삼성동 12', 37.5100000, 127.0500000, '02-3456-7890'),
    (5, 5, '7832', 'MC-0000005', 'CGV 강남', '서울특별시 강남구 강남대로 438', 37.5016000, 127.0264000, NULL),
    (6, 6, '7230', 'MC-0000006', '올리브영 강남타운점', '서울특별시 강남구 강남대로 429', 37.5001000, 127.0268000, NULL),
    (7, NULL, '7523', 'MC-0000007', '강남역 공영주차장', '서울특별시 강남구 역삼동 858', 37.4977000, 127.0281000, NULL),
    (8, NULL, '7011', 'MC-0000008', '베네호텔 강남점', '서울특별시 강남구 테헤란로 200', 37.5019000, 127.0385000, '02-1111-2222');

INSERT INTO bookmarked_stores
(bookmark_id, user_id, merchant_id, created_at, is_deleted)
VALUES
    (1, 1, 1, '2026-07-01 08:00:00', 0),
    (2, 1, 5, '2026-07-03 12:00:00', 0),
    (3, 2, 6, '2026-07-05 14:00:00', 0);

INSERT INTO payments
(payment_id, merchant_id, user_card_id, payment_time, original_amount,
 discount_amount, final_amount, payment_status, payment_method)
VALUES
    (1, 1, 1, '2026-07-01 08:12:00', 6000, 600, 5400, 'APPROVED', 'QR'),
    (2, 2, 2, '2026-07-02 19:30:00', 12000, 600, 11400, 'APPROVED', 'BARCODE'),
    (3, 4, 3, '2026-07-03 07:50:00', 50000, 4000, 46000, 'CANCELED', 'QR'),
    (4, 1, 1, '2026-07-10 15:05:00', 4500, 450, 4050, 'PENDING', 'QR');

INSERT INTO card_issuance_events
(id, event_id, ci_hash, card_ref_id, card_last4, card_type, status, fail_reason, processed_at)
VALUES
    (1, '550e8400-e29b-41d4-a716-446655440000',
     'd8e8fca2dc0f896fd7cb4cb0031ba24900000000000000000000000000000000',
     'KB-CARD-REF-0001', '7777', 'CREDIT', 'PENDING_USER', NULL, NULL);

COMMIT;
