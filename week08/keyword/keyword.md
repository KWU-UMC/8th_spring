# 핵심 키워드
## java의 Exception 종류들
Exception 클래스는 RuntimeException(런타임 에러를 다룸)과 그 외의 자식 클래스 그룹(컴파일 에러를 다룸)으로 나뉘게 된다.

- Exception 및 하위 클래스 : 사용자의 실수와 같은 외적인 요인에 의해 발생하는 컴파일시 발생하는 예외
    - 존재하지 않는 파일의 이름을 입력 (FileNotFoundException)
    - 실수로 클래스의 이름을 잘못 기재 (ClassNotFoundException)
    - 입력한 데이터 형식이 잘못된 경우 (DataFormatException)
- RuntimeException 클래스 : 프로그래머의 실수로 발생하는 예외
    - 배열의 범위를 벗어남 (IndexOutOfBoundsException)
    - 값이 null인 참조 변수의 멤버를 호출 (NullPointerException)
    - 클래스 간의 형 변환을 잘못함 (ClassCastException)
    - 정수를 0으로 나누는 산술 오류 (ArithmeticException)

## @Valid
### 정의

- 빈 검증기(Bean Validator)를 이용해 객체의 제약 조건을 검증하도록 지시하는 어노테이션
- @Valid는 기본적으로 컨트롤러에서만 동작하며, 기본적으로 다른 계층에서는 검증이 되지 않는다.
- 유효성 검증에 실패할 경우, MethodArgumentNotValidException이 발생

### 사용 방법

1. build.gradle 에 의존성을 추가를 해야 사용 가능

```java
implementation 'org.springframework.boot:spring-boot-starter-validation'
```

2.  유효성 검증

방법1) Controller 의 메소드에 @Valid 붙이기 (@Valid 는 주로 @RequestBody 앞에 붙음)

```java
@PostMapping("/user/add") 
public ResponseEntity<Void> addUser(@Valid @RequestBody AddUserRequest addUserRequest) {
      ...
}
```

방법2) 유효성 검사를 할 필드에 붙이기

```java
public class Person {
    @NotNull
    @Size(max = 64)
    private String name;
        ...
}
```

3. 해당 제약 조건들이 정상적으로 검증되는지 확인하기 위해서 테스트 코드를 작성하는데 @Valid에 의한 반환값은 400 BadRequest이므로 이를 결과로 예측하면 된다.