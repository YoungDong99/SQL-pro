/* DML에서 서브쿼리 사용 */


-- 1. Subquery : 데이터 입력

-- VALUES절에 VALUES 대신 입력하고자 하는 서브 쿼리문을 기술
INSERT INTO emp2(empno, ename, sal, deptno)
  SELECT empno, ename, sal, deptno
    FROM emp
    WHERE deptno = 10;


-- 2. Subquery : 데이터 수정

-- SET절에 서브 쿼리를 사용해 직업이 SAMESMAN인 사원들의 월급을 ALLEN의 월급으로 갱신
UPDATE emp
SET sal = (SELECT sal
            FROM emp
            WHERE ename = 'ALLEN')
WHERE job = 'SALESMAN';

-- 여러 개의 컬럼들을 기술해 한 번에 갱신 가능
UPDATE emp
SET (sal, comm) = (SELECT sal, comm
                    FROM emp
                    WHERE ename = 'ALLEN')
WHERE ename = 'SCOTT';


-- 3. Subquery : 데이터 삭제
DELETE FROM emp
WHERE sal > (SELECT sal
              FROM emp
              WHERE ename = 'SCOTT');

DELETE FROM emp m
WHERE sal > (SELECT avg(sal)
              FROM emp s
              WHERE s.deptno = m.deptno);
-- 사원의 월급이 자기가 속한 부서의 평균 월급보다 크면 삭제하고 작으면 삭제하지 않음


-- 4. MERGE : 데이터 합치기

-- 부서 테이블에 새롭게 추가된 SUMSAL 컬럼에 해당 부서 번호의 토탈 월급으로 값을 갱신하는 MERGE문 
MERGE INTO dept d
USING (SELECT deptno, sum(sal) sumsal
        FROM emp
        GROUP BY deptno) v
ON (d.deptno = v.deptno)
WHEN MATCHED THEN
UPDATE set d.sumsal = v.sumsal;

-- USING절에서 서브 쿼리를 사용해 출력하는 데이터로 DEPT 테이블을 MERGE한다.
-- 서브 쿼리에서 반환하는 데이터는 부서 번호와 부서 번호별 토탈 월급
-- ON절에서 서브 쿼리에서 반환하는 데이터인 부서 번호와 사원 테이블의 부서 번호로 조인조건
-- 부서 번호가 일치하면 해당 부서 번호의 토탈 월급으로 값을 갱신

-- MERGE문으로 수행하지 않고 서브 쿼리를 사용한 UPDATE문
UPDATE dept d
    SET sumsal = (SELECT SUM(sal)
                  FROM emp e
                  WHERE e.deptno = d.deptno);

