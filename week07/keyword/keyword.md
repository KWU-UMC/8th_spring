# 핵심 키워드
## RestContollerAdvice
- `@RestControllerAdvice`는 `@ControllerAdvice`와 거의 동일하지만, 한 가지 큰 차이점은 이 어노테이션을 사용하면 `@ResponseBody`가 암시적으로 추가된다는 것이다. 따라서 JSON 형태로 바로 응답을 보낼 수 있다.
- ResponseEntity나 POJO 객체를 반환하여 JSON 형태로 응답할 수 있다.
- **RESTful** 웹 서비스에서 주로 사용된다.

## lombok
- 자바의 Annotation processsor라는 기능을 이용해서 컴파일 시점에 Lombok의 어노테이션을 읽어서, 다양한 메스드와 생성자(getter, setter, constructor등등)를 생성해주는 라이브러리
  = 개발자가 해야하는 기본적이고 반복적인 일들을 정해진 위치에 @어노테이션만 붙여주면, Lombok이 이런 일들을 대신 해주는 것

### lombok의 효과
1) Getter/Setter
- 💧 Before: 필드(변수) 하나에 getter와 setter를 생성해줘야해서 코드양이 많다.
- 🔥 After: Lombok이 getter와 setter를 생성해주기 때문에 필드만 생성해주면 된다.

### 2) Constructor
`@RequiredArgsConstructor` 라는 어노테이션은 `final` 또는 `@NonNull` 키워드가 붙은 필드에 대해서 생성자를 자동으로 만들어준다.
- 💧 Before: 보다시피 인자를 받아서 변수에 할당해주는 생성자를 작성해줘야한다.
- 🔥 After: 어노테이션만 붙여주면, 끝! 코드엔 안보이지만 아래와 같은 생성자가 만들어져있는 것과 같다.