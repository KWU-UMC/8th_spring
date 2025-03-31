# 홈 화면
## - API Endpoint
    POST /users/login

## - Request Body
    {
	    "id": "user",
        "password": "123"
    }

## - Request Header
    Authorization : accessToken (String)

# 마이 페이지 리뷰 작성
1. 로그인한 사용자만 리뷰 작성 가능 → 사용자 아이디 1개
2. 특정 가게에 대한 리뷰 작성 → 가게마다 식별ID 필요(storeId)
3. 리뷰=내용+별점 → 별점(rating)
-------
## - API Endpoint
    POST /store/{storeId}/review
## 스터디
POST는 보통 복수형 경로로 표시 
-> POST /store**s**/{storeId}/review**s**

## - Request Body
    {
        "comment": "음식이 정말 맛있어요!",
        "rating": 5.0
    }

## - Request Header
    Authorization : accessToken (String)
### 스터디
Content-Type: application/json 추가 
**WHY?** Request Body이 json 형식이기 때문에
-> Authorization : accessToken (String)
   content-Type: application/json

## - Path variable
    GET /store/{storeId}/review

# 미션 목록 조회(진행 중, 진행 완료)
## - API Endpoint
    GET /mission

## - Request Body
    {
        "mission": [
        {
            "missionId": 1,
            "title": "미션 1",
            "status": "incompletd",
            "deadline": "2025-04-15",
            "mission_spec": "(미션 내용)"
        }
    }
### 스터디
목적: 서버에 요청. GET:조회. GET은 Request Body 사용 X

## - Request Header
    Authorization : accessToken (String)

## - query String
    GET /mission?status=completed&status=incompleted
### 스터디
?(조건)은 필터링 개념. AND, OR의 개념은 없음. 조건 한 번에 써주기

# 미션 성공 누르기
## - API Endpoint
    POST /mission/{missionId}/success
### 스터디
PATCH로 상태만 바꿔주기도 가능. 굳이 목록으로 안 만들어도 됨.

## - Request Body
    {
	    "status" : "completed",
	    "missionId" : 1,
	    "updated_at" : "20xx-xx-xx (시간)"
    }
### 스터디
POST일 경우에 →"status" : "completed"
PATCH로 상태만 바꿔주기 → "status" : "completed" 안 써도 됨

## - Request Header
    Authorization : accessToken (String)

## - query String
    GET /mission?status=completed

## - Path variable
    GET /missions/{missionId}

# 회원 가입 하기(소셜 로그인 고려 X)
## - API Endpoint
    PATCH /users
### 스터디
PATCH → POST. 아예 정보를 처음 생성할 때, POST
Endpoint는 unique 해야 함. 보통 생성:POST, 수정:PATCH, 삭제:DELETE

## - Request Body
    {
        "name": "홍길동",
        "gender": "female",
        "birth": "20xx-xx-xx",
        "address": "서울특별시 노원구 광운로 20",
        "category" : "korean"
    }

## - Request Header
    Authorization : json
### 스터디
형식이 잘못됨 → Content-Type: application/json
