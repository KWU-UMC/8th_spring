# 미션

## 회원가입
### API endpoint

POST `/api/users`

### Request Header

```json
{
  "Content-Type": "application/json"
}
```

### Request Body

```json
{
	"name":"홍길동",
	"gender":"M",
	"birthday":"2000-01-01",
	"address":"서울시 노원구 광운로21",
	"prefer":["한식","양식","중식"],
	"email":"example@example.com",
	"password" :"password123"
}
```

### Response Body

```json
{
	"user_id":123
	
}
```

## 홈화면
### API endpoint

GET `/api/users/home`

### Request Header

```json
{
    "Authorization" : "accessToken", 
    "Content-Type": "application/json"
}
```

### Response Body

```json
{
	"region":"안암동",
	"mission_completed": 7,
	"missions":[
		{
		"member_mission_id":123,
		"d_day":7,
		"store_name":"반이학생마라탕",
		"category":"중식",
		"mission_description":"10,000원 이상 식사시",
		"reward": 500
		},
		{
		"member_mission_id":123,
		"d_day":7,
		"store_name":"반이학생마라탕",
		"category":"중식",
		"mission_description":"10,000원 이상 식사시",
		"reward": 500
		}
	]
	
}
```

## 마이페이지 - 조회
### API endpoint

GET `/api/users`

### Request Header

```json
{
	"Authorization" : "accessToken"
  "Content-Type": "application/json"
}
```

### Response Body

```json
{
	"name":"홍길동",
	"email":"example@example.com",
	"phone_num":null,
	"point":2500
	
}
```

## 마이페이지 - 닉네임 수정
### API endpoint

PATCH `/api/users/nickname`

### Request Header

```json
{
  "Authorization" : "accessToken",
  "Content-Type": "application/json"
}
```

### Request Body

```json
{
	"name":"홍길동 수정"
}
```

## 마이페이지 - 회원 탈퇴
### API endpoint

DELETE `/api/users`

### Request Header

```json
{
  "Authorization" : "accessToken",
  "Content-Type": "application/json"
}
```

## 마이페이지 - 포인트 내역 조회
### API endpoint

PATCH `/api/users/point`

### Request Header

```json
{
  "Authorization" : "accessToken",
  "Content-Type": "application/json"
}
```

### Response Body

```json
{
	"user_id":123,
	"point":22500,
	"mission_list":[
		{
			"member_mission_id":123,
			"store_name":"반이학생 마라탕",
			"mission_description":"1000원이상 식사하세요",
			"reward":500,
			"date":"2025-03-01"
		},
		{
			"member_mission_id":123,
			"store_name":"반이학생 마라탕",
			"mission_description":"1000원이상 식사하세요",
			"reward":500,
			"date":"2025-03-01"
		}	
	],
	"conver_list":[
		{
      "type": "convert",
      "description": "포인트 전환 신청",
      "amount": -20000,
      "date": "2025-03-01"
    }
	]
}
```

## 리뷰 작석
### API endpoint

POST `/api/reviews`

### Request Header

```json
{
  "Authorization" : "accessToken",
  "Content-Type": "application/json"
}
```

### Request Body

```json
{
	"score": 5.0,
	"store_id": 123,
	"body": "너무 맛있어요",
	"image": file
	
}
```
## 미션 목록 조회
### API endpoint

GET `/api/reviews`

### Query String

- status = {completed/ongoing}

```json
status=completed & page=1 & limit=5
```

### Request Header

```json
{
  "Authorization" : "accessToken",
  "Content-Type": "application/json"
}
```

### Response Body

```json
{
  "user_id": 123,
  "status": "completed",
  "page": 1,
  "limit": 5,
  "total": 12,
  "missions": [
    {
      "member_mission_id": 123,
      "store_name": "가게이름a",
      "mission_description": "12,000원 이상의 식사를 하세요!",
      "reward": 500,
      "status": "성공",
      "write_review": true,
      "date": "2025-03-01"
    },
    {
      "member_mission_id": 123,
      "store_name": "가게이름a",
      "mission_description": "12,000원 이상의 식사를 하세요!",
      "reward": 500,
      "status": "성공",
      "write_review": true,
      "date": "2025-03-01"
    }
  ]
}

```

## 미션 성공 누르기
### API endpoint

PATCH `/api/missions/success`

### Request Header

```json
{
  "Authorization" : "accessToken",
  "Content-Type": "application/json"
}
```

### Response Body

```json
{
	"member_mission_id" : 123
}
```

### Response Body

```json
{
  "verify_code": 123,
  "status" : "completed"
}

```

# 시니어 미션
https://velog.io/@sunnin/UMC-POST-PATCH-설계할수록-헷갈리는-API-정리