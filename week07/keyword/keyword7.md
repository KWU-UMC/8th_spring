- RestContollerAdvice

  ### 정의

    - `@RestControllerAdvice`는 `@ControllerAdvice + @ResponseBody`의 조합입니다.
    - 모든 `@RestController`에서 발생하는 예외를 **전역적으로 감지하여 JSON 형태로 응답 처리**합니다.

  ### 주요 속성

    - 클래스 레벨에서 선언
    - 내부에 `@ExceptionHandler` 메서드를 정의해 예외별 대응 가능
    - Spring의 예외 처리 체계에서 중심 역할

  ### 사용이유?

  | 이유 | 설명 |
      | --- | --- |
  | **전역 예외 처리** | 컨트롤러마다 try-catch 하지 않아도 됨 |
  | **응답 형식 일관화** | 에러 응답도 API 응답 형식과 통일 가능 |
  | **로깅과 디버깅 용이** | 예외 발생 지점을 한 곳에서 로그로 추적 가능 |
  | **코드 재사용성 증가** | 동일한 예외 처리 로직을 재사용 가능 |
  | **유지보수 용이** | 새로운 예외가 생겨도 Advice만 수정하면 됨 |
- lombok

  ### 정의

    - **Lombok**은 Java 코드의 반복적인 보일러플레이트를 줄여주는 도구로, 어노테이션 기반으로 **getter, setter, builder, constructor** 등을 자동 생성합니다.

  ### 자주 사용하는 어노테이션

  | 어노테이션 | 설명 |
      | --- | --- |
  | `@Getter` | 모든 필드의 getter 생성 |
  | `@Setter` | 모든 필드의 setter 생성 |
  | `@Builder` | 빌더 패턴 자동 생성 |
  | `@AllArgsConstructor` | 모든 필드를 받는 생성자 생성 |
  | `@NoArgsConstructor` | 기본 생성자 생성 |
  | `@RequiredArgsConstructor` | `final` 필드만 받는 생성자 생성 |
  | `@ToString` | toString 자동 생성 |

  ### 장점

    - 코드의 가독성 향상
    - 유지보수 용이
    - 반복 작업 자동화
    - 도메인 모델이나 DTO, Entity 설계 시 생산성 향상
- Builder란

  빌더 패턴(Builder Pattern)은 **복잡한 객체를 단계적으로 생성**할 수 있게 해주는 디자인 패턴입니다. 특히 생성자에 전달해야 할 **인자 수가 많거나 선택적 인자가 많은 객체**를 만들 때 유용합니다.
    
  ---

  ## 

    ```java
    java
    복사편집
    // 생성자에 인자가 많아질수록 가독성이 떨어짐
    User user = new User("익명", 25, "서울", "010-1234-5678", true, false);
    
    ```

  이런 생성자는 인자의 순서를 실수할 수 있고, 선택적으로 일부만 설정하고 싶을 때도 불편합니다.
    
  ---

  ## 빌더 패턴을 사용하면

    ```java
    
    User user = User.builder()
                    .name("익명")
                    .age(25)
                    .city("서울")
                    .phone("010-1234-5678")
                    .isActive(true)
                    .isAdmin(false)
                    .build();
    
    ```

  ### 장점:

    - **가독성 향상**: 어떤 값이 어떤 필드에 들어가는지 명확
    - **유연성**: 필요한 필드만 설정 가능
    - **불변 객체 생성에 유리**: 객체를 final로 만들고도 편하게 생성