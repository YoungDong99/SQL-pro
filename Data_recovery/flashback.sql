
/* FLASHBACK QUERY : 실수로 지운 데이터 복구 */


-- 1. 사원 테이블의 5분 전 KING 데이터 검색
SELECT *
FROM EMP
AS OF TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE)    -- 현재시간에서 5분을 뺀 시간
WHERE ENAME = 'KING';

-- AS OF TIMESTAMP절에 과거 시점 작성
-- 데이터를 수정, COMMIT 후 수정 전 데이터를 출력 가능

-- 1-1. 시간으로 조회하기
SELECT ename, sal
FROM emp
AS OF TIMESTAMP '22/11/29 21:24:45'
WHERE ename = 'KING';



-- 2. 사원 테이블을 5분 전으로 되돌리기
ALTER TABLE emp ENABLE ROW MOVEMENT;

FLASHBACK TABLE emp TO TIMESTAMP (SYSTIMESTAMP - INTERVAL '5' MINUTE);

-- ALTER 명령어로 사원 테이블을 플래쉬백이 가능한 상태로 설정
-- 설정 후 확인 방법
SELECT row_movement
FROM user_tables
WHERE table_name = 'EMP';
-- 출력결과 : ENABLED

-- 5분 전으로 플래쉬백 : 백업을 가지고 복구하는 것이 아니라 5분 전부터 현재까지 수행했던 DML 작업을 반대로 수행하며 과거로 되돌리기
-- ex) 5분 전부터 현재까지 수행한 작업 중 DELETE가 있다면 반대로 INSERT를 수행, INSERT가 있다면 DELETE를 수행함
-- 성공적으로 플래쉬백이 되면 데이터를 확인한 후 COMMIT을 해야 변경상태가 DB에 영구히 반영됨

-- 2-1. TO_TIMESTAMP 함수 : 지정한 시간으로 테이블 되돌리기
FLASHBACK TABLE emp TO TIMESTAMP
TO_TIMESTAMP('22/11/29 21:24:45', 'RR/MM/DD HH24:MI:SS');

-- 해당 시점까지 수행한 모든 DML 작업을 반대로 수행하며 EMP 테이블을 되돌린다.
-- 지정된 과거 시점부터 현재까지 DDL이나 DCL문을 수행했다면 FLASHBACK 명령어가 수행되지 않고 에러 발생



-- 3. DROP된 테이블 복원
FLASHBACK TABLE emp TO BEFORE DROP;

-- DROP된 테이블이 휴지통에 있다면 다시 복구하는 명령

-- 테이블 DROP 후 휴지통에 존재하는지 확인하는 방법
SELECT ORIGINAL_NSMA, DROPTIME FROM USER_RECYCLEBIN;

-- 3-1. 휴지통에서 복구할 때 테이블명 변경
FLASHBACK TABLE emp TO BEFORE DROP RENAME TO emp2;



-- 4. 테이블 데이터 변경 이력 정보 출력

SELECT ename, sal, versions_starttime, versions_endtime, versions_operation
FROM emp
VERSIONS BETWEEN TIMESTAMP
    TO_TIMESTAMP('2023-10-20 10:20:00', 'RRRR-MM-DD HH24:MI:SS')
    AND MAXVALUE
WHERE ename = 'KING'
ORDER BY versions_starttime;
-- 이력 정보를 기록하기 시작한 순서대로 정렬해서 출력

-- VERSIONS절에 변경 이력 정보를 보고 싶은 기간을 지정 : TO_TIMESTAMP 변환 함수 사용
-- 변경 이력 확인방법 : 현재시간 확인 > KING 데이터 확인 > 데이터 수정 > 이력정보 확인 > 변경시간, U(업데이트) 출력 확인



-- 5. FLASHBACK TRANSACTION QUERY

SELECT undo_sql         -- UNDO(취소)할 수 있는 SQL 조회        
FROM flashback_transaction_query
WHERE table_owner = 'SCOTT' AND table_name = 'EMP'
AND commit_scn bewteen 9457390 AND 9457397
ORDER BY start_timestamp DESC;      -- 최근 정보가 먼저 추력되게 정렬

-- SCN은 System Change Number의 약자로 commit할 때 생성되는 번호 > 특정 시간대의 SCN 번호로 범위 지정
-- TRANSACTION QUERY의 결과를 보려면 데이터베이스 모드를 아카이브 모드로 변경해야 함
-- > 아카이브 모드 : 장애가 발생했을 때 DB를 복구할 수 있는 로그 정보를 자동으로 저장하게 하는 모드
-- 아카이브 변경을 위한 DB 설정은 sqlplus에서 수행


