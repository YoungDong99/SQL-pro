/* 프로시저(Procedure) : PL/SQL을 통해서 만들어지고 특정 작업을 수행하는 단위 프로그램 */



-- 입력받은 교수번호의 급여를 10% 인상하는 프로시저
CREATE OR REPLACE PROCEDURE sal_inc(pno in NUMBER)  -- in 생략 가능 or out(외부로 내보냄)
IS
     -- 별도 선언 내용 없음
BEGIN
     update professor01 set pay = pay * 1.1
     where profno = pno;        -- pro : 매개변수 (외부 입력값과 비교)
     COMMIT;    -- db반영
     EXCEPTION WHEN OTHERS THEN   -- 예외(에러)
     ROLLBACK;   -- DML 작업 취소
END;


-- 프로시저 실행 시 메시지 출력(급여 인상 후 또는 예외 발생 시)
CREATE OR REPLACE PROCEDURE sal_inc(pno in NUMBER)
IS
BEGIN
    update professor01 set pay = pay * 1.1 where profno = pno;
        DBMS_OUTPUT.PUT_LINE('교수테이블의 급여 인상 프로시저 실행 성공');
        COMMIT;
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('교수테이블의 급여 인상 프로시저 실행 실패');
        ROLLBACK;
END;



-- 프로시저 삭제
DROP PROCEDURE sal_inc;


-- [실습1]

-- 테이블 준비
DROP TABLE emp01;
CREATE TABLE emp01
AS
SELECT * FROM emp;


-- 특정 사원 급여 인상 프로시저
CREATE OR REPLACE PROCEDURE emp_sal_inc(Vempno NUMBER)  -- 매개변수 : 사번
IS
    -- 변수 선언
    ename_val VARCHAR2(30);  -- 사원명 저장
    sal_val INT;    -- 급여 저장
BEGIN
    UPDATE emp01 SET sal = sal * 1.1 WHERE empno = Vempno;  -- 1. 수정문 : 급여인상
    SELECT ename, sal INTO ename_val, sal_val FROM emp01  -- SELECT 실제칼럼 INTO 변수명 FROM 테이블
    WHERE empno = Vempno;    -- 2. 조회문
    DBMS_OUTPUT.PUT_LINE(Vempno || '급여 인상 성공');    -- 3. 메시지 출력
    DBMS_OUTPUT.PUT_LINE('사원명 : ' || ename_val || ', 인상 급여 : ' || sal_val);   -- 4. 메시지 출력
    COMMIT;    -- 5. db 반영
    EXCEPTION WHEN OTHERS THEN  -- 예외처리
        DBMS_OUTPUT.PUT_LINE('급여 인상 실패');
        ROLLBACK;
END;

-- 기존 테이블 확인
SELECT * FROM emp01;

-- 프로시저 실행
EXECUTE emp_sal_inc(7839);
/*
    출력 결과
    7839급여 인상 성공
    사원명 : KING, 인상 급여 : 7986
*/


-- [실습2]

-- 테이블 준비
DROP TABLE dept01;
CREATE TABLE dept01
AS
SELECT * FROM dept;


CREATE OR REPLACE PROCEDURE update_insertDEPT(vdno NUMBER, 
                                              vdname VARCHAR, 
                                              vloc VARCHAR)
IS
    cnt_var NUMBER;   -- 내부변수
BEGIN
    SELECT COUNT(*) INTO cnt_var FROM dept01 WHERE deptno=vdno;
    IF cnt_var = 0 THEN
        INSERT INTO dept01 VALUES(vdno, vdname, vloc);
        DBMS_OUTPUT.PUT_LINE('부서테이블 레코드 삽입 성공!!');
        COMMIT;
    ELSE
        UPDATE dept01 SET dname=vdname, loc=vloc WHERE deptno=vdno;
        DBMS_OUTPUT.PUT_LINE('부서테이블 레코드 수정 성공!!');
        COMMIT;
    END IF;
    EXCEPTION WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE(' 작업 실패!!' );
        ROLLBACK;
END;

-- 프로시저 실행 전
SELECT * FROM dept01;   -- 30  SALES  CHICAGO

-- 프로시저 실행
EXECUTE update_insertDEPT(30, 'SALES', 'CHICAGO');
-- 부서테이블 레코드 수정 성공!!
EXECUTE update_insertDEPT(50, 'MARKETING', 'SEOUL');     -- 테이블에 없는 부서정보
-- 부서테이블 레코드 삽입 성공!!

SELECT * FROM dept01;   -- 테이블 변경 내용 확인

