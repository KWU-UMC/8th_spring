# 핵심 키워드

## 1. java의 Exception 종류들
### 💡 Unchecked Exception

- RuntimeException과 그 하위 클래스에서 발생
- 실행 중(runtime) 생기는 예외
- 컴파일러가 예외 처리(try-catch)를 강요하지 않음
- 예시


| 예외 클래스 | 설명 |
| --- | --- |
| `NullPointerException` | 참조 변수의 값이 `null`인 상태에서 필드나 메서드에 접근하려 할 때 발생 |
| `ArrayIndexOutOfBoundsException` | 배열, 리스트 등에서 유효하지 않은 인덱스에 접근할 때 발생 |
| `NumberFormatException` | 문자열을 숫자로 변환할 때 형식이 올바르지 않으면 발생 |
| `ClassCastException` | 잘못된 타입으로 객체를 형변환할 때 발생 |

### 💡 **Checked Exception**

- Exception 중에서 RuntimeException을 제외한 예외
- 컴파할 때부터 예외 처리를 **꼭** 해야 하는 예외
- 처리하지 않으면 **컴파일 오류 발생**
- 예시


| 예외 클래스 | 설명 |
| --- | --- |
| `IOException` | 입출력 작업 중 문제가 발생했을 때 발생 (예: 파일 읽기/쓰기 실패) |
| `FileNotFoundException` | 존재하지 않는 파일을 열려고 할 때 발생 (`IOException`의 하위 클래스) |
| `SQLException` | 데이터베이스 연결, 쿼리 실행 등에서 오류가 발생할 때 |
| `ClassNotFoundException` | `Class.forName()` 등으로 클래스를 동적으로 로딩할 때, 클래스를 찾을 수 없을 때 발생 |

## 2. Valid
💡 개념

@Valid Java Bean Validation의 표준 어너테이션으로 객체의 필드에 지정된 유효성 검사 제약 조건을 실행하도록 트리거하는 역할

💡 주요 어노테이션

| 어노테이션 | 설명 | 조건 예시 |
| --- | --- | --- |
| `@NotNull` | null이면 안 됨 | null ❌, 빈 문자열은 허용 |
| `@NotBlank` | null ❌, 빈 문자열 ❌, 공백만 ❌ | 문자열 필드 검증에 주로 사용 |
| `@NotEmpty` | null ❌, 빈값 ❌ | 문자열, 컬렉션에 사용 가능 |
| `@Size(min, max)` | 문자열/컬렉션 크기 제한 | ex) `@Size(min=2, max=10)` |
| `@Email` | 이메일 형식 검증 | ex) `abc@domain.com` |
| `@Min` / `@Max` | 숫자 최소/최대값 제한 | ex) `@Min(1)`, `@Max(100)` |

💡 @Validated와 비교

| 항목 | @Valid | @Validated |
| --- | --- | --- |
| **정의** | 자바 표준 스펙 | 스프링에서 제공하는 어노테이션 |
| **사용 범위** | 주로 Controller 계층 (요청 바디 등) | Controller 외 Service, Component 계층 등에서도 사용 가능 |
| **예외 유형** | MethodArgumentNotValidException | ConstraintViolationException |