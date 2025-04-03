# 추가 공부

## REST API와 RESTful API의 차이점

### 1. **REST API란?**

- **REST (Representational State Transfer)** 원칙을 따르는 API를 의미합니다.
- HTTP 메서드(`GET`, `POST`, `PUT`, `DELETE` 등)를 사용하여 리소스를 처리합니다.
- 리소스를 URL(엔드포인트)로 표현하고, JSON 또는 XML을 주고받는 것이 일반적입니다.

예:

```
GET https://api.example.com/users/1
```

이 요청은 ID가 `1`인 사용자의 정보를 가져오는 REST API 호출입니다.

---

### 2. **RESTful API란?**

- REST 원칙을 **잘 준수한** API를 의미합니다.
- 모든 REST API가 RESTful API는 아닙니다.
- RESTful API는 다음 기준을 충족해야 합니다.
    1. **클라이언트-서버 구조 (Client-Server)**
        - 클라이언트(사용자)와 서버(데이터 제공자)가 분리되어야 합니다.
    2. **무상태성 (Stateless)**
        - 서버는 클라이언트의 상태를 저장하지 않습니다. 요청마다 필요한 정보를 포함해야 합니다.
    3. **캐시 가능 (Cacheable)**
        - 응답을 캐싱할 수 있어야 합니다.
    4. **계층화된 시스템 (Layered System)**
        - API 요청이 여러 계층(로드 밸런서, 보안 계층 등)을 거쳐 처리될 수 있어야 합니다.
    5. **일관된 인터페이스 (Uniform Interface)**
        - 리소스를 URI로 식별하며, HTTP 메서드(`GET`, `POST`, `PUT`, `DELETE`)를 올바르게 사용해야 합니다.
    6. **코드 온 디맨드 (Code on Demand, 선택적)**
        - 필요하면 클라이언트가 서버에서 실행할 코드(JavaScript 등)를 받을 수도 있습니다. (필수 아님)

---

### 3. **REST API vs. RESTful API 차이점**

| 개념 | 설명 | 예시 |
| --- | --- | --- |
| REST API | REST 원칙을 따르는 API | `GET /users/1` |
| RESTful API | REST 원칙을 철저히 준수하는 API | 무상태성, 계층 구조, 일관된 인터페이스 적용 |

즉, **모든 RESTful API는 REST API이지만, 모든 REST API가 RESTful API는 아닙니다.**

REST 원칙을 어긴 REST API(예: HTTP 메서드 대신 `GET /deleteUser?id=1` 같은 요청 사용)는 RESTful하지 않습니다.


## HTTP 메소드

### **HTTP 메소드란?**

HTTP 메소드는 클라이언트가 서버에 **어떤 작업을 수행할지** 지정하는 명령어입니다.

RESTful API에서 자원을 다룰 때 많이 사용됩니다.

---

### **1. 주요 HTTP 메소드**

#### **1) GET - 데이터 조회**

- 서버에서 데이터를 가져올 때 사용
- 요청 바디가 없음 (쿼리 스트링으로 데이터 전달 가능)
- 브라우저에서 URL을 입력하면 기본적으로 `GET` 요청이 발생

---

#### **2) POST - 데이터 생성**

- 서버에 **새로운 데이터**를 추가할 때 사용
- 요청 바디(`body`)에 데이터를 포함해야 함
- 여러 번 호출하면 **중복된 데이터가 생성될 가능성**이 있음 (멱등하지 않음)

---

#### **3) PUT - 데이터 전체 수정**

- 기존 데이터를 **덮어쓰기(완전 대체)**
- **요청할 때 기존 데이터 전체를 보내야 함**
- 여러 번 호출해도 같은 결과 (멱등함)
---

#### **4) PATCH - 데이터 부분 수정**

- 특정 필드만 수정할 때 사용
- 변경할 데이터만 전송 가능
- 여러 번 호출하면 다를 수도 있음 (멱등하지 않을 수 있음)
---

#### **5) DELETE - 데이터 삭제**

- 데이터를 삭제할 때 사용
- 보통 요청 바디 없이 실행됨
- 여러 번 호출해도 같은 결과 (멱등함)
---

#### **6) OPTIONS - 지원하는 HTTP 메소드 확인**

- 서버가 특정 URL에서 **어떤 HTTP 메소드**를 지원하는지 확인
- CORS(교차 출처 리소스 공유) 요청 시 많이 사용
---

#### **7) HEAD - 응답 헤더만 가져오기**

- `GET`과 동일하지만 **응답 바디 없이 헤더만 가져옴**
- 응답의 크기나 캐시 상태 확인할 때 사용
---

#### **8) TRACE - 네트워크 경로 추적**

- 서버까지 가는 네트워크 경로를 디버깅할 때 사용
- 보안 문제로 거의 사용하지 않음
---

#### **9) CONNECT - 터널링 요청**

- 프록시 서버를 통해 SSL/TLS 연결을 설정할 때 사용
- HTTPS 요청을 처리할 때 사용됨
---

**정리하면:**

- **데이터 조회 → `GET`**
- **새로운 데이터 생성 → `POST`**
- **기존 데이터 전체 수정 → `PUT`**
- **기존 데이터 일부 수정 → `PATCH`**
- **데이터 삭제 → `DELETE`**

----------------------------------------------------------------
----------------------------------------------------------------

## **JSON 파일의 헤더(Header)와 바디(Body) 구성**

JSON 자체는 헤더(Header)와 바디(Body) 개념을 가지고 있지 않지만,

**JSON을 API 요청/응답의 형식으로 사용할 때**는 헤더와 바디를 구분하여 사용합니다.

---

## **1. JSON 파일 자체의 구조**

JSON 파일 자체는 **키-값 쌍(Key-Value Pair)**으로 이루어진 데이터 형식이며,

단독으로 사용될 때는 헤더와 바디가 따로 존재하지 않습니다.

---

## **2. API에서 JSON 요청(Request)과 응답(Response)의 헤더와 바디**

JSON이 API에서 사용될 때는 **HTTP Header(헤더) + HTTP Body(바디)** 로 구성됩니다.

### **1) 요청(Request)**

- **헤더(Header)** → 요청의 메타데이터 (JSON 형식, 인증 정보 등)
- **바디(Body)** → 실제 JSON 데이터 (클라이언트가 서버로 전송하는 내용)

✅ **예제 - `POST` 요청 (JSON 데이터 포함)**

```
POST /users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer abcdefg123456
Accept: application/json
Content-Length: 85

{
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
```

| 구성 요소 | 설명 |
| --- | --- |
| **헤더(Header)** | `Content-Type: application/json` → 요청 바디가 JSON 형식임을 지정 |
| **바디(Body)** | 실제 JSON 데이터 (사용자 정보) |

---

### **2) 응답(Response)**

- **헤더(Header)** → 응답의 메타데이터 (JSON 형식, 응답 코드, 캐시 정책 등)
- **바디(Body)** → 실제 JSON 데이터 (서버가 클라이언트에게 보내는 내용)

✅ **예제 - `200 OK` 응답**

```
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 85
Date: Mon, 01 Apr 2024 12:34:56 GMT
Server: nginx/1.21.6
Cache-Control: no-cache

{
  "id": 123,
  "name": "John Doe",
  "email": "john@example.com",
  "age": 30
}
```

| 구성 요소 | 설명 |
| --- | --- |
| **헤더(Header)** | `Content-Type: application/json` → 응답 바디가 JSON 형식 |
| **바디(Body)** | 서버가 반환하는 JSON 데이터 |

---

## **3. API 요청과 응답에서 JSON 헤더(Header) 필드 정리**

JSON을 사용하는 HTTP 요청과 응답의 **헤더(Header)**에는 다음과 같은 필드가 포함될 수 있습니다.

### **1) 요청(Request) 헤더 필드**

| 헤더 필드 | 설명 | 예제 값 |
| --- | --- | --- |
| `Content-Type` | 요청 바디의 데이터 형식 | `application/json` |
| `Authorization` | 인증 정보 (토큰) | `Bearer abcdefg123456` |
| `User-Agent` | 클라이언트 정보 | `Mozilla/5.0` |
| `Accept` | 서버가 응답할 데이터 형식 | `application/json` |
| `Host` | 요청 대상 서버 | `api.example.com` |
| `Content-Length` | 요청 데이터 크기 (바이트) | `85` |

✅ **예제**

```
POST /users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Authorization: Bearer abcdefg123456
Accept: application/json
Content-Length: 85
```

---

### **2) 응답(Response) 헤더 필드**

| 헤더 필드 | 설명 | 예제 값 |
| --- | --- | --- |
| `Content-Type` | 응답 데이터의 형식 | `application/json` |
| `Content-Length` | 응답 데이터 크기 (바이트) | `85` |
| `Date` | 응답이 생성된 시간 | `Mon, 01 Apr 2024 12:34:56 GMT` |
| `Server` | 응답을 보낸 서버 정보 | `nginx/1.21.6` |
| `Cache-Control` | 캐싱 정책 | `no-cache` |

✅ **예제**

```
HTTP/1.1 200 OK
Content-Type: application/json
Content-Length: 85
Date: Mon, 01 Apr 2024 12:34:56 GMT
Server: nginx/1.21.6
Cache-Control: no-cache
```
---

## **4. 요약**

| 구분 | 설명 | 예제 |
| --- | --- | --- |
| **JSON 파일** | 독립적인 데이터 저장 형식 | `data.json` 파일 |
| **API 요청(Request)** | 클라이언트 → 서버 | `POST /users` |
| **API 응답(Response)** | 서버 → 클라이언트 | `HTTP/1.1 200 OK` |
| **헤더(Header)** | 요청/응답 메타데이터 | `Content-Type: application/json` |
| **바디(Body)** | 요청/응답 데이터 | `{ "name": "John Doe" }` |

✔ **JSON 파일 자체는 헤더와 바디가 없음**

✔ **API 요청과 응답에서 JSON을 사용할 때는 HTTP 헤더와 바디로 구분**


---------------------------------------------------------------
---------------------------------------------------------------

# Query String은 API Endpoint에 포함되지 않는다?

### **1. API 엔드포인트 vs. 쿼리 스트링**

- **API 엔드포인트(Endpoint)** → 특정한 리소스에 접근하는 **고정된 URL**
- **쿼리 스트링(Query String)** → 선택적인 데이터 전달을 위한 **추가 파라미터**



쿼리 스트링은 URL에 포함되지만 **API 엔드포인트의 일부가 아님**.

즉, 엔드포인트는 고정된 경로지만, 쿼리 스트링은 요청마다 달라질 수 있음.

---

### **2. 쿼리 스트링(Query String)의 특징**

✔ **1) 엔드포인트를 변경하지 않고 데이터 전달 가능**

✔ **2) `?key=value&key2=value2` 형식으로 사용**

✔ **3) `GET` 요청에서 주로 사용되며, 바디가 없는 요청에도 활용 가능**

✔ **4) 순서는 중요하지 않음**

✔ **5) 기본적으로 URL 인코딩 필요 (`space` → `%20`)**

---

### **3. API에서 경로 변수(Path Variable)와 차이점**

| 구분 | 쿼리 스트링 | 경로 변수 (Path Variable) |
| --- | --- | --- |
| **위치** | URL 뒤 `?` 이후 | 엔드포인트 내부 |
| **사용 방식** | `?key=value&key2=value2` | `/users/{id}` |
| **예제** | `/users?age=30` | `/users/123` |
| **유형** | 선택적 (없어도 됨) | 필수적 (보통 필요함) |
| **사용 용도** | 필터링, 정렬, 검색 | 특정 리소스 식별 |

### **✅ 예제 비교**

```
GET /users?age=30&sort=asc  (쿼리 스트링 사용)
GET /users/123  (경로 변수 사용)
```

---

### **4. 결론**

- **쿼리 스트링은 API 엔드포인트에 포함되지 않음**
- **API 엔드포인트는 고정된 리소스를 가리키고, 쿼리 스트링은 추가 정보 전달**
- **쿼리 스트링은 주로 필터링, 검색, 정렬에 사용됨**