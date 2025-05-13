# 7주차 키워드

## RestControllerAdvice
- @ControllerAdvice와 @ResponseBody를 합친 어노테이션
- @ControllerAdvice의 역할을 수행하고, @ResponseBody를 통해 객체를 리턴할 수 있음
- 단순 예외 처리는 @ControllerAdvice, 응답으로 객체 리턴은 @RestControllerAdvice 사용

#### 장점
- 전역 예외 처리로 코드 중복 제거 > 한 곳에서 에러 메시지, HTTP 상태 코드를 통일되게 관리 가능
- 일관된 에러 응답 포맷 유지
- 모든 컨트롤러에 자동 적용 (AOP처럼 작동)

#### RestControllerAdvice가 없을 때 불편한 점
- 컨트롤러마다 try-catch를 반복해 중복 코드가 많아지고 유지보수가 어려워짐
- 공통 처리가 어려워 로깅, 응답 구조 통일 등을 매번 수작업해야함
- 에러 응답 포맷이 일관되지 않아 프론트가 헷갈림 

### ControllerAdvice
- @ExceptionHandler, @ModelAttribute, @InitBinder가 적용된 메소드들에 AOP를 적용하여 Controller단에 적용하기 위해 고안된 어노테이션
- 클래스에 선언
- 모든 @Controller에 전역적으로 발생할 수 있는 예외를 잡아서 처리

### ResponseBody
- HttpMessageConverter를 통해 응답 값을 자동으로 json으로 직렬화 한 뒤 응답해주는 역할


## Lombok
- 어노테이션 기반으로 코드 자동완성 기능을 제공하는 라이브러리
- 장점: 코드 자동 생성을 통한 생산성, 편의성 증가 / 코드의 길이가 줄어 가독성, 유지보수성 향상

### Lombok 어노테이션 종류
- @Getter: 코드가 컴파일될 때 getter 메서드들 생성
- @NoArgsConstructor: 파라미터가 없는 생성자를 생성
- @RequiredArgsConstructor: final, @NonNull이 있는 필드를 포함하여 생성자 생성
- @AllArgsConstructor: 모든 필드를 파라미터로 갖는 생성자 생성
- @Log: log라는 변수를 이용해 로그 기능을 사용할 수 있음
- @Value: 불변 클래스 생성 / 모든 필드를 private, final로 설정하고 setter를 생성하지 않음


