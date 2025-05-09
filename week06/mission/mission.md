# 미션
## 1번
```java
 @Override
    public List<MissionHistoryResponseDto> findMissionsByMemberIdAndStatus(Long memberId, MissionStatus status) {
        return jpaQueryFactory
                .select(Projections.constructor(
                        MissionHistoryResponseDto.class,
                        store.name,
                        mission.missionDescription,
                        mission.reward
                ))
                .from(memberMission)
                .join(memberMission.mission, mission)
                .join(mission.store, store)
                .where(
                        memberMission.member.id.eq(memberId),
                        memberMission.status.eq(status)
                )
                .fetch();
    }
```

## 2번
QueryDSL은 주로 조회(SELECT)에 특화되어 있어 INSERT 작업은 QueryDSL을 적용하지 않았습니다.

## 3번
```java
@Override
    public HomeReponseDto findHomedataByMemberId(Member member) {
        // memberId의 지역, 포인트 조회
        String regionName = member.getSpecAddress();
        Integer point = member.getPoint();

        // 완료한 미션 수
        Long completed = jpaQueryFactory
                .select(memberMission.count())
                .from(memberMission)
                .where(
                        memberMission.member.id.eq(member.getId()),
                        memberMission.status.eq(MissionStatus.COMPLETE)
                )
                .fetchOne();

        // 2. 진행중/진행완료된 미션id 필터링
        List<Long> participatedMissionIds = jpaQueryFactory
                .select(memberMission.mission.id)
                .from(memberMission)
                .where(memberMission.member.id.eq(member.getId()))
                .fetch();

        // 3. My Mission
        List<MyMissionResponseDto> missions = jpaQueryFactory
                .select(Projections.constructor(
                        MyMissionResponseDto.class,
                        store.name,
                        store.category,
                        mission.missionDescription,
                        mission.reward,
                        mission.deadline
                ))
                .from(mission)
                .join(mission.store, store)
                .join(store.region, region)
                .where(
                        region.name.eq(regionName),
                        mission.id.notIn(participatedMissionIds.isEmpty() ? List.of(-1L) : participatedMissionIds)
                )
                .fetch();

        return new HomeReponseDto(
                regionName,
                point,
                completed,
                missions
        );
    }
```

## 4번
```java
@Override
    public MemberInfoResponseDto findMemberInfoById(Long memberId) {
        return jpaQueryFactory
                .select(Projections.constructor(
                        MemberInfoDto.class,
                        member.name,
                        member.email,
                        member.phoneNumber,
                        member.point
                ))
                .from(member)
                .where(member.id.eq(memberId))
                .fetchOne();
    }
```

# 시니어 미션
[QueryDSL 기반 JPA 성능 최적화 전략](https://velog.io/@sunnin/UMC-QueryDSL-기반-JPA-성능-최적화-전략)