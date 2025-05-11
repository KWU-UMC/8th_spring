# 🔥 미션
- **미션 기록**
    1. 내가 진행중, 진행 완료한 미션 모아서 보는 쿼리(페이징 포함)

  ### MemberMissionDto

    ```java
    @Getter
    @AllArgsConstructor
    public class MemberMissionDto {
        private Long memberMissionId;
        private int reward;
        private String storeName;
        private String missionSpec;
        private MemberMissionStatus status;
    }
    
    ```

  ### QueryDSL 쿼리 작성

    ```java
    public List<MemberMissionDto> findOngoingOrCompletedMissions(Long memberId, int page, int size) {
        QMemberMission mm = QMemberMission.memberMission;
        QMission m = QMission.mission;
        QStore s = QStore.store;
    
        return queryFactory
            .select(Projections.constructor(
                MemberMissionDto.class,
                mm.id,
                m.reward,
                s.name,
                m.missionSpec,
                mm.status
            ))
            .from(mm)
            .join(mm.mission, m)
            .join(m.store, s)
            .where(
                mm.member.id.eq(memberId),
                mm.status.in(MemberMissionStatus.진행중, MemberMissionStatus.성공)
            )
            .offset(page * size)
            .limit(size)
            .fetch();
    }
    
    ```

  2. 리뷰 작성하는 쿼리, * 사진의 경우는 일단 배제

        ```java
        public void saveReview(Long memberId, Long storeId, int score, String body) {
            Member member = em.getReference(Member.class, memberId);
            Store store = em.getReference(Store.class, storeId);
        
            Review review = Review.builder()
                    .member(member)
                    .store(store)
                    .score(score)
                    .body(body)
                    .createdAt(LocalDateTime.now())
                    .build();
        
            reviewRepository.save(review);
        }
        ```

  3. 홈 화면 쿼리(현재 선택 된 지역에서 도전이 가능한 미션 목록, 페이징 포함)

       **QueryDSL 변환 코드**

        ```java
        public List<HomeMissionDto> findMissionsByRegion(Long regionId, int page, int size) {
            QMission m = QMission.mission;
            QStore s = QStore.store;
            QRegion r = QRegion.region;
        
            return queryFactory
                .select(Projections.constructor(
                    HomeMissionDto.class,
                    r.name,
                    m.id,
                    s.name,
                    m.missionSpec,
                    m.reward,
                    Expressions.numberTemplate(
                        Long.class,
                        "DATEDIFF({0}, {1})", 
                        m.deadline, 
                        Expressions.currentTimestamp()
                    )
                ))
                .from(m)
                .join(m.store, s)
                .join(s.region, r)
                .where(r.id.eq(regionId))
                .orderBy(m.deadline.asc())
                .offset(page * size)
                .limit(size)
                .fetch();
        }
        
        ```

       HomeMissionDto

        ```java
        public class HomeMissionDto {
            private String regionName;
            private Long missionId;
            private String storeName;
            private String missionSpec;
            private Integer reward;
            private Long dDay;
        
            public HomeMissionDto(String regionName, Long missionId, String storeName,
                                  String missionSpec, Integer reward, Long dDay) {
                this.regionName = regionName;
                this.missionId = missionId;
                this.storeName = storeName;
                this.missionSpec = missionSpec;
                this.reward = reward;
                this.dDay = dDay;
            }
        }
        
        ```

  4. 마이 페이지 화면 쿼리

       QueryDSL 쿼리 – 마이페이지 정보 조회

        ```java
        public MyPageDto findMyPageInfo(Long memberId) {
            QMember m = QMember.member;
        
            return queryFactory
                .select(Projections.constructor(
                    MyPageDto.class,
                    m.name,
                    m.email,
                    m.point,
                    Expressions.stringTemplate(
                        "CASE WHEN {0} IS NULL THEN '미인증' ELSE '인증됨' END",
                        m.phoneNumber
                    )
                ))
                .from(m)
                .where(m.id.eq(memberId))
                .fetchOne();
        }
        
        ```

       MyPageDto

        ```java
        public class MyPageDto {
            private String nickname;
            private String email;
            private Integer point;
            private String phoneStatus;
        
            public MyPageDto(String nickname, String email, Integer point, String phoneStatus) {
                this.nickname = nickname;
                this.email = email;
                this.point = point;
                this.phoneStatus = phoneStatus;
            }
        }
        
        ```
    