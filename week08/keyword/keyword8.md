- java의 Exception 종류들

  ## 자바의 예외(Exception)는 크게 두 가지로 나뉩니다:

  ### 1. **Checked Exception (컴파일 시점에서 체크됨)**

    - 반드시 `try-catch` 또는 `throws`로 처리해야 함.
    - **예시**:
        - `IOException` (파일/입출력 관련)
        - `SQLException` (DB 작업 관련)
        - `ClassNotFoundException`
    - **장점**: 안정성 높음 (컴파일 타임 체크)
    - **단점**: 코드가 지저분해짐, 너무 많이 써야 함

    ```java
    java
    복사편집
    try {
        FileReader reader = new FileReader("test.txt");
    } catch (IOException e) {
        e.printStackTrace();
    }
    
    ```
    
  ---

  ### 2. **Unchecked Exception (런타임 예외, RuntimeException)**

    - 명시적으로 처리하지 않아도 됨
    - **예시**:
        - `NullPointerException`
        - `IllegalArgumentException`
        - `IndexOutOfBoundsException`
        - `ArithmeticException`
    - **장점**: 빠른 개발 가능
    - **단점**: 예외 처리가 누락되기 쉬움

    ```java
    java
    복사편집
    int[] arr = new int[3];
    System.out.println(arr[4]); // ArrayIndexOutOfBoundsException 발생
    
    ```
    
  ---

  ### 실무에서는?

    - **비즈니스 로직 실패나 유효성 실패**는 대부분 `Unchecked`로 처리하고,
    - DB나 파일 관련 예외는 `Checked`로 다룸.

    ---

  ## 

- @Valid

  ### 정의

  `javax.validation.@Valid`는 **스프링에서 DTO의 유효성 검사**를 수행할 때 사용하는 어노테이션입니다.

  컨트롤러에서 `@RequestBody`, `@ModelAttribute` 등의 파라미터에 붙이면 **DTO 필드에 선언된 검증 규칙**을 기준으로 자동 검증합니다.
    
  ---

  ### 사용법 예시

    ```java
    java
    복사편집
    @PostMapping("/signup")
    public ResponseEntity<?> signup(@RequestBody @Valid MemberRequest request) {
        // request 내부의 필드 유효성 검증 후 통과된 데이터만 넘어옴
    }
    
    ```

  ### DTO에 선언 예

    ```java
    java
    복사편집
    public class MemberRequest {
        @NotBlank
        private String name;
    
        @Email
        private String email;
    
        @Min(18)
        private int age;
    }
    
    ```
    
  ---

  ### 지원 어노테이션 종류

  | 어노테이션 | 설명 |
      | --- | --- |
  | `@NotNull` | null 불가 |
  | `@NotBlank` | 공백 불가 (String) |
  | `@Size` | 길이 제한 |
  | `@Min` / `@Max` | 최소/최대값 |
  | `@Pattern` | 정규식 검증 |
  | `@Email` | 이메일 형식 |
    
  ---

  ### 함께 사용되는 것

  | 어노테이션 | 설명 |
      | --- | --- |
  | `@Valid` | DTO 필드 검증 |
  | `@Validated` | 커스텀 어노테이션 검증 시 사용 (@PathVariable, @RequestParam 등) |
    
  ---

  ### 장점

    - **코드 가독성 증가**
    - **Controller가 깔끔해짐**
    - **오류 메시지를 통합 포맷으로 관리 가능 (ExceptionAdvice)**