/* 서열을 주고 데이터 출력하기 */



-- 1. 사원들 간의 서열을 출력하는 쿼리

SELECT rpad(' ', level*3)  || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'       -- 루트 노드의 데이터를 KING 으로 지정
CONNECT BY prior empno = mgr;  -- 노드 간 관계지정 : 가운데 PRIOR 이후 왼쪽 부모노드, 오른쪽 자식노드 기술

/* 해설 */
-- CONNECT BY와 START WITH절을 사용하면 PSEUDO COLUMN인 LEVEL을 출력할 수 있음
-- LEVEL : 계층 트리 구조에서 계층을 뜻함
-- KING은 트리 구조의 최상위에 있는 노드여서 계층 1레벨이 되며 순차적으로 하위 레벨 2,3,4 레벨이 출력됨
-- RPAD로 이름 앞에 공백을 level수의 3배가 되도록 추가하여 서열 시각화



-- 2. BLAKE와 BLAKE의 직속 부하들 출력 제외

SELECT rpad(' ', level*3)  || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr AND ename != 'BLAKE';

-- BLAKE만 제외하고 출력하려면 WHERE절에 조건 기술
-- BUT BLAKE의 팀원들까지 모두 출력하지 않으려면 CONNECT BY절에 ename != 'BLAKE' 조건 추가
-- > 부모 노드와 자식 노드의 관계를 맺을 때 BLAKE를 제외하면 BLAKE의 사원 번호를 MGR 번호로 하는 사원들이 모두 출력되지 않음



-- 3. 서열 순위를 유지하면서 월급이 높은 사원부터 출력

SELECT rpad(' ', level*3)  || ename as employee, level, sal, job
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr
ORDER SIBLINGS BY sal desc;
-- ORDER과 BY 사이에 SIBLINGS를 사용해 정렬하면 계층형 질의문 서열을 깨트리지 않으면서 출력 가능
-- SIBLINGS를 사용하지 않으면 서열 순위가 섞여 출력됨



-- 4. 서열 순서를 가로로 출력

SELECT ename, SYS_CONNECT_BY_PATH(ename, '/') as path
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr;
-- 이름과 이름 사이가 '/'로 구분되어 출력


SELECT ename, LTRIM(SYS_CONNECT_BY_PATH(ename, '/'), '/') as path
FROM emp
START WITH ename = 'KING'
CONNECT BY prior empno = mgr;
-- LTRIM을 사용해 이름 앞에 '/' 제거 후 출력