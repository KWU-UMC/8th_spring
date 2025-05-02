# 📍 Domain
    - Domain : 엔티티 선언을 통해 DB에 저장되는 객체들을 구현한다.즉, 테이블의 각 Column들이 하나의 도메인이라 보면 된다.

  **JPA에서 사용하기 위한 엔티티 클래스를 저장**하기 위한 패키지입니다.

    - 도메인은 일반적인 요구사항, 전문 용어, 그리고 컴퓨터 프로그래밍 분야에서 문제를 풀기 위해 설계된 어떤 소프트웨어 프로그램에 대한 기능성을 정의하는 연구의 한 영역
    - 즉, 도메인은 기획의 요구사항을 구현하고, 문제를 풀기 위해 설계된 소프트웨어 프로그램의 기능성을 정의하는 영역
    - 도메인이란 사용자가 이용하는 앱 기능, 회사의 비즈니스 로직을 정의하는 영역이라고 이해해 볼 수 있습니다.

  ### Entity와 Domian의 차이점

    - Domian은 비즈니스 영역을 추상적으로 나타내는 개념이고, Entity는 Domain 내에서 실제 개별 객체나 개념을 나타냅니다.즉, Domain은 서비스를 대표하는 개념이고 Entity는 Domain 내에 식별 가능한 객체를 뜻합니다.

# 📍 양방향 매핑
## 1. 연관관계란?

- 두 개 이상의 **엔티티(Entity)** 가 서로 연결되어 있는 상태를 말한다.
- 예를 들어, `Member`와 `Team`이 있다면,
    - "Member는 어떤 Team에 속해 있다" 같은 관계를 뜻한다.

## 2. 단방향 매핑 (One-way Mapping)

- **단방향 매핑만으로도 연관관계 매핑은 끝난다.**
- 예를 들어, `Member`가 `Team`을 참조한다면: Member에만 작성하면 됨
    - 한 쪽(`Member`)만 다른 쪽(`Team`)을 알면 되는 구조
    - but Team에서는 `Member` 와의 연결관계를 모르는 구조이다.

    ```java
    @ManyToOne
    @JoinColumn(name = "team_id")
    private Team team;
    ```


## 3. 양방향 매핑 (Two-way Mapping)

- **양방향 매핑은 필수가 아니라 선택이다.**
- 단방향 매핑만 해도 DB 상 FK는 이미 매핑되어 있기 때문에,
- **"객체 그래프 탐색"** 이 필요할 때만 양방향 매핑을 추가한다.

  즉,

    - `Member` ➔ `Team` 으로만 조회할 수 있었던 걸
    - `Team` ➔ `Member` 리스트로도 조회하고 싶을 때 **양방향 매핑**을 추가한다.

> 양방향 매핑은 단순히 "역방향 탐색 기능"을 추가하는 것이다.
>

**양방향 매핑 추가 방법:**

team에 자바 코드에 컬렉션만 추가해주면 된다.

```java
@OneToMany(mappedBy = "team")
private List<Member> members = new ArrayList<>();

```

## 4. 연관관계 주인 (Owner of Relationship)

- JPA는 두 객체를 단순히 양방향으로 참조한다고 해서 자동으로 연관관계를 관리하지 않는다.
- **둘 중 누군가가 "진짜로 DB 외래키를 관리하는 주체"가 되어야 한다.**

### 주인 결정 기준

- **"외래 키(FK)를 갖고 있는 쪽"이 연관관계의 주인이다.** (✅)

즉:

- `Member` 테이블에 `team_id` 외래키가 있다면
- `Member` 엔티티가 연관관계의 주인이 된다.

**주인은 @JoinColumn을 가지고, 비주인은 mappedBy를 사용한다.**

# 📍N + 1 문제

**N+1 : 조회 시 1개의 쿼리를 생각하고 설계를 했으나 나오지 않아도 되는 조회의 쿼리가 N개가 더 발생하는 문제.**

- JPA가 등장함에 따라 자동화된 쿼리문들이 생겨나면서 어쩔 수 없이 발생하는 문제

### **JPA에서의 즉시로딩과 지연로딩의 개념**

- **즉시로딩 (xxToxx(fetch = fetchType.EAGER): 데이터를 조회할 때, 연관된 모든 객체의 데이터까지 한 번에 불러오는 것이다.**
    - 실무에서 가장 사용하지 않아야 할 로딩방식
- **지연로딩 : @xxToxx(fetch = fetchType.LAZY)** :  필요한 시점에 연관된 객체의 데이터를 불러오는 것이다.

⇒ 즉시 로딩에서는 member와 연관된 Team이 1개여서 Team을 조회하는 쿼리가 나갔지만, 만약 Member를 조회하는 JPQL을 날렸는데 연관된 Team이 1000개라면? Member를 조회하는 쿼리를 하나 날렸을 뿐인데 Team을 조회하는 SQL 쿼리 1000개가 추가로 나가게 된다.

그러므로, 지연로딩을 사용하는 것이 좋다.

### 기대했던 sql문

```java
SELECT * FROM user;
```

### JPA가 실행한 sql문

```java
1. SELECT * FROM user;   (모든 유저 조회) ➔ 1번
2. SELECT * FROM article WHERE user_id = 1; ➔ 1번
3. SELECT * FROM article WHERE user_id = 2; ➔ 1번
4. SELECT * FROM article WHERE user_id = 3; ➔ 1번
...
```

### 해결 방법

- jpql에서 fetch join 사용!
    - 하드코딩을 막기 위해서는 `@EntityGraph`를 사용하면 된다.

```java
@EntityGraph(attributePaths = {"articles"}, type = EntityGraphType.FETCH)
List<User> findAllEntityGraph();
```

출처

[https://velog.io/@jinyoungchoi95/JPA-모든-N1-발생-케이스과-해결책](https://velog.io/@jinyoungchoi95/JPA-%EB%AA%A8%EB%93%A0-N1-%EB%B0%9C%EC%83%9D-%EC%BC%80%EC%9D%B4%EC%8A%A4%EA%B3%BC-%ED%95%B4%EA%B2%B0%EC%B1%85)

[https://velog.io/@jinyeong-afk/기술-면접-즉시-로딩과-지연-로딩의-차](https://velog.io/@jinyeong-afk/%EA%B8%B0%EC%88%A0-%EB%A9%B4%EC%A0%91-%EC%A6%89%EC%8B%9C-%EB%A1%9C%EB%94%A9%EA%B3%BC-%EC%A7%80%EC%97%B0-%EB%A1%9C%EB%94%A9%EC%9D%98-%EC%B0%A8)
