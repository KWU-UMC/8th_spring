# 8주차 키워드

## JAVA Exception 종류
- exception은 코딩으로 인해 발생하는 프로그램 오류를 말하며, 예외 발생시 프로그램은 종료된다는 점에서 에러와 동일함
- 하지만 예외는 Exception Handling을 통해 프로그램을 종료하지 않고 정상 실행 상태가 유지될 수 있도록 할 수 있음

### Checked Exception
- 컴파일 체크 예외라고도 하며, 예외 처리 코드가 없다면 컴파일 오류 발생
- 개발자가 반드시 예외 처리를 직접 진행해야 함

### Unchecked Exception
- 컴파일하는 과정에서 예외 코드를 검사하지 않는 예외
- 명시적인 예외 처리가 강제되는 것이 아니므로 개발자가 예외 처리를 직접 하지 않아도 됨

### Unchecked Exception 케이스
1. NullPointerException(NPE)
- null 값을 가지고 있는 참조 변수로 객체 접근 연산자인 도트(.)를 사용했을 시 발생

2. ArrayIndexOutOfBoundsException
- 배열의 할당된 인덱스 범위를 초과하여 사용할 경우 발생

3. NumberFormatException
- 매개변수로 오는 문자열이 숫자로 변환될 수 없는 문자가 오는 경우 발생

4. ClassCastException
- 타입 변환(Casting)은 상위 클래스와 하위 클래스 간, 구현 클래스와 인터페이스 간에 발생
- 위 관계가 아니면 클래스는 다른 클래스를 타입으로 변환 불가
- 강제 타입 변환을 시도할 경우 오류 발생

## @Valid
- 주로 요청 데이터(request body)를 검증하는데 사용
- @NotNull, @Size, @Email과 같은 제약 조건 어노테이션과 함께 사용됨
- 주로 DTO 파라미터 검증에 쓰임

### @Valid vs @Validated
- @Valid는 Bean Validation에서, @Validated는 Spring Framework에서 지원
- @Valid는 단순히 객체 내의 제약 조건을 검사하고, @Validated는 객체 내 제약 조건을 검사하는 것에 더해 그룹 기반 검증을 지원함
- @Valid는 그룹 지정이 불가능, @Validated는 가능함
- @Validated는 주로 Controller, Service단 검증에서 주로 쓰임

