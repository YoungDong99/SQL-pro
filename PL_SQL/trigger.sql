/* 트리거(Trigger) : INSERT, UPDATE, DELETE 등의 DML 명령어가 실행될 때 자동으로 이벤트를 발생시키는 데이터베이스 객체 */


-- Professor 테이블이 수정되면 메시지로 알려주는 트리거
CREATE OR REPLACE TRIGGER sal_chk
BEFORE UPDATE     -- 이벤트 기술
ON PROFESSOR01     -- 대상 테이블
BEGIN
    -- 트리거 발생 시 실행되는 명령문
    DBMS_OUTPUT.PUT_LINE('교수테이블이 수정되었습니다.');
END;

-- 트리거 실행 확인
SELECT * FROM PROFESSOR01;
UPDATE PROFESSOR01 SET BONUS = 80 WHERE PROFNO = 1001;

-- 트리거 삭제
DROP TRIGGER sal_chk;

-- 트리거 목록 확인 데이터 사전뷰
SELECT * FROM USER_TRIGGERS;


-- [실습]

-- 테이블 준비
CREATE TABLE sale01
AS
SELECT * FROM sale; -- 판매 테이블

CREATE OR REPLACE TRIGGER update_sale_date
BEFORE INSERT 
ON SALE01
FOR EACH ROW  -- 각 행에 트리거 실행
BEGIN
    :NEW.sale_date := SYSDATE;
    -- :NEW.칼럼명  := (할당연산자) 대입값
    DBMS_OUTPUT.PUT_LINE('판매완료!');
END;

-- 트리거 적용 확인
SELECT * FROM sale01;
INSERT INTO sale01 VALUES(6, 20, '', 1);

