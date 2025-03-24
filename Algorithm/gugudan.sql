/* SQL 알고리즘 - 구구단 출력 */


-- 구구단 2단 출력
WITH LOOP_TABLE  as ( SELECT LEVEL as NUM
                        FROM DUAL
                        CONNECT BY LEVEL <= 9 )
  SELECT  '2' || ' x ' ||  NUM || ' = ' || 2 * NUM  AS "2단"
    FROM LOOP_TABLE;


-- WITH절의 TEMP 테이블인 계층형 질의문만 실행 > 1~9 출력
SELECT LEVEL as NUM
    FROM DUAL
    CONNECT BY LEVEL <= 9;


-- 구구단 1단 ~ 9단 출력
WITH  LOOP_TABLE  AS  ( SELECT LEVEL   AS NUM
                                FROM DUAL
                                CONNECT BY LEVEL <= 9 ),
         GUGU_TABLE  AS ( SELECT LEVEL + 1 AS GUGU
                                FROM DUAL 
                                CONNECT BY LEVEL <= 8 )
SELECT TO_CHAR( A.NUM ) || ' X ' ||  TO_CHAR( B.GUGU) || ' = ' || 
          TO_CHAR( B.GUGU * A.NUM ) as 구구단
  FROM  LOOP_TABLE A, GUGU_TABLE B;

-- LOOP_TABLE : 계층형 질의문으로 1~9번까지 출력한 결과를 WITH절로 저장
-- GUGU_TABLE : 계층형 질의문으로 2~9번까지 출력한 결과를 WITH절로 저장
-- LOOP_TABLE과 GUGU_TABLE에서 숫자를 각각 불러와 구구단 전체 출력문 연산자로 연결결
-- WHERE절에 조인 조건절이 없으므로 전체를 조인해 결과를 출력
