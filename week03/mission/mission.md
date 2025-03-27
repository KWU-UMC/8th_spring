## 홈 화면 API

---

### ☑️ API 이름

홈 화면 데이터 조회

### ☑️  Endpoint

`GET /home`

### ☑️ Request Body

get 요청이므로 없음

### ☑️ Request Header

Authorization : accessToken (String)

### ☑️ Query String

`GET /home?location=안암동`

- 피그마에 지역 선택 기능이 있는 듯 하여(한 유저가 여러개의 지역 등록 가능) 쿼리 스트링을 넣었습니다!
## **마이 페이지 리뷰 작성** API

---

### ☑️ API 이름

마이페이지 리뷰 작성

### ☑️  Endpoint

`POST /users/{user_id}/reviews`

- 생성 시 POST는 보통 복수형 경로(reviews)

### ☑️ Request Body

```jsx
Body:
{
  "store_id": {현재 리뷰 쓰는 store_id},
  "body": "맛있었어요!",
  "score": 5,
  "images" : {이미지 url}
}
```

### ☑️ Request Header

Authorization : accessToken (String)

### ☑️ Query String

없음.

## **미션 목록 조회(진행중, 진행 완료)** API

---

### ☑️ API 이름

미션 목록 조회 : 로그인 한 사용자의 미션 목록을 조회하는 것

### ☑️  Endpoint

`GET/missions`

### ☑️ Request Body

get 요청이므로 없음

### ☑️ Request Header

Authorization : accessToken (String)

### ☑️ Query String

`GET /missions?status="진행중"`

- 진행중을 선택했을 경우
## **미션 성공 누르기** API

---

### ☑️ API 이름

**미션 성공 누르기** :

사용자가 해당 미션을 완료했음을 서버에 알리고,

사장님 인증 번호(구분 번호)를 반환받는 API

### ☑️  Endpoint

`POST /missions/{mission_id}/complete-request`

### ☑️ Request Body

```jsx
{
  "store_id": 12
}
```

### ☑️ Request Header

Authorization : accessToken (String)

### ☑️ Query String

- 없음

### ☑️ Response

- “성공요청” 버튼을 눌렀을 경우, post 요청 뒤 인증 코드 생성하여 클라이언트에게 반환하는 값
  ```jsx
  {
  "auth_code": "920394810" // 인증번호
  }
  ```
  ## **회원 가입 하기(소셜 로그인 고려 X) API**

---

### ☑️ API 이름

회원가입

### ☑️  Endpoint

`POST /users/signup`

### ☑️ Request Body

```jsx
{
  "name": {사용자 이름},
  "gender" : {사용자 성별},
  "age" : {사용자 나이},
  "address" : {사용자 주소},
  "preferences": [선호 음식 카테고리 ID 목록(숫자)]
}
```

### ☑️ Request Header

- 로그인 전 상태이므로 회원가입 시에는 **accessToken이 필요 없음**

### ☑️ Query String

- 없음
  