# 📘 API 명세서

> Access Token에 사용자 정보가 포함되어 있으므로, 회원가입을 제외한 API에서는 사용자 정보를 별도로 전달하지 않는다.

> Request Header에서 'Authorization' 외의 정보는 생략

---

## 1. 🏠 홈 화면
현재 선택된 지역을 전달한다.\
GET을 사용하여 홈 화면의 정보를 요청한다.

| 항목            | 내용                                      |
|-----------------|-------------------------------------------|
| **API Endpoint** | `GET /users/home?location=LOCATION`       |
| **Request Body** | X                                         |
| **Request Header** | Authorization: Bearer {accessToken}     |
| **Query String** | `?location=LOCATION`                      |
| **Path Variable** | X                                        |

---

## 2. ✍️ 마이 페이지 리뷰 작성
작성 날짜, 평점, 리뷰 내용, 가게 정보(id)를 전달한다.\
POST를 사용하여 리뷰 생성을 요청한다.

| 항목            | 내용                                  |
|-----------------|-------------------------------------|
| **API Endpoint** | `POST /reviews/{store-id}`          |
| **Request Body** | {                                   |
|                 | "created_at": "{created_at}",       |
|                 | "rating": "{rating}",               |
|                 | "content": "{content}"              |
|                 | }                                   |
| **Request Header** | Authorization: Bearer {accessToken} |
| **Query String** | X                                   |
| **Path Variable** | `{store-id}`                        |

---

## 3. 📋 미션 목록 조회
상태(진행중 / 진행완료)를 전달한다.\
GET을 사용하여 미션 목록을 요청한다.

| 항목            | 내용                                          |
|-----------------|-----------------------------------------------|
| **API Endpoint** | `GET /missions?state=STATE`                   |
| **Request Body** | X                                             |
| **Request Header** | Authorization: Bearer {accessToken}         |
| **Query String** | `?state=STATE` (`진행중` or `진행완료`)        |
| **Path Variable** | X                                            |

---

## 4. ✅ 미션 성공 처리

미션 정보(id), 변경할 미션 상태(completed)를 전달한다.\
PATCH를 사용하여 미션 상태를 변경한다.

| 항목            | 내용                                      |
|-----------------|-------------------------------------------|
| **API Endpoint** | `PATCH /missions/{mission-id}`            |
| **Request Body** |{                                           |
|                 |   "state": "completed"                    |
|                 | }                                         |
| **Request Header** | Authorization: Bearer {accessToken}     |
| **Query String** | X                                         |
| **Path Variable** | `{mission-id}`                            |

---

## 5. 👤 회원 가입

회원 정보(아이디, 비밀번호, 이름, 성별, 이메일, 휴대폰 번호 등)를 전달한다.\
POST를 사용하여 회원 생성을 요청한다.

| 항목            | 내용                             |
|-----------------|--------------------------------|
| **API Endpoint** | `POST /users`                  |
| **Request Body** | {                              |
|                 | "username": "{username}",      |
|                 | "password": "{password}",      |
|                 | "name": "{name}",              |
|                 | "gender": "{gender}",          |
|                 | "email": "{email}",            |
|                 | "phoneNumber": "{phoneNumber}" |
|                 | }                              |
| **Request Header** | X                              |
| **Query String** | X                              |
| **Path Variable** | X                              