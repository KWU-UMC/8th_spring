# 핵심 키워드

## RestContollerAdvice
- `@ControllerAdvice` + `@ResponseBody` 의 조합
- 모든 컨트롤러에서 발생한 예외를 전역적으로 처리하고 JSON 형식으로 응답을 반환함
- **@ControllerAdvice**
    - 모든 컨트롤러에서 발생하는 예외를 전역적으로 처리할 수 있음
    - 반환 형식: View (HTML)
- **@RequestBody**
    - 메서드의 반환 값을 JSON 또는 XML 등 HTTP 응답 본문으로 변환


## lombok

💡 개념

어노테이션 기반으로 코드 자동완성 기능을 제공하는 라이브러리

💡 장점

1. 보일러플레이트 코드 감소
   
    반복적으로 작성해야 하는 getter, setter, 생성자 등의 코드를 어노테이션으로 자동 생성

    > 📌  보일러플레이트란? 반복적으로 사용하는 기본적인 코드 블록


2. 코드의 간결성과 가독성 향상

   불필요한 코드가 줄어들어 핵심 로직에 집중할 수 있고 코드가 더 읽기 쉬워짐


3. 개발 생산성 향상

   코드 작성 시간 단축, 실수 가능성 감소, 유지보수 편의성 증가


💡 자주 사용하는 어노테이션
    
| 어노테이션 | 설명 |
| --- | --- |
| @Getter | 모든 필드에 대해 getter 메서드 생성 |
| @Setter | 모든 필드에 대해 setter 메서드 생성 |
| @ToString | 모든 필드를 포함한 toString() 메서드 생성 |
| @NoArgsConstructor | 파라미터 없는 기본 생성자 생성 |
| @AllArgsConstructor | 모든 필드를 파라미터로 받는 생성자 생성 |
| @RequiredArgsConstructor | final 또는 @NonNull이 붙은 필드만 포함한 생성자 생성 |
| @Data | @Getter, @Setter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor를 포함한 종합 어노테이션 |
| @Builder | 빌더 패턴 메서드 자동 생성 |
| @Value | @Data와 비슷하지만 모든 필드를 final로 만들어 불변 객체 생성 |
| @Slf4j | log 객체 자동 생성 (로깅용) |


## Inner Class

💡 개념

- 클래스 내부에 또 다른 클래스를 선언하는 방식
- 클래스 내부에 `public static class`  형태로 사

💡 Inner Class로 DTO 관리

  - 요청/응답 DTO를 매번 별도의 파일로 만들면 파일 수가 많아져 관리가 복잡해짐
  - 기능 또는 도메인 단위로 DTO를 하나의 클래스 내부에 Inner Class로 모아 관리하면 별도의 Dto 클래스 파일을 생성할 필요없이 클래스 안에서 관리할 수 있음

💡 주의할 점`static`으로 선언할 것

  - static을 붙이지 않으면?
      - inner 클래스가 outer class의 인스턴스에 자동으로 연결됨

    →불필요한 메모리 사용 → 생성 속도 저하 → outer class에 대한 참조가 남아 가비지 컬렉션이 메모리 해지 못함 → 메모리 누수 발생

    ⇒ DTO는 out class에 독립적으로 동작하므로 반드시 `static` 으로 선언하기