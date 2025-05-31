- Spring Data JPA의 Paging

  Spring Data JPA에서는 **대량의 데이터를 페이징 처리**하여 효율적으로 클라이언트에 제공할 수 있도록 지원합니다. 이때 사용되는 주요 인터페이스는 `Page`, `Slice`, `Pageable`입니다.

  ### Pageable

    - 페이지 번호, 사이즈, 정렬 정보를 담는 인터페이스
    - 컨트롤러에서 파라미터로 받아 사용 가능

    ```java
    
    @GetMapping("/members")
    public Page<Member> getMembers(Pageable pageable)
    
    ```

  예: `/members?page=0&size=10&sort=name,asc`

    - Page

      ### Page<T>

        - **총 개수(count 쿼리 포함)** 와 **전체 페이지 정보**를 반환
        - 일반적인 **페이징 UI**에 적합

        ```java
        
        Page<Member> page = memberRepository.findAll(pageable);
        page.getTotalElements(); // 전체 개수
        page.getTotalPages();    // 전체 페이지 수
        page.getContent();       // 실제 데이터
        
        ```

    - Slice

      ### Slice<T>

        - 다음 페이지가 있는지만 판단하고 **전체 개수는 반환하지 않음**
        - 무한 스크롤(더보기 버튼 등)에 최적화

            ```java
            
            Slice<Member> slice = memberRepository.findAllByAge(age, pageable);
            slice.hasNext(); // 다음 페이지 존재 여부
            
            ```


        ### 차이 비교
        
        | 항목 | `Page` | `Slice` |
        | --- | --- | --- |
        | 전체 개수 반환 | o (count 쿼리 실행) | x(count 쿼리 없음) |
        | 다음 페이지 여부 | o | o |
        | 성능 | 느릴 수 있음 | 더 빠름 |
        | 적합한 사용 예 | 페이지네이션 UI | 무한스크롤 등 |
- 객체 그래프 탐색

  ## 객체 그래프 탐색 (Object Graph Navigation)

  ### 정의

    - 연관된 엔티티를 **객체 형태로 탐색**하는 것
    - 예: `member.getReviews().get(0).getStore().getName()`

    ---

  ### 문제점

    1. **지연 로딩(LAZY)** 으로 인해 N+1 문제 발생 가능
        - 각 연관 엔티티를 조회할 때마다 쿼리가 발생
    2. **즉시 로딩(EAGER)** 은 불필요한 조인으로 성능 저하 가능성 있음

    ---

  ### 해결 방법

  | 방법 | 설명 |
      | --- | --- |
  | `fetch join` | JPQL에서 join fetch로 연관 객체 함께 로딩 |
  | `@EntityGraph` | Repository에서 연관 객체를 미리 로딩하도록 설정 |
  | DTO 프로젝션 | 필요한 데이터만 추출해 DTO로 변환 |

  ### fetch join 예시

    ```java
    @Query("SELECT m FROM Member m JOIN FETCH m.reviews r WHERE r.score > 4")
    List<Member> findMembersWithReviews();
    
    ```

  ### DTO 변환 예시