https://github.com/kimdanha/UMC8th_project
https://velog.io/@danha/Spring-Boot-%EC%97%90%EB%9F%AC%EB%A5%BC-%EB%94%94%EC%8A%A4%EC%BD%94%EB%93%9C%EB%A1%9C-%EC%9E%90%EB%8F%99-%EC%A0%84%EC%86%A1%ED%95%98%EA%B8%B0

RestControllerAdvice의 장점

- 전역에서 예외를 처리할 수 있어 컨트롤러마다 `try-catch` 하지 않아도 됨
- 응답 형식을 통일
- 코드 중복이 줄고, 유지보수가 쉬워짐

단점

- 컨트롤러마다 예외 처리 코드를 반복해야 함
- 응답 형식이 제각각이라 통일성이 없음
- 예외가 분산돼 있어 디버깅과 수정이 어려움
