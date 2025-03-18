/* 1. 데이터 출력 형식 변환 */

/* LISTAGG : 데이터를 가로로 출력 */
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



/* 2. SUM + DECODE (ROW를 COLUMN으로 출력) */
SELECT SUM(DECODE(deptno, 10, sal)) AS "10",
          SUM(DECODE(deptno, 20, sal)) AS "11",
          SUM(DECODE(deptno, 30, sal)) AS "12"
FROM emp;
-- 부서 번호, 부서 번호별 토탈 월급을 가로로 출력하기

/* 1단계 */
SELECT deptno, DECODE(deptno, 10, sal) AS "10"
FROM emp;
-- 부서번호가 10번이면 월급, 아니면 NULL 출력

/* 2단계 */
SELECT sum(DECODE(deptno, 10, sal)) AS "10"
FROM emp;
-- deptno 칼럼 제외하고 DECODE(deptno, 10, sal)만 출력한 다음 결과값 더하기

/* 3단계 */ 
SELECT SUM(DECODE(deptno, 10, sal)) AS "10",
          SUM(DECODE(deptno, 20, sal)) AS "11",
          SUM(DECODE(deptno, 30, sal)) AS "12"
FROM emp;
-- 20, 30번도 같이 출력하면 가로로 나열됨


SELECT SUM(DECODE(job, 'ANALYST', sal)) AS "ANALYST",
          SUM(DECODE(job, 'CLERK', sal)) AS "CLERK",
          SUM(DECODE(job, 'MANAGER', sal)) AS "MANAGER",
          SUM(DECODE(job, 'SALESMAN', sal)) AS "SALESMAN"
FROM emp;
-- 직업별 토탈 월급 출력
-- 어떤 직업이 있는지 알고있다는 가정하에 작성된 쿼리

SELECT SUM(DECODE(job, 'ANALYST', sal)) AS "ANALYST",
          SUM(DECODE(job, 'CLERK', sal)) AS "CLERK",
          SUM(DECODE(job, 'MANAGER', sal)) AS "MANAGER",
          SUM(DECODE(job, 'SALESMAN', sal)) AS "SALESMAN"
FROM emp
GROUP BY deptno;
-- 부서 번호별로 각각 직업의 토탈 월급의 분퐈를 보기 위해 그룹화



/* 3. PIVOT (ROW를 COLUMN으로 출력) */

/* SUM+DECODE 대신 PIVOT문을 이용해 간단한 쿼리 작성 */

SELECT *
    FROM (select deptno, sal from emp)
    PIVOT (sum(sal) for deptno in (10, 20, 30));
-- 부서번호별 토탈 월급 출력
-- FROM절에서 부서번호와 월급만 조회
-- PIVOT절에서 10번, 20번, 30번에 대한 토탈 월급 출력

SELECT *
    FROM (select job, sal from emp)
    PIVOT (sum(sal) for job in ('ANALYST', 'CLERK', 'MANAGER', 'SALESMAN'));
-- PIVOT문을 이용해 직업과 직업별 토탈 월급을 가로로 출력

/* PIVOT문을 사용할 때는 반드시 FROM절에 특정 컬럼만 선택 */

SELECT *
    FROM (select job, sal from emp)
    PIVOT (sum(sal) for job in ('ANALYST' as "ANALYST", 'CLERK' as "CLERK", 'MANAGER' as "MANAGER", 'SALESMAN' as "SALESMAN"));
-- 싱글 쿼테이션 제거 후 출력



/* 4. UNPIVOT (COLUMN을 ROW로 출력) */

-- ORDER2 테이블 생성
CREATE TABLE ORDER2 (
    ENAME VARCHAR(50),
    BICYCLE INT,
    CAMERA INT,
    NOTEBOOK INT
);

-- 샘플 데이터 삽입
INSERT INTO ORDER2 (ENAME, BICYCLE, CAMERA, NOTEBOOK) VALUES ('Alice', 3, 2, 1);
INSERT INTO ORDER2 (ENAME, BICYCLE, CAMERA, NOTEBOOK) VALUES ('Bob', 5, 1, 3);
INSERT INTO ORDER2 (ENAME, BICYCLE, CAMERA, NOTEBOOK) VALUES ('Charlie', 2, 4, 2);

-- order2 테이블의 칼럼이 행으로 출력
SELECT *
    FROM order2
    UNPIVOT( 건수 for 아이템 in (BICYCLE, CAMERA, NOTEBOOK));
-- '건수'는 가로로 저장되어 있는 데이터를 세로로 unpivot시킬 출력 열 이름 -> 임의로 지정
-- '아이템'은 가로로 되어 있는 order2 테이블의 컬럼명을 unpivot시켜 세로로 출력할 열 이름 -> 임의로 지정

SELECT *
    FROM order2
    UNPIVOT( 건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));
-- as절을 이용해 값 변경

/* 데이터에 NULL이 포함되어 있다면 결과에서 출력되지 않음 */ 

SELECT *
    FROM order2
    UNPIVOT INCLUDE NULLS( 건수 for 아이템 in (BICYCLE as 'B', CAMERA as 'C', NOTEBOOK as 'N'));
-- INCLUDE NULLS : NULL값도 결과에 포함해 출력


