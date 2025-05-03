## Mission
### 1
~~~java
@Override
    public Page<Mission> findMissionsByMemberIdAndStatus(Long memberId, MissionStatus status, Pageable pageable) {
        // 메인 쿼리
        List<Mission> content = jpaQueryFactory
                .select(mission)
                .from(myMission)
                .join(myMission.mission, mission)
                .where(
                        myMission.member.id.eq(memberId),
                        status != null ? myMission.missionStatus.eq(status) : null
                )
                .offset(pageable.getOffset())
                .limit(pageable.getPageSize())
                .fetch();

        // 카운트 쿼리
        Long count = jpaQueryFactory
                .select(myMission.count())
                .from(myMission)
                .where(
                        myMission.member.id.eq(memberId),
                        status != null ? myMission.missionStatus.eq(status) : null
                )
                .fetchOne();

        return new PageImpl<>(content, pageable, count == null ? 0 : count);
    }
~~~
### 2
insert는 querydsl이 크게 의미 x
### 3
~~~java
@Override
    public HomeDto findHomeDtoByMemberId(Long memberId) {
        // 1. ACTIVE 상태의 MyRegion 조회
        Region activeRegion = jpaQueryFactory
                .select(region1)
                .from(myRegion)
                .join(myRegion.region, region1)
                .where(
                        myRegion.member.id.eq(memberId),
                        myRegion.regionStatus.eq(RegionStatus.ACTIVE)
                )
                .fetchFirst();

        if (activeRegion == null) {
            throw new IllegalStateException("활성화된 지역이 없습니다.");
        }

        // 2. member의 point 조회
        Integer point = jpaQueryFactory
                .select(member.point)
                .from(member)
                .where(member.id.eq(memberId))
                .fetchOne();
        if (point == null) point = 0;

        // 3. 아직 참여하지 않은 mission 조회
        List<ResponseMissionDto> responseMissionDtoList = jpaQueryFactory
                .select(Projections.constructor(ResponseMissionDto.class,
                        mission.id,
                        mission.content,
                        mission.point
                ))
                .from(mission)
                .join(mission.restaurant, restaurant)
                .where(
                        restaurant.region.eq(activeRegion),
                        mission.notIn(
                                JPAExpressions
                                        .select(myMission.mission)
                                        .from(myMission)
                                        .where(myMission.member.id.eq(memberId))
                        )
                )
                .fetch();

        return HomeDto.builder()
                .region(activeRegion.getRegion()) // region 이름 (String)
                .point(point)
                .responseMissionDtoList(responseMissionDtoList)
                .build();
    }
~~~
### 4
~~~java
@Override
    public Optional<ResponseMemberDto> findResponseMemberDtoById(Long memberId) {
        ResponseMemberDto dto = jpaQueryFactory
                .select(Projections.constructor(ResponseMemberDto.class,
                        member.name,
                        member.nickname,
                        member.email,
                        member.point.coalesce(0)
                ))
                .from(member)
                .where(member.id.eq(memberId))
                .fetchOne();

        return Optional.ofNullable(dto);
    }
~~~

### senior mission
[hannho velog](https://velog.io/@hann1233/UMC-8th-Senior-Mission-chapter.6)