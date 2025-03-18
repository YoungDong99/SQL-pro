/* 데이터 분석 함수로 집계 결과 출력하기 */


/* 1. ROLLUP */

-- 맨 마지막 행에 토탈 월급 출력(추가 행)
SELECT job, sum(sal)
FROM emp
GROUP BY ROLLUP(job);
-- ROLLUP 사용시 JOB 컬럼의 데이터도 오름차순으로 정렬되어 출력


-- ROLLUP에 컬럼 두 개 사용 : 부서 번호별로 토탈 월급 출력
SELECT deptno, job, SUM(sal)
FROM EMP1
GROUP BY ROLLUP(deptno, job)
ORDER BY deptno NULLS LAST, job NULLS LAST;

-- NULL LAS : 부서 전체 합계가 마지막에 오도록 정렬



/* 2. CUBE */

-- 직업별 토탈 월급을 첫 번째 행에 출력
SELECT job, SUM(sal)
FROM emp
GROUP BY CUBE(job);

-- CUBE 사용시 부서 번호 오름차순으로 정렬되어 출력
SELECT deptno, SUM(sal)
FROM emp
GROUP BY CUBE(deptno);

-- CUBE에 컬럼 2개 사용
SELECT deptno, job, SUM(sal)
FROM emp
GROUP BY CUBE(deptno, job);

-- GROUP BY CUBE(deptno, job) 에 총 4개 집계 결과 출력
/*
    1. () : 전체 토탈 월급 (맨 위)
    2. job : 직업별 토탈 월급 목록
    3. deptno : 부서 번호별 토탈 월급
    4. deptno, job : 부서 번호별 직업별 토탈 월급
*/



/* 3. GROUPING SETS */

-- GROUPING SETS에 집계하고 싶은 컬럼들을 기술하면 그대로 출력
SELECT deptno, job, SUM(sal)
FROM emp1
GROUP BY GROUPING SETS((deptno), (job), ( ));
-- 부서번호별, 직업별로 토탈 월급 출력

-- 1) ROLLUP 사용
SELECT deptno, SUM(sal)
FROM EMP1
GROUP BY ROLLUP(deptno);

-- 2) GROUPING SETS 사용 (예측하기 더 쉬움)
SELECT deptno, SUM(sal)
FROM emp1
GROUP BY GROUPING SETS((deptno), ( ));




