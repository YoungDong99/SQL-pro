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
