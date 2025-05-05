## 1. 사용자의 미션 ‘진행 중’과 ‘완료’ 상태를 가져오는 쿼리

- 커스텀 인터페이스 생성

```java
public interface MemberMissionRepositoryCustom {
    Page<MemberMission> findMissions(Long memberId, Pageable pageable);
}

```

---

- 구현 클래스

```java

@Repository
@RequiredArgsConstructor
public class MemberMissionRepositoryImpl implements MemberMissionRepositoryCustom {

    private final JPAQueryFactory queryFactory;
    QMemberMission memberMission = QMemberMission.memberMission;
    QMember member = QMember.member;

    @Override
    public Page<MemberMission> findMissionsByMemberIdAndStatusIn(Long memberId, Pageable pageable) {
        List<MemberMission> content = queryFactory
            .selectFrom(memberMission)
            .join(memberMission.member, member).fetchJoin()
            .where(
                member.id.eq(memberId),
                memberMission.status.in(MemberMissionStatus.challanging, MemberMissionStatus.complete)
            )
            .offset(pageable.getOffset())
            .limit(pageable.getPageSize())
            .fetch();

        Long count = queryFactory
            .select(memberMission.count())
            .from(memberMission)
            .where(
                member.id.eq(memberId),
                memberMission.status.in(MemberMissionStatus.IN_PROGRESS, MemberMissionStatus.COMPLETED)
            )
            .fetchOne();

        return new PageImpl<>(content, pageable, count);
    }
}

```

---

- `MemberMissionRepository`에서 상속

```java
public interface MemberMissionRepository extends JpaRepository<MemberMission, Long>, MemberMissionRepositoryCustom {
}

```

---

## 2. 리뷰 작성 쿼리

- ReviewRepositoryCustom (인터페이스)

```java

public interface ReviewRepository {
    Page<Review> findReviewsByStoreId(Long storeId, Pageable pageable);
}

```

---

- ReviewRepositoryImpl (구현체)

```java

@Repository
@RequiredArgsConstructor
public class ReviewRepositoryImpl implements ReviewRepositoryCustom {

    private final JPAQueryFactory queryFactory;
    QReview review = QReview.review;

    @Override
    public Page<Review> findReviewsByStoreId(Long storeId, Pageable pageable) {
        List<Review> content = queryFactory
                .selectFrom(review)
                .where(storeIdEq(storeId))
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        Long count = queryFactory
                .select(review.count())
                .from(review)
                .where(storeIdEq(storeId))
                .fetchOne();

        return new PageImpl<>(content, pageable, count);
    }

    private BooleanExpression storeIdEq(Long storeId) {
        return storeId != null ? review.store.id.eq(storeId) : null;
    }
}

```

---

- 3. ReviewRepository

```java

public interface ReviewRepository extends JpaRepository<Review, Long>, ReviewRepositoryCustom {
}

```

---



## 3. 홈화면 – 선택 지역의 도전 가능한 미션 목록 + 페이징

- 커스텀 인터페이스 생성

```java

public interface MissionRepositoryCustom {
    Page<Mission> findAvailableMissionsByRegion(String regionName, Pageable pageable);
}

```

---

- `MissionRepositoryImpl`(구현체)

```java
@Repository
@RequiredArgsConstructor
public class MissionRepositoryImpl implements MissionRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    QMission mission = QMission.mission;
    QRegion region = QRegion.region;

    @Override
    public Page<Mission> findAvailableMissionsByRegion(String regionname, Pageable pageable) {
        BooleanBuilder predicate = new BooleanBuilder();

        if (regionname != null) {
            predicate.and(mission.region.name.eq(regionname));
        }

        
        List<Mission> content = queryFactory
                .selectFrom(mission)
                .join(mission.region, region).fetchJoin()
                .where(predicate)
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        Long count = queryFactory
                .select(mission.count())
                .from(mission)
                .where(predicate)
                .fetchOne();

        return new PageImpl<>(content, pageable, count);
    }
}

```

---

- `MissionRepository`

```java

public interface MissionRepository extends JpaRepository<Mission, Long>, MissionRepositoryCustom {
}

```

---

##  4. 마이페이지

- `MemberRepositoryCustom.java`

```java
public interface MemberRepositoryCustom {
    Member findMemberInfoForMyPage(Long memberId);
}

```

---

- `MemberRepositoryImpl.java`

```java
@Service
@RequiredArgsConstructor
public class MemberRepositoryImpl implements MemberRepositoryCustom {

    private final JPAQueryFactory queryFactory;
    private final QMember member = QMember.member;

    @Override
    public Member findMemberInfoForMyPage(Long memberId) {
        return queryFactory
                .selectFrom(member)
                .where(member.id.eq(memberId))
                .fetchOne();
    }
}

```

---

###   기존 `MemberRepository` 수정

```java

public interface MemberRepository extends JpaRepository<Member, Long>, MemberRepositoryCustom {
}

```

---

