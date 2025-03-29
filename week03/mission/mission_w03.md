# 💡 Content-Type과 Authorization 헤더 정리

## 1. `Content-Type: application/json`

> 보낼 데이터의 형식이 json 형식이라는 것을 서버에 알려줌
>

```
POST /api/users/register
Content-Type: application/json

{
  "name": "홍길동",
  "email": "hong@example.com"
}

```


### 결론:
- 서버는 위의 요청을 보고 json parser로 읽음
- Content-Type은 **보내는 데이터의 형식**을 명시
- API 호출 중 **POST, PUT, PATCH 등 Body가 있을 때** 반드시 필요

---

## 2. `Authorization: Bearer {token}`

> 로그인한 사용자를 인증해주는 역할을 함
>

```
GET /api/users/123/missions
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR...

```

### 결론:
- 위의 요청을 통헤 서버는 토큰이 있다는 것을 알고, 사용자의 토큰 검증
- Authorization은 **사용자 인증**을 위해 사용됨
- 토큰은 로그인 성공 시 발급되며, 이후 요청마다 첨부해야 함
    - stateless 특성 때문
- 서버는 이 토큰을 보고 이 요청이 누구의 요청인지를 판단함

# 📋 API 명세서
| API 명 | HTTP Method | endpoint | Path Variable | Query String | Request Header | Request Body | Response |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 홈화면 | GET | `/api/region/{region_id}/home` | `region_id` | `status=진행전` | `Authorization: Bearer {token}` | - | `{ "region_name": "string", "missions": [ { "mission_name": "string" } ] }` |
| 마이페이지 리뷰작성 | POST | `/api/store/{store_id}/reviews` | `store_id` | - | `Content-Type: application/json Authorization: Bearer {token}` | `{ "user_id": int, "score": int, "description": "string", "photo_url": "string" }` | `{ "status": 200, "message": "success" }` |
| 미션 목록 조회 | GET | `/api/user/{user_id}/missions` | `user_id` | `status=진행중` or `status=완료` | `Authorization: Bearer {token}` | - | `[ { "mission_id": int, "mission_name": "string", "status": "string" } ]` |
| 미션 성공 누르기 | PATCH | `/api/mission/{mission_id}` | `mission_id` | - | `Content-Type: application/json`
Authorization: Bearer {token}` | `{ "user_id": int, "status": "완료" }` | `{ "status": 200, "message": "success" }` |
| 회원가입 | POST | `/api/user/register` | - | - | `Content-Type: application/json` | `{ "name": "string", "gender": "string", "birthdate": "YYYY-MM-DD", "email": "string", "address": "string" }` | `{ "status": 200, "message": "success" }` |