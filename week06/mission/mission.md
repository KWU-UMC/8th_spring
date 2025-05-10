# 💪 미션 기록

1. 내가 진행 중, 진행 완료한 미션  모아서 보는 쿼리(페이징 포함)

```sql
select m.required_price, m.point, s.name 
from mission m 
join mission_member mm on m.id = mm.mission_id
join store s on m.store_id = s.id
where mm.member_id = 1
  and mm.state = 'active' 
  and (
    mm.created_at > {last_created_at}
    or (mm.created_at = {last_created_at} and mm.id > {last_mm_id})
  )
order by mm.created_at asc, mm.id asc
limit 10;
```

  QueryDSL 사용

```java
private final JPAQueryFactory queryFactory;
private final QMission m = QMission.mission;
private final QMissionMember mm = QMissionMember.missionMember;
private final QStore s = QStore.store;

public List<StatusMissionDTO> fetchMissionByStatus(Long memberId, String status,
                                                LocalDateTime lastCreatedAt, Long lastMemberId) {

    return queryFactory
            .select(new QStatusMissionDTO(
                    m.requiredPrice,
                    m.point,
                    s.name))
            .from(m)
            .join(mm).on(m.id.eq(mm.mission.id))
            .join(s).on(m.store.id.eq(s.id))
            .where(
                    mm.member.id.eq(memberId)
                    .and(mm.state.eq(status))
                    .and(
                        mm.createdAt.gt(lastCreatedAt)
                        .or(
                            mm.createdAt.eq(lastCreatedAt)
                            .and(mm.id.gt(lastMemberId))
                        )
                    )
            )
            .orderBy(mm.createdAt.asc(), mm.id.asc())
            .limit(10)
            .fetch();
}
```
---

2. 리뷰 조회 쿼리

```sql
select m.nickname, r.content, r.rating, r.created_at
join member m on m.id = r.member_id
where r.store_id = 1;
```

  QueryDSL 사용

```java
private final JPAQueryFactory queryFactory;
private final QMember m = QMember.member;
private final QReview r = QReview.review;

public List<ReviewDTO> fetchReview(Long storeId) {
    return queryFactory
        .select(new QReviewDTO(
                m.nickname,
                r.content,
                r.rating,
                r.createdAt))
        .from(r)
        .join(m).on(m.id.eq(r.member.id))
        .where(r.store.id.eq(storeId))
        .fetch();
}
```

---

3. 홈 화면 쿼리(현재 선택된 지역에서 도전이 가능한 미션 목록, 페이징 포함)

```sql
select s.name, s.category, ms.required_price, ms.point
from member mb
join mission_member mm on mm.member_id = mb.id
join mission ms on ms.id = mm.mission_id
join store s on s.id = ms.store_id
where mb.id = 1
  and mm.status = 'ready'
  and s.location = '선택 지역'
  and (
    ms.start_at > {last_start_at}
    or (ms.start_at = {last_start_at} and ms.id > {last_mission_id})
  )
order by ms.start_at asc, ms.id asc
limit 10;
```

QueryDSL 사용

```java 
private final JPAQueryFactory queryFactory;
private final QMember mb = QMember.member;
private final QMissionMember mm = QMissionMember.missionMember;
private final QMission ms = QMission.mission;
private final QStore s = QStore.store;

public List<LocationMissionDTO> fetchMissionByLocation(Long memberId, String location,
                                                                        LocalDateTime lastStartAt, Long lastMissionId){
        return queryFactory
             .select(new QLocationMissionDto(
            s.name,
            s.category,
            ms.requiredPrice,
            ms.point
        ))
        .from(mb)
        .join(mm).on(mb.id.eq(mm.member.id))
        .join(ms).on(ms.id.eq(mm.mission.id))
        .join(s).on(s.id.eq(ms.store.id))
        .where(
                mb.id.eq(memberId)
                .and(mm.status.eq('ready'))
                .and(s.location.eq(location))
                .and(
                ms.startAt.gt(lastStartAt)
                .or(
                    ms.startAt.eq(lastStartAt)
                    .and(ms.id.gt(lastMissionId))
                        )
                    )
                )
                .orderBy(ms.startAt.asc(), ms.id.asc())
                .limit(10)
                .fetch();
}
```

---

4. 마이 페이지 화면 쿼리

```sql
select nickname, email, phone_number, phone_verifed, point
from member
where id = 1; -- 해당 멤버의 id를 1이라 가정
```

QueryDSL 사용

```java
private final JPAQueryFactory queryFactory;
private final QMember m = QMember.member;

public MemberDTO fetchMyPage(Long memberId){
        return queryFactory
                .select(new QMemberDTO(
                        m.nickname,
                        m.email,
                        m.phoneNumber,
                        m.phoneVerified,
                        m.point))
                .from(m)
                .where(
                        m.id.eq(memberId))
                    )
                .fetchOne();
}
```