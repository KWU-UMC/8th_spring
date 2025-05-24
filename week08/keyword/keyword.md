# 🔥 java의 Exception 종류들

## 💡 정의
    
---

- 프로그램 실행 중 발생할 수 있는 오류 상황을 객체로 표현한 것
- 예외가 발생하면 JVM은 해당 예외를 던지고, catch하지 않으면 프로그램 종료함.

## ❕ 주요 분류
    
---

  | 분류 | 상속 계층 | 설명 |
    | --- | --- | --- |
  | Checked Exception | `Exception` → `Throwable` | 컴파일 시 예외 처리(try-catch 또는 throws)를 강제 |
  | Unchecked Exception(Runtime Exception) | `RuntimeException` → `Exception` | 컴파일 시 예외 처리 강제되지 않음 |
  | Error | `Error` → `Throwable` | JVM 내부에서 발생하는 심각한 오류 (ex: OutOfMemoryError) |

## ✅ Checked Exception
    
---

### 🎯 특징

- 컴파일러가 예외 처리를 강제
- 예외를 처리하지 않으면 컴파일 에러 발생

### 📌 주요 예시

- `IOException`: 입출력 작업 실패
- `SQLException`: DB 연동 중 오류
- `ClassNotFoundException`: 클래스 로딩 실패
- `ParseException`: 날짜/숫자 등 파싱 실패

### ➡️ 장점

- 안정성 보장
- API 사용 시 예외 상황을 명확히 알 수 있음

### ❌ 단점

- 코드가 장황해짐 (예외 전파 or 처리 필요)

## ✅ Unchecked Exception (Runtime Exception)

### 🎯 특징

- 컴파일러가 예외 처리를 강제하지 않음
- 논리적 오류나 프로그래머 실수로 발생

### 📌 주요 예시

- `NullPointerException`
- `IllegalArgumentException`
- `IndexOutOfBoundsException`
- `ArithmeticException`

### ➡️ 장점

- 코드 간결
- 내부 구현 자유도 높음

### ❌ 단점

- 예외 처리 누락 가능
- 코드 작성 시점이 아니라 런타임 시에 버그가 발생함
- 안정성이 저하되고, 디버깅이 어려

# 🔥 @Valid

## 💡 정의

- **javax.validation.Valid** 또는 **jakarta.validation.Valid**에 정의된 애노테이션
- 객체(DTO, 자바 빈 등)의 내부 필드에 선언된 유효성 검사(@NotNull, @Size 등)를 재귀적으로 검사하도록 지시
- 보통 `@RequestBody`, `@ModelAttribute`와 함께 사용되며, Spring MVC에서 자동 유효성 검사를 수행

## 🧾 사용 위치 예시

  | 위치 | 예시 |
    | --- | --- |
  | 컨트롤러 파라미터 | `public ApiResponse<?> join(@RequestBody @Valid MemberDTO memberDTO)` |
  | 메서드 파라미터 | `public void setMember(@Valid Member member)` |
  | 컬렉션, 중첩 객체 | `List<@Valid Review> reviewList;`  |
    
---

## 📌 동작 방식

1. 컨트롤러 진입 시 `@Valid`가 붙은 파라미터의 필드에 대해
2. 선언된 제약 어노테이션 (`@NotNull`, `@Min`, `@Size` 등)을 검사하고
3. 위반 시 예외 발생 (`MethodArgumentNotValidException`)
4. `@ControllerAdvice`를 통해 예외를 전역 처리 가능

---

## 🔍 주요 유효성 제약 어노테이션

  | 어노테이션 | 설명 |
    | --- | --- |
  | `@NotNull` | null이 아님 |
  | `@NotEmpty` | null & 빈 문자열 허용 안 함 |
  | `@NotBlank` | null, 공백문자 허용 안 함 |
  | `@Size(min=, max=)` | 길이 제약 |
  | `@Min`, `@Max` | 숫자 최소/최대 |
  | `@Pattern` | 정규표현식 만족 여부 |
    
---

## ✅ 예시 코드

### 📦 DTO

  ```java
  public class ReviewDTO {
      @NotNull
          @Min(1)
          @Max(5)
          Integer rating;
    		
      @NotBlank
      String content;
  }
  ```

### 📦 Controller

  ```java
  @PostMapping("/reviews")
  public ResponseEntity<?> createReview(@RequestBody @Valid RiviewDTO reviewDTO) {
          .
          .
          .
      return ResponseEntity.ok("유효성 통과");
  }
    
  ```
    
---

## ✅ 장점

  | 항목 | 설명 |
    | --- | --- |
  | 재사용 가능 | DTO마다 유효성 제약을 한 번만 설정하면 여러 곳에서 재사용 가능 |
  | 코드 분리 | 비즈니스 로직과 입력 검증을 분리하여 깔끔한 구조 유지 |
  | 중첩 객체 지원 | 객체 안 객체 구조에서도 재귀적 유효성 검사 가능 (`List<@Valid T>`) |
    
---

## ❌ 단점 / 주의점

  | 항목 | 설명 |
    | --- | --- |
  | 원시 타입은 null 검증 안 됨 | `int`는 `null`로 들어오지 않아 `@NotNull` 동작하지 않음 → `Integer`로 변경 필요 |
  | 에러 메시지 커스터마이징 필요 | 기본 메시지가 불친절할 수 있어 사용자 메시지 지정 또는 `messages.properties` 필요 |
  | 컬렉션은 `@Valid` + 요소 단위 어노테이션 필요 | `List<@Valid ReviewDTO>` 같이 구성해야 작동 |