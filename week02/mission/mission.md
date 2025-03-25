1. 내가 진행중, 진행 완료한 미션 모아서 보는 쿼리(페이징 포함
```sql
SELECT mm.*, 
       m.store_id, 
       m.reward, 
       m.deadline, 
       s.name AS store_name,
       CONCAT(mm.status, '_', DATE_FORMAT(mm.updated_at, '%Y%m%d%H%i%s'), '_', LPAD(mm.mission_id, 10, '0')) AS cursor_value
FROM member_mission AS mm
JOIN mission AS m ON mm.mission_id = m.id
JOIN store AS s ON m.store_id = s.id
WHERE mm.member_id = ?
AND (
    mm.status > ?  
    OR (mm.status = ? AND mm.updated_at < ?)  
    OR (mm.status = ? AND mm.updated_at = ? AND mm.mission_id > ?)  
)
ORDER BY FIELD(mm.status, 'IN_PROGRESS', 'NOT_STARTED', 'COMPLETED'),
         mm.updated_at DESC,
         mm.mission_id ASC
LIMIT 10;
```

- 특정 member_id에 해당하는 member_mission 목록을 상태(status), 업데이트 시간, mission_id 기준으로 정렬해서, 앞에서부터 10개만 조회
- 커서 기반 페이징 구현
- member_mission의 모든 컬럼, mission 테이블의 store_id, reward, deadline, store 테이블에서 store_name 이 필요
- 커서 기반 페이지네이션을 구현하기 위해 고유 문자열을 만듦

- member_mission과 mission, store 테이블을 조인

- 상태가 더 뒤일 수록
- 상태는 같다면 업데이트 시점이 더 오래된 미션일수록
- misison_id가 클 수록 다음 페이지 대상이 됨

- status 순서를 IN_PROGRESS → NOT STARTED → COMPLETED 순서로 정렬
- 최신 미션이 위에 오게끔 (최근→ 과거) 정렬
- 시간이 같을 경우 작은 ID가 위로 오도록 정렬

- 정렬 기준을 만족하는 항목 중 10개만 가져옴

2. 리뷰 작성하는 쿼리,
* 사진의 경우는 일단 배제
```sql
INSERT INTO review (member_id, store_id, body, score, created_at, updated_at)
```

3. 홈 화면 쿼리
(현재 선택 된 지역에서 도전이 가능한 미션 목록, 페이징 포함)
달성도 UI 부분: 쿼리로 해당 사용자가 지역별로 완료한 미션 수 가져오면 프론트에서 처리

```sql
SELECT m.id AS mission_id,
       m.store_id,
       s.name AS store_name,
       r.name AS region_name,
       m.reward,
       m.mission_spec
       m.deadline,
       (
         SELECT COUNT(*)
         FROM member_mission mm_sub
         JOIN mission m_sub ON mm_sub.mission_id = m_sub.id
         JOIN store s_sub ON m_sub.store_id = s_sub.id
         WHERE mm_sub.member_id = ?
           AND mm_sub.status = 'COMPLETED'
           AND s_sub.region_id = r.id
       ) AS region_completed_count,
       CONCAT(DATE_FORMAT(m.deadline, '%Y%m%d%H%i%s'), LPAD(m.id, 10, '0')) AS cursor_value
FROM mission AS m
JOIN store AS s ON m.store_id = s.id
JOIN region AS r ON s.region_id = r.id
JOIN member_mission mm ON mm.mission_id = m.id
WHERE r.id = ?
  AND mm.member_id = ?
  AND mm.status = 'NOT_STARTED'
  AND m.deadline >= NOW()
  AND (
       m.deadline > ?
    OR (m.deadline = ? AND m.id > ?)
  )
ORDER BY m.deadline ASC, m.id ASC
LIMIT 10;

```

- misison 테이블의 mission_id, store_id, reward, mission_spec, deadline, store 테이블의 name, region 테이블의 name 컬럼을 조회해야 함

- 현재 조회 중인 지역 r.id에서 지금 로그인한 사용자가 완료한 (status = ‘COMPLETED’) 미션이 몇개인지 서브쿼리로 셈
- region_completed_count라는 컬럼으로 보여줌

- 커서 기반 페이지네이션을 위해 고유 문자열을 만듦

- mission 테이블과 store, region 테이블을 조인하여 미션에 해당하는 가게 정보와 지역 정보를 가져옴
- status가 NOT STARTED 인 미션을 확인하기 위해 member_mission과도 조인

- 선택된 지역만 가져오고, 현재 로그인한 사용자의 NOT_STARTED인 미션만 필터링, 현재 시간이 마감일보다 이전인 유효한 미션만 가져옴

- 지금 커서의 deadline보다 마감일이 더 늦을 수록
- 마감일이 같다면 id가 클수록
- 다음 페이지 대상이 됨

- deadline이 얼마 안남은 미션부터 보여주도록 정렬
- 10개씩 가져옴

4. 마이 페이지 화면 쿼리
```sql
SELECT 
    m.name,
    m.email,
    m.profile_image,
    CASE 
        WHEN m.phone_number IS NOT NULL THEN m.phone_number
        ELSE '미인증'
    END AS phone_number,
    m.point
FROM member AS m
WHERE m.id = ?;  
```

- phone_number가 존재하면 인증된 것

시니어 미션
-https://velog.io/@danha/SQL-커서-기반-페이지네이션
-https://velog.io/@danha/SQL-SQL-Injection과-방지-방법
-https://velog.io/@danha/SQL-테이블-JOIN조인