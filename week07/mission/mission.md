https://github.com/kimdanha/UMC8th_project

RestControllerAdvice의 장점

- 전역에서 예외를 처리할 수 있어 컨트롤러마다 `try-catch` 하지 않아도 됨
- 응답 형식을 통일
- 코드 중복이 줄고, 유지보수가 쉬워짐

단점

- 컨트롤러마다 예외 처리 코드를 반복해야 함
- 응답 형식이 제각각이라 통일성이 없음
- 예외가 분산돼 있어 디버깅과 수정이 어려움
