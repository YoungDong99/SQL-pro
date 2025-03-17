/* 데이터 출력 형식 변환 */

/* LISTAGG : 데이터를 가로로 출력력 */
SELECT deptno, LISTAGG(ename, ', ') within group (ORDER BY ename) as EMPLOYEE
FROM EMP
GROUP BY deptno;
-- 구분자를 콤마(,)로 하여 데이터를 가로로 출력
-- WITHIN GROUP '~이내의' 괄호에 속한 그룹의 데이터 출력
-- GROUP BY절은 LISTAGG 함수를 사용하려면 필수로 기술해야 하는 절


SELECT job, LISTAGG(ename, ' / ') within group (ORDER BY ename asc) AS EMPLOYEE
FROM emp1
GROUP BY job;
-- 직업과 그 직업에 속한 사원들의 이름을 가로로 출력

SELECT job,
LISTAGG(ename || '(' || sal || ')', ',') within group (ORDER BY ename asc) AS EMPLOYEE
FROM emp1
GROUP BY job;
-- 연결 연산자를 사용해 직업별로 월급의 분포를 한눈에 확인하기












