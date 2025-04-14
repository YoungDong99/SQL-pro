/* PL/SQL 변수 */


-- 1. 두 변수 입력받아 합 구하기
set serveroutput on
accept p_num1 prompt    '첫 번째 숫자를 입력하세요 ~ '
accept p_num2 prompt    '첫 번째 숫자를 입력하세요 ~ '

declare  -- 선언절
        v_sum number(10);
begin  -- 실행절
        v_sum := &p_num1 + &p_num2;
        dbms_output.put_line('총합은: ' || v_sum);  -- 변수 내용 출력력
end;  -- PL/SQL 블록 종료료

/*
    accept : 받아들이는 sqlplus 명령어
    prompt : 화면에 메시지 출력

    :=  는 할당 연산자
    dbms_output : 패키지 (변수값을 화면에 출력하는 put_line 함수를 포함)
    -> 인자값의 결과를 출력하려면 반드시 serveroutput을 on으로 설정해야함
*/




-- 2. 입력된 사원번호의 월급 출력력

set serveroutput on
accept p_empno prompt    '사원 번호를 입력하세요 ~ '

    declare
            v_sal number(10);
    begin
            select sal into v_sal
                from emp
                where empno = &p_empno;
    dbms_output.put_line('해당 사원의 월급은 : ' || v_sal);

end;

/*
    select .. into 절 : 테이블의 데이터를 검색하여 화면에 출력 가능 
*/




