# ✅ 지연로딩과 즉시로딩의 차이
### 1. 정의

---

- 즉시 로딩(Eager Loading): 엔티티를 조회할 때 연관된 모든 엔티티도 함께 한 번에 데이터베이스에서 조회하는 방식
- 지연 로딩(Lazy Loading): 주 엔티티만 먼저 조회하고, 연관된 엔티티는 실제로 해당 데이터가 필요할 때(접근 시점에) 별도의 쿼리로 조회하는 방식
### 2. 장단점

---

  **즉시 로딩**

- 장점: 필요한 데이터를 한 번에 모두 가져와 추가 쿼리 없이 사용할 수 있음
- 단점: 불필요한 데이터까지 미리 조회되어 메모리 사용량 증가, 조인으로 인한 복잡한 쿼리 생성 및 성능 저하 가능


  **지연 로딩**

- 장점: 실제 필요한 데이터만 로딩해 메모리 사용량과 초기 쿼리 부하를 줄일 수 있음
- 단점: 연관 객체 접근 시마다 추가 쿼리가 발생할 수 있어, 데이터 접근 패턴에 따라 성능 저하 가능성 있음

### 3. 선택 기준

---

- 연관 엔티티를 자주 함께 사용한다면 즉시 로딩이 유리할 수 있음
- 연관 엔티티를 가끔 사용하거나 데이터 크기가 크다면 지연 로딩이 성능 및 메모리 측면에서 더 적합함

### 4. 주요 차이점

---

  | **구분** | **즉시 로딩 (Eager)** | **지연 로딩 (Lazy)** |
    | --- | --- | --- |
  | 데이터 조회 시점 | 엔티티와 연관 객체를 한 번에 모두 조회 | 엔티티만 먼저 조회, 연관 객체는 실제 사용 시 조회 |
  | 쿼리 발생 | 한 번에 모든 데이터 조회 (조인 쿼리 등) | 연관 객체 접근 시 추가 쿼리 발생 |
  | 메모리 사용 | 불필요한 데이터까지 미리 로딩 → 메모리 사용 증가 | 필요한 데이터만 로딩 → 메모리 사용 최적화 |
  | 성능 | 불필요한 데이터까지 로딩 시 성능 저하 가능 | 데이터 접근 빈도가 낮으면 성능 최적화 가능 |
  | 프록시 사용 | 실제 객체를 바로 사용 | 프록시 객체로 대기, 실제 접근 시 초기화 |
  | 사용 예시 | 연관 객체를 자주 함께 사용할 때 | 연관 객체를 가끔 사용할 때 |

# ✅ **Fetch Join**

## Join(지연 로딩) VS Fetch Join(즉시 로딩)

### 1. 쿼리 실행 방식

---

JOIN(일반 조인)

- 목적: 조건 필터링에 사용되며, 연관 엔티티 데이터를 SELECT 하지 않음.
- 동작:

```sql
SELECT m.* FROM Member m JOIN Review r ON m.id = r.member_id
```

- Member 엔티티만 조회되며, Review는 조회되지 않음.
- 연관 엔티티 접근 시 별도 쿼리 발생 (N+1 문제 유발)


FETCH JOIN(페치 조인) 
- 목적: 연관 엔티티를 한 번에 초기화하여 즉시 로딩
- 동작:
        
```sql
SELECT m.*, r.* FROM Member m JOIN Review r ON m.id = r.member_id
```
        
- Member와 Review를 동시에 조회
- 프록시가 아닌 실제 객체를 즉시 로딩
    
### 2. 데이터 로딩 시점

---
    
  | **구분** | **지연 로딩**  | **즉시 로딩 (FETCH JOIN을 통한)** |
  | --- | --- | --- |
  | **초기 조회** | Member만 로딩 | Member와 Review를 함께 로딩 |
  | **연관 접근** | `member.getReviews()` 호출 시 추가 쿼리 실행 | 추가 쿼리 없이 즉시 접근 가능 |
  | **프록시 사용** | Review는 프록시 객체로 대기 | 실제 Review 객체가 즉시 로딩됨 |
    
### 3. 장단점

---
    
FETCH JOIN
    
- 장점
  - 연관 엔티티를 한 번의 쿼리로 모두 가져옴 → N+1 문제 해결
  - 세션이 종료된 후에도 연관 객체 접근 가능
- 단점:
  - 불필요한 컬럼까지 조회될 수 있음
  - 일대다 조인 시 중복 데이터 발생 가능 → 카테시안 곱 문제
    
지연 로딩
    
- 장점
  - 필요한 순간까지 데이터 조회를 지연하므로 초기 로딩 속도가 향상됨
- 단점
  - 연관 객체 접근 시 매번 쿼리를 실행하므로 N+1 문제 발생
    
### 4. 사용 예시

---
    
  지연 로딩 적용 시
    
  ```java
  // Member 엔티티
  @OneToMany(mappedBy = "member", fetch = FetchType.LAZY)
  private List<Review> reviews = new ArrayList<>();
  ```
    
  - `member.getReviews()` 호출 전까지 Review 조회 쿼리 실행 x
    
  페치 조인을 통한 즉시 로딩
    
  ```java
  @Query("SELECT m FROM MEMBER m JOIN FETCH m.reviews")
  List<Member> findAllMembersWithReviews();
  ```
    
  - Member 조회 시 Review도 함께 로딩
    
### 5. 선택 기준

---

  | 구분 | 선택 기준                                            |
  | --- |--------------------------------------------------|
  | **JOIN FETCH** | - 연관 엔티티를 즉시 사용해야 할 때 <br>- N+1 문제를 사전에 방지해야 할 때 |
  | **지연 로딩** | - 연관 엔티티 사용 빈도가 낮을 때<br>- 대량 데이터의 초기 로딩 시간을 줄일 때 |
# ✅ **@EntityGraph**

### 1. @EntityGraph란?

---

- JPA에서 페치 전략을 동적으로 제어하기 위한 기능
- 특정 쿼리 실행 시 연관 엔티티를 즉시 로딩하도록 지정할 수 있음
- N+1 문제 해결과 성능 최적화에 유용하며, 어노테이션 또는 동적 생성 방식으로 정의 가능

### 2. 생성 방식

---

**선언적 정의(`@NamedEntityGraph` )**

- 엔티티 클래스에 직접 그래프 구조 명시

```java
  @NamedEntityGraph(
    name = "Member.detail",
    attributeNodes = {
      @NamedAttributeNode("reviews"),
      @NamedAttributeNode("missions")
    }
  )
  @Entity
  public class Member {
    @Id private Long id;
    @OneToMany(mappedBy = "member") private List<Review> reviews = new ArrayList<>();
    @OneToMany(mappedBy = "member") private List<Mission> missions = new ArrayList<>();
  }
```

- `name`: 그래프 식별자
- `attributeNodes`: 즉시 로딩할 연관 필드 지정

**프로그래밍적 정의(`createEntityGraph`)**

- 런타임에 동적으로 그래프 구성이 가능함

```java
  EntityGraph<User> graph = entityManager.createEntityGraph(Member.class);
  graph.addAttributeNodes("reviews", "missions");
```

- 유연한 설정이 필요할 때 유용함

### 3. 적용 방법

---

**쿼리 힌트 사용**

```java
  EntityGraph<Member> graph = entityManager.getEntityGraph("Member.detail");
  List<Member> members=entityManager.createQuery("SELECT m FROM Member m", Member.class)
                                 .setHint("jakarta.persistence.loadgraph", graph)
                                 .getResultList();
```

- `jakarta.persistence.loadgraph`: 지정된 속성만 즉시 로딩, 나머지는 기본 전략
- `jakarta.persistence.fetchgraph`: 지정된 속성만 즉시 로딩, 나머지는 지연 로딩

**Spring Data JPA 통합**

```java
  public interface MemberRepository extends JpaRepository<Member, Long> {
    @EntityGraph(value = "Member.detail", type = EntityGraphType.LOAD)
    Member findByUsername(String username);
  }
```

- `@EntityGraph` 어노테이션으로 레포지토리 메서드에 직접 적용

### 4. 페치 조인 vs EntityGraph

---

  | **특성** | **페치 조인 (JPQL)** | **EntityGraph** |
    | --- | --- | --- |
  | **조인 타입** | INNER JOIN (기본) | LEFT JOIN (기본) |
  | **로딩 전략** | LAZY → 즉시 로딩으로 재정의 | EAGER → 즉시 로딩 강제 |
  | **쿼리 제어** | JPQL에 직접 명시 | 힌트 또는 어노테이션으로 분리 관리 |
  | **DTO 프로젝션** | 지원 안 함 | DTO 변환 시 제한적 사용 가능 |
  | **유연성** | 쿼리당 일회성 설정 | 재사용 가능한 이름 있는 그래프 |
- EntityGraph는 LEFT JOIN을 기본으로 하여 연관 엔티티가 없는 경우에도 주 엔티티를 반환함

### 5. 성능 고려 사항

---

- 장점:
    - N+1문제 방지: 연관 데이터를 단일 쿼리로 조회함
    - 트랜잭션 외부 접근 가능: 세션 종료 후에도 연관 객체 접근 가능
- 단점:
    - 카테시안 곱: 일대다 관계에서 중복 데이터 발생 가능 → `DISTINCT` 활용 필요
    - 과도한 패치: 불필요한 컬럼 로딩으로 메모리 사용 증가

### 6. 사용 시나리오

---

- EntitnGraph
    - 특정 화면에서 연관 엔티티를 반드시 함께 표시할 때
    - 동적  페치 전략이 필요한 경우(예: 조건별 로딩)
- 페치 조인
    - INNER JOIN이 필요할 때
    - 복잡한 JPQL 쿼리 내에서 직접 조인 제어가 필요할 때

# ✅ **JPQL**

### 1. JPQL(Java Persistence Query Language)이란?

---

- JPA(Java Persistence API)에서 사용하는 객체지향 쿼리 언어
- 데이터베이스의 테이블이 아닌 엔티티 객체를 대상으로 쿼리를 작성함.

### 2. 주요 특징

---

- **객체지향 쿼리**: JPQL은 SQL과 달리 테이블과 컬럼이 아니라, 엔티티와 엔티티의 필드(속성)를 대상으로 쿼리를 작성한다.
- **SQL과 유사한 문법**: SELECT, FROM, WHERE, GROUP BY, ORDER BY 등 SQL과 비슷한 구문을 사용하지만, 실제 쿼리 대상이 다르다.
- **DB 독립성**: JPQL은 특정 데이터베이스에 종속되지 않고, JPA 구현체가 JPQL을 실제 데이터베이스에 맞는 SQL로 변환해 실행한다. 따라서 DBMS가 바뀌어도 JPQL 쿼리는 그대로 사용할 수 있다.
- **엔티티 중심**: 쿼리에서 사용하는 이름은 엔티티 이름과 필드명(대소문자 구분)이다. 예를 들어, `Member` 엔티티의 `name` 필드를 조회할 때는 `select m from Member m where m.name = :name`과 같이 작성한다.

### 3. 기본 문법 예시

---

```java
  String jpql = "select m from Member m where m.name = :name";
  TypedQuery<Member> query = em.createQuery(jpql, Member.class);
  query.setParameter("name", "kjh");
  List<Member> result = query.getResultList();   
```

- `Member`는 엔티티 이름, `name`은 엔티티의 필드명
- `:name`은 파라미터 바인딩을 위한 이름 파라미터

### 4. SQL과의 차이점

---

  | **구분** | **JPQL** | **SQL** |
    | --- | --- | --- |
  | 대상 | 엔티티, 필드 | 테이블, 컬럼 |
  | 독립성 | DBMS에 독립적 | DBMS마다 SQL 문법 차이 있음 |
  | 반환 타입 | 엔티티 객체, DTO 등 | 결과 집합(ResultSet) |
  | 연관관계 | 객체 그래프 탐색 지원 | JOIN 등으로 직접 명시 |

### 5. 사용 방법

---

  - **EntityManager를 통한 실행**:

    `EntityManager.createQuery()` 메서드로 JPQL 쿼리를 실행한다.

  - **@Query 어노테이션**:

    Spring Data JPA에서는 `@Query` ****어노테이션을 통해 JPQL을 직접 작성할 수 있다.

  - **파라미터 바인딩**:

    이름 기준(`:name`)과 위치 기준(`?1`) 파라미터 바인딩을 모두 지원한다.


### 6. 지원 기능

---
    
- 조회(SELECT)
- 수정(UPDATE), 삭제(DELETE)
- JOIN, 집계 함수, 서브쿼리, 프로젝션(DTO 변환) 등 다양한 쿼리 기능 제공
# ✅ **QueryDSL**

### 1. QueryDSL이란?

---

- Java에서 SQL, JPQL과 유사한 쿼리를 타입 안전성을 보장하며 작성할 수 있게 해주는 프레임워크
- 즉, 쿼리를 문자열이 아닌 코드(Fluent API)로 작성하므로, 컴파일 시점에 문법 오류와 타입 오류 탐지 가능

### 2. 주요 특징

---

- **타입 안전성(Type-safety)**: 쿼리에서 사용하는 도메인 객체와 필드명을 코드로 직접 참조하므로 오타나 타입 오류를 컴파일 타임에 바로 확인할 수 있다.
- **IDE 자동완성 지원**: 쿼리 작성 시 IDE의 코드 자동완성 기능을 활용할 수 있어 생산성과 유지보수성이 높아진다.
- **동적 쿼리 작성 용이**: 복잡한 조건의 동적 쿼리도 안전하고 직관적으로 작성할 수 있다.
- **JPQL, SQL, JDO, MongoDB 등 다양한 백엔드 지원**: JPA뿐 아니라 다양한 데이터 소스에 적용할 수 있다.

### 3. 동작 원리 및 구성 요소

---

1. **Q-클래스(메타 모델) 생성**
    - 엔티티 클래스를 기반으로 APT(Annotation Processing Tool)가 QMember, QMission 등 ‘Q’ 접두사가 붙은 쿼리 전용 클래스를 자동으로 생성함
    - Q-클래스의 각 필드는 엔티티의 필드와 1:1로 매핑됨
2. **JPAQueryFactory 사용**
    - 쿼리 생성을 위한 핵심 객체이다.
    - 이를 통해 select, from, where, join 등 다양한 쿼리 메서드를 체이닝 방식으로 사용할 수 있다.
3. **쿼리 작성 예시**

  ```java
  QMember member = QMember.member;
  List<Member> result = queryFactory
      .selectFrom(member)
      .where(member.name.eq("김주현"))
      .fetch();
  ```

  - 위 코드는 SQL로 변환되어 DB에 전달된다.
4. **동적 쿼리와 조건절**
  - `BooleanExpression`을 활용해 조건을 동적으로 조합할 수 있다.
  - 예: `where(member.age.gt(26).and(member.name.startsWith("김")))`
5. **프로젝션**
- 엔티티 전체가 아닌 일부 필드만 조회할 때 Tuple, Projections, @QueryProjection 등을 활용할 수 있다.

### 4. JPQL과 비교

---

  | **구분** | **JPQL** | **QueryDSL** |
    | --- | --- | --- |
  | 쿼리 작성법 | 문자열/복잡한 객체 그래프 | 코드(Fluent API, 타입 안전) |
  | 타입 체크 | 런타임 오류(문자열 오타 등) | 컴파일 타임 오류(IDE 자동완성, 리팩토링 용이) |
  | 동적 쿼리 | 코드가 복잡, 가독성 낮음 | 코드가 간결, 가독성 높음 |
  | 유지보수성 | 도메인 변경 시 쿼리 일일이 수정 필요 | 도메인 변경 시 Q-클래스 자동 반영 |
# ✅ N+1 문제 해결 방법

### **1. Deduplication at Application Layer (애플리케이션 레벨 중복 제거)**

---

- **문제점**: 페치 조인 시 `1:N` ****관계에서 중복된 엔티티가 반환된다.
- **해결법**:

    ```java
    List<Review> review = queryFactory.selectFrom(review)
                                   .join(review.members, member).fetchJoin()
                                   .distinct() // 애플리케이션 레벨에서 중복 제거
                                   .fetch();
    ```

- **장점**: SQL `DISTINCT`보다 유연하게 중복을 관리할 수 있다.
- **단점**: 메모리에서 처리되므로 대량 데이터에서는 성능 저하 가능성이 있다.

### **2. Second-Level Cache (2차 캐시)**

---

- **동작 원리**: Hibernate의 2차 캐시는 세션 간 공유되는 캐시로, 자주 조회되는 엔티티나 컬렉션을 캐싱해 N+1 쿼리를 방지한다.
- **적용 예시**:

  ```xml
  <property name="hibernate.cache.use_second_level_cache" value="true"/>
  <property name="hibernate.cache.region.factory_class" value="org.hibernate.cache.ehcache.EhCacheRegionFactory"/>
  ```

  ```java
  @Entity
  @Cacheable
  @org.hibernate.annotations.Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
  public class Mission { ... }
  ```

  - **장점**: 동일한 엔티티 반복 조회 시 쿼리 수 감소.
  - **주의사항**: 실시간성이 중요한 데이터에는 부적합하며, 캐시 무효화 전략이 필요하다.

### **3. Materialized View (물리화된 뷰)**

---

  - **개념**: 데이터베이스에서 미리 계산된 테이블을 생성해 복잡한 조인 결과를 저장한다.
  - **적용 예시** (PostgreSQL):

    ```sql
    CREATE MATERIALIZED VIEW member_review_summary AS
    SELECT m.id, m.name, COUNT(r.id) AS review_count
    FROM member m LEFT JOIN review r ON m.id = r.member_id
    GROUP BY m.id;
    ```

  - **장점**: 애플리케이션 코드 변경 없이 복잡한 조인 결과를 빠르게 조회 가능.
  - **단점**: 뷰 갱신 주기 관리가 필요하며, 데이터 실시간성 감소.

### **4. Asynchronous Data Loading (비동기 데이터 로딩)**

---

  - **동작 방식**: 주 엔티티 조회 후 연관 엔티티를 비동기로 병렬 조회한다.
  - **예시** (Java CompletableFuture):

    ```java
    List<Member> members = memberRepository.findAll();
    CompletableFuture<List<Review>> future = CompletableFuture.supplyAsync(() -> 
        reviewRepository.findByMember(members));
    List<Review> reviews = future.join(); *// 모든 멤버의 리뷰를 한 번에 조회*
    ```

  - **장점**: 동기 방식보다 전체 쿼리 시간 단축 가능.
  - **주의사항**: 트랜잭션 경계 관리와 동시성 제어가 복잡해질 수 있다.

### **5. GraphQL-Style Batching**

---

  - **개념**: 클라이언트가 필요한 필드를 지정하면, 서버에서 **단일 최적화된 쿼리**로 응답한다.
  - **적용 예시** (Java + GraphQL):

    ```graphql
    query {
      members {
        id
        name
        reviews {  *# 클라이언트가 필요한 연관 필드 지정*
          id
          content
        }
      }
    }
    ```

    - 서버에서는 `members`와 `reviews` 를 조인한 쿼리 1번으로 처리한다.
  - **장점**: 클라이언트 요청에 맞춘 유연한 데이터 조회.
  - **단점**: GraphQL 인프라 구축 비용 발생.

### **6. Database-Specific Optimizations (데이터베이스 특화 기능)**

---

  - **예시 1**: PostgreSQL의 LATERAL JOIN

    ```sql
    SELECT m.*, r.*
    FROM member m
    LEFT JOIN LATERAL (
      SELECT * FROM review r WHERE r.member_id = m.id LIMIT 100
    ) r ON true;
    ```

  - **예시 2**: MySQL의 **Derived Table**

    ```sql
    SELECT mb.*, ms.*
    FROM member mb
    LEFT JOIN (
      SELECT member_id, GROUP_CONCAT(name) AS mission_names
      FROM mission GROUP BY member_id
    ) ms ON mb.id = ms.member_id;
    ```

  - **장점**: 데이터베이스 엔진의 최적화 기능을 활용해 쿼리 성능 향상.
  - **단점**: 특정 DB에 종속되어 이식성이 떨어진다.

### **7. Read Replica 활용**

---

  - **전략**: 쓰기 작업은 마스터 DB에서, 읽기 작업은 복제본(Replica)에서 처리해 부하 분산.
  - **장점**: 마스터 DB의 부하 감소로 N+1 쿼리 영향 최소화.
  - **주의사항:** 복제 지연(replication lag) 문제를 고려해야 한다.

### **8. Event Sourcing 패턴**

---

  - **개념**: 데이터 상태 변경 이벤트를 저장하고, 필요한 시점에 프로젝션을 생성해 조회한다.
  - **적용 분야**: 주문 이력, 사용자 활동 추적 등 이벤트 기반 시스템.
  - **장점**: 연관 데이터 조회를 이벤트 재생으로 대체해 N+1 문제 회피.
  - **단점**: 시스템 복잡도 증가.

  ### **선택 기준**

  | **방법**                | **사용 시나리오** | **고려 사항** |
  |-----------------------| --- | --- |
  | **2차 캐시**             | 자주 조회되고 변경 빈도가 낮은 데이터 | 캐시 무효화 전략 수립 |
  | **Materialized View** | 대규모 집계 데이터 조회 | 뷰 갱신 주기 관리 |
  | **비동기 로딩**            | 대량 데이터 병렬 처리 가능 환경 | 트랜잭션 경계 관리 복잡성 |
  | **GraphQL Batching**  | 클라이언트가 필요한 필드를 유동적으로 지정 | GraphQL 인프라 구축 필요 |
  | **DB 특화 기능**          | 특정 DB의 고성능 조인 기능 활용이 가능할 때 | DB 종속성 증가 |