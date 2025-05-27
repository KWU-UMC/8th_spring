# 9주차 미션

## CustomPage 어노테이션 
- 프론트에서 page=1부터 시작하는 쿼리를 보낼 때, 백에서 page-1로 변환
- page 값이 <= 0 이면 예외 처리하여 에러 응답

### ![커스텀어노테이션.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/%EC%BB%A4%EC%8A%A4%ED%85%80%EC%96%B4%EB%85%B8%ED%85%8C%EC%9D%B4%EC%85%98.png)
- page 파라미터를 입력하지 않았을 때 정상적으로 에러 문구가 출력됨을 확인하였음

### ![커스텀어노테이션2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/%EC%BB%A4%EC%8A%A4%ED%85%80%EC%96%B4%EB%85%B8%ED%85%8C%EC%9D%B4%EC%85%982.png)
- page=5를 입력했을 때 정상적으로 페이지 번호가 출력됨을 확인하였음 

## 1번 - 내가 작성한 리뷰 목록
### ReviewController.java
- @CustomPage를 통해 page=1 요청시 page=0으로 처리
- 로그인 유저를 하드코딩하여 (user_id=1) 리뷰 목록을 조회함 

### ![1번결과.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88%EA%B2%B0%EA%B3%BC.png)
- user_id=1 에서 작성한 리뷰가 하나였기에 정상적으로 하나의 리뷰가 출력됨을 확인하였음


## 2번 - 특정 가게의 미션 목록
### ![2번DB.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88DB.png)
- store DB에 더미데이터를 삽입함
- store id를 1부터 14까지 하나씩 만들었음
- store id가 1인 가게의 미션은 여러 개 작성함

### ![2번결과.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88%EA%B2%B0%EA%B3%BC.png)
- page=1을 확인했을 때는 10개의 데이터가 정상적으로 출력됨을 확인하였음 (사진에는 아랫부분이 잘렸음)

### ![2번결과2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88%EA%B2%B0%EA%B3%BC2.png)
- page=2를 넣어 확인했을 때, 11번째 데이터부터 정상적으로 출력됨을 확인하였음


## 3번 - 내가 진행중인 미션 목록
### ![3번DB.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/3%EB%B2%88DB.png)
- user_mission DB에 5개의 더미데이터를 삽입하여 확인함
- user_id = 1 데이터를 두 개 삽입하였음

### ![3번결과2.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/3%EB%B2%88%EA%B2%B0%EA%B3%BC2.png)
- 하드코딩 된 userId를 1로 설정했기에 결과값으로 user_id=1인 값 두 개가 정상적으로 출력됨


## 미션 조건 적용 여부 
- 페이징 처리 완료: 한 페이지 당 10개씩 조회
- DB 더미데이터 삽입: mySQL에서 더미데이터를 직접 삽입하여 결과 출력 확인
- CustomPage 어노테이션: 조건을 모두 만족하는 어노테이션 구현 완료
- Swagger 명세: @Operation, @Parameter, @Tag 사용
- Stream 사용: DTO 변환에 stream.map(...).collect(...) 사용
- 빌더패턴 사용: 모든 DTO에 .builder() 사용

#### 깃허브 링크 
-https://github.com/EunSe-o/UMC_Spring/tree/week09
