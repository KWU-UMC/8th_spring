## ☑️ 실습 인증

---

** 위에 공개되어있는 데이터베이스 설계를 참고하여 진행하였습니다.

1. **내가 진행중, 진행 완료한 미션 모아서 보는 쿼리(페이징 포함)**

    ```jsx
    SELECT 
        mm.id AS member_mission_id,
        m.reward,
        s.name AS store_name,
        m.mission_spec,
        mm.status
    FROM member_mission AS mm
    JOIN mission AS m ON mm.mission_id = m.id
    JOIN store AS s ON m.store_id = s.id
    
    WHERE mm.member_id = {로그인 사용자 ID 넣기}
    AND mm.status IN ('진행중', '성공')
    LIMIT 3 OFFSET 0;
    ```

- `member_mission` 테이블을 기준으로 `mission`과 `store` 테이블을 **JOIN**
- 화면에 표시되어있는 정보들인 `reward`, `store_name`, `mission_spec`, `status`를 가져옴.
- `WHERE mm.member_id = {로그인 사용자 ID 넣기}` → 로그인된 사용자의 미션 목록만 조회.
- `LIMIT 3 OFFSET 0`→ offset paging으로 첫 번째 페이지 기준 3개의 콘텐츠만 나올 수 있게 표시

2. 리뷰 작성하는 쿼리 (* 사진의 경우는 일단 배제)

    ```jsx
   INSERT INTO review (member_id, store_id, score, body, created_at)
   VALUES ('사용자 id', '가게 id', 5, '음 너무 맛있어요 포인트도 얻고 맛있는 맛집도 알게 된 것 같아 너무나도 행복한 식사였답니다. 다음에 또 올께요!!', NOW());
    ```

3. **홈 화면 쿼리(현재 선택 된 지역에서 도전이 가능한 미션 목록, 페이징 포함)**

```jsx
SELECT 
    r.name AS region_name, // 현재 선택된 지역 이름 상단 표시
    m.id AS mission_id,
    s.name AS store_name,
    m.mission_spec,
    m.reward,
    DATEDIFF(m.deadline, NOW()) AS D_day
FROM mission AS m
JOIN store AS s ON m.store_id = s.id
JOIN region AS r ON s.region_id = r.id
WHERE r.id = {선택된 지역 ID}  // 현재 선택된 지역 필터링
ORDER BY m.deadline ASC  // 마감일 기준 정렬
LIMIT 10 OFFSET 0;  -- // Offset 페이징 적용

```

- mission, store, region 테이블 join
- DATEDIFF 연산을 사용해 D-day 구하여 표시
4**마이 페이지 화면 쿼리**
```jsx
SELECT
   m.name AS nickname,
   m.email,
   m.point
   CASE //인증과 미인증 표시하는 단계
   WHEN m.phone_number IS NULL THEN '미인증'
   ELSE '인증됨'
   END AS phone_status
   FROM member AS m
   WHERE m.id = {현재 로그인된 사용자 ID};