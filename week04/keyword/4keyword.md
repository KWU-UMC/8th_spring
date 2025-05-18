
# 📦 Spring 핵심 개념 정리

## 🔧 DI (Dependency Injection, 의존성 주입)

**의존성 주입(DI)**은 객체 간의 의존 관계를 코드 내부에서 직접 생성하지 않고, 외부에서 주입하는 방식입니다.  
Spring에서는 객체가 생성자 인수, 메서드 호출, 또는 객체 인스턴스의 속성을 설정하는 방식으로 의존성을 주입합니다.

Spring IoC 컨테이너는 애플리케이션 실행 시점에 **빈(Bean)**을 생성하면서 필요한 의존성을 자동으로 주입합니다.

---

### ✅ DI 방식 3가지

#### 1. 생성자 주입 (Constructor Injection)

- 생성자 매개변수로 의존성을 주입
- 불변성 보장, 테스트 용이
- 예시:
  ```java
  @Component
  public class OrderService {
      private final UserRepository userRepository;

      @Autowired
      public OrderService(UserRepository userRepository) {
          this.userRepository = userRepository;
      }
  }
  ```

#### 2. Setter 주입 (Setter Injection)

- setter 메서드를 통해 의존성 주입
- 필수 의존성 강제 불가
- 예시:
  ```java
  @Component
  public class OrderService {
      private UserRepository userRepository;

      @Autowired
      public void setUserRepository(UserRepository userRepository) {
          this.userRepository = userRepository;
      }
  }
  ```

#### 3. 필드 주입 (Field Injection)

- 필드에 직접 `@Autowired`를 붙여 주입
- 테스트/유지보수 어려움, 순환 참조 문제 가능
- 예시:
  ```java
  @Component
  public class OrderService {
      @Autowired
      private UserRepository userRepository;
  }
  ```

---

## 🧭 IoC (Inversion of Control, 제어의 역전)

**IoC**는 객체의 생성과 관리를 개발자가 아닌 프레임워크(SPRING 등)에게 맡기는 방식입니다.  
Spring IoC 컨테이너는 **객체 생성, 생명주기 관리, 의존성 주입** 등을 자동으로 처리합니다.

### IoC 작동 순서

1. 객체(Class)를 정의
2. 객체 간 의존성 관계를 어노테이션 또는 설정 파일로 정의
3. IoC 컨테이너가 관계 정보를 바탕으로 객체를 생성하고 주입

---

## 📚 프레임워크와 API의 차이

| 항목       | 프레임워크                                       | API                                           |
|------------|--------------------------------------------------|-----------------------------------------------|
| 정의       | 프로그램의 뼈대를 제공하는 코드 구조              | 소프트웨어 간 상호작용을 위한 명세/집합       |
| 제어 흐름  | 프레임워크가 흐름을 제어                          | 사용자가 직접 필요한 기능 호출                |
| 비유       | 집의 설계도나 뼈대                                 | 집을 짓는 도구(함수, 메서드, 클래스 등)       |
| 예시       | Spring, Django, React 등                         | Java API, DOM API, REST API 등               |

---

## 🧩 AOP (Aspect-Oriented Programming)

**AOP**는 핵심 로직과 부가 기능(공통 관심사)을 분리하여 코드 중복을 줄이고 유지보수성을 향상시키는 기법입니다.

- **사용 예시:** 로깅, 트랜잭션 관리, 예외 처리 등
- **Spring AOP 어노테이션:** `@Aspect`, `@Before`, `@After`, `@Around` 등

---

## 🌐 서블릿 (Servlet)

**Servlet**은 자바 기반 웹 애플리케이션에서 클라이언트의 요청을 처리하고 응답을 생성하는 핵심 컴포넌트입니다.

- HTTP 요청을 받아 로직 처리 후 응답 생성
- Spring에서는 **DispatcherServlet**이 중심 역할 수행
