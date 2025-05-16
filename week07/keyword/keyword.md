# RestControllerAdvice

### **@RestControllerAdvice란?**

`@RestControllerAdvice`는 Spring Framework에서 **REST API 전용 전역 예외 처리 클래스**를 만들 때 사용하는 어노테이션

**정의**

> @RestControllerAdvice = @ControllerAdvice + @ResponseBody
>
- `@ControllerAdvice`: 전역 예외 처리 클래스
- `@ResponseBody`: return 값을 JSON 또는 XML로 변환

---

**역할**

1. **전역 예외 처리**
    - 컨트롤러에서 발생한 예외를 한 곳에서 처리
2. **일관된 응답 포맷 유지**
    - API 응답을 공통 형식(`ApiResponse`, `ErrorDTO` 등)으로 반환
3. **코드 중복 제거**
    - 모든 컨트롤러에서 예외 처리 반복 안 해도 됨

---

### 장점

1. **전역 예외 처리**
- 컨트롤러마다 예외 처리 코드를 반복하지 않고 한 곳에서 관리 가능
- 코드 중복 제거 → 깔끔하고 간결한 컨트롤러 유지

---

2. **응답 형식의 일관성 유지**

- 에러 발생 시에도 `ApiResponse`, `ErrorDTO` 등으로 항상 **일관된 JSON 구조** 제공 가능

  → 프론트엔드에서 처리 로직 단순화


---

3. **컨트롤러 코드와 예외 로직 분리 (관심사 분리, SoC)**

- 컨트롤러는 요청/응답에만 집중
- 예외 처리 로직은 Advice에서 전담 → 유지보수 편리

---

4. **유연한 적용 범위 설정**

- 특정 패키지, 어노테이션, 타입만 처리하도록 범위 제한 가능

  예: `@RestControllerAdvice(basePackages = "com.example.api")`


---

5. **스프링이 기본 제공하는 예외도 오버라이드 가능**

- `ResponseEntityExceptionHandler`를 상속하면

  `handleMethodArgumentNotValid` 등 기본 예외 처리도 커스터마이징 가능


---

6. **로깅, 에러 추적, AOP 활용에 유리**

- 에러 로깅, 슬랙/디스코드 알림, 추적 코드 삽입 등

  부가 기능을 한 곳에서 관리 가능


### **Advice란?**

RestControllerAdvice도 Advice의 한 종류이다.

> “ **언제, 어떤 부가적인 로직을** 핵심 로직 외부에서 끼워 넣을지 정의한 코드 조각"
>

즉, **핵심 비즈니스 로직을 건드리지 않고도**, **로깅, 예외 처리, 트랜잭션, 보안** 같은 부가기능을 외부에서 "끼워넣는" 방식이다.

# lombok
Lombok은 Java에서 반복적인 코드(boilerplate code)를 줄이기 위해 사용하는 라이브러리. 

주로 Getter, Setter, toString, 생성자, Builder 패턴 등을 어노테이션으로 간단하게 작성할 수 있게 도와줌.

| 어노테이션 | 설명 |
| --- | --- |
| `@Getter` / `@Setter` | 필드의 getter/setter 자동 생성 |
| `@ToString` | toString 메서드 자동 생성 |
| `@EqualsAndHashCode` | equals/hashCode 메서드 생성 |
| `@NoArgsConstructor` | 기본 생성자 생성 |
| `@AllArgsConstructor` | 모든 필드 생성자 생성 |
| `@RequiredArgsConstructor` | final 필드/nonnull 필드만 생성자에 포함 |
| `@Builder` | 빌더 패턴 자동 생성 |
| `@Data` | `@Getter`, `@Setter`, `@ToString`, `@EqualsAndHashCode`, `@RequiredArgsConstructor` 포함 |

# DTO

DTO는 계층 간 데이터 전달을 목적으로 하는 객체로, 주로 Controller ↔ Service ↔ Client 사이에서 사용

### DTO의 특징

- 엔티티와 분리되어 있어 보안, 유지보수성 향상
- 필요한 필드만 포함 → 네트워크 낭비 줄임
- validation 어노테이션(@NotNull, @Size 등) 부착 가능

### 그럼 dto 패키지는 데이터를 가공하는 거야?

아니, `dto` 패키지 자체는 데이터를 가공하지 않는다. DTO 클래스는 데이터를 "운반"하기 위한 그릇 역할만 한다.

### 핵심 정리

- DTO 클래스는 데이터를 담는 역할만 함 → "데이터를 가공하는 책임은 없음"
- 데이터를 가공하는 책임은 보통 `Service` 계층이 가짐
- `dto` 패키지 안에는 보통 순수 필드와 getter/setter만 있음

### 그럼 repository와 다른 것이 무엇인가?

| 항목 | DTO | Repository |
| --- | --- | --- |
| **역할** | 데이터 "운반"용 객체 | DB 접근을 위한 인터페이스 |
| **위치** | `dto` 패키지 | `repository` 패키지 |
| **행위** | 아무 행위도 하지 않음 (보통 필드와 getter/setter만) | DB에서 데이터를 조회/저장/삭제 등의 로직 수행 |
| **예시** | `UserResponseDto`, `LoginDto` | `UserRepository extends JpaRepository<User, Long>` |
| **책임** | 계층 간 전달에 필요한 데이터 포맷 정의 | Entity에 대한 CRUD를 DB와 연결해 처리 |
- DTO는 데이터의 형태를 정의하는 객체, Repository는 데이터를 어디서 어떻게 가져올지를 정의하는 객체
- DTO는 말 그대로 "데이터를 어떤 형식으로 전달할지"를 정의하는 틀(형식, 구조)

# 빌더 패턴

빌더 패턴(Builder Pattern)은 복잡한 객체를 단계적으로 만들 수 있게 해주는 생성 디자인 패턴

특히 생성자에 파라미터가 너무 많아지거나, 선택적 필드가 많을 때 유용하게 쓰임

- 필드가 많아서 생성자나 setter로 만들기 복잡할 때
- 필수/선택 필드를 명확히 구분하고 싶을 때
- 가독성과 유지보수성이 중요한 객체 생성에 사용

| 장점 | 설명 |
| --- | --- |
| 가독성 ↑ | 어떤 값을 설정했는지 코드로 한눈에 확인 가능 |
| 안정성 ↑ | 빌더에만 setter를 열어두면 불변 객체로도 활용 가능 |
| 유연성 ↑ | 선택적 파라미터 처리에 유리함 |

---

## 예시 (Lombok 사용 X)

```java
public class User {
    private String username;
    private int age;
    private String email;

    private User(Builder builder) {
        this.username = builder.username;
        this.age = builder.age;
        this.email = builder.email;
    }

    public static class Builder {
        private String username;
        private int age;
        private String email;

        public Builder username(String username) {
            this.username = username;
            return this;
        }

        public Builder age(int age) {
            this.age = age;
            return this;
        }

        public Builder email(String email) {
            this.email = email;
            return this;
        }

        public User build() {
            return new User(this);
        }
    }
}

```

### 사용

```java
User user = new User.Builder()
                .username("홍길동")
                .age(25)
                .email("hong@example.com")
                .build();

```

---

## Lombok 사용 시 (매우 간단)

```java
@Builder
public class User {
    private String username;
    private int age;
    private String email;
}

```

### 사용

```java
User user = User.builder()
                .username("홍길동")
                .age(25)
                .email("hong@example.com")
                .build();

```
