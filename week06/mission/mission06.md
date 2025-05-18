# 6주차 미션

## Repository

### MissionRepository.java
- 미션 관련 기본 CRUD + QueryDSL 커스텀 기능 사용


### MissionRepositoryCustom.java
- QueryDSL 기반 커스텀 쿼리 메서드 정의 인터페이스


### MissionRepositoryImpl.java
- dynamicQueryWithBooleanBuilder(String name, String city)
  → name과 city를 기준으로 조건부 검색 (검색 필터 기능)
- findMissionsByUserAndStatus(...)
  → 특정 유저의 진행 상태별 미션 리스트 조회 (페이징 포함)
- findNewMissionsInRegion(...)
  → 선택된 지역에서 status가 new인 미션 리스트 페이징 조회 
- countCompletedMissionsInRegion(...)
  → 특정 유저가 지역에서 완료한 미션 수 
- countTotalMissionsInRegion(...)
  → 특정 지역의 전체 미션 수


### ReviewRepository.java
- 리뷰 저장 및 조회용 기본 JPA 레포지토리

### MissionRepositoryCustom + Impl 구조
- Spring Data JPA는 findBy 쿼리만 지원되고, 복잡한 조건, 페이징, 동적 조건 등은 QueryDSL로 직접 짜야 함
- BooleanBuilder, Enum 상태 필터링, 페이징 등 JPA로 힘든 로직을 처리
- 유지보수성과 확장성 확보

### [사진2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Desktop/%EC%82%AC%EC%A7%842.png)
- uid는 Integer, userId는 Long
- 타입 불일치로 인한 컴파일 에러 방지


## Service

### ReviewService.java
- 유저와 미션을 조회한 후, 리뷰 객체를 생성하고 저장
- 저장된 리뷰의 reviewId를 반환함


## Controller

### ReviewController.java
- 클라이언트가 전달한 userId, missionId, score, reviewText를 바탕으로 리뷰 작성 요청 처리
- ReviewService.writeReview() 호출하여 결과 반환

### ![사진1.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Desktop/%EC%82%AC%EC%A7%841.png)
- UserInfo.uid의 타입이 Integer이기에 Integer userId 사용
- Long을 사용하면 findById(userId)에서 타입 충돌 발생


## ![사진3.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Desktop/%EC%82%AC%EC%A7%843.png)
- Spring Boot는 GET요청만 브라우저에서 보냄
- /reviews는 POST만 허용하도록 설정하였으므로 405 에러 발생 -> 정상 작동