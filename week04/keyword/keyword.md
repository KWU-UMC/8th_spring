## 🎯핵심 키워드

---

<aside>
💡 주요 내용들에 대해 조사해보고, 자신만의 생각을 통해 정리해보세요!
레퍼런스를 참고하여 정의, 속성, 장단점 등을 적어주셔도 됩니다.
조사는 공식 홈페이지 **Best**, 블로그(최신 날짜) **Not Bad**

</aside>

- **DI**

  ### **의존성 주입 = Dependency Injection = DI**

  의존성이란 **파라미터나 리턴값 또는 지역변수 등으로 다른 객체를 참조하는 것(부품의 개념)**

  Spring Bean(Controller, Service, Repository)를 스프링 컨테이너에서 관리하게 된다.

  ### 의존성 주입 방법

    - **생성자 주입(가장 권장하는 방식)**
        - 생성자를 통해 의존관계를 주입받는 방법, 기존 자바 코드와 다른 점 없음
            - @Autowired 어노테이션을 붙이는 것이 정석이나, 생성자가 1개인 경우 생략 가능

        ```jsx
        @Service
        public class StationConstructorService {
            private final StationRepository stationRepository;
        
            @Autowired
            public StationConstructorService(final StationRepository stationRepository) {
                this.stationRepository = stationRepository;
            }
        
            public String sayHi() {
                return stationRepository.sayHi();
            }
        }
        ```

    - **setter 주입**
        - 필드의 값을 변경하는 setter에 의존성을 주입하는 방식
            - 변경 가능성이 있을때 사용
            - 생성자 호출 후 변수 변경이 일어나야하므로 final 붙일 수 없음.

        ```jsx
        @Service
        public class StationSetterService {
            private StationRepository stationRepository;
        
            @Autowired
            public void setStationRepository(final StationRepository stationRepository) {
                this.stationRepository = stationRepository;
            }
        
            public String sayHi() {
                return stationRepository.sayHi();
            }
        }
        ```

    - 필드 주입 **(사용하지 않는 것을 권장)**
        - 코드가 간결하지만, 클래스 외부 접근이 불가해 테스트하기 어려움
        - DI 프레임워크가 없으면 사용할 수 없게 된다.

    ```jsx
    @Service
    public class StationFieldService {
        @Autowired
        private StationRepository stationRepository;
    
        public String sayHi() {
            return stationRepository.sayHi();
        }
    }
    ```

  출처 : https://engineerinsight.tistory.com/46
- **IoC**

  ### **IoC (Inversion Of Control) = 제어의 역전**

    - 객체의 생성, 생명주기, 관리까지 객체의 주도권을 프레임워크가 관리하는 방식
    - Spring 에서 IoC를 담당하는 컨테이너 = spring container(IoC Container)

  ### **IoC 구현 방법 4가지**

    - Factory Pattern : 객체 생성을 전담하는 팩토리 클래스를 두어 객체를 생성하는 방식
    - Template Method Pattern : 객체 생성 과정을 추상화하여, 하위 클래스에서 구체적인 구현을 담당하는 방식
    - Service Locator Pattern : 객체 생성 및 관리를 위한 서비스 위치자 패턴
    - **Dependency Injection (DI)** : 객체 생성 및 관리에 대한 책임을 IoC 컨테이너가 가지며, 필요한 객체를 직접 생성하거나 외부에서 주입받는 방식(생성자 주입, 속성 주입, 메소드 주입 등 다양한 방식으로 이루어짐)

  ⇒ 이 중에서 Spring Framework 및 Spring Boot는 DI (Dependency Injection) 방식을 IoC 구현 방식으로 채택하고 있다.

  ### **IoC 장점**

    - 의존성을 관리하기 쉬워져 코드 변경이 쉬워진다.
    - 의존성 주입을 통해 테스트용 객체를 쉽게 만들 수 있으므로 테스트 코드 작성에 유용하다.
    - 의존성을 관리하는 작업이 자동화되니, 객체 간의 결합도가 낮아지므로 유지보수에 용이해진다.

  출처 : [https://velog.io/@kwontae1313/제어-역전IoC과-의존성-주입DI](https://velog.io/@kwontae1313/%EC%A0%9C%EC%96%B4-%EC%97%AD%EC%A0%84IoC%EA%B3%BC-%EC%9D%98%EC%A1%B4%EC%84%B1-%EC%A3%BC%EC%9E%85DI)
- - **프레임워크와 API의 차이**

    ### API (Application Programming Interface)

    - 두 개 이상의 소프트웨어 컴포넌트 사이에서 상호 작용할 수 있도록 정의된 인터페이스
    - 다른 개발자들이 사용할 수 있는 함수, 메서드, 클래스 등을 정의하는 것이다.
    - 라이브러리를 활용하기 위한 하나의 규약
        - ex) Twitter API, Google Maps API, YouTube API, Kakao API
        - 자동차가 컴포넌트일 경우, 자동차가 할 수 있는 것(브레이크, 라디오 켜는 법)이 api이다.

    ### **프레임워크 (Framework)**

    - 개발자들이 애플리케이션을 개발하는 데 사용되는 구조를 제공하는 역할
    - 응용프로그램이나 소프트웨어 구현을 수월하게 하기 위해 제공되는 소프트웨어 환경
    - 프레임워크에 `의존하여` 개발해야하며, 프레임워크가 정의한 규칙을 준수해야 함

    보통 여러 컴포넌트와 라이브러리를 포함하며, 개발자가 특정 기능을 구현하기 위해 이를 조합하여 사용하는 것

    - ex) Django, Spring

    ### **프레임워크와 API의 차이점**

    | 구분 | 프레임워크 | API |
        | --- | --- | --- |
    | 의존성 | 프레임워크에 의존하여 개발한다. | 독립적으로 제공, 필요할때마다 호출하는 방식 |
    | 제어흐름(control flow) | 프레임워크가 개발자의 코드를 호출(IoC) | 개발자가 api를 호출하여 사용하는 방식 |
    | 사용 목적 | 개발을 쉽게 하기 위해 | 특정 기능을 외부에서 사용하기 위해 |
    | 의미 | 전체적인 애플리케이션 구조를 포함하여 규칙과 설계방식 제공 | 다른 소프트웨어와의 통신을 위해 제공 |

    출처 :

    https://rlakuku-program.tistory.com/19

    [https://velog.io/@bcl0206/API-vs-라이브러리-풀리지-않는-미스터리에-관하여](https://velog.io/@bcl0206/API-vs-%EB%9D%BC%EC%9D%B4%EB%B8%8C%EB%9F%AC%EB%A6%AC-%ED%92%80%EB%A6%AC%EC%A7%80-%EC%95%8A%EB%8A%94-%EB%AF%B8%EC%8A%A4%ED%84%B0%EB%A6%AC%EC%97%90-%EA%B4%80%ED%95%98%EC%97%AC)
- - **AOP**

    ### **AOP (Aspect-Oriented Programming) / 관점 지향 프로그래밍**

    - 객체지향 프로그래밍을 **보완**하기 위해 쓰이는 것
    - **컴파일 시점 적용 / 클래스 로딩 시점 적용 / 런타임 시점 적용 즉 3가지로 나뉨**

    ### **Spring AOP**

    - **런타임 시점에 적용하는 방식을 사용**
        - 왜? 컴파일 시점과 클래스 로딩 시점에 적용하려면 별도의 컴파일러와 클래스로더 조작기를 써야 하는데, 이것을 정하고 사용 및 유지하는 과정이 매우 어렵고 복잡하기 때문이다.
    - 소스 코드상에서 다른 부분에 계속 반복해서 쓰는 코드 : 흩어진 관심사
        - 흩어진 관심사를 Aspect로 모듈화하고 핵심적인 비즈니스 로직에서 분리하여 재사용하겠다는 것이 AOP의 취지다.

    ### **AOP 주요 개념**

    - Aspect : 위에서 설명한 흩어진 관심사를 모듈화 한 것. 주로 부가기능을 모듈화함.
    - Target : Aspect를 적용하는 곳 (클래스, 메서드 .. )
    - Advice : 실질적으로 어떤 일을 해야할 지에 대한 것, 실질적인 부가기능을 담은 구현체
    - JointPoint : Advice가 적용될 위치, 끼어들 수 있는 지점. 메서드 진입 지점, 생성자 호출 시점, 필드에서 값을 꺼내올 때 등 다양한 시점에 적용가능
    - PointCut : JointPoint의 상세한 스펙을 정의한 것. 'A란 메서드의 진입 시점에 호출할 것'과 같이 더욱 구체적으로 Advice가 실행될 지점을 정할 수 있음

    출처 : [https://velog.io/@kai6666/Spring-Spring-AOP-개념](https://velog.io/@kai6666/Spring-Spring-AOP-%EA%B0%9C%EB%85%90)

    [https://engkimbs.tistory.com/entry/스프링AOP](https://engkimbs.tistory.com/entry/%EC%8A%A4%ED%94%84%EB%A7%81AOP) [새로비:티스토리]
- - **서블릿**

    ### 서블릿의 정의(***Servlet)***

    : 클라이언트 요청을 처리하고, 그 결과를 다시 클라이언트에게 전송하는 Servlet 클래스의 구현 규칙을 지킨 자바 프로그램

    - 웹페이지를 동적으로 생성하여 클라이언트에게 반환해주는 역할
    - main메서드가 아닌, 웹 컨테이너(Servlet Container)에 의해 실행된다.

    ```jsx
    @WebServlet(name = "helloServlet", urlPatterns = "/hello")
    public class HelloServlet extends HttpServlet {
    
        @Override
        protected void service(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            // 애플리케이션 로직
        }
    }
    ```

    - urlPatterns("/hello") 의 URL이 호출되면 서블릿 코드가 실행된다.
        - HttpServletRequest : HTTP 요청 정보를 사용
        - HttpServletResponse : HTTP 응답 정보를 사용

    ### 서블릿의 동작방식(***Servlet)***

    사용자가 URL을 입력 ⇒ 서블릿 컨테이너로 요청 전송 ⇒ Http Request, HttpResponse 객체를 생성 ⇒ 사용자가 요청한 URL이 어느 서블릿에 대한 요청인지 찾기(예제에서는  helloServlet 찾음)  ⇒ 서블릿의 `service()` 메소드를 호출 ⇒ 클라이언트가 GET일 경우  `doGet()`, POST일 경우 `doPost()` 메소드 호출 ⇒ 동적 페이지를 생성한 후 HttpServletResponse 객체에 응답보냄 ⇒ 응답 후 request, response 객체를 소멸한다.

    출처 : https://steady-coding.tistory.com/599