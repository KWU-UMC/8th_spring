# Spring Data JPA의 Paging

  Spring Data JPA의 Paging 기능은 `Pageable` 인터페이스를 통해 요청 정보를 전달받는다.

```java
Pageable pageable = PageRequest.of(page, size, Sort.by("createdAt").descending());
```

- `page`: 0부터 시작
- `size`: 페이지당 요소 수
- `sort`: 정렬 기준
    ## Page

    ### 📌 정의

    ```java
    public interface Page<T> extends Slice<T> {
        int getTotalPages();
        long getTotalElements();
        ...
    }
    ```

  ### ✅ 특징

    - 전체 데이터 개수(`totalElements`)를 알기 위해 count 쿼리를 별도로 실행
    - 정확한 페이지 수 계산 가능
    - 전체 페이지 넘버를 표시할 수 있음

  ### ✅ 예시

    ```java
    Page<Mission> page = missionRepository.findByState(MissionState.READY, pageable);
    List<Mission> missions = page.getContent();
    long total = page.getTotalElements();
    int totalPages = page.getTotalPages();
    ```

  ### ⚠ 단점

    - count 쿼리 성능 비용 발생 (대량 데이터에서는 느림)
  ## Slice

  ### 📌 정의

    ```java
    public interface Slice<T> {
        List<T> getContent();
        boolean hasNext();
        boolean isFirst();
        ...
    }
    ```

    ### ✅ 특징

    - count 쿼리 없이, (size + 1)개의 row만 가져와서 다음 페이지 여부만 판단
    - 더 빠름, 특히 무한 스크롤/모바일에서 유용
    - 전체 페이지 수/총 개수는 알 수 없음

    ### ✅ 예시

    ```java
    Slice<Mission> slice = missionRepository.findByState(MissionState.READY, pageable);
    List<Mission> missions = slice.getContent();
    boolean hasNext = slice.hasNext();
    ```

    ### ⚠ 단점

    - 전체 페이지 번호 표시 불가능
  # 객체 그래프 탐색

  ## ✅ 1. 정의

  >   객체 그래프(Object Graph): 엔티티(Entity) 객체들이 연관관계를 통해 연결된 구조
  >
  >
  >   탐색(Navigation): 연관된 객체로부터 다른 객체를 '점(.) 연산자'를 통해 따라가는 것
  >

    ```java
    Review review = reviewRepository.findById(1L).get();
    String nickname = review.getMember().getNickname();
    ```

    - 위 예제에서 `review → member → nickname` 으로 객체 그래프를 따라 탐색한다.
    - 이는 JPA가 내부적으로 객체 간 연관 관계를 따라가며 필요한 데이터를 조회하거나 프록시 객체를 생성하는 방식이다.

  ## ✅ 2. 주요 개념과 연관성

  ### 🔹 a. 연관관계 매핑 (@OneToMany, @ManyToOne 등)

  객체 그래프 탐색은 연관관계가 있어야 가능하다.

    ```java
    @Entity
    class Review {
        @ManyToOne(fetch = FetchType.LAZY)
        private Member member;
    }
    ```
    
  ---

  ### 🔹 b. Fetch 전략과 영향

  | 전략 | 설명 |
      | --- | --- |
  | `EAGER` | 연관된 객체를 즉시 함께 로딩 (객체 그래프 탐색 시 바로 접근 가능) |
  | `LAZY` | 연관된 객체는 접근할 때 프록시를 통해 조회 (객체 탐색 시 SQL 추가 발생 가능) |

  **예)** LAZY일 때:

    ```java
    review.getMember(); // 이 시점에서 추가 쿼리 발생 (N+1 가능성 있음)
    ```
    
  ---

  ### 🔹 c. N+1 문제

    - `List<review> reviews = reviewRepository.findAll();` 이후

      각 `review.getMember()`에 대해 개별 쿼리가 발생하면 → N+1 문제

    - 이는 객체 그래프 탐색이 지연로딩 상태에서 반복될 때 흔히 발생

    ---

  ## ✅ 3. JPQL 경로 탐색 (Path Expression)

  JPQL에서 객체 그래프 탐색은 아래와 같은 방식으로 쓰인다:

    ```java
    SELECT r.member.nickname FROM Review r
    ```

    - `r → member → nickname`: JPQL 내에서 객체 그래프 탐색
    - 일반적인 SQL은 조인을 직접 쓰지만, JPQL은 객체 기반 탐색을 활용

    ---

  ## ✅ 4. DTO 변환에서의 객체 그래프 탐색

    ```java
    Review review = reviewRepository.findById(1L).get();
    ReviewDTO reviewDTO = ReviewDTO.builder()
        .reviewId(review.getId())
        .memberNickname(review.getMember().getNickname())  // 객체 그래프 탐색
        .build();
    ```

    - 이처럼 DTO 변환 시에도 객체 그래프 탐색이 자주 활용됨

    ---

  ## ✅ 5. 성능 최적화와 연관 키워드

  | 키워드 | 설명 |
      | --- | --- |
  | **Fetch Join** | 객체 그래프 탐색 시, `join fetch`를 통해 성능 향상 |
  | **Entity Graph** | 어노테이션으로 탐색 범위를 명시 |
  | **DTO Projection** | 필요한 필드만 조회하여 탐색 없이 처리 |
  | **Batch Size** | LAZY 로딩 시 in-query로 묶어 탐색 성능 향상 |