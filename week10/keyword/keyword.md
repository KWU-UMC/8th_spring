# 1. Spring Security란?

Spring 기반 웹 애플리케이션의 **보안(인증/인가)**을 위한 프레임워크.

서블릿 필터 기반으로 동작하며, 다양한 인증 방식(Form, Basic, JWT, OAuth 등)을 지원함.

Java / Java EE 프레임워크

개발을 하면서 보안 분야는 시간이 많이 소요되는 활동들 중 하나다. Spring Security를 사용함으로써 짜여진 내부 로직을 통해 인증, 권한 확인에 필요한 기능과 옵션들을 제공한다.


---

## 핵심 개념

| 용어 | 설명 |
| --- | --- |
| **Authentication** | 사용자가 누구인지 확인하는 절차 (ex. 로그인) |
| **Authorization** | 사용자가 무엇을 할 수 있는지를 판단하는 절차 (ex. 관리자만 접근 가능) |
| **Principal** | 인증된 사용자 객체 |
| **GrantedAuthority** | 인증된 사용자의 권한 정보 (ex. ROLE_USER, ROLE_ADMIN) |
---
## 흐름
1. Http Request 수신

-> 사용자가 로그인 정보와 함께 인증 요청을 한다.

2. 유저 자격을 기반으로 인증토큰 생성

-> AuthenticationFilter가 요청을 가로채고, 가로챈 정보를 통해 UsernamePasswordAuthenticationToken의 인증용 객체를 생성한다.

3. FIlter를 통해 AuthenticationToken을 AuthenticationManager로 위임

-> AuthenticationManager의 구현체인 ProviderManager에게 생성한 UsernamePasswordToken 객체를 전달한다.

4. AuthenticationProvider의 목록으로 인증을 시도

-> AutenticationManger는 등록된 AuthenticationProvider들을 조회하며 인증을 요구한다.

5. UserDetailsService의 요구

-> 실제 데이터베이스에서 사용자 인증정보를 가져오는 UserDetailsService에 사용자 정보를 넘겨준다.

6. UserDetails를 이용해 User객체에 대한 정보 탐색

-> 넘겨받은 사용자 정보를 통해 데이터베이스에서 찾아낸 사용자 정보인 UserDetails 객체를 만든다.

7. User 객체의 정보들을 UserDetails가 UserDetailsService(LoginService)로 전달

-> AuthenticaitonProvider들은 UserDetails를 넘겨받고 사용자 정보를 비교한다.

8. 인증 객체 or AuthenticationException

-> 인증이 완료가되면 권한 등의 사용자 정보를 담은 Authentication 객체를 반환한다.

9. 인증 끝

-> 다시 최초의 AuthenticationFilter에 Authentication 객체가 반환된다.

10. SecurityContext에 인증 객체를 설정

-> Authentication 객체를 Security Context에 저장한다.

최종적으로는 SecurityContextHolder는 세션 영역에 있는 SecurityContext에 Authentication 객체를 저장한다. 사용자 정보를 저장한다는 것은 스프링 시큐리티가 전통적인 세선-쿠키 기반의 인증 방식을 사용한다는 것을 의미한다.

------
# 2. 인증(Authentication) , 인가(Authorization)
- 인증: 해당 사용자가 본인이 맞는지를 확인하는 절차.
- 인가: 인증된 사용자가 요청된 자원에 접근가능한가를 결정하는 절차
인증 방식

1. credential 방식: username, password를 이용하는 방식

2. 이중 인증(twofactor 인증): 사용자가 입력한 개인 정보를 인증 후, 다른 인증 체계(예: 물리적인 카드)를 이용하여 두가지의 조합으로 인증하는 방식이다.

3. 하드웨어 인증: 자동차 키와 같은 방식

이중 Spring Security는 credential 기반의 인증을 취합니다.

principal: 아이디 (username)
credential: 비밀번호 (password)
특정 자원에 대한 접근을 제어하기 위해서는 권한을 가지게 된다.

특정 권한을 얻기 위해서는 유저는 인증정보(Authentication)가 필요하고 관리자는 해당 정보를 참고해 권한을 인가(Authorization)한다.

보편적으로 username - password 패턴의 인증방식을 거치기 때문에 스프링 시큐리티는 principal - credential 패턴을 가지게 된다.

---
# 3. 세션과 토큰
## 개념 요약

| 구분 | 세션(Session) | 토큰(Token, 주로 JWT) |
| --- | --- | --- |
| 방식 | 서버가 세션ID를 발급하고 저장 | 서버가 토큰을 발급하고, 저장하지 않음 (Stateless) |
| 저장 위치 | 서버 메모리/DB (Session Store) | 클라이언트(로컬스토리지, 쿠키 등) |
| 인증 방법 | 요청 시 `쿠키`에 세션 ID 포함 | 요청 시 `Authorization` 헤더에 토큰 포함 |
| 상태 관리 | 상태 유지 (Stateful) | 무상태 (Stateless) |

---

## 세션 기반 인증

### 동작 흐름

1. 사용자 로그인 → 서버가 세션 ID 발급
2. 서버는 해당 세션 ID와 사용자 정보를 서버에 저장
3. 클라이언트는 세션 ID를 쿠키에 저장
4. 이후 요청 시 쿠키를 통해 세션 ID 전송
5. 서버는 세션 ID 기반으로 사용자 정보 조회 후 인증

### 장점

- 서버에서 상태를 관리하므로 세밀한 제어 가능
- 보안이 상대적으로 쉬움 (토큰 유출시 무효화 가능)

### 단점

- 서버 메모리 사용 증가 → 확장성 낮음
- 로드밸런싱시 세션 동기화 필요 (ex. Redis 사용)

---

## 토큰 기반 인증 (JWT)

### 동작 흐름

1. 로그인 성공 → 서버가 JWT 생성 (서명 포함)
2. 클라이언트가 JWT를 저장 (주로 localStorage)
3. 이후 요청 시 Authorization 헤더에 JWT 포함
4. 서버는 토큰을 검증 후 사용자 인증

### 장점

- 서버 상태 저장 필요 없음 → 확장성 좋음
- 모바일/SPA 등 다양한 환경에서 사용 용이
- 인증 서버 분리 가능 (SSO 구현 유리)

### 단점

- 토큰 탈취 시 위험 → 재발급 어렵고 노출 시 심각
- 무효화 어려움 (블랙리스트 처리나 짧은 만료시간 필요)
- 토큰 크기가 큼 → 네트워크 낭비 발생 가능
---
# 4. 액세스 토큰(Access Token)과 리프레시 토큰(Refresh Token)

## 개념 정리

| 구분 | Access Token | Refresh Token |
| --- | --- | --- |
| 역할 | **API 요청에 사용되는 인증 수단** | **Access Token을 재발급 받기 위한 수단** |
| 저장 위치 | 클라이언트(LocalStorage, Cookie 등) | 보안상 Cookie (HttpOnly)에 저장 권장 |
| 유효 기간 | 짧음 (5~30분 등) | 김 (1주일~한 달) |
| 서버 검증 | 서명 검증으로만 가능 (stateless) | DB 또는 Redis에서 검증 (stateful로 운용 가능) |
| 노출 시 피해 | 심각 (즉시 탈취 가능) | 탈취되면 Access Token 무제한 발급 가능 |

---

## 🔄 동작 흐름

```

[1] 로그인 성공 → Access Token + Refresh Token 발급
[2] 클라이언트는 Access Token을 Authorization 헤더에 담아 API 요청
[3] Access Token 만료 → Refresh Token으로 새로운 Access Token 요청
[4] Refresh Token도 만료 → 다시 로그인 필요

```

---


### Access Token만 쓰면 생기는 문제

- 만료시간을 너무 길게 하면 **탈취 위험**
- 너무 짧게 하면 **로그인 자주해야 해서 UX 저하**

👉 그래서 **짧은 Access Token + 긴 Refresh Token 조합**을 사용함

