/* SQL 알고리즘 - 수학 */


-- 1. 1부터 10까지 숫자의 합
undefine p_n
ACCEPT p_n prompt '숫자를 입력하세요~';

SELECT SUM(LEVEL) as 합계
  FROM DUAL
  CONNECT BY LEVEL<=&p_n;
/*
    ACCEPT : 사용자로부터 입력을 받아 p_n이라는 변수에 저장
    LEVEL이라는 가상 칼럼을 이용해 1부터 p_n까지의 합계를 구하는 쿼리
    CONNECT BY LEVEL<=&p_n : LEVEL은 CONNECT BY 구문에서 사용하는 특별한 가상 칼럼으로,
    계층 쿼리에서 각 레벨을 나타낸다. LEVEL을 1부터 p_n까지 증가시키는 역할
    &p_n : 사용자가 입력한 값 ex) 3을 입력하면 LEVEL은 1,2,3으로 진행
*/


-- 2. 1부터 10까지 숫자의 곱
undefine p_n 
ACCEPT p_n prompt '숫자를 입력하세요~'

SELECT ROUND(EXP(SUM(LN(LEVEL)))) 곱
  FROM DUAL
  CONNECT BY LEVEL<=&p_n;

/*
    LN(LEVEL) : 자연로그 함수로 X의 자연로그를 구한다
    SUM(LN(LEVEL)) : LEVEL 값들의 자연로그 결과값들의 합
    EXP(SUM(LN(LEVEL))) : 자연상수 e의 x 거듭제곱을 구하는 함수. 즉 EXP(x) = e^x
    -> 위에서 SUM으로 구해진 값을 지수로 변환
*/


-- 3. 1부터 10까지 짝수만 출력
undefine p_n 
ACCEPT p_n prompt '숫자를 입력하세요~';

SELECT LISTAGG(LEVEL, ', ') as 짝수
  FROM DUAL
  WHERE MOD(LEVEL, 2) = 0
  CONNECT BY LEVEL <= &p_n ;

/*
    MOD(LEVEL, 2) : LEVEL 값을 2로 나눈 나머지 구하기
    LISTAGG(LEVEL, ', ') : 그룹 내의 값을 하나의 문자열로 합치는 집계 함수
*/


-- 4. 1부터 10까지 소수만 출력
undefine p_n 
ACCEPT p_n prompt '숫자를 입력하세요~';

WITH LOOP_TABLE as ( SELECT LEVEL AS NUM
                       FROM DUAL
                       CONNECT BY LEVEL <= &p_n)
SELECT L1.NUM as 소수
  FROM LOOP_TABLE L1, LOOP_TABLE L2
  WHERE MOD(L1.NUM, L2.NUM) = 0
  GROUP BY L1.NUM
  HAVING COUNT(L1.NUM) = 2;

/*
    소수는 1과 자기 자신의 수로만 나눌 수 있는 수이므로 자기 자신의 수로 나누기 위해 self join 수행 > where절 조건X

    WITH 구문은 임시 테이블을 정의 -> LOOP_TABLE이라는 임시 테이블을 정의
    L1.NUM이 소수인지 확인하기 위해 L1.NUM과 L2.NUM을 서로 비교하여, 
    L1.NUM이 L2.NUM으로 나누어 떨어지는 경우를 찾아낸다.
    L1은 소수 후보를 나타내고, L2는 L1.NUM이 나누어지는 숫자를 검사하는 역할 => L1.NUM과 L2.NUM을 비교

    WHERE MOD(L1.NUM, L2.NUM) = 0
    L1.NUM을 L2.NUM으로 나누었을 때 나머지가 0이면 L1.NUM은 L2.NUM의 배수
    소수는 1과 자기 자신만 나누어지기 때문에, 나누어 떨어지는 수가 두 개(1과 자기 자신)만 있어야 한다.

    GROUP BY L1.NUM
    L1.NUM을 기준으로 그룹화하여, L1.NUM에 대해 L2.NUM이 몇 번 나누어지는지를 계산
    이 과정은 각 숫자가 몇 개의 다른 숫자로 나누어지는지 확인하는 역할을 한다.

    HAVING COUNT(L1.NUM) = 2
    소수는 1과 자기 자신만 나누어지므로 L1.NUM이 2개의 숫자로만 나누어지면 소수
*/


-- 5. 최대 공약수 구하기

ACCEPT p_n1 prompt ' 첫번째 숫자를 입력하세요.';
ACCEPT p_n2 prompt ' 두번째 숫자를 입력하세요.';

WITH NUM_D AS ( SELECT &p_n1 as NUM1, &p_n2 as NUM2
                FROM DUAL )
SELECT MAX(LEVEL) AS "최대 공약수"
  FROM NUM_D
  WHERE MOD(NUM1, LEVEL) = 0
  AND MOD(NUM2, LEVEL) = 0
  CONNECT BY LEVEL <= NUM2 ;

/*
  16과 24 입력 : 1번부터 24번까지의 숫자를 하나씩 16과 24로 나누면서 나눈 나머지 값이
  둘 다 0이 되는 숫자를 찾아 그 중 최댓값 출력
*/


-- 6. 최소 공배수 구하기

ACCEPT P_N1  PROMPT ' 첫번째 숫자를 입력하세요: ';
ACCEPT P_N2  PROMPT ' 두번째 숫자를 입력하세요: ';

WITH NUM_D AS ( SELECT &P_N1 NUM1, &P_N2 NUM2
                 FROM DUAL )
SELECT NUM1, NUM2, (NUM1/MAX(LEVEL))*(NUM2/MAX(LEVEL))*MAX(LEVEL) AS "최소 공배수"
  FROM NUM_D
  WHERE MOD(NUM1, LEVEL) = 0
  AND MOD(NUM2, LEVEL) = 0
  CONNECT BY LEVEL <= NUM2 ;

/*
  16과 24 입력 : 최대공약수 8을 구해서 16과 24를 나눈 후 몫인 3과 2를 곱해서 최소공배수 48 출력
*/


-- 7. 피타고라스의 정리

ACCEPT NUM1 PROMPT '밑변의 길이를 입력하세요 ~ '
ACCEPT NUM2 PROMPT '높이를 입력하세요 ~ '
ACCEPT NUM3 PROMPT '빗변의 길이를 입력하세요 ~ '

SELECT CASE WHEN ( POWER(&NUM1,2) + POWER(&NUM2,2) ) = POWER(&NUM3,2)  
             THEN '직각 삼각형이 맞습니다'
             ELSE '직각 삼각형이 아닙니다' END AS "파타고라스의 정리"
  FROM DUAL;

-- CASE문은 END로 반드시 종료
-- AS 다음 컬럼 별칭으로 공백을 넣기 위해 더블 쿼테이션("") 사용


-- 8. 몬테가를로 알고리즘

SELECT SUM(CASE WHEN (POWER(NUM1,2) + POWER(NUM2,2)) <= 1  THEN 1
                ELSE 0 END ) / 100000 * 4 as "원주율"
 FROM ( 
           SELECT DBMS_RANDOM.VALUE(0,1) AS NUM1,
                  DBMS_RANDOM.VALUE(0,1) AS NUM2
             FROM DUAL
             CONNECT BY LEVEL < 100000
        ) ; 


-- 9. 오일러 상수 자연상수 구하기

WITH LOOP_TABLE AS ( SELECT LEVEL  AS NUM 
                     FROM DUAL 
                     CONNECT BY LEVEL <= 1000000
                     ) 
SELECT RESULT
  FROM ( 
           SELECT NUM, POWER( (1 + 1/NUM) ,NUM) AS RESULT
            FROM LOOP_TABLE
                )
  WHERE NUM = 1000000;

-- 숫자가 커질수록 점점 자연상수(e) 값에 근사 -> 가장 마지막 제공 숫자인 1000000으로 출력 제한

