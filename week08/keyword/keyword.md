# java의 Exception 종류들

## 1. **Checked Exception (검사 예외)**

- 컴파일 타임에 반드시 처리해야 하는 예외
- 예외 처리를 하지 않으면 컴파일 오류 발생
- `try-catch` 블록으로 처리하거나 `throws` 키워드로 위임해야 함
- 파일 입출력, 데이터베이스 접근 등 **외부 자원**과 관련된 작업에서 주로 발생

**예시:**

- `IOException`
- `SQLException`
- `FileNotFoundException`
- `ClassNotFoundException`

## 2. **Unchecked Exception (비검사 예외)**

- 런타임에 발생
- 컴파일러가 강제로 예외 처리를 요구하지 않음
- 개발자가 필요에 따라 예외 처리를 선택적으로 수행

**예시:**

- `NullPointerException`
- `ArrayIndexOutOfBoundsException`
- `ArithmeticException`
- `IllegalArgumentException`
- `IllegalStateException`

# @Valid

- `@Valid`는 Java에서 **Bean Validation**을 수행할 때 사용하는 어노테이션
- 요청 데이터의 유효성을 검사할 때 활용
- `javax.validation.Valid`에 속함
- DTO 객체 내부의 필드에 설정된 유효성 검증 애노테이션(예: `@NotNull`, `@Size`, `@Email` 등)을 **자동으로 검사**함
- 보통 `@RequestBody`, `@ModelAttribute` 등과 함께 사용됨

### 사용 예시

```java
@RestController
public class UserController {

    @PostMapping("/users")
    public ResponseEntity<?> createUser(@RequestBody @Valid UserDto userDto) {
        // 유효성 검사 통과 시 실행됨
        return ResponseEntity.ok("회원 생성 완료");
    }
}

```

```java
public class UserDto {
    @NotNull
    private String name;

    @Min(18)
    private int age;
}

```

### 연관 객체 검증도 가능

```java
public class OrderDto {
    @Valid  // 내부 객체도 검증
    private AddressDto address;
}
```

