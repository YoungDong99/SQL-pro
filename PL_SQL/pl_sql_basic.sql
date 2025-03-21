/* PL/SQL : SQL을 확장한 절차형 프로그랭 언어 */

/* 로직(logic) 관련 명령문 */


-- 1. CURSOR문 : PL/SQL에서 여러 행을 저장하는 역할 
DECLARE -- 선언부     
   CURSOR emp_cursor is
         select ename, sal, job 
         from emp 
         where deptno = 30;
BEGIN -- 실행부 
    DBMS_OUTPUT.PUT_LINE('사원이름  급여  직책');   -- 화면에 문자열 출력 > 테이블 헤더 역할
    FOR emp_row in emp_cursor LOOP  -- 레코드 수만큼 반복
      -- 변수(객체).칼럼명
       DBMS_OUTPUT.PUT_LINE(emp_row.ename || ' | ' || emp_row.sal || ' | ' || emp_row.job);   -- 결합연산자 || 로 하나의 문장처럼 출력력
    END LOOP;   -- 반복문 끝
END;  -- 프로그램 끝

-- > cursor라는 객체에 임시로 저장된 내용이 출력된다.



-- 2. IF문 : 급여 분류 
DECLARE -- 선언부 : 커서 정의
   cursor emp_cursor is
         select ename, sal, job
         from emp 
         where deptno = 30;
BEGIN -- 실행부
    DBMS_OUTPUT.PUT_LINE('*****  급여 분류 *****');
    FOR emp_row in emp_cursor LOOP -- 1행 단위 반복
        IF emp_row.sal >= 1500 THEN
           DBMS_OUTPUT.PUT_LINE('1,500 이상 => ' || emp_row.ename || ' ' || emp_row.sal);  -- 조건 : TRUE
        ELSE 
           DBMS_OUTPUT.PUT_LINE('1,500 미만 => ' || emp_row.ename || ' ' || emp_row.sal);  -- 조건 : FALSE
        END IF;
    END LOOP;
END;



-- IF문 : 다중선택문 
DECLARE -- 선언부 : 커서 정의
   cursor emp_cursor is
         select ename, sal, deptno
         from emp;
BEGIN -- 실행부  
    DBMS_OUTPUT.PUT_LINE('*****  부서 분류 *****');
    FOR emp_row in emp_cursor LOOP -- 1행 단위 반복
        IF emp_row.deptno = 10 THEN
           DBMS_OUTPUT.PUT_LINE('10번 부서 => ' || emp_row.ename || ' ' || emp_row.sal);
        ELSIF emp_row.deptno = 20 THEN 
           DBMS_OUTPUT.PUT_LINE('20번 부서 => ' || emp_row.ename || ' ' || emp_row.sal);
        ELSE 
           DBMS_OUTPUT.PUT_LINE('30번 부서 => ' || emp_row.ename || ' ' || emp_row.sal);        
        END IF;       
    END LOOP; 
END;



-- 3. WHILE문 : 반복문 
DECLARE -- 선언부 : 변수 선언  
  cnt NUMBER;-- 변수명 자료형
BEGIN -- 실행부  
    DBMS_OUTPUT.PUT_LINE('***** WHILE 반복문 *****');
    cnt := 1; -- 변수 초기값    
    WHILE cnt < 6 LOOP
       DBMS_OUTPUT.PUT_LINE('반복 수행 결과 => ' || cnt);              
       cnt := cnt + 1;
    END LOOP; 
END;



-- 4. FOR문 : 반복문 
DECLARE -- 선언부 : 변수 선언  
  dan NUMBER;-- 단수 
  cnt NUMBER;-- 곱수
BEGIN -- 실행부  
    DBMS_OUTPUT.PUT_LINE('*** 구구단 ***');
    dan := 2;  -- 변수
    cnt := 0;  -- 제어변수 : 루프 실행동안 값이 자동으로 증가
    FOR  cnt IN 1..9 LOOP -- FOR 변수 IN 하한값..상한값 LOOP -> 1~9까지 범위의 숫자가 cnt로 넘어옴
       DBMS_OUTPUT.PUT_LINE(dan ||' * '|| cnt || ' = ' || dan*cnt);              
    END LOOP; 
END;

