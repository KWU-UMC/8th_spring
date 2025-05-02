# ✔️ Domain
### 💡 정의

---
- 애플리케이션이 다루는 비즈니스 로직 자체 혹은 이를 코드로 표현한 도메인 모델
- 보통 `domain` 패키지에 `@Entity`, `VO`, `Enum` 등을 두며, 데이터와 메서드를 함께 포함한다.

### ✅ 속성

---
- 핵심 비즈니스 로직 담당
- 변경 가능성이 낮음
- `Service`, `Controller`와 구분되어야 함 (계층 분리 원칙)

### ✅ 장점

---
- 비즈니스 로직 중심 설계 가능
- 코드 가독성과 유지보수성 향

# ✔️ 양방향 매핑

### 💡 정의

---
- JPA에서 두 엔티티가 서로 참조하는 관계

  예: `Member → Review` (OneToMany),  `Review -> Member` (ManyToOne)
- 
### ✅ 장점 

---
- 객체 그래프 탐색이 유연해짐 (review.getMember() 또는 member.getReviewList() 모두 가능)
- 조회 최적화 및 API 응답 구성에 유리

### ❗ 주의사항

---    
  - 무한 순환 참조 주의 (ex: JSON 직렬화 시)

# ✔️ N + 1 문제
### 💡 정의

---
- JPA에서 1개의 쿼리로 N개의 데이터를 가져온 후, N개의 추가 쿼리가 발생하는 현상
- 특히 `@OneToMany`, `@ManyToOne` 관계에서 **LAZY 로딩**일 때 자주 발생

### ✅ 예시 (문제 상황)

---
  ```java
  List<Member> members = memberRepository.findAll(); // 1개의 쿼리
    
  for (Member m : members) {
      System.out.println(m.getReviewList()); // N개의 쿼리 추가 발생!
  }
  ```

### ✅ 해결 방법

---
  1. `@EntityGraph` 사용 → 연관된 엔티티 즉시 로딩
  2. `fetch join` 사용 → JPQL에서 join fetch
  3. `batch-size` 설정 → in 절로 일괄 로딩