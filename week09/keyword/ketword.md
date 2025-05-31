# Spring Data JPA의 Paging

# Page

Spring Data JPA의 Paging은 대량의 데이터를 효율적으로 조회하기 위해 데이터를 페이지 단위로 나누어 조회하는 기능이다.

### 1. 페이징의 필요성

- 한 번에 모든 데이터를 가져오면 메모리 사용량 증가 + 성능 저하
- 사용자는 전체 데이터 중 일부만 보고 싶어함 (ex. 게시판 1페이지 10개)
- DB도 `LIMIT`, `OFFSET` 같은 문법으로 일부 데이터만 제공 가능

### 2. JPA Paging의 구성요소

| 구성 요소 | 설명 |
| --- | --- |
| `Pageable` | 요청 페이지 정보 (몇 페이지, 몇 개, 정렬 기준 등) |
| `PageRequest` | `Pageable`의 구현체 (ex. `PageRequest.of(0, 10)`) |
| `Page<T>` | 반환 결과 객체. 현재 페이지 데이터 + 전체 메타데이터 포함 |
| `Slice<T>` | `Page<T>`보다 가벼운 버전. 전체 개수 불필요할 때 사용 |

### 3. PageRequest 사용법

```java
PageRequest pageRequest = PageRequest.of(페이지번호, 페이지크기);

PageRequest.of(0, 10, Sort.by("createdAt").descending());

Sort sort = Sort.by("username").ascending();
Pageable pageable = PageRequest.of(0, 10, sort);

Sort sort = Sort.by("username").descending().and(Sort.by("createdAt").ascending());
```

`PageRequest.of(0, 10)` → 0번째 페이지, 10개씩

※ 페이지 번호는 **0부터 시작**

### 4.  Page<T> 객체의 구성

```java
Page<User> page = userRepository.findAll(PageRequest.of(0, 10));
```

| 메서드 | 설명 |
| --- | --- |
| `getContent()` | 실제 데이터 리스트 반환 (`List<T>`) |
| `getTotalElements()` | 전체 데이터 수 |
| `getTotalPages()` | 전체 페이지 수 |
| `getNumber()` | 현재 페이지 번호 |
| `getSize()` | 페이지 당 아이템 수 |
| `isFirst()` | 첫 번째 페이지인지 여부 |
| `isLast()` | 마지막 페이지인지 여부 |

### 5. 예시

**Repository**

```java
Page<User> findByRole(String role, Pageable pageable);
```

**Service**

```java
public Page<User> getAdminUsers(int page, int size) {
    Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
    return userRepository.findByRole("ADMIN", pageable);
}
```

**Controller**

```java
@GetMapping("/admin/users")
public Page<User> getAdminUsers(@RequestParam int page, @RequestParam int size) {
    return userService.getAdminUsers(page, size);
}
```

프론트에서 `GET /admin/users?page=0&size=10`로 요청

### 6. 기본: 0-based. 프런트에서 1-based로 요청할 경우

프론트가 `page=1`을 주는 경우:

```java
int requestedPage = Math.max(0, page - 1);
Pageable pageable = PageRequest.of(requestedPage, size);
```

# Slice

Slice는 전체 페이지 수를 계산하지 않고 다음 페이지가 있는지만 판단하는 더 가벼운 페이징 방식이다.

### 1. Slice란?

- `Page`와 유사하지만 **전체 개수(count)** 를 구하지 않음
- 현재 페이지 정보 + **다음 페이지 존재 여부만 포함**
- **"더보기" UI**나 **무한 스크롤**에 최적화됨

### 2. Page와 Slice 비교

| 항목 | `Page<T>` | `Slice<T>` |
| --- | --- | --- |
| 전체 개수 계산 | ✅ `SELECT COUNT(*)` 쿼리 실행 | ❌ 실행하지 않음 |
| 다음 페이지 여부 | `hasNext()` | `hasNext()` |
| 총 페이지 수 제공 | `getTotalPages()` 가능 | ❌ 불가능 |
| 메모리/쿼리 부담 | 상대적으로 큼 | 가벼움 |
| UI 적합성 | 페이지 버튼 기반 UI | 더보기, 무한스크롤 UI |

### 3. 예제

**Repository**

```java
Slice<User> findByAgeGreaterThan(int age, Pageable pageable);
```

**Service**

```java
public Slice<User> getUsersOverAge(int age, int page, int size) {
    Pageable pageable = PageRequest.of(page, size, Sort.by("id").descending());
    return userRepository.findByAgeGreaterThan(age, pageable);
}
```

**Controller**

```java
@GetMapping("/users/slice")
public Slice<User> getUserSlice(@RequestParam int page, @RequestParam int size) {
    return userService.getUsersOverAge(20, page, size);
}
```

### 4. Slice 동작 방식

- `size + 1` 개를 요청해서 다음 페이지 존재 여부 판단
    - ex) `PageRequest.of(0, 10)` → 실제로는 최대 11개까지 조회
- `hasNext()`가 true면 다음 페이지 존재함
- 내부적으로 `LIMIT size+1` 방식으로 동작

### 5. Slice 메서드

| 메서드 | 설명 |
| --- | --- |
| `getContent()` | 현재 페이지 데이터 (`List<T>`) |
| `hasNext()` | 다음 페이지가 존재하는지 여부 |
| `getNumber()` | 현재 페이지 번호 |
| `getSize()` | 요청한 페이지 크기 |
| `getNumberOfElements()` | 현재 페이지에 조회된 데이터 수 |

### Page와 Slice가 코드에서 사용되는 구조가 비슷한 것 같다…쿼리만 다른 것인가?

`Page`와 `Slice`는 **코드 구조(메서드 시그니처나 Pageable 사용법 등)는 거의 동일**하지만, **실제로 JPA가 실행하는 쿼리가 다르다**는 점에서 차이가 있다.

### 코드 구조: 거의 동일

**공통 사용법 예시 (`Pageable` 사용)**

```java
Pageable pageable = PageRequest.of(0, 10, Sort.by("createdAt").descending());

// Page
Page<User> pageResult = userRepository.findAll(pageable);

// Slice
Slice<User> sliceResult = userRepository.findByActiveTrue(pageable);
```

- 둘 다 `Pageable`을 받아서 `PageRequest.of()`로 생성
- 반환 타입만 `Page`냐 `Slice`냐 차이 있음

### 쿼리 구조

| 반환 타입 | 실행되는 쿼리 내용 |
| --- | --- |
| **Page** | 1. `SELECT ... LIMIT ... OFFSET ...`   2. `SELECT COUNT(*) FROM ...` (총 개수 계산) |
| **Slice** | `SELECT ... LIMIT size + 1 OFFSET ...`   (다음 페이지 존재 여부 판단만 수행) |

### 예를 들어:

- `Page<User>`일 경우:

    ```sql
    SELECT * FROM users ORDER BY created_at DESC LIMIT 10 OFFSET 0;
    SELECT COUNT(*) FROM users;  ← 추가로 한 번 더 실행됨
    
    ```

- `Slice<User>`일 경우:

    ```sql
    SELECT * FROM users ORDER BY created_at DESC LIMIT 11 OFFSET 0;
    
    ```


※ `LIMIT 11`로 가져와서 `hasNext()` 판단 후 앞 10개만 리턴

### 정리

| 구분 | Page | Slice |
| --- | --- | --- |
| 코드 사용 방식 | 동일 (`Pageable` 전달) | 동일 (`Pageable` 전달) |
| 반환 객체 | Page | Slice |
| 쿼리 차이 | COUNT 포함 2번 쿼리 | LIMIT+OFFSET 1번 쿼리 (size+1 사용) |
| 목적 | 전체 수와 페이지 수 필요할 때 | 다음 페이지 여부만 필요할 때 |

# 0-based, 1-based

Spring Data JPA에서 페이징(Paging) 을 구현할 때, 핵심적으로 사용하는 `PageRequest.of(page, size)`의 `page` 값은 0-based이다.

반면, 프론트엔드 UI는 보통 1-based를 사용하므로 이 사이에 변환이 필요하다.

### 사용 위치에 따른 기준

| 위치 | 기준 | 설명 |
| --- | --- | --- |
| **Spring 내부** | 0-based | `PageRequest.of(0, 10)` → 첫 페이지 |
| **프론트엔드 (UI)** | 1-based | 사용자에게는 `page=1`이 첫 페이지로 보임 |
| **DB LIMIT OFFSET** | 0-based | OFFSET 0이 첫 레코드부터 |

### 왜 변환이 필요한가?

프론트에서 `page=1`을 넘기면 Spring에서는 1번째가 아닌 2번째 페이지로 해석됨.

→ **1-based → 0-based 변환 필요**

### 실전 코드 예시

**Controller에서 변환**

```java
@GetMapping("/users")
public Page<User> getUsers(@RequestParam(defaultValue = "1") int page,
                           @RequestParam(defaultValue = "10") int size) {
    int zeroBasedPage = Math.max(0, page - 1);
    Pageable pageable = PageRequest.of(zeroBasedPage, size);
    return userService.findAll(pageable);
}

```

### 변환 없이 사용하면 생기는 문제

프론트가 `page=1`로 보냈는데, Spring에서 2번째 페이지로 해석되어

→ 데이터가 11~20번째부터 나오는 문제 발생 가능

### 해결 방법 요약

| 방법 | 설명 |
| --- | --- |
| Controller에서 `page - 1` | 가장 기본적이고 흔한 방식 |
| 커스텀 어노테이션 + ArgumentResolver | 재사용 가능한 구조화된 방식 |
| 프론트에서 0-based로 보냄 | API 설계 시 사전 합의 필요 |

### 커스텀 어노테이션과 `HandlerMethodArgumentResolver`

### 목표

- `@Page`라는 커스텀 어노테이션을 만들어서 프론트에서 `page=1`을 넘겨도 서버에서 자동으로 `page=0`으로 처리되게 함
- 0 이하 값은 예외 처리도 포함

### 1. 커스텀 어노테이션 정의

```java
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
public @interface Page {
}

```

### 2. 커스텀 리졸버 구현

```java
@Component
public class PageArgumentResolver implements HandlerMethodArgumentResolver {

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.getParameterAnnotation(Page.class) != null
               && parameter.getParameterType() == Integer.class;
    }

    @Override
    public Object resolveArgument(MethodParameter parameter,
                                  ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest,
                                  WebDataBinderFactory binderFactory) {
        String pageStr = webRequest.getParameter("page");
        int page = 0; // 기본값

        try {
            if (pageStr != null) {
                int parsed = Integer.parseInt(pageStr);
                if (parsed < 1) {
                    throw new IllegalArgumentException("Page number must be >= 1");
                }
                page = parsed - 1; // 1-based → 0-based 변환
            }
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid page format");
        }

        return page;
    }
}

```

### 3. WebMvcConfigurer에 등록

```java
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
        resolvers.add(new PageArgumentResolver());
    }
}

```

### 4. Controller에서 사용

```java
@GetMapping("/users")
public Page<User> getUsers(@Page Integer page,
                           @RequestParam(defaultValue = "10") int size) {
    Pageable pageable = PageRequest.of(page, size);
    return userService.findAll(pageable);
}

```

### 동작 요약

- 클라이언트가 `?page=1`을 보냄
- `@Page` 어노테이션이 있는 파라미터는 `PageArgumentResolver`가 처리
- 내부에서 `page - 1` 처리되어 0-based로 변환
- 0 미만이면 예외 발생

# 객체 그래프 탐색

## 객체 그래프

객체 그래프(Object Graph)는 **엔티티 간의 관계를 통해 연결된 전체 구조**를 의미한다.

JPA에서는 테이블이 아니라 객체를 중심으로 데이터베이스를 다루기 때문에, 이 객체들이 서로 연결되어 **그래프처럼 구성되는 것**이 바로 객체 그래프이다.

### 객체 그래프란?

- **객체(Object)**: Java의 클래스 인스턴스 (ex. `Member`, `Order`, `Item` 등)
- **그래프(Graph)**: 노드(객체)와 간선(연관 관계)의 집합
- 즉, **연관된 객체들을 따라가며 전체 구조를 트리 혹은 그래프로 보는 것**

---

### 예시 구조

```java
@Entity
class Member {
    @OneToMany(mappedBy = "member")
    private List<Order> orders;
}

@Entity
class Order {
    @ManyToOne
    private Member member;

    @OneToMany(mappedBy = "order")
    private List<OrderItem> orderItems;
}

@Entity
class OrderItem {
    @ManyToOne
    private Order order;

    @ManyToOne
    private Item item;
}

```

위 구조는 다음과 같은 **객체 그래프**를 이룸:

```
Member
 └── Order1
      ├── OrderItem1 → Item1
      └── OrderItem2 → Item2
 └── Order2
      └── OrderItem3 → Item3

```

### 객체 그래프의 특징

| 특징 | 설명 |
| --- | --- |
| 트리 또는 그래프 구조 | 엔티티들이 연관관계를 통해 계층적으로 연결됨 |
| **양방향 연관 관계** 포함 가능 | 객체 A → B 뿐만 아니라 B → A도 가능 |
| **탐색 가능성** 중심 | 객체에서 다른 객체로 참조를 통해 이동 가능 |
| JPA의 **지연 로딩**, **즉시 로딩** 전략과 밀접 |  |

### 객체 그래프가 중요한 이유

1. **DB JOIN 없이 객체 접근 가능**

   → `order.getMember().getName()`처럼 객체 간 참조로 데이터에 접근

2. **비즈니스 로직이 객체 중심으로 구성 가능**

   → 객체 설계에 따라 데이터 흐름 구조도 달라짐

3. **N+1 문제** 발생 위치를 파악할 수 있음

   → 그래프 상에서 어떤 지점을 탐색하느냐에 따라 성능 문제 발생

4. **직렬화/REST 응답 구조 설계 시 고려됨**

   → 순환 참조, 깊은 탐색에 따른 JSON 무한 루프 문제 발생 가능


### 요약

- 객체 그래프는 연관관계를 통해 연결된 엔티티들의 구조
- 데이터베이스의 조인과 유사하지만 객체 중심
- 탐색 방법과 로딩 전략에 따라 성능과 안정성에 큰 영향
- 설계 시 객체 간 관계의 깊이와 방향을 잘 설정하는 것이 중요

## 객체 그래프 탐색

Spring Data JPA에서 말하는 **"객체 그래프 탐색(Object Graph Traversal)"** 은 엔티티 간의 연관관계를 **객체를 통해 순차적으로 따라가면서 접근하는 행위**를 의미한다.

### 객체 그래프 탐색이란?

- `Order` 객체에서 `Member` 객체로 이동하면서 **연관된 객체를 탐색하는 것**

```java
String name = order.getMember().getName(); // 탐색 발생
```

### 로딩 방식과의 관계

객체 그래프 탐색은 **JPA의 Fetch 전략**에 따라 동작 방식이 달라진다.

| 전략 | 설명 | 탐색 시 동작 |
| --- | --- | --- |
| `EAGER` | 즉시 로딩 | `Order`를 조회할 때 `Member`도 함께 조회 (join) |
| `LAZY` | 지연 로딩 | `getMember()` 호출 시 SQL 추가 실행됨 |

### 관련 문제

**1. N+1 문제**

- 루프 안에서 객체 그래프 탐색 시, **각 객체마다 추가 쿼리 발생**

```java
List<Order> orders = orderRepository.findAll();
for (Order o : orders) {
    System.out.println(o.getMember().getName());  // N개의 쿼리 추가
}

```

**2. LazyInitializationException**

- `LAZY` 로딩된 필드를 영속성 컨텍스트 종료 후 접근 시 에러 발생

### 해결 방법

| 방법 | 설명 |
| --- | --- |
| `fetch join` | JPQL에서 `join fetch`로 연관 객체 미리 로딩 |
| `@EntityGraph` | 쿼리 메서드에 그래프 탐색 명시 |
| DTO 직접 조회 | 필요한 필드만 `select new`로 추출 |
| 양방향 관계 정리 | 순환 탐색, 직렬화 문제 방지 |

### 요약

- 객체 그래프 탐색은 `order.getMember().getName()`처럼 연관된 객체를 따라가는 것
- 로딩 전략에 따라 SQL 실행 시점이 달라짐
- 잘못 사용하면 성능 문제(N+1), 예외 발생(LazyInit) 등 발생