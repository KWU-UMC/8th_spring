### 1. 내가 진행 중, 진행 완료한 미션을 모아서 보는 쿼리 (페이징 포함)

```sql
SELECT ms.reward, mm.status, s.name, ms.mission_spec
FROM member_mission AS mm
LEFT JOIN mission AS ms ON mm.mission_id = ms.id
LEFT JOIN member AS mb ON mm.member_id = mb.id
LEFT JOIN store AS s ON ms.store_id = s.id
WHERE mb.id = (value)
  AND mm.id < (last_cursor_id)
ORDER BY mm.id DESC
LIMIT 10;
```

**QueryDSL**

```sql
List<Tuple> result = queryFactory
    .select(ms.reward, mm.status, s.name, ms.missionSpec)
    .from(mm)
    .leftJoin(ms).on(mm.mission.id.eq(ms.id))
    .leftJoin(mb).on(mm.member.id.eq(mb.id))
    .leftJoin(s).on(ms.store.id.eq(s.id))
    .where(
        mb.id.eq(value),
        mm.id.lt(lastCursorId)
    )
    .orderBy(mm.id.desc())
    .limit(10)
    .fetch();
```

### 2. 리뷰를 작성하는 쿼리 (사진 배제)

```sql
INSERT INTO review (member_id, store_id, created_at, body, score)
VALUES (?, ?, ?, ?)
(= VALUES (11, 15, ‘광운대 맛집 이층집’, 5) )
```

**QueryDSL**

QueryDSL은 JPQL 기반이기 때문에 INSERT를 지원하지 않는다고 한다.

그래서 JPA를 통해서 엔티티를 저장하는 방법을 사용해야한다고 한다.

```sql
Review review = Review.builder()
    .member(member)           
    .store(store)             
    .createdAt(LocalDateTime.now())
    .body("광운대 맛집 이층집")
    .score(5)
    .build();

reviewRepository.save(review);
```

### 3. 홈 화면 쿼리 (현재 선택된 지역에서 도전이 가능한 미션 목록, 페이징 포함)

```sql
SELECT r.name, ms.status, s.name, s.address, ms.reward
FROM member_mission AS mm
LEFT JOIN mission AS ms ON mm.mission_id = ms.id
LEFT JOIN store AS s ON ms.store_id = s.id
LEFT JOIN region AS r ON s.region_id = r.id
WHERE mm.member_id = (value)
  AND mm.status = '진행 중'
  AND mm.id < (last_cursor_id)
ORDER BY mm.id DESC
LIMIT 10;
```

**QueryDSL**

```sql
QMemberMission mm = QMemberMission.memberMission;
QMission ms = QMission.mission;
QStore s = QStore.store;
QRegion r = QRegion.region;

List<Tuple> results = queryFactory
    .select(r.name, mm.status, s.name, s.address, ms.reward)
    .from(mm)
    .leftJoin(ms).on(mm.mission.id.eq(ms.id))
    .leftJoin(s).on(ms.store.id.eq(s.id))
    .leftJoin(r).on(s.region.id.eq(r.id))
    .where(
        mm.member.id.eq(memberId),
        mm.status.eq(MissionStatus.진행중)
        mm.id.lt(lastCursorId)
    )
    .orderBy(mm.id.desc())
    .limit(10)
    .fetch();
```

### 4. 마이 페이지 화면 쿼리

```sql
SELECT name, email, phone, point
FROM member
WHERE id = (value)
```

**QueryDSL**

```sql
QMember m = QMember.member;

Member result = queryFactory
    .selectFrom(m)
    .where(m.id.eq(memberId))
    .fetchOne();
```