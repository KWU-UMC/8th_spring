# 3주차 미션

## 주어진 조건에 필요한 API를 설계하여 간단한 API 명세서 만들기

### 홈 화면
- API Endpoint: GET /home
- Request Body: GET 이므로 필요하지 않음
- Request Header: Authorization: Bearer {token} > 인증에 사용 (사용자 로그인)
- 사용자의 토큰을 헤더에 포함해 사용자가 누구인지 확인
- Query String: mission-status=progress > 진행중인 미션을 불러옴
- Path Variable: 사용자 정보는 헤더에 포함되므로 필요하지 않음


### 마이페이지 리뷰 작성
(마이페이지 화면인지 리뷰 작성을 말하는 것인지 몰라서 리뷰 작성에 대한 api 명세서를 구현하였습니다.)
- API Endpoint: POST/mission/{mission-id}/review
- Request Body: 
{
    "rating: 5"
    "comment": "잘 먹었습니다"
}

- Request Header: Authorization: Bearer {token}
- Query String: Request Body에 데이터를 포함하였기에 필요하지 않음
- Path Variable: mission-id > 미션의 고유 ID



### 미션 목록 조회(미션중, 미션완료)
- API Endpoint: GET /mission
- Request Body: 데이터 조회이므로 필요하지 않음
- Request Header: Authorization: Bearer {token}
- Query String: GET /missions?mission-status=completed(미션완료)/progress(진행중)
- Path Variable: 미션 목록 전체를 조회하므로 특정 ID가 필요하지 않음




### 미션 성공 누르기
- API Endpoint: POST /mission/{mission-id}/completed
- Request Body: 단순 성공 처리에는 필요하지 않음
- Request Header: Authorization: Bearer {token}
- Query String: 단순 성공 처리에는 필요하지 않음
- Path Variable: mission-id



### 회원 가입 (소셜 로그인 고려 X)
- API Endpoint: POST /userinfo/register
- Request Body
{
  "name": "홍길동",
  "gender": "male",
  "birthyear": "2001",
  "birthmonth": "05",
  "birthday": "22",
  "address": "서울시 강남구 테헤란로 123"
}
- Request Header: content-type: application/json
- Query String: 새로운 데이터를 생성하는 것이므로 필요하지 않음
- Path Variable: 새로운 데이터를 생성하는 것이므로 필요하지 않음 

