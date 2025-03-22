/* WITH절 */

-- 1. WITH ~ AS

-- 직업과 직업별 토탈 월급을 출력 + 직업별 토탈 월급들의 평균값보다 더 큰 값들만 출력
WITH JOB_SUMAL AS (SELECT JOB, SUM(SAL) AS 토탈
                            FROM EMP
                            GROUP BY JOB)
  SELECT JOB, 토탈
    FROM JOB_SUMAL 
    WHERE 토탈 > (SELECT AVG(토탈)
                        FROM JOB_SUMAL);

/*
    ※ 검색 시간이 오래 걸리는 SQL이 하나의 SQL 내에서 반복되어 사용될 때 성능을 높이기 위한 방법으로 WITH절 사용
    - WITH절 수행 원리
    - 직업과 직업별 토탈 월급을 출력하여 임시 저장 영역(Temporary Tablespace)에 테이블명을 JOB_SUMAL로 명명지어 저장
    - 임시 저장 영역에 저장된 테이블인 JOB_SUMAL을 불러와서 직업별 토탈 월급들의 평균값보다 더 큰 직업별 토탈 월급 출력
    -> 임시 저장 영역에 저장된 데이터를 출력하는데 많은 시간이 걸렸다면 WITH절은 이 시간을 반으로 줄여준다.
*/

-- 위의 WITH절을 서브 쿼리문으로 수행했을 때
SELECT JOB, SUM(SAL) as 토탈
FROM EMP
WHERE SUM(SAL) > (SELECT AVG(SUM(SAL))
             FROM EMP
             GROUP BY JOB);

/*
    EMP 테이블의 데이터가 대용량이어서 직업과 직업별 토탈 월급을 출력하는데 시간이 많이 걸려 20분이 걸린다고 하면
    위의 SQL은 동일한 SQL을 두 번이나 사용했으므로 40분이 걸리게 된다.
    그러나 WITH절로 고쳐 작성하게 되면 20분 걸려서 얻은 5개의 데이터를 임시 저장 영역에 저장하고 그 데이터를
    JOB_SUMAL 테이블 이름으로 불러오기만 하면 되므로 시간이 절반으로 줄어든다.
    ※ 단, WITH절에서 사용한 TEMP 테이블은 WITH절 내에서만 사용 가능
*/



-- 2. SUBQUERY FACTORING : WITH절의 쿼리 결과를 임시 테이블로 생성하는 것

-- 직업별 토탈 값의 평균값에 3000을 더한 값보다 더 큰 부서 번호별 토탈 월급 출력
WITH JOB_SUMAL AS (SELECT JOB, SUM(SAL) 토탈
                            FROM EMP
                            GROUP BY JOB),
        DEPTNO_SUMAL AS (SELECT DEPTNO, SUM(SAL) 토탈
                                FROM EMP
                                GROUP BY DEPTNO
                                HAVING SUM(SAL) > (SELECT AVG(토탈) + 3000
                                                        FROM JOB_SUMAL)
                        )
  SELECT DEPTNO, 토탈
    FROM DEPTNO_SUMAL;

/*
    - WITH절을 사용하면 특정 서브 쿼리문의 컬럼을 다른 서브 쿼리문에서 참조 가능
    - 직업과 직업별 토탈 월급을 출력해 JOB_SUMAL이라는 이름으로 임시 저장 영역에 저장
*/

-- 아래와 같이 FROM절의 서브 쿼리로는 불가능
SELECT DEPTNO, SUM(SAL)
FROM (SELECT JOB, SUM(SAL) 토탈
                    FROM EMP
                    GROUP BY JOB) as JOB_SUMAL,
        (SELECT DEPTNO, SUM(SAL) 토탈
                        FROM EMP
                        GROUP BY DEPTNO
                      HAVING SUM(SAL) > (SELECT AVG(토탈) + 3000
                                                FROM JOB_SUMAL)
                        ) DEPTNO_SUMSAL;

-- 4행 오류:
-- ORA-00933: SQL 명령어가 올바르게 종료되지 않았습니다.
