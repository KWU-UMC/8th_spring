## 1. **미션 기록 조회 쿼리**

> 사용자 ID 7번이 도전 중이거나 완료한 미션들 조회 (페이징 포함)
>

```sql
SELECT *
FROM mission AS m
JOIN user_mission AS um ON m.id = um.mission_id
WHERE um.user_id = 7
  AND (um.status = '진행중' OR um.status = '진행완료')
ORDER BY um.created_at DESC, m.id DESC
LIMIT 15 OFFSET 0;

```

---

## 2. **리뷰 작성 쿼리**

> 유저 이름을 기준으로 user_id 조회 후, 해당 유저가 가게 ID 1번에 리뷰 작성
>

```sql
INSERT INTO review (user_id, store_id, score, description)
VALUES (
  (SELECT id FROM user WHERE name = '닉네임1234'), -- 유저 이름 → ID 조회
  1,                                              -- 가게 ID
  '5',                                            -- 별점
  '음 너무 맛있어요 포인트도 얻고 맛있는 맛집도 알게 된 것 같아 너무나도 행복한 식사였답니다. 다음에 또 올게요!!'
);

```

---

## 3. **홈 화면 쿼리**

> 현재 선택된 지역(region_id=1)에서 아직 도전하지 않은 미션 목록 조회 (페이징 포함)
>

```sql
SELECT m.*, s.store_name
FROM mission AS m
JOIN store AS s ON m.store_id = s.id
LEFT JOIN user_mission AS um
  ON m.id = um.mission_id AND um.user_id = 7
WHERE s.region_id = 1
  AND um.user_id IS NULL -- 도전한 적 없는 미션만
ORDER BY m.id DESC
LIMIT 15 OFFSET 0;

```

---

## 4. **마이페이지 정보 조회 쿼리**

> 사용자의 닉네임, 이메일, 포인트 조회

```sql
SELECT name, email, point
FROM user
WHERE id = 7;
```
 