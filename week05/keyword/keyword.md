# Domain

`DOMAIN` 패키지는 소프트웨어 시스템에서 **비즈니스 로직**이나 **핵심 데이터 모델**을 정의하는 데 사용되는 패키지입니다. 흔히 **도메인 모델(Domain Model)** 이라고도 하며, 애플리케이션의 비즈니스 규칙과 관련된 객체들을 포함합니다. 이 패키지는 애플리케이션의 핵심 영역에서 발생하는 데이터를 구조화하고, 시스템의 주요 기능을 구현하는 데 필요한 객체들을 관리합니다.

- **비즈니스 로직 구현**:
    - 애플리케이션에서 처리해야 할 비즈니스 규칙을 모델링하는 클래스들이 위치합니다.
    - 예를 들어, 쇼핑몰 애플리케이션에서 `Product`, `Order`, `Customer`와 같은 클래스가 도메인 패키지에 정의될 수 있습니다.
- **엔티티(Entity)**:
    - 데이터베이스와 연결되는 **엔티티 클래스**들이 주로 포함됩니다.
    - 이 클래스들은 `@Entity`, `@Table`, `@Id` 등을 사용하여 데이터베이스 테이블과 매핑되는 객체입니다.
- **값 객체(Value Object)**:
    - 특정 값을 나타내는 객체로, 변경 불가능(immutable)한 특성을 가집니다.
    - 예: `Address`, `Money`, `DateRange` 등이 값 객체로 모델링될 수 있습니다.
- **집합체(Aggregate)**:
    - 여러 엔티티가 함께 묶여 하나의 도메인 객체로 모델링된 경우입니다. 이들은 하나의 **상위 객체**로부터 관리됩니다.
    - 예를 들어, `Order`와 `OrderItem`은 하나의 집합체로 묶일 수 있습니다.
- **리포지토리(Repository)**:
    - 도메인 객체와 데이터베이스 간의 데이터 저장/조회 처리를 담당하는 객체입니다. 이는 종종 **DAO(Data Access Object)** 패턴을 구현합니다.
- **서비스(Service)**:
    - 비즈니스 로직을 처리하는 서비스를 정의합니다. `Service`는 도메인 객체를 사용하는 기능을 구현하지만, 도메인 모델 자체는 아닙니다.
    - 예: `OrderService`, `PaymentService` 등이 서비스 클래스에 해당합니다.


# 양방향 매핑

**양방향 매핑**은 두 엔티티 간의 관계에서 두 엔티티가 서로를 참조할 수 있도록 설정하는 것입니다. 예를 들어, `A` 엔티티와 `B` 엔티티가 **1:N** 또는 **N:M** 관계로 연결되어 있을 때, 양방향 매핑을 사용하면 두 엔티티가 서로를 참조할 수 있게 됩니다.

### 1. **양방향 매핑의 개념**

- **단방향 매핑**은 한 엔티티만 다른 엔티티를 참조하는 방식입니다.
- **양방향 매핑**은 두 엔티티가 서로를 참조하는 방식입니다.

양방향 관계를 설정하려면 두 엔티티에 서로를 참조하는 필드를 추가하고, 이 관계를 명시적으로 설정해야 합니다. `@OneToMany`와 `@ManyToOne`, 또는 `@ManyToMany`와 `@ManyToMany` 등의 애너테이션을 사용하여 양방향 관계를 설정합니다.

### 2. **양방향 매핑의 예시**

### 1) **1:N 관계 (OneToMany / ManyToOne)**

`User`와 `Order` 간에 **1:N 관계**를 설정한다고 가정해봅시다. 한 명의 `User`는 여러 개의 `Order`를 가질 수 있습니다.

- **단방향 매핑**: `Order`는 `User`를 참조하고, `User`는 `Order`를 참조하지 않습니다.
- **양방향 매핑**: `User`도 `Order`를 참조하고, `Order`도 `User`를 참조합니다.

### 1.1 **`User`와 `Order`의 양방향 매핑 예시**:

```java
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;

    @OneToMany(mappedBy = "user")  // user가 참조하는 필드 이름 (Order 클래스의 'user' 필드)
    private List<Order> orders;    // 한 명의 User는 여러 개의 Order를 가질 수 있습니다.
}

@Entity
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String orderDetails;

    @ManyToOne
    @JoinColumn(name = "user_id") // user_id가 외래 키
    private User user;  // 여러 개의 Order는 하나의 User에 속합니다.
}

```

### 1.2 **설명**:

- **`@OneToMany(mappedBy = "user")`**: `User`가 여러 개의 `Order`를 가질 수 있도록 설정합니다. `mappedBy` 속성은 `Order` 클래스에서 `user` 필드가 `User` 엔티티를 참조하는 필드임을 명시합니다.
- **`@ManyToOne`**: `Order` 엔티티는 여러 개의 `Order`가 하나의 `User`에 속하기 때문에 `ManyToOne` 관계로 설정합니다.
- **`@JoinColumn(name = "user_id")`**: `Order` 테이블에서 외래 키로 `user_id` 컬럼을 사용하도록 지정합니다.

이렇게 설정하면, `User`는 `Order` 목록을 직접 참조하고, `Order`는 `User`를 참조할 수 있습니다. 즉, **양방향 관계**가 성립합니다.

---

### 2) **N:M 관계 (ManyToMany)**

`Student`와 `Course` 간에 **N:M 관계**가 있다고 가정해봅시다. 여러 `Student`는 여러 `Course`에 참여할 수 있습니다.

- **단방향 매핑**: `Student`가 `Course`를 참조하거나, `Course`가 `Student`를 참조할 수 있습니다.
- **양방향 매핑**: `Student`가 `Course`를 참조하고, `Course`도 `Student`를 참조할 수 있습니다.

### 2.1 **`Student`와 `Course`의 양방향 매핑 예시**:

```java
@Entity
public class Student {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @ManyToMany
    @JoinTable(
      name = "student_course",
      joinColumns = @JoinColumn(name = "student_id"),
      inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private List<Course> courses;  // 한 명의 Student는 여러 개의 Course를 들을 수 있습니다.
}

@Entity
public class Course {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String courseName;

    @ManyToMany(mappedBy = "courses")  // student가 참조하는 필드 이름
    private List<Student> students;  // 여러 개의 Student가 여러 개의 Course에 등록될 수 있습니다.
}

```

### 2.2 **설명**:

- **`@ManyToMany`**: `Student`와 `Course`는 다대다 관계이므로 `@ManyToMany` 애너테이션을 사용합니다.
- **`@JoinTable`**: `Student`와 `Course`의 관계를 나타내는 교차 테이블 `student_course`를 정의합니다. 이 테이블은 `student_id`와 `course_id` 외래 키를 포함합니다.
- **`mappedBy`**: `Course` 클래스에서 `Student`를 참조하는 필드를 `mappedBy = "courses"`로 지정하여 양방향 매핑을 설정합니다.

이렇게 설정하면, `Student`는 `Course` 목록을 참조하고, `Course`도 `Student` 목록을 참조할 수 있습니다. **양방향 관계**가 성립됩니다.

---

### 📌 양방향 매핑의 주의사항

1. **순환 참조**:
    - 양방향 매핑에서 `User` ↔ `Order` 또는 `Student` ↔ `Course`처럼 두 엔티티가 서로를 참조하면, 무한 순환 참조가 발생할 수 있습니다. 이를 피하기 위해 **`@JsonIgnore`** (Spring에서는 `@JsonIgnore` 어노테이션을 사용하여 직렬화에서 참조를 무시하게 할 수 있음) 등을 사용할 수 있습니다.
2. **성능 이슈**:
    - 양방향 매핑을 사용하면 `JOIN` 쿼리가 두 개의 테이블을 모두 참조하게 되어 성능에 영향을 미칠 수 있습니다. 따라서 `fetch` 전략(`EAGER`/`LAZY`)을 적절히 설정하여 성능 최적화를 해야 합니다.
3. **`mappedBy` 사용 시 주의**:
    - 양방향 관계에서 `mappedBy`는 주로 연관 관계의 주체가 아닌 반대쪽 엔티티에서 설정합니다. 연관 관계의 주체가 되는 엔티티에 외래 키가 설정됩니다.

---

# N+1 문제

**N+1 문제**는 **ORM(Object-Relational Mapping)**에서 발생하는 성능 이슈 중 하나입니다. 주로 `Lazy Loading`과 연관되어 발생하는데, 이 문제는 **쿼리의 수가 예상보다 많아져서 성능이 급격히 저하되는 현상**을 말합니다.

### 📌 N+1 문제의 원인:

1. **`Lazy Loading`**: `Lazy Loading`은 연관된 엔티티를 실제로 필요할 때 로딩하는 방식입니다. 하지만 여러 개의 객체를 조회하고, 그 객체와 관련된 다른 객체들을 개별적으로 로딩할 경우, 쿼리가 반복적으로 실행됩니다. 이로 인해 예상보다 많은 쿼리가 실행되어 성능 문제를 일으킵니다.
2. **연관된 엔티티를 조회할 때마다 쿼리가 추가로 발생**: 예를 들어, `User`와 `Order`라는 엔티티가 있고, `User`가 여러 개의 `Order`를 가질 수 있는 **1:N 관계**라면, `User` 목록을 조회할 때 각 `User`에 대해 관련된 `Order`가 각각 별도의 쿼리로 조회될 수 있습니다. 이 경우, `User`가 N명일 때 `Order`를 조회하는 쿼리가 **N+1개**가 실행됩니다.

### 📌 예시: N+1 문제 발생 예시

### 1. `User`와 `Order` 엔티티 관계

```java
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToMany(mappedBy = "user")
    private List<Order> orders;  // 여러 개의 Order가 하나의 User에 속함
}

```

```java
@Entity
public class Order {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;  // 여러 개의 Order는 하나의 User에 속함
}

```

### 2. N+1 문제 발생 코드

```java
public List<User> getUsersWithOrders() {
    List<User> users = userRepository.findAll(); // User 조회

    for (User user : users) {
        List<Order> orders = user.getOrders(); // 각 User에 대해 Order 조회 (여기서 N+1 문제 발생)
    }

    return users;
}

```

### 📌 N+1 문제 분석:

- `userRepository.findAll()`로 `User` 엔티티들을 조회한 후, 각 `User` 객체에서 `getOrders()` 메서드를 호출하여 관련된 `Order`들을 가져옵니다.
- `findAll()` 쿼리는 **1번** 실행됩니다.
- 그 후, **각각의 `User`에 대해** `getOrders()` 메서드에서 `Order`들을 별도로 조회하는 쿼리가 추가로 실행됩니다. 이 쿼리들은 총 **N번** 실행됩니다.
- 따라서, **1 + N** 개의 쿼리가 실행되며, 이게 **N+1 문제**입니다.

### 📌 N+1 문제 해결 방법

### 1. **`Eager Loading` 사용**

`Eager Loading`은 연관된 엔티티를 조회할 때 한 번의 쿼리로 모두 로드하는 방식입니다. `@OneToMany`, `@ManyToOne` 등에서 `fetch = FetchType.EAGER`를 설정하여 연관된 엔티티를 미리 로딩하도록 할 수 있습니다.

```java
@Entity
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToMany(mappedBy = "user", fetch = FetchType.EAGER) // Eager Loading 적용
    private List<Order> orders;
}

```

그러나 `Eager Loading`을 사용하면 항상 연관된 엔티티들을 함께 로드하게 되어 **불필요한 데이터가 로드될 수** 있습니다. 이로 인해 성능에 영향을 줄 수 있으므로, **필요한 경우에만** 사용하는 것이 좋습니다.

### 2. **`@Query`와 `JOIN FETCH` 사용 (수동으로 Fetch 전략 설정)**

`JOIN FETCH`를 사용하면 한 번의 쿼리로 연관된 엔티티를 함께 가져올 수 있습니다. 이렇게 하면 **한 번의 쿼리로 모든 데이터를 로드**할 수 있어 N+1 문제를 해결할 수 있습니다.

```java
public List<User> getUsersWithOrders() {
    return entityManager.createQuery(
            "SELECT u FROM User u JOIN FETCH u.orders", User.class)
            .getResultList();
}

```

또는, **`@Query` 어노테이션을 사용**하여 쿼리를 작성할 수도 있습니다.

```java
public interface UserRepository extends JpaRepository<User, Long> {

    @Query("SELECT u FROM User u JOIN FETCH u.orders")
    List<User> findAllWithOrders();
}

```

### 3. **`@EntityGraph` 사용**

`@EntityGraph`를 사용하면 `EAGER` 로딩과 유사하지만, 필요한 필드만 **선택적으로** 로딩할 수 있습니다. 특정 필드를 가져오도록 설정할 수 있어서 **성능을 최적화**할 수 있습니다.

```java
public interface UserRepository extends JpaRepository<User, Long> {

    @EntityGraph(attributePaths = "orders")
    List<User> findAll(); // orders 필드만 EAGER 로딩
}

```

이 방법은 `Eager Loading`을 사용하되, **필요한 연관 필드만 선택적으로 로딩**할 수 있게 해줍니다.

### 4. **배치 처리 (Batch Fetching)**

JPA는 기본적으로 연관된 엔티티들을 조회할 때 **배치로 로딩**할 수 있는 기능도 제공합니다. `@BatchSize` 애너테이션을 사용하여 성능을 개선할 수 있습니다.

```java
@Entity
@BatchSize(size = 10)  // 한 번에 10개씩 배치로 조회
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String name;

    @OneToMany(mappedBy = "user")
    private List<Order> orders;
}

```

### 📌 요약

- **N+1 문제**는 연관된 엔티티를 조회할 때 불필요하게 여러 번의 쿼리가 실행되는 문제입니다.
- 이를 해결하려면 **`Eager Loading`**, **`JOIN FETCH`**, **`@EntityGraph`**, **배치 처리** 등을 사용하여 성능을 최적화할 수 있습니다.
- `Lazy Loading`과 `Eager Loading`을 적절히 사용해야 하며, 연관된 데이터를 로드할 때 필요한 경우에만 데이터를 로드하도록 설계하는 것이 중요합니다.