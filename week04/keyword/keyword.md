## 의존성 주입(Dependency Injection)

**Spring Boot에서 의존성 주입(Dependency Injection)이 뭐야?**

- 애플리케이션의 구성 요소들이 서로 의존하는 관계를 설정하고 관리하는 방식. 이를 통해 객체 간의 결합도를 낮추고, 유연하고 테스트 가능한 코드 작성 가능.

**Bean? 어노테이션? 그게 뭐야?**

- Spring에서 객체는 빈(Bean) 이라는 이름으로 관리됨. Spring 빈은 Spring IoC(Inversion of Control) 컨테이너가 생성하고 관리하는 객체. 이러한 객체들은 애플리케이션의 다양한 기능을 담당하며, 의존성 주입(Dependency Injection)을 통해 다른 빈들과 상호작용함.

**Spring Boot에서 객체는?**

- Spring Boot에서 객체는 주로 빈(bean) 또는 컴포넌트(component)라고 불림. Spring에서는 객체를 관리하고, 이러한 객체 간의 의존성을 자동으로 처리하여 애플리케이션의 구조를 효율적이고 유연하게 만듦.

**Spring Boot에서 class는 객체인데 이 class를 Bean으로 관리한다는 건가?**

- Spring Boot에서 클래스는 객체의 설계도이자 템플릿 역할. 그리고 이 클래스를 Bean으로 관리한다고 할 때, Spring IoC (Inversion of Control) 컨테이너가 해당 클래스의 인스턴스를 생성하고 관리. 즉, 클래스를 정의하면, Spring이 자동으로 그 클래스를 인스턴스화하고, 필요한 의존성을 주입.
- Spring에서 Bean은 Spring IoC 컨테이너에 의해 관리되는 객체를 의미. 쉽게 말해, Bean은 Spring 애플리케이션에서 Spring 컨테이너가 관리하는 클래스의 인스턴스.

**객체와 Bean의 차이**

- **클래스**는 객체의 **설계도**. 클래스를 통해 객체가 만들어짐.
- **객체**는 클래스의 **인스턴스**. 예를 들어, **MyCalss**라는 클래스를 통해 **MyClass**객체가 만들어짐.

  ### ⇒ class가 정의되면 Bean은 정의된 class로 객체를 생성하고, 그 객체를 관리하는 구나!!!

- **Spring Bean**은 **Spring IoC 컨테이너가 관리하는 객체**. 즉, Spring Boot에서 Bean으로 등록되면, 해당 객체는 Spring이 관리하는 객체로 간주.

**이렇게 만들어진 객체에 Bean을 통해 의존성을 주입하게 되면 어떻게 되?**

- 의존성 주입이 이루어지면, 해당 객체는 주입된 의존성을 활용할 수 있게 됨. 예를 들어, `MyService` 객체는 `MyComponent` 객체를 주입받아 `MyComponent`의 기능을 활용.
- 의존성 주입 후 객체의 상태 변화:
    - `MyService` 객체는 `MyComponent` 객체의 `printMessage()` 메서드를 사용할 수 있게 됨.
    - `MyComponent`의 상태나 기능을 `MyService`가 이용할 수 있으므로, `MyService`의 동작이 **`MyComponent`에 의존**.
    - 이로 인해 `MyService`는 `MyComponent`가 가진 기능을 활용하여 자신의 작업을 수행.

---

## 의존성 주입(Dependency Injection)

Spring Boot에서 의존성 주입(Dependency Injection, DI)은 애플리케이션의 구성 요소들이 서로 의존하는 관계를 설정하고 관리하는 방식입니다. 이를 통해 객체 간의 결합도를 낮추고, 유연하고 테스트 가능한 코드 작성이 가능합니다.

### 1. 생성자 주입(Constructor Injection)

생성자 주입은 의존성을 클래스의 생성자를 통해 주입하는 방법입니다. 이는 **불변성**을 보장하고, 의존성이 반드시 필요하다는 것을 명확히 나타내므로 권장되는 방법입니다.

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyService {

    private final MyRepository myRepository;

    @Autowired
    public MyService(MyRepository myRepository) {
        this.myRepository = myRepository;
    }

    public void performTask() {
        myRepository.saveData();
    }
}

```

### 2. 필드 주입(Field Injection)

필드 주입은 클래스의 필드에 `@Autowired` 어노테이션을 사용하여 의존성을 주입하는 방법입니다. 코드가 간단하지만, 테스트가 어려워지는 단점이 있습니다.

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyService {

    @Autowired
    private MyRepository myRepository;

    public void performTask() {
        myRepository.saveData();
    }
}

```

### 3. 세터 주입(Setter Injection)

세터 주입은 클래스의 세터 메서드를 통해 의존성을 주입하는 방법입니다. 필드에 직접 접근하지 않고 메서드를 통해 주입을 받습니다. 이는 선택적인 의존성에 유용할 수 있습니다.

```java
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MyService {

    private MyRepository myRepository;

    @Autowired
    public void setMyRepository(MyRepository myRepository) {
        this.myRepository = myRepository;
    }

    public void performTask() {
        myRepository.saveData();
    }
}

```

### 의존성 주입을 활용한 자동화

Spring Boot에서는 `@Autowired` 어노테이션을 통해 의존성 주입을 자동으로 처리합니다. `@Service`, `@Component`, `@Repository`, `@Controller`와 같은 스프링의 특수 어노테이션을 사용하여 컴포넌트를 정의하면, 스프링 컨테이너가 해당 클래스의 인스턴스를 자동으로 관리하고 의존성을 주입합니다.

## IoC(Inversion Of Control, 제어의 역전)

Spring Boot에서의 Inversion of Control (IoC)는 Spring 프레임워크의 핵심 개념 중 하나로, 객체의 생성과 의존성 관리를 **Spring IoC 컨테이너**가 담당하게 합니다. 즉, 객체의 생성과 의존성 주입이 Spring이 관리하게 되어 개발자가 직접 객체를 생성하고 의존성을 주입하는 작업을 하지 않아도 됩니다.

Spring Boot에서는 IoC를 통해 애플리케이션에서 객체 간의 의존성을 유연하고 효율적으로 관리할 수 있습니다. **Spring IoC 컨테이너**는 객체의 생명주기와 의존성 주입을 자동으로 처리하여 개발자가 애플리케이션의 비즈니스 로직에 집중할 수 있도록 도와줍니다.

### Spring IoC의 핵심 개념

1. **빈(Bean) 관리**:
    - Spring IoC 컨테이너는 Spring 애플리케이션에서 사용되는 **빈** 객체들을 관리합니다. 빈은 Spring이 관리하는 객체로, `@Component`, `@Service`, `@Repository`, `@Controller`와 같은 어노테이션을 사용하여 등록됩니다.
    - 이러한 빈들은 Spring이 **자동으로 생성하고 관리**하며, 필요한 의존성도 자동으로 주입합니다.
2. **의존성 주입(Dependency Injection, DI)**:
    - IoC의 중요한 개념은 **의존성 주입**입니다. 즉, 객체가 다른 객체를 **직접 생성하거나 관리하지 않고**, 외부에서 필요한 객체를 주입받는 방식입니다. 이를 통해 객체 간 결합도를 낮추고, 테스트 가능하고 유연한 코드를 작성할 수 있습니다.
    - Spring에서는 생성자 주입, 필드 주입, 세터 주입 등의 방법을 사용해 의존성을 주입할 수 있습니다.
3. **컨테이너**:
    - Spring IoC 컨테이너는 빈을 **생성하고 관리**하는 역할을 합니다. 이 컨테이너는 빈의 생명주기, 의존성 주입, 그리고 애플리케이션의 다양한 설정들을 처리합니다.
    - Spring에서는 두 가지 주요 IoC 컨테이너를 제공합니다:
        - **BeanFactory**: 초기화가 지연되는 경량 IoC 컨테이너 (일반적으로 Spring에서는 사용되지 않음)
        - **ApplicationContext**: 더 강력한 기능을 제공하며, 대부분의 Spring 애플리케이션에서 사용됩니다.

### Spring IoC의 작동 방식

1. **빈 등록**:
    - 애플리케이션에서 사용할 객체들을 `@Component`, `@Service`, `@Repository`, `@Controller` 등으로 어노테이션을 사용하여 **빈으로 등록**합니다.
    - Spring Boot는 이러한 어노테이션이 붙은 클래스를 자동으로 탐지하여 **빈으로 등록**하고 관리합니다.
2. **빈 생성 및 의존성 주입**:
    - Spring IoC 컨테이너는 애플리케이션 시작 시에 **빈을 생성**합니다.
    - 각 빈은 **의존성 주입**을 통해 다른 빈을 필요에 맞게 자동으로 주입받습니다.
    - 의존성 주입은 **생성자 주입**, **세터 주입**, **필드 주입** 등을 통해 이루어집니다.

---

## 프레임워크와 API의 차이

**프레임워크**

프레임워크는 이미 만들어져있는 뼈대 프로젝트를 개발에 사용하는 것이다. 일반적으로 프로젝트에 필요한 기능이 포함되어 있어서 프로젝트를 간편하게 시작할 수 있다. 여기에 원하는 라이브러리나 기능을 추가하여 개발을 진행할 수 있다.

**API**

API는 Application Programming Interface로 어떤 기능이 이미 구현되어 제공된다.

예를 들어 네이버 지도 API를 사용하면 따로 지도 기능을 개발하지 않고도 지도 기능을 사용할 수 있다.

제공되는 API를 사용하여 원하는 기능을 구현할 수 있다.

---

## AOP(Aspects-Oriented Programming)

AOP는 **Aspect-Oriented Programming**으로 여러 프로그램들의 공통된 부분을 모듈화하는 방법이다.

로깅, 트랜잭션 관리, 보안과 같은 여러 프로그램에서 자주 사용되는 기능을 한 곳에서 처리할 수 있다.

메소드나 객체의 기능을 핵심 관심사(Core Concern)와 공통 관심사(Cross-cutting Concern)로 나누어 프로그래밍하는 것을 말한다.

여러 개의 클래스에서 반복해서 사용하는 코드가 있다면 해당 코드를 모듈화 하여 공통 관심사로 분리한다. 이렇게 분리한 공통 관심사를 Aspect로 정의하고 Aspect를 적용할 메소드나 클래스에 Advice를 적용하여 공통 관심사와 핵심 관심사를 분리할 수 있다. 이렇게 AOP에서는 공통 관심사를 별도의 모듈로 분리하여 관리하며, 이를 통해 코드의 재사용성과 유지 보수성을 높일 수 있다.

**Spring AOP란?**

- Spring AOP는 스프링 프레임워크에서 제공하는 기능 중 하나로 관점 지향 프로그래밍을 지원하는 기술이다.

Spring AOP는 로깅, 보안, 트랜잭션 관리 등과 같은 공통적인 관심사를 모듈화 하여 코드 중복을 줄이고 유지 보수성을 향상하는데 도움을 줍니다.

https://adjh54.tistory.com/133

---

## 서블릿

서블릿(Servlet)은 서버 측 기술로, 클라이언트의 요청을 처리하고 동적인 웹 페이지를 생성하는 역할을 한다. 서블릿은 주로 **Java 기반의 웹 서버**나 **애플리케이션 서버**에서 실행되며, **HTTP 요청**을 처리하고 **HTTP 응답**을 생성하는 데 사용됩니다.

서블릿은 **HTTP 프로토콜**을 기반으로 동작하며, **서버와 클라이언트** 간의 상호작용을 처리하는 중요한 역할을 한다. 서블릿을 사용하면 클라이언트의 요청에 따라 동적으로 콘텐츠를 생성하거나, 데이터베이스와 상호작용하는 등의 작업을 수행할 수 있다.

### 서블릿의 주요 개념

1. **서블릿 컨테이너(Servlet Container)**:
    - 서블릿은 **서블릿 컨테이너**(또는 **서블릿 엔진**)에서 실행된다. 서블릿 컨테이너는 서블릿의 생명주기를 관리하고, 클라이언트의 요청을 서블릿에 전달하며, 서블릿에서 생성된 응답을 클라이언트로 반환한다.
2. **요청과 응답**:
    - 클라이언트(일반적으로 웹 브라우저)가 서버에 **HTTP 요청**을 보내면, 서블릿은 이 요청을 처리하고, 그에 맞는 **HTTP 응답**을 생성하여 클라이언트에게 전송한다.
    - 서블릿은 **HttpServletRequest** 객체를 사용하여 요청 데이터를 받으며, **HttpServletResponse** 객체를 사용하여 응답을 보낸다.
3. **서블릿의 생명주기**:
    - **서블릿 초기화(init)**: 서블릿 객체가 생성되면 한 번만 호출된다. 서블릿의 초기화 작업을 처리할 수 있다.
    - **요청 처리(service)**: 클라이언트 요청을 처리하는 메서드가 호출된다. 이 메서드는 매 요청마다 호출된다.
    - **서블릿 종료(destroy)**: 서블릿이 더 이상 필요 없을 때 호출되며, 리소스 해제 등의 종료 작업을 수행한다.

### 서블릿의 작동 방식

1. 클라이언트가 **HTTP 요청**을 보냅니다.
2. 서블릿 컨테이너는 요청을 해당 서블릿에 전달합니다.
3. 서블릿은 **doGet()** 또는 **doPost()** 메서드를 호출하여 요청을 처리합니다.
4. 서블릿은 처리 결과를 **HTTP 응답**으로 생성하여 클라이언트에게 반환합니다.

### 서블릿의 장점과 단점

### 장점:

1. **서블릿은 서버 측에서 실행**되므로, 클라이언트 측의 환경에 구애받지 않고 일관된 동작을 보장할 수 있다.
2. **성능**: 서블릿은 **멀티스레드** 방식으로 작동하므로, 하나의 서블릿에서 여러 요청을 동시에 처리할 수 있다. 이는 성능 향상에 도움이 된다.
3. **동적 콘텐츠 생성**: 서블릿은 서버에서 동적으로 콘텐츠를 생성할 수 있어, **동적인 웹 페이지**를 만들 수 있다.
4. **확장성**: 서블릿은 자바 언어를 사용하여 다양한 기능을 확장하고 수정할 수 있어, 유연성이 뛰어나다.

### 단점:

1. **복잡성**: 서블릿을 사용하여 웹 애플리케이션을 구축하는 것은 비교적 복잡할 수 있다. 특히 UI와 로직을 분리하려면 추가적인 작업이 필요하다.
2. **화면 구성 분리 어려움**: 서블릿은 주로 **비즈니스 로직**을 처리하는 데 집중되므로, 화면 구성과 비즈니스 로직이 결합되기 쉽다. 이를 해결하기 위해 **JSP**(JavaServer Pages)와 함께 사용되곤 한다.