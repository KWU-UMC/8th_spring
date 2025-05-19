# 🎯핵심 키워드

# Java Exception 종류

Java에서 발생하는 예외(Exception)와 에러(Error)는 크게 세 가지 범주로 나뉨:

1. Checked Exceptions (검사 예외)
2. Unchecked Exceptions (비검사 예외)
3. Errors (에러)

## Checked Exceptions (검사 예외)

* IOException: 입출력 작업 중 예외 발생 (예: FileNotFoundException 포함)
* SQLException: JDBC 관련 SQL 처리 중 예외
* ClassNotFoundException: 클래스를 찾지 못했을 때
* InterruptedException: 쓰레드가 대기 상태에서 인터럽트될 때
* MalformedURLException: 잘못된 URL 형식
* FileNotFoundException: 파일을 찾지 못했을 때

```java
try {
    FileInputStream fis = new FileInputStream("file.txt");
} catch (IOException e) {
    e.printStackTrace();
}
```

## Unchecked Exceptions (비검사 예외)

* NullPointerException: null 참조 접근
* ArrayIndexOutOfBoundsException: 배열 인덱스 범위 벗어남
* IllegalArgumentException: 잘못된 인자를 메소드에 전달
* IllegalStateException: 메소드 호출 시 객체 상태가 올바르지 않을 때
* ClassCastException: 잘못된 타입 캐스팅
* ArithmeticException: 수학적 연산 오류 (예: 0으로 나누기)
* NumberFormatException: 문자열을 숫자로 변환할 때 형식 오류
* IndexOutOfBoundsException: 컬렉션의 인덱스 범위 벗어남

```java
List<String> list = new ArrayList<>();
String s = list.get(0); // IndexOutOfBoundsException
```

## Errors (에러)

* OutOfMemoryError: 메모리 부족
* StackOverflowError: 스택 오버플로우
* VirtualMachineError: 가상 머신에서 심각한 문제 발생
* AssertionError: assert 문 실패

```java
public class Recursion {
    public static void recurse() {
        recurse(); // StackOverflowError
    }
}
```

## 자주 사용하는 예외

| 예외명                      | 설명           |
| ------------------------ | ------------ |
| IOException              | 입출력 에러       |
| NullPointerException     | null 참조 접근   |
| SQLException             | 데이터베이스 처리 에러 |
| ClassNotFoundException   | 클래스 로딩 실패    |
| IllegalArgumentException | 메소드 인자 오류    |

## 커스텀 예외 사용법

```java
public class MyCustomException extends Exception {
    public MyCustomException(String message) {
        super(message);
    }
}

try {
    throw new MyCustomException("사용자 정의 예외 발생");
} catch (MyCustomException e) {
    e.printStackTrace();
}
```
# @Valid 어노테이션

Spring MVC 또는 Jakarta Bean Validation 환경에서 입력값 검증을 간단히 처리할 수 있는 어노테이션

## 주요 내용

* **역할**: 파라미터나 필드에 적용된 제약 애노테이션(`@NotNull`, `@Size` 등)을 해석하여 자동으로 검사
* **위치**: 컨트롤러 메서드 파라미터(`@RequestBody`, `@ModelAttribute`), 서비스 메서드 파라미터, DTO 필드 등
* **동작**: 유효성 검사 실패 시 `MethodArgumentNotValidException`(Spring) 또는 `ConstraintViolationException` 발생

## 사용 방법

1. **의존성 추가** (Spring Boot):

   ```xml
   <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-validation</artifactId>
   </dependency>
   ```

2. **DTO에 제약조건 설정**:

   ```java
   public class UserDto {
       @NotBlank(message = "이름은 필수입니다.")
       private String name;

       @Email(message = "이메일 형식이 아닙니다.")
       private String email;
   }
   ```

3. **컨트롤러에서 @Valid 적용**:

   ```java
   @PostMapping("/users")
   public ResponseEntity<?> createUser(
       @Valid @RequestBody UserDto dto,
       BindingResult br) {
     if (br.hasErrors()) {
       return ResponseEntity.badRequest().body(
         br.getFieldErrors().stream()
           .map(e -> e.getField()+": "+e.getDefaultMessage())
           .collect(Collectors.joining(", "))
       );
     }
     // 정상 처리
     return ResponseEntity.ok("OK");
   }
   ```

4. **예외 처리 (글로벌 핸들러)**:

   ```java
   @ControllerAdvice
   public class GlobalExceptionHandler {
     @ExceptionHandler(MethodArgumentNotValidException.class)
     public ResponseEntity<String> handleValidation(MethodArgumentNotValidException e) {
       String msg = e.getBindingResult().getFieldErrors().stream()
         .map(f -> f.getField()+": "+f.getDefaultMessage())
         .collect(Collectors.joining(", "));
       return ResponseEntity.badRequest().body(msg);
     }
   }
   ```
* `@Valid` 하나만 추가하면 DTO에 선언한 제약조건을 자동 검사
* 실패 시 예외 발생 → 글로벌 핸들러에서 일괄 처리
* 코드가 간결해지고 검증 로직 중복 감소
