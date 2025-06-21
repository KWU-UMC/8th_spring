# 10주차 미션

## 1. Spring Security를 활용한 로그인 및 회원가입 구현 > Session방식
### 회원가입
![1번-회원가입성공.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88-%ED%9A%8C%EC%9B%90%EA%B0%80%EC%9E%85%EC%84%B1%EA%B3%B5.png)
- 정보를 입력하여 회원가입 요청시 성공 확인

### DB에 저장된 회원 정보 확인
![1번-코드수정.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88-%EC%BD%94%EB%93%9C%EC%88%98%EC%A0%95.png)
- 회원가입 후 로그인 시도 시에 로그인이 안 되는 문제 발생
- mySQL workbench를 통해 확인해보니 회원가입 요청을 보내도 DB에 제대로 저장이 안 되고 있음을 확인
- @Transaction 어노테이션을 추가하여 해결

### 로그인 시도 화면
![1번-로그인.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88-%EB%A1%9C%EA%B7%B8%EC%9D%B8.png)
![1번-쿠키.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88-%EC%BF%A0%ED%82%A4.png)
- Postman을 사용해 로그인 요청시 응답은 200 OK, 쿠키 탭에는 JSESSIONID가 생성됨을 확인
- 내부적으로는 302 login-success가 일어났지만, Postman은 리디렉션을 따라가지 않아 최종 결과가 200 OK로 출력됨 (정상출력)

### 로그아웃 요청 후 결과
![1번-로그아웃.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/1%EB%B2%88-%EB%A1%9C%EA%B7%B8%EC%95%84%EC%9B%83.png)
- 로그아웃 성공하여 로그 출력됨을 확인

## 2. Spring Security를 활용한 로그인 및 회원가입 구현 > JWT 방식
### 회원가입
![2번-회원가입성공.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88-%ED%9A%8C%EC%9B%90%EA%B0%80%EC%9E%85%EC%84%B1%EA%B3%B5.png)
- JWT 방식으로 회원가입 요청했을 때 정상적으로 요청됨을 확인

### DB에 저장된 회원 정보 확인
![2번-DB.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88-DB.png)
- JWT 방식으로 회원가입 후, mySQL 에서 DB에 저장된 회원 정보를 확인 (정상 저장)
- 암호화되어 password가 저장되었음을 확인할 수 있음

### 로그인 시도 화면
![2번-로그인성공.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88-%EB%A1%9C%EA%B7%B8%EC%9D%B8%EC%84%B1%EA%B3%B5.png)
- 로그인 성공시 token이 출력됨을 확인할 수 있음
- 해당 token을 헤더에 추가해 추가 API 요청 가능

### 로그아웃 요청 후 결과
![2번-로그아웃.png](../../../../Users/%EB%B0%95%EC%9D%80%EC%84%9C/Documents/%EC%B9%B4%EC%B9%B4%EC%98%A4%ED%86%A1%20%EB%B0%9B%EC%9D%80%20%ED%8C%8C%EC%9D%BC/2%EB%B2%88-%EB%A1%9C%EA%B7%B8%EC%95%84%EC%9B%83.png)
- 헤더에 추가했던 token을 포함하지 않고 로그인 요청을 보내 로그아웃 되었음을 확인할 수 있음 
- JWT는 서버에 상태를 저장하지 않기 때문에 로그아웃 API가 따로 필요하지 않음