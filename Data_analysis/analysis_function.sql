
/* 1. RANK() 뒤 OVER 다음에 나오는 괄호 안에 출력하고 싶은 데이터를 정렬하는 SQL 문장을 넣으면 해당 칼럼에 대한 순위 출력 */

SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) 순위
FROM emp
WHERE job in ('ANALYST', 'MANAGER');


SELECT ename, sal, job, RANK() OVER (PARTITION BY job ORDER BY sal DESC) as 순위 FROM emp;
-- PARTITION BY JOB : 직업별로 묶어서 순위 부여(그룹화하면서 개별 데이터 유지)


/* 2. DENSE_RANK : 순위 출력 (바로 2위 출력) */

SELECT ename, job, sal, RANK() over (ORDER BY sal DESC) AS RANK, 
                        DENSE_RANK() over (ORDER BY sal DESC) AS  DENSE_RANK
FROM emp1
WHERE job IN ('ANALYST', 'MANAGER');
-- 1위가 두명이어서 바로 다음에 3위 로 출력하는 RANK() 함수와 다르게 2위로 출력

SELECT job, ename, sal, DENSE_RANK() OVER (PARTITION BY job
                                                            ORDER BY sal DESC) 순위
FROM emp
WHERE hiredate BETWEEN to_date('1981/01/01', 'RRRR/MM/DD')
                             AND to_date('1981/12/31', 'RRRR/MM/DD');
-- 81년도 입사한 사원들의 직업별 월급이 높은 순서대로 순위를 부여한 쿼리


/* 특정 값의 순위 출력(RANK 함수도 가능) */
SELECT DENSE_RANK(2975) within group (ORDER BY sal DESC) 순위
FROM emp;
-- 월급이 2975인 사원(가정)의 월급 순위 출력
-- WITHIN은 '~이내'라는 뜻으로 WITHIN GROUP은그룹 이내에서 2975의 순위가 어떻게 되는지 확인하는 것.
-- GROUP 이후 쿼리 > 월급이 높은 순서대로 정렬된 그룹 안에서 2975의 순위 출력

SELECT DENSE_RANK('81/11/17') within group (ORDER BY hiredate ASC) 순위 FROM emp;
-- 입사일이 81년 11월 17일인 사원이 몇번째로 입사했는지 출력


/* 3. NTITLE : 등급 출력 */

SELECT ename, job, sal,
            NTILE(4) over (order by sal desc nulls last) 등급
FROM emp
WHERE job in ('ANALYST', 'MANAGER', 'CLERK');
-- 월급의 등급을 4등급으로 나눠 출력(상위 25%씩 1~4등급)
-- NULL LAST 는 NULL을 맨 아래에 출력하라는 의미


/* 4. CUME_DIST : 순위의 비율 출력 */
SELECT ename, sal, RANK( )        over ( order by sal DESC ) AS RANK,
                   DENSE_RANK( )  over ( order by sal DESC) AS DENSE_RANK,
                   CUME_DIST( )   over ( order by sal DESC) AS CUM_DIST
FROM emp;
-- 월급의 순위 비율 출력
-- 월급이 같은 사원은 비율 같음
-- 결과 : 0.0... ~ 1  까지 상위 비율 출력

-- -> 알아보기 쉽게 퍼센트로 변환
SELECT ename, sal, 
       RANK()            OVER (ORDER BY sal DESC) AS RANK,
       DENSE_RANK()      OVER (ORDER BY sal DESC) AS DENSE_RANK,
       ROUND(CUME_DIST() OVER (ORDER BY sal DESC) * 100, 0) || '%' AS CUM_DIST_PERCENT
FROM emp;

-- PARTITION BY를 사용해 직업별 순위 비율 출력
SELECT job, ename, sal, RANK()      over (partition by job
                                          order by sal DESC) as RANK,
                        CUME_DIST() over (partition by job
                                          order by sal DESC) as CUM_DIST
FROM emp;


/* 5. LAG (바로 전 행), LEAD(바로 다음 행) 출력 */

SELECT empno, ename, sal,
                LAG(sal, 1) over (ORDER BY sal ASC) "전 행",
                LEAD(sal, 1) over (order by sal asc) "다음 행"
FROM emp
WHERE job IN ('ANALYST', 'MANAGER');
-- LAG 함수 : 바로 전 행의 데이터 출력. 숫자 1을 사용하면 전 행을, 2를 사용하면 전전행을 출력
-- LEAD 함수 : 바로 다음 행의 데이터 출력. 숫자 1을 사용하면 다음 행을, 2를 사용하면 다다음 행을 출력

SELECT empno, ename, hiredate,
                LAG(hiredate, 1) over (order by hiredate asc) "전 행",
                LEAD(hiredate, 1) over (order by hiredate asc) "다음 행"
FROM emp
WHERE job IN ('ANALYST', 'MANAGER');
-- 바로 전에 입사한 사원의 입사일과 바로 다음에 입사한 사원의 입사일 출력

SELECT deptno, empno, ename, hiredate,
                LAG(hiredate, 1) over (partition by deptno
                                              order by hiredate asc) "전 행",
                LEAD(hiredate, 1) over (partition by deptno
                                               order by hiredate asc) "다음 행"
FROM emp;
-- 부서별로 구분해서 바로 전 입사한 사원의 입사일, 바로 다음에 입사한 사원의 입사일 출력




