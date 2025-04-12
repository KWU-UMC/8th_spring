- **DI**
    - 개념
        - 사용할 객체를 직접 생성하지 않고 외부에서 주입받아 사용하는 방식
    - 사용하는 이유
        - 객체 간 결합도를 낮추기 위해
        - 테스트하기 쉬워지며 유지보수에 용이
        - SOLID 원칙 중 DIP (의존 역전 원칙)의 핵심
    - 방식
        1. **생성자 주입(**⭐)
            - 객체를 생성할 때 의존성 주입
            - 불변성 보장
            - 의존성이 없으면 컴파일 에러
            - 예시코드

                ```java
                @Service
                public class MemberSignupService {
                
                    private final MemberRepository memberRepository;
                
                    @Autowired
                    public MemberSignupService(MemberRepository memberRepository) {
                        this.memberRepository = memberRepository;
                    }
                }
                ```

        2. **setter 주입**
            - 방식
                - 주입 받으려는 빈의 생성자를 호출하여 빈을 찾거나, 빈 팩토리에 등록
                - 생성자 인자에 사용하는 빈을 찾거나, 생성
                - Setter의 인자로 주입
            - 단점
                - 런타임에 의존성을 주입, 의존성이 없는 개체가 생성될 수 있음
                - 주입 받지 않은 채 작동할 수 있어 nullpointexception에러가 발생할 수 있음
            - 예시코드

                ```java
                @Service
                public class MemberSignupService {
                
                    private MemberRepository memberRepository;
                
                    @Autowired
                    public void setMemberRepository(MemberRepository memberRepository) {
                        this.memberRepository = memberRepository;
                    }
                }
                
                ```

        3. **필드 주입**
            - 런타임에 의존성을 주입, 의존성이 없는 개체가 생성될 수 있음
            - 방식
                - 주입받으려는 빈의 생성자를 호출하여 빈을 찾거나 빈 팩토리에 등록
                - 생성자 인자에 사용하는 빈을 찾거나 생성
                - 필드에 주입
            - 단점
                - 런타임에 의존성을 주입, 의존성이 없는 개체가 생성될 수 있음
                - 주입 받지 않은 채 작동할 수 있어 nullpointexception에러가 발생할 수 있음
                - 명시적으로 드러나는 의존성이 없어 의존성 구조를 이해하기 어려움
                - Bean들 간의 **순환 참조 문제** 발생
            - 예시코드

                ```java
                @Service
                public class MemberSignupService {
                
                    @Autowired
                    private MemberRepository memberRepository;
                }
                
                ```
<br/>

- **IoC**
    - 객체의 생성과 관리를 개발자가 아닌 Spring 프레임워크가 담당하는 것
    - 개발자는 필요한 객체만 선언해두고 Spring이 알아서 적절한 객체를 주입
    - 작동방식
        1. 객체를 class로 정의
        2. 객체들간의 연관성 지정
            1.  config파일을 통해
            2.  annotation을 통해
        3. IoC 컨테이너가 이 정보를 바탕으로 객체들을 생성하고 필요한 곳에 주입
    - 빈 (Bean)
        - spring 컨테이너가 관리하는 자바 객체
        - 등록방법
            - @Component → @Autowired: 묵시적 빈 정의
                - @Component 어노테이션을 붙여주면 spring은 자동으로 객체를 bean으로 등록한다. 그래서 다른 클래스에서 이 객체를 이용하고 싶으면 @Autowired로 의존성을 주입해주면 된다.
            - @Configuration → @Bean: 명시적 빈 정의

<br/>

- **프레임워크와 API의 차이**
    - 프레임워크
        - 어떤 목적을 달성하기 위해 목적과 관련된 코드의 뼈대를 미리 마련해둔 것
    - API
        - API: 2개 이상의 소프트웨어 컴포넌트 사이에서 상호작용할 수 있도록 정의된 인터페이스
    - 프레임워크는 "**어떻게 짤지의 틀**"이고, API는 "**필요한 기능을 가져다 쓰는 도구**”

<br/>

- **AOP**
    - aspect-oriented progamming 관점 지향 프로그래밍
    - **공통 기능을 핵심 로직과 분리해서** 중복을 줄이고 유지보수를 쉽게 해주는 프로그램 기법
        - 핵심 기능: 해당 객체가 제공하는 고유의 기능 ex) 로그인, 회원가입
        - 부가 기능: 핵심 기능을 보조하기 위해 제공되는 기능 ex) 로그 추적 기능
    - 필요한 이유
        - 부가 가능을 적용해야할 클래스가 100개라면?
        - 모두 똑같은 코드를 추가해야하므로 비효율적임 → AOP를 사용하면 부가기능을 한곳에만 작성하고 필요한 곳에 끼워넣을 수 있음
    - 적용방식
        1. 컴파일 시점
        2. 클래스 로그 시점
        3. **런타임 시점(프록시 사용): 스프링 AOP 방식**

     
<br/>

- **서블릿**
    - 자바를 사용해서 웹 요청과 응답을 처리하는 서버측 프로그램
    - **Servlet Container**
        - 서블릿을 실행하고 관리하는 역
    - 동작 방식
        1. 클라이언트가 브라우저에서 URL을 입력하여 HTTP Request 를 보냄
        2. 서블릿 컨테이너가 요청을 받아 HttpServletRequest, HttpServletResponse 객체를 생성함
        3. web.xml을 기반으로 요청을 처리할 서블릿 매핑
        4. 해당 서블릿의 service() 메서드 호출
        5. 서블릿이 요청을 처리하고 결과를 응답으로 작성 (HttpServletResponse)
        6. 응답이 클라이언트로 반환되고 HttpServletRequest와 HttpServletResponse 객체 소멸시킴