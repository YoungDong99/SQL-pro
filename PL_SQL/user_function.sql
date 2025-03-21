/* 사용자 함수(Function) */


/*
    프로시저 vs 사용자 함수
    프로시저 : RETURN 선택, EXECUTE 실행, 데이터 사전 뷰 제공
    사용자 함수 : RETURN 필수, SELECT로 호출, 데이터사전 뷰X
*/
CREATE OR REPLACE FUNCTION EMP_SAL(ENO NUMBER)
RETURN NUMBER -- 리턴값의 자료형
IS
    SAL_VAL NUMBER(6); -- 리턴 변수 선언
BEGIN
    SELECT SAL
    INTO SAL_VAL -- SAL 칼럼 조회 결과를 변수에 저장
    FROM EMP
    WHERE EMPNO = ENO;
    RETURN SAL_VAL; -- 급여 결과 리턴
END;
-- 사번으로 특정 사원의 급여를 조회하는 함수


-- 함수 호출 방법 : SELECT문 이용

SELECT * FROM emp;   -- 테이블 정보 확인
SELECT DISTINCT EMP_SAL(7369) 월급 FROM EMP;

-- 사용자 함수 삭제
DROP FUNCTION EMP_SAL;
