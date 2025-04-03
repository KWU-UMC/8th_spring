API 명세서가 무엇인지, 어떻게 작성해야 하는지 먼저 알아보았다.

API 명세서는 API의 사용 방법, 요청 형식, 응답 데이터 구조 등을 문서화한 것이라고 한다. API를 사용하는 개발자가 쉽게 이해하고 연동할 수 있도록 설명하는 역할을 한다.

API 명세서의 구성요소는 미션에서 요구한 API Endpoint, Request Body, Request Header, Query String, Path variable 만을 작성했다.

## 1. **홈 화면**

```markdown
## 홈 화면 API

### 1. 개요
- **설명:** 사용자의 홈 화면 구성 정보를 GET 요청을 통해 데이터베이스에 조회하는 API

### 2. 요청
- **API Endpoint:** `GET /home`
- **Path variable:** `null (Not necessary)`
- **query String:** `null (Not necessary)`
- **Request Header:** `Authorization : accessToken(Bearer) (String)`
- **Request Body:** `null (Not necessary)`
```

홈 화면을 구성하는 정보를 요청하는 API이다. 기본적으로 JWT 토큰을 사용했다고 가정했다.

API Endpoint는 GET 요청으로 ‘/home’ url에 API를 요청한다.

Path variable은 이 API에서 필요로 하지 않는다.

query String은 이 API에서 필요로 하지 않는다. Authorization 토큰에 사용자의 id 정보가 포함되어 있다고 생각했다.

Request Header는 유저의 권한(Authorization) 토큰을 사용한다.

Request Body는 GET 요청 메소드에서는 필요하지 않다.

## 2. **마이 페이지 리뷰 작성**

```markdown
## 마이 페이지 리뷰 작성 API

### 1. 개요
- **설명:** 사용자가 작성한 가게의 리뷰를 POST 요청을 통해 데이터베이스에 데이터를 삽입하는 API

### 2. 요청
- **API Endpoint:** `POST /restaurants/reviews`
- **Path variable:** `null (Not necessary)`
- **query String:** `null (Not necessary)`
- **Request Header:** `Authorization : accessToken(Bearer) (String)`
- **Request Body:**
`
	JSON
	{
		"restaurant": "이층집",
		"score": 5,
		"contents": "광운대 부대찌개 맛집!",
		"image": "food_image.jpg",
	}
`
```

마이 페이지 리뷰 작성은 마이 페이지에서 리뷰 작성이 없는 것 같아서 그냥 리뷰 작성을 하는 API로 생각하고 명세서를 작성했다.

API Endpoint는 POST 요청으로 ‘/restaurants/reviews’ url로 API를 요청한다. 음식점과 리뷰의 관계가 N:M이어서, 가게(음식점)의 리뷰이므로 restaurants를 앞에 두었다.

Path variable은 이 API에서 필요로 하지 않는다.

query String은 이 API에서 필요로 하지 않는다.

Request Header는 유저의 권한(Authorization) 토큰을 사용한다.

Request Body는 유저의 id, 음식점, 별점, 리뷰 본문, 이미지 정보를 전달한다.

## 3.**미션 목록 조회(진행 중, 진행 완료)**

```markdown
## 미션 목록 조회 API

### 1. 개요
- **설명:** 사용자가 진행 중이거나 진행 완료한 미션을 GET 요청을 통해 데이터베이스에서 조회하는 API

### 2. 요청
- **API Endpoint:** `GET /missions`
- **Path variable:** `null (Not necessary)`
- **query String:** `null (Not necessary)` or `?status=진행 중,진행 완료`
- **Request Header:** `Authorization : accessToken(Bearer) (String)`
- **Request Body:** `null (Not necessary)`
```

진행 중 그리고 진행 완료 미션 목록 조회를 요청하는 API이다.

API Endpoint는 GET 요청으로 ‘/missions’ url로 API를 요청한다.

Path variable은 이 API에서 필요로 하지 않는다.

query String은 이 API에서 필요로 하지 않는다. 미션의 상태가 진행 중 또는 진행 완료만 있다고 생각했다. 만약 다른 상태가 있다면 `?status=진행 중,진행 완료`가 되어야한다.

Request Header는 유저의 권한(Authorization) 토큰을 사용한다.

Request Body는 이 API에서 필요로 하지 않는다.

## 4.**미션 성공 누르기, 회원가입 하기(소셜 로그인 고려 X)**

```markdown
## 미션 성공 누르기 API

### 1. 개요
- **설명:** 사용자가 성공한 미션의 상태를 PATCH 요청을 통해 데이터베이스에서 데이터를 갱신하는 API

### 2. 요청
- **API Endpoint:** `PATCH /missions/{mission_id}`
- **Path variable:** `{mission_id}`
- **query String:** `null (Not necessary)`
- **Request Header:** `Authorization : accessToken(Bearer) (String)`
- **Request Body:**
`
	JSON
	{
		"status": "진행 완료"
	}
`
```

사용자가 미션을 성공해서 미션이 상태 변경을 요청하는 API이다.

API Endpoint는 PATCH 요청으로 ‘/missions/{mission_id}’ url로 API를 요청한다.

Path variable은 {mission_id}로 미션의 id 기본키이다. 미션 상태 정보를 업데이트할 미션의 id이다.

query String은 이 API에서 필요로 하지 않는다.

Request Header는 유저의 권한(Authorization) 토큰을 사용한다.

Request Body는 미션의 상태 정보만 업데이트하면 되므로 {"status": "진행 완료"} 정보를 담고있다.

```markdown
## 회원가입 하기 API

### 1. 개요
- **설명:** 사용자가 회원가입 폼으로 입력한 정보를 POST 요청을 통해 데이터베이스에 데이터를 삽입하는 API

### 2. 요청
- **API Endpoint:** `POST /users/signup`
- **Path variable:** `null (Not necessary)`
- **query String:** `null (Not necessary)`
- **Request Header:** `null (Not necessary)`
- **Request Body:**
`
	JSON
	{
		"user_id": "userid123",
		"user_pw": "userpw123",
		"age": 20,
		"gender": "남",
		"email": "abc123@naver.com",
		"address": "서울특별시 광운구 인융동 컴공로",
		...
	}
`
```

사용자가 회원가입을 진행하면서 새로운 회원정보의 생성을 요청하는 API이다.

API Endpoint는 POST 요청으로 ‘/user/signup’ url로 API를 요청한다.

Path variable은 이 API에서 필요로 하지 않는다.

query String은 이 API에서 필요로 하지 않는다.

Request Header는 이 API에서 필요로 하지 않는다. 사용자가 아직 회원이 아니기 때문이다.

Request Body는 유저의 가입 아이디, 가입 패스워드, 나이, 성별, 이메일, 주소 등의 정보를 담고있다.