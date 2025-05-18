- **지연로딩과 즉시로딩의 차이**
    - **즉시 로딩(EAGER)**

      조회 요청이 들어오는 시점에 연관된 엔티티를 **즉시** DB에서 모두 함께 가져옵니다.

    - **지연 로딩(LAZY)**

      조회 시점에는 실제 엔티티 대신 **프록시 객체**를 반환하고,

      프록시의 데이터를 실제로 사용할 때(`.getXxx()` 호출 등) 비로소 DB에 쿼리를 보내 연관 엔티티를 **지연** 조회합니다.

- **Fetch Join**

  Fetch
  JPA가 부모(entity A)를 조회할 때, 자식(entity B)까지 언제 로딩할지 결정.

    - FetchType.EAGER (즉시 로딩)
    - **FetchType.LAZY (지연 로딩)**
    - 프록시

      프록시(Proxy)란 쉽게 말해 **실제 엔티티 객체를 대신하는 가짜 대리 객체**예요.

        - JPA 구현체(예: Hibernate)는 지연 로딩을 위해 실제 클래스(`Member`, `Order` 등)를 상속하거나 인터페이스를 구현한 **동적 생성 클래스**를 만들어 냅니다.
        - 이 프록시는 **초기에는 ID 값만 가지고** 있다가, 실제 필드에 접근(예: `member.getName()`)하는 순간에야 DB에서 데이터를 조회해서 진짜 `Member` 인스턴스로 초기화(“초기화(fetch)”)해 줍니다.

        ---

        1. **최초 조회 시점**
            - `em.find()` 나 `getReference()` 로 엔티티를 요청하면
            - JPA는 실제 객체(`Member`) 대신에 **프록시 객체**를 만들어 돌려줘요.
            - 이 프록시에는 “이 객체가 나중에 실제 데이터가 필요한 엔티티”라는 정보만 담겨 있어요.
        2. **실제 데이터가 필요할 때**
            - 코드에서 `proxy.getName()` 처럼 필드에 접근하면
            - 그제야 JDBC로 `SELECT … FROM member WHERE id = ?` 쿼리를 날리며
            - 실제 `Member` 데이터를 디비에서 꺼내와 프록시를 진짜 객체로 **초기화(fetch)** 해 줍니다.


    Fetch Join이란
    
    **JPA에서 연관된 엔티티를 즉시 로딩(EAGER fetch)**
    
    하기 위해 사용하는
    
    **JPQL 조인 방식**
    
    입니다.
    
    기본 조인은 SQL처럼 동작하지만,
    
    fetch Join은
    
    **연관된 엔티티를 한 번의 쿼리로 함께 조회하여 N+1 문제를 해결**

- **JPQL**

  `Repository`란?

  **자바 객체를 관계형 데이터 베이스에 영속적으로 저장하고 조회할 수 있는 ORM 기술에 대한 표준 명세인 JPA에서 제공하는 인터페이스 중 하나로, JPA를 사용하여 데이터베이스를 조작하기 위한 메서드들을 제공.**
  Spring Data JPA에서 **Repository 인터페이스**는 도메인 엔티티에 대한 **데이터 접근 계층(DAO)** 을 추상화해 주는 역할. 보통 `JpaRepository<T, ID>` 를 상속받아 선언만 해 두면 스프링이 런타임에 구현체를 만들어 주고, CRUD 메서드와 페이징·정렬 기능을 자동으로 제공.

    ```java
    // 예시: Member 엔티티에 대한 레포지토리
    public interface MemberRepository
            extends JpaRepository<Member, Long> {
        // → 기본 CRUD, 페이징, 정렬 기능이 전부 제공됨
    }
    
    ```

  여기서는 **repository 인터페이스**를 활용하는 방법을 설명해줌

  1.**메서드 이름으로 쿼리 생성 (Query Method)**

    - **어떻게 작동하나?**

      리포지토리 인터페이스에 메서드 이름을 `findBy`, `countBy`, `existsBy` 같은 키워드 + 엔티티 필드명으로 조합해서 선언만 하면, 스프링 데이터 JPA가 런타임에 자동으로 JPQL을 생성해서 실행해줌.

    - **예시**

        ```java
        java
        복사편집
        public interface MemberRepository extends JpaRepository<Member, Long> {
            // name 컬럼이 "Alice"인 Member를 찾아 리턴
            List<Member> findByName(String name);
        
            // status가 ACTIVE이고 age가 30 이상인 Member를 찾아 리턴
            List<Member> findByStatusAndAgeGreaterThan(MemberStatus status, int age);
        }
        
        ```

    - **장점**
        - **코드가 간결**: 선언만으로 CRUD · 단순 조건 조회 가능
        - **컴파일 시점에 문법 검사**: 메서드 시그니처에 오타나 잘못된 필드명이 있으면 컴파일 에러 발생
    - **단점**
        - **복잡한 조회 로직 한계**: 조인, 서브쿼리, 프로젝션 DTO, 그룹핑 등은 메서드 이름만으로 표현하기 어렵거나 불가능

    ---

  **2. @Query 어노테이션 (명시적 JPQL·Native)**

    - **어떻게 작동하나?**

      리포지토리 메서드 위에 `@Query("JPQL 문장")` 또는 `@Query(value="SQL", nativeQuery=true)` 를 달아서 직접 쿼리를 작성함.

    - **예시**

        ```java
        java
        복사편집
        public interface MemberRepository extends JpaRepository<Member, Long> {
            // JPQL: 엔티티(Member) 기준으로 직접 쿼리 작성
            @Query("SELECT m FROM Member m JOIN m.reviewList r WHERE r.score >= :minScore")
            List<Member> findActiveReviewers(@Param("minScore") double minScore);
        
            // 네이티브 SQL: 실제 테이블·컬럼명을 그대로 사용
            @Query(value = "SELECT * FROM member WHERE email LIKE %:domain%", nativeQuery = true)
            List<Member> findByEmailDomain(@Param("domain") String domain);
        }
        
        ```

    - **장점**
        - **무제한 표현력**: JPQL의 모든 기능(조인, 서브쿼리, DTO 프로젝션 등)과 네이티브 SQL까지 사용 가능
    - **단점**
        - **쿼리 문자열 관리 필요**: 길고 복잡한 JPQL은 가독성이 떨어짐
        - **컴파일 시점 검증 한계**: 문자열 안의 문법 오류는 런타임에야 발견

    ---

  | 구분 | 메서드 이름으로 쿼리 생성 | @Query 어노테이션 |
      | --- | --- | --- |
  | **복잡도** | 단순 조건 조회에 최적 | 복잡한 조인·집계·DTO 프로젝션 가능 |
  | **코드량** | 선언만으로 충분 | 직접 JPQL/SQL 문자열 작성 필요 |
  | **가독성** | 간결·직관적 | 문자열 길어지면 가독성↓ |
  | **타입 안전성** | 컴파일 시점 문법 검사 | 런타임 오류 가능성 있음 |
  | **유지보수** | 메서드 이름 주석, 시그니처로 파악 | 쿼리 주석·문서화 필요 |
    
  ---

  ### 언제 무엇을 선택할까?

    - **간단한 조회**(단일 필드 비교, `AND`·`OR` 조합 정도): **메서드 이름**
    - **복잡한 비즈니스 조회**(다중 조인, 그룹핑, DTO 반환 등): **@Query**

- **QueryDSL**

  JPA에서 **타입 안전(Type-safe)** 하게 쿼리를 작성할 수 있게 도와주는 라이브러리입니다.

  어떻게 동작하나?

    1. **Q 클래스 생성**
        - `Member` 엔티티가 있으면, 빌드 시점에 `QMember`라는 메타 모델 클래스가 `target/generated-sources` 등에 생성됩니다.
    2. **Fluent API로 쿼리 작성**
        - `JPAQueryFactory` 등을 통해, SQL 대신 자바 코드처럼 쿼리를 짭니다.

        ```java
        java
        복사편집
        // Q 타입 불러오기
        QMember m = QMember.member;
        
        // JPAQueryFactory 주입받기
        List<Member> activeAdmins = queryFactory
          .selectFrom(m)
          .where(
            m.status.eq(MemberStatus.ACTIVE),
            m.role.eq("ADMIN")
          )
          .orderBy(m.createdAt.desc())
          .fetch();
        
        ```

    3. **실행**
        - `fetch()`, `fetchOne()`, `fetchResults()` 등 메서드 호출로 실제 SQL이 날아갑니다.

  | 구분 | 메서드 이름 | `@Query` | QueryDSL |
      | --- | --- | --- | --- |
  | **표현력** | 단순 조회 | 복잡 조회 가능 | 복잡·동적 조회 최적 |
  | **타입 안전성** | 높음 | 낮음 (문자열) | 높음 |
  | **유지보수성** | 높음 | 보통 (쿼리 문자열) | 높음 |
  | **가독성** | 매우 간결 | 쿼리 길어지면 ↓ | 자바 코드 스타일 |
  | **동적 조건** | 한계 | `StringBuilder`로 직접 조합 | `if`문 + BooleanExpression 조합 |
- N+1 문제 해결

  ‘N+1 문제’에서 ‘N’과 ‘+1’은 **쿼리 수**를 나타냄. 연관된 리스트의 요소 개수(예: M)가 아니라, “몇 번의 쿼리가 실행되는지”가 관건.

    1. **‘+1’**:

       – 부모 엔티티를 한 번 조회하기 위한 **1번**의 쿼리

        ```sql
        sql
        복사편집
        SELECT * FROM member;
        
        ```

    2. **‘N’**:

       – 조회된 부모가 N개라면, **각각의 부모마다** 연관된 자식 리스트를 가져오기 위해 **N번**의 쿼리

        ```sql
        sql
        복사편집
        -- for member_id = 1
        SELECT * FROM member_prefer WHERE member_id = 1;
        -- for member_id = 2
        SELECT * FROM member_prefer WHERE member_id = 2;
        ...
        -- for member_id = N
        SELECT * FROM member_prefer WHERE member_id = N;
        
        ```


    각 쿼리는 해당 부모의 모든 자식을 한 번에 가져오기 때문에,
    
    - 자식이 M개라고 해도 **쿼리 수는 한 번**으로 처리됨.
    - 그래서 전체 쿼리 수 = 1 (부모 조회) + N (각 부모당 1번씩) = **N+1**
    
    만약 자식 한 건당 또 쿼리를 낸다면 그제야 N×M 쿼리가 되겠지만, JPA의 기본 방식은 “부모당 한 번”이기 때문에 **N+1**이라 부르는 것.
    
    해결법
    
    | 방법 | 설명 | 장단점 |
    | --- | --- | --- |
    | 1. Fetch Join | JPQL에서 `JOIN FETCH` 키워드를 써서 연관 엔티티를 한 번의 쿼리로 미리 로딩 | + 즉시 전체 조회, N+1 문제 없음– 페이징과 함께 쓰기 어렵다 |
    | 2. @EntityGraph | 리포지토리 메서드에 `@EntityGraph(attributePaths = "...")` 를 붙여서 연관관계 로딩 제어 | + 코드 가독성 높음, 설정만으로 적용 가능– 너무 많은 필드 지정 시 부하 가능 |
    | 3. Batch Size 설정 | `@BatchSize(size = n)` 혹은 `spring.jpa.properties.hibernate.default_batch_fetch_size`로 설정 | + 지연 로딩이지만 한 번에 N개 묶어서 가져옴– 영속성 컨텍스트가 커질 수 있음 |
    | 4. QueryDSL FetchJoin | QueryDSL `.join(entity).fetchJoin()` 을 써서 한 번에 페치 조인 | + 타입 안전, 컴파일 시점 오류 탐지 가능– 설정이 살짝 복잡함 |
    | 5. Subselect Fetch | `@OneToMany(fetch = LAZY) @Fetch(FetchMode.SUBSELECT)` Hibernate 전용 서브셀렉트 방식 사용 | + 두 번째 쿼리 하나에 N개 모두 조회– Hibernate 전용, 이식성 ↓ |