# 8주차 미션

## 1. 특정 지역에 가게 추가하기 API
### ![store 추가.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/store%20%EC%B6%94%EA%B0%80.png)
- mission에서 주소 정보를 받아 가게 엔티티를 따로 만들지 않고 진행하였었음
- store 엔티티를 만들어 mission에서 주소를 빼고, 가게 관련된 것은 모두 store로 옮기고 코드 수정

### ![1번확인.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88%ED%99%95%EC%9D%B8.png)
- POSTMAN을 이용하여 특정 지역에 가게를 추가하는 API 구현을 확인함
- 사진처럼 이름과 주소, 시,구,동을 기입하여 POST를 보냈을 때, 정상적으로 id가 추가됨을 확인할 수 있음


## 2. 가게에 리뷰 추가하기 API
### ![status값변경.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/status%EA%B0%92%EB%B3%80%EA%B2%BD.png)
- 이전에 만든 DB에는 mission status 값이 new로 되어있어서 new_로 바꾸었음 -> 자바 코드에서는 new사용이 불가하기 때문

### ![NotNull.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/NotNull.png)
- @NotNull과 @NotBlank를 통해 입력 받은 값을 체크함 

### ![2번검증.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88%EA%B2%80%EC%A6%9D.png)
- 정상값을 입력했을 때의 결과 검증 완료

### ![2번검증_2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88%EA%B2%80%EC%A6%9D_2.png)
- 없는 mission id를 입력 받았을 때의 오류 메시지 출력 확인
- 가게가 없을 때의 예외 어노테이션은 따로 구현하였음

## 3. 가게의 미션을 도전 중인 미션에 추가 API 
### ![4번포트오류.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/4%EB%B2%88%ED%8F%AC%ED%8A%B8%EC%98%A4%EB%A5%98.png)
- 8080 포트가 이미 실행중이라 재실행할 수 없다는 오류 발생

### ![포트강제종료.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/%ED%8F%AC%ED%8A%B8%EA%B0%95%EC%A0%9C%EC%A2%85%EB%A3%8C.png)
- cmd창에서 포트를 강제종료해 재실행 가능하도록 문제 해결

### ![4번검증완료_1.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/4%EB%B2%88%EA%B2%80%EC%A6%9D%EC%99%84%EB%A3%8C_1.png)
- id = 1을 입력했을 때 정상적으로 동작함을 확인

### ![4번오류메시지누락.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/4%EB%B2%88%EC%98%A4%EB%A5%98%EB%A9%94%EC%8B%9C%EC%A7%80%EB%88%84%EB%9D%BD.png)
- 그러나 id = 1을 재입력했을 때, 오류 메시지가 출력되지 않음

### ![4번검증완료_2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/4%EB%B2%88%EA%B2%80%EC%A6%9D%EC%99%84%EB%A3%8C_2.png)
- GlobalExceptionHandler 파일을 추가하여 문제해결
- 해당 파일에서는 @RestControllerAdvice를 통해 모든 컨트롤러의 예외를 전역에서 찾아 유효성 검사가 실패했을 때, @ExceptionHandler 메서드로 가게 함
- 어노테이션에서 지정한 메시지를 이용해 JSON 응답을 구성하였음


## 미션 조건 확인
- 2번 요구사항대로 controller, service, converter, dto, repository를 모두 활용하여 미션을 진행하였음
- GlobalExceptionHandler를 구현, @Valid + 커스텀 메시지 응답을 확인하였음
- 2번 API에서 @ExistsMission, @ExistsStore 어노테이션을 구현
- 각 어노테이션들로 미션과 해당 미션에 연결된 가게가 존재하는지 검증 후 메시지 응답
- 4번 API에서 @ExistsMissionNotChallenged 어노테이션을 구현
- 검증하여 이미 도전 중이면 "이미 도전 중인 미션입니다" 메시지 응답
