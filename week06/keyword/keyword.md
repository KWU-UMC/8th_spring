# 지연 로딩과 즉시 로딩의 차이
## 지연 로딩 (Lazy Loading)

### 특징

- 연관된 엔티티를 실제 사용할 때 DB에서 가져옴
- 프록시 객체로 먼저 가져오고, 필요할 때 쿼리 실행
- 초기 로딩 속도 빠름
- 성능 최적화에 유리

### **장점**

- 진짜 필요한 시점에만 조회해서 DB 부하 ↓
- 쿼리 최적화 가능성 높음 (Fetch Join, EntityGraph 등 활용 가능)

### **단점**

- 프록시 객체 개념을 이해해야 함
- 영속성 컨텍스트가 닫힌 상태에서 사용하면 LazyInitializationException 발생

### 프록시를 사용하는 이유

지연 로딩의 프록시 객체는 데이터를 저장하고 있는 게 아니라, 진짜 객체에 접근하기 위한 "껍데기"이다.

JPA는 `@ManyToOne(fetch = FetchType.LAZY)` 같이 지연로딩을 설정하면, 연관된 엔티티(Member 등)를 처음부터 진짜 객체로 로딩하지 않고 대신 프록시 객체를 넣어놓는다.

이 프록시는 진짜 객체처럼 보이지만, 데이터를 가지고 있지 않는다. 내부에 다음과 같은 로직이 있다:

```java
if (실제 객체를 아직 로딩하지 않았으면) {
    영속성 컨텍스트에게 DB 조회 요청
    진짜 객체 로딩
}
return 진짜 객체의 메서드나 필드
```

### 프록시는 무엇인가

Hibernate는 실제 클래스(Member)를 상속한 가짜 클래스를 만들어서 넣어준다.

예를 들어 `Member`의 프록시라면:

```java
class Member$HibernateProxy extends Member {
    // 내부적으로 EntityManager를 가지고 있다가
    // 처음 접근되는 시점에 진짜 Member를 로딩해서 대신 동작함
}
```

### 프록시가 실제 로딩하는 시점

- `member.getName()` 같이 프록시 객체의 메서드나 필드를 호출할 때
- 즉, 데이터가 필요한 시점에 DB에 쿼리를 날리고 진짜 객체로 초기화됨

### 주의할 점

- 트랜잭션이 끝난 이후 프록시를 접근하면 DB 접근이 불가능하므로 `LazyInitializationException` 발생함
- `member instanceof HibernateProxy` 같은 체크로 프록시 여부를 알 수 있음

## 즉시 로딩 (Eager Loading)

### 특징

- 엔티티를 조회할 때 연관된 엔티티도 함께 즉시 로딩
- 한 번에 가져오기 때문에 N+1 문제가 발생할 수 있음
- 편리하지만, 예측하기 어려운 쿼리 증가 가능성

### 장점

- 연관 엔티티를 바로 사용할 수 있어 편함.
- 코드가 단순함 (프록시 개념을 몰라도 됨).

### 단점

- 불필요한 쿼리까지 날라감.
- N+1 문제 발생 가능성 높음.
- 모든 연관 객체를 항상 JOIN해서 가져오므로 성능 저하.
- 서비스 계층에서 실제로 안 쓰는 필드까지 다 가져오는 건 낭비.

## 지연 로딩과 즉시 로딩간의 차이점

- 즉시 로딩은 조회를 하면 즉시 로딩, 지연 로딩은 객체를 실제로 사용할 때 로딩된다.
- 즉시 로딩은 불필요한 경우에도 로딩이 되어 성능에 영향을 미칠 수 있지만, 지연 로딩은 설제 객체에 접근이 필요할 때만 로딩을 해서 성능적 측면에서 더 좋다.

# Fetch Join
`fetch join`은 JPA에서 지연 로딩(LAZY) 상태인 연관 엔티티를 한 번의 쿼리로 즉시 함께 로딩하기 위해 사용하는 JPQL 문법

```java
SELECT p FROM Post p JOIN FETCH p.comments
```

- `Post`와 `Comment`가 1:N 관계일 때,
- `Post`를 조회하면서 `Comment`를 한 번에 같이 조회함.

### fetch join 효과

| 효과 | 설명 |
| --- | --- |
|  **N+1 문제 해결** | 연관 객체를 한 번에 가져와서 반복 쿼리 방지 |
| **지연 로딩 → 즉시 로딩** 전환 | 지연 로딩 설정돼 있어도 즉시 로딩처럼 동작 |
| **중복 데이터 발생 가능성** | 컬렉션 fetch join은 중복 row 생기기 쉬움 (→ `DISTINCT` 사용 권장) |

### 그냥 SELECT p, p.comments하면 안되나?

단순히 `p.comments`를 접근하면 가져오지 않는다.

`JOIN FETCH`는 명시적으로 한 번에 join해서 가져오라고 지시하는 것이다

### 1. 단순히 p.comments 호출

```java
Post post = em.find(Post.class, 1L);
List<Comment> comments = post.getComments();
```

- `comments`는 기본이 `LAZY` 로딩
- `post.getComments()`를 호출하는 시점에 추가 쿼리(N+1 문제) 가 발생함
- 즉, `Post`만 먼저 가져오고, `comments`는 나중에 프록시를 통해 별도 쿼리로 가져옴

### 2. Fetch Join 사용

```java
SELECT p FROM Post p JOIN FETCH p.comments
```

- Post와 Comment를 한 번에 join해서 가져옴
- 즉, `comments`를 따로 조회하지 않고 한 번의 쿼리로 모두 가져옴

# @EntityGraph
`@EntityGraph`는 JPA에서 fetch join 없이 지연 로딩을 즉시 로딩으로 바꾸는 방법이다.

지연 로딩 필드를 특정 쿼리에서만 즉시 로딩하고 싶을 때 사용한다.

```java
public interface PostRepository extends JpaRepository<Post, Long> {

    @EntityGraph(attributePaths = {"comments"})
    @Query("SELECT p FROM Post p WHERE p.id = :id")
    Post findByIdWithComments(@Param("id") Long id);
}
```

`Post`를 조회할 때 `comments`를 즉시 로딩한다. 내부적으로는 `JOIN FETCH`와 유사한 쿼리가 생성된다.

# JPQL
SQL가 관계 지향 언어라면, JPQL은 엔티티 객체를 대상으로 쿼리하는 객체 지향 쿼리 언어

### JPQL vs SQL

| 구분 | JPQL | SQL |
| --- | --- | --- |
| 대상 | 테이블이 아닌 **엔티티** | 테이블 |
| 필드 접근 | **엔티티 필드 이름**으로 접근 | 컬럼 이름으로 접근 |
| 사용 목적 | JPA에서 데이터 조회, 수정, 삭제 등 | 데이터베이스 직접 조회 |

### SQL

```sql
SELECT * FROM post p WHERE p.title = 'hello';
```

### JPQL

```java
SELECT p FROM Post p WHERE p.title = 'hello'
```

- 여기서 `Post`는 테이블명이 아니라 엔티티 클래스 이름
- `p.title`은 엔티티 필드 이름

### 특징

- **DB 독립적**: RDBMS에 따라 바뀌지 않음
- **엔티티 중심**: 객체 기반으로 설계
- **TypedQuery**를 통해 타입 안정성 보장 가능

# QueryDSL

QueryDSL은 JPQL을 Java 코드로 안전하게 작성하게 해주는 프레임워크이다.

### 기본 구조

```java
JPAQueryFactory queryFactory = new JPAQueryFactory(em);

QPost post = QPost.post;

List<Post> result = queryFactory
    .selectFrom(post)
    .where(post.title.eq("hello"))
    .fetch();
```

다음을 제공한다.

| 항목 | 설명 |
| --- | --- |
| **타입 안전성** | 컴파일 시점에 문법 오류를 잡아줌 (JPQL은 런타임 오류) |
| **자동 완성 지원** | IDE에서 `.where()`, `.orderBy()` 등 자동 완성 가능 |
| **동적 쿼리** | if문, BooleanBuilder 등을 활용한 조건적 where 절 구성 |
| **간결한 문법** | 코드 기반으로 쿼리를 표현할 수 있어 가독성 높음 |

# N+1 문제 해결 방법

### N+1 문제

1개의 쿼리를 실행한 후에, 관련된 N개의 데이터를 각각 가져오기 위해 추가적으로 N번의 불필요한 쿼리가 실행되어 성능 저하가 발생하는 문제이다.

### 1. Fetch Join (JPQL)

    - 연관된 엔티티를 한 번의 쿼리로 함께 로딩
    - 가장 흔하고 빠른 해결책

    ```java
    SELECT m FROM Member m JOIN FETCH m.team
    ```

주의:

    - 컬렉션(fetch join) 2개 이상 불가
    - 페이징 불가 (`OneToMany`에서는 `fetch join` 사용 시)

### 2. @EntityGraph

    - JPQL을 쓰지 않고도 fetch join과 비슷한 효과
    - `@NamedEntityGraph` 또는 `@EntityGraph` 사용

    ```java
    @Repository
    public interface MemberRepository extends JpaRepository<Member, Long> {
    
        @EntityGraph(attributePaths = {"team"})
        List<Member> findAll();
    }
    ```

### 3. BatchSize 설정 (Hibernate)

    - `@OneToMany(fetch = LAZY)` 관계에서 여러 건의 지연 로딩을 한 번에 처리

### 전역 설정

    ```
    spring.jpa.properties.hibernate.default_batch_fetch_size=100
    ```

### 개별 설정

    ```java
    @OneToMany(fetch = FetchType.LAZY)
    @BatchSize(size = 100)
    private List<Order> orders;
    ```

    - IN 쿼리로 여러건을 한 번에 가져옴

### 4. DTO로 직접 조회 (JPQL / QueryDSL)

    - N+1을 신경 쓸 필요 없는 방식
    - 필요한 필드만 골라서 성능 최적화 가능

    ```java
    SELECT new com.example.dto.MemberDto(m.id, m.name, t.name)
    FROM Member m
    JOIN m.team t
    ```

### 5. 쿼리 튜닝

    - Join 대신 `Subquery` 사용
    - Index 최적화, DB 레벨 조정 등