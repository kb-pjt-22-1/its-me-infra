-- =========================================================
-- kb_card_mock DB 접근 권한 부여
--
-- MySQL 공식 이미지는 컨테이너 최초 기동 시 MYSQL_USER 환경변수로
-- 만든 계정에게 MYSQL_DATABASE(=benepay)에 대한 권한만 자동으로 부여한다.
-- card-mock 서버는 같은 계정으로 kb_card_mock DB에도 접속해야 하므로
-- 별도로 권한을 부여해야 한다.
--
-- 계정명은 .env의 MYSQL_USER 값과 일치해야 한다 (현재: benepay).
-- =========================================================

GRANT ALL PRIVILEGES ON kb_card_mock.* TO 'benepay'@'%';

FLUSH PRIVILEGES;
