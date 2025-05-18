# 🎯 핵심 키워드
# RestContollerAdvice

  ### `@ExceptionHandler`

    - 기존 : try- catch 구문으로 Exception을 잡았어야 했음
    - Spring에서는 `@ExceptionHandler` 어노테이션을 통해 매우 유연하고 간단하게 예외처리 가능

  ⇒ @ExceptionHandler 어노테이션이 붙은 메서드는 ExceptionHandlerExceptionResolver에 의해 처리

  **장점**

    - HttpServletRequest나 WebRequest 얻을 수 있음
    - 반환 타입 : ResponseEntity, String, void 등 자유롭게 사용 가능

  **단점**

    - 특정 컨트롤러에서만 발생하는 예외만 처리
        - 여러 Controller에서 발생하는 에러 처리 코드 중복 가능성 있음
        - 사용자의 요청과 응답을 처리하는 Controller 기능에 예외처리 코드가 생겨 단일 책임 원칙(SRP) 위배

  ### `@**RestControllerAdvice**`

    - 컨트롤러에서 발생하는 예외(@ExceptionHandler)를 AOP를 적용해 **예외를 전역적으로 처리**할 수 있는 어노테이션
    - `@RestControllerAdvice` 는 `@ControllerAdvice + @ResponseBody` 의 조합으로, RESTful API를 개발할 때 사용

      응답을 JSON 형식으로 내려줍니다.

      ⇒ 응답 형식 : json으로 응답


    ```java
    @Slf4j
    @RestControllerAdvice // 예외 전역적 처리 어노테이션
    public class GlobalExceptionHandler {
    
    		//에러처리 1 : @ExceptionHandler
        @ExceptionHandler(ArithmeticException.class)
        public ResponseEntity<String> handleArithmeticException(ArithmeticException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
        
        //에러처리 2 : @ExceptionHandler
        @ExceptionHandler(IllegalArgumentException.class)
        public ResponseEntity<String> handleIllegalArgument(IllegalArgumentException e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(e.getMessage());
        }
    ```

# lombok

  LomBok : **어노테이션 기반으로 코드 자동완성 기능을 제공하는 라이브러리**

  ⇒ Web 개발을 하다보면 등장하는 반**복되는 코드를 줄여준다.**

  ### 장점

    1. 어노테이션을 통한 코드 자동 생성을 통한 생산성, 편의성 증가
    2. Code의 길이가 줄어듬으로 가독성, 유지보수성 향상
    3. Builder 패턴의 적용, Log 생성 등등 편의성

  ### 종류

    - @Data
        - @Getter, @Setter, @ToString, @RequiredArgsConstructor, @EqualsAndHashCode 어노테이션의 집합체
        - 단점 1 : @ToString이 포함되어있으므로, 양방향 연관관계에서 순환참조 문제가 발생
        - 단점 2 : setter 가 포함되어 어디서든 변경 가능
    - **@Getter,  @Setter**
        - **클래스 위에 적용시킨다면 모든 변수**들에 적용
        - 필드(변수) 위에만 할당하면 **해당 변수에만 적용 가능**
    - **@ToString**
        - 클래스 전체에 적용시킨다면 해당 클래스 변수들을 toString 메서드를 자동 완성
    - **@AllArgsConstructor**
        - 모든 필드를 사용하는 생성자를 만들어 주는 어노테이션
    - **@NoArgsConstructor**
        - 파라미터가 없는 생성자 만들어줌
    - **@RequiredArgsConstructor**
        - final 키워드가 붙은 필드를 포함하여 생성자를 생성
        - DI 주입시 주로 사용
    - **@Builder**
        - 클래스 위에 적용 한다면 해당 클래스 모든 변수에 대해서 빌더 패턴을 사용할 수 있게 해준다.
    - https://lucas-owner.tistory.com/27