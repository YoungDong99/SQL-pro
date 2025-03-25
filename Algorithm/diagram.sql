/* SQL 알고리즘 - 도형 출력 */



-- 1. 직각삼각형 출력

WITH  LOOP_TABLE  as  ( SELECT LEVEL   as NUM
                          FROM DUAL
                          CONNECT BY LEVEL <= 8 )
 SELECT LPAD('★',  num, '★') as STAR
   FROM LOOP_TABLE;

-- 숫자 1부터 8번까지 출력한 결과를 WITH절을 이용해 LOOP_TABLE로 저장
-- LPAD를 이용해 NUM에서 출력되는 숫자만큼 별을 채워 넣고 출력
-- > LPAD의 두 번째 인자의 숫자만큼 자릿수를 잡고 첫번째 인자인 별을 먼저 출력 후 나머지 자리에 별 채워넣기

-- 전체 10자리를 잡고 별 하나를 출력 후 나머지 9자리에 별을 채워 출력하는 쿼리
SELECT LPAD('★', 10, '★') as STAR FROM DUAL;



-- 2. 삼각형 출력

WITH LOOP_TABLE as ( SELECT LEVEL   as NUM
                        FROM DU     AL
                        CONNECT BY LEVEL <= 8 )
  SELECT LPAD(' ',  10-num, ' ')  ||  LPAD('★',  num, '★') as "Triangle"
    FROM LOOP_TABLE ;

/*
    첫번째 LPAD는 10-num만큼 자릿수를 잡고 그 중 하나를 공백으로 출력, 나머지 자리에 공백 채움
    연결 연산자로 별표를 출력한 LPAD를 작성
    두번쨰 LPAD는 NUM만큼 전체 자릿수를 잡고 별표 하나를 출력한 후 나머지 자리를 별로 채워넣음
    첫번째 LPAD는 전체 자리를 잡는 숫자가 점점 줄면서 공백이 줄어들고 두번째 LPAD는 별표가 늘어나며 삼각형 모양이 출력
*/


-- 치환변수(&)를 사용해 입력받은 숫자만큼 출력
WITH  LOOP_TABLE  as ( SELECT LEVEL   as NUM
                        FROM DUAL
                        CONNECT BY LEVEL <= &숫자1)
  SELECT LPAD(' ',  &숫자2-num, ' ')  ||  LPAD('★',  num, '★') as "Triangle"
    FROM LOOP_TABLE ;



-- 3. 마름모 출력

undefine p_num
ACCEPT p_num prompt '숫자입력 : '

SELECT lpad( ' ',  &p_num-level, ' ') || rpad('★',  level, '★')  as star
  FROM dual
  CONNECT BY level <&p_num+1
UNION ALL
SELECT lpad( ' ',  level, ' ') || rpad('★',  (&p_num)-level, '★')  as star
  FROM dual
  CONNECT BY level < &p_num ;

/*
    p_num은 HOST변수 또는 외부 변수
    undifine 명령어로 변수에 담겨 있는 내용 삭제
    accept는 값을 받아 p_num 변수에 담겠다는 SQL*PLUS 명령어
    prompt로 '숫자 입력'을 화면에 출력하고 숫자 입력 옆에 입력한 숫자를 p_num에 입력
    - lpad( ' ',  &p_num-level, ' ') : p_num에 입력한 숫자에서 LEVEL에 입력되는 숫자만큼 차감해 공백을 채움
    - 처음엔 공백이 5개 채워졌다가 다음 라인부터 1씩 차감되어 채워짐
    - rpad('★',  level, '★') : 별을 LEVEL수만큼 채워 출력
    UNION ALL 집합 연산자로 하나의 결과 집합으로 출력
    - lpad( ' ',  level, ' ') : level 수만큼 공백을 채워 출력 > level수가 증가하므로 공백 증가
    - rpad('★',  (&p_num)-level, '★') : 입력받은 숫자 p_num에서 level 수를 차감해 별 채워넣음 > level 수가 증가하므로 별은 줄어듬
*/



-- 4. 사각형 출력

undefine p_n1
undefine p_n2
ACCEPT p_n1 prompt '가로숫자를 입력하세요~';
ACCEPT p_n2 prompt '세로숫자를 입력하세요~';

WITH LOOP_TABLE as (SELECT LEVEL as NUM
                                 FROM DUAL
                                 CONNECT BY LEVEL <= &p_n2 )
SELECT LPAD('★',  &p_n1, '★') as STAR
  FROM LOOP_TABLE;

