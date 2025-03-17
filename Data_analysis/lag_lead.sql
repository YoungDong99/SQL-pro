/* LAG (바로 전 행), LEAD(바로 다음 행) 출력 */

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