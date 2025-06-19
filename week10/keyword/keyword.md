# 핵심 키워드
## Spring Security
- **역할**: 스프링 기반 웹 애플리케이션의 보안을 담당하는 모듈.
- **기본 구조**:
    - `FilterChain` 구조로 동작하며, 사용자의 요청을 여러 필터를 통해 검증.
    - 사용자 인증 로직(`AuthenticationManager`), 인가 로직(`AccessDecisionManager`) 등이 핵심.
- **장점**:
    - 다양한 인증 방식 지원 (폼 로그인, OAuth2, JWT 등).
    - 보안 취약점(CSRF, 세션 고정 등)에 대한 방어 기능 포함.

## 인증(Authentication)과 인가(Authorization)
### 인증(Authentication)
- **의미**: "너 진짜 그 사람이 맞아?"를 확인하는 절차.
- **정의**: 사용자가 누구인지 확인하는 절차. 예: 아이디와 비밀번호를 입력하여 본인임을 증명.
- **결과**: 인증 성공 시 사용자 정보를 담은 `Authentication` 객체가 생성됨.
- **예시**: 사용자가 `id`와 `password`를 입력 → DB에 있는 계정 정보와 일치하면 인증 성공.
- **Spring Security에서의 동작**:
    1. 인증 요청 → `UsernamePasswordAuthenticationFilter`를 통해 처리
    2. 인증 성공 → `SecurityContextHolder`에 사용자 정보 저장
    3. 인증 실패 → 예외 반환 (`BadCredentialsException` 등)

### **인가(Authorization)**
- **정의**: 인증된 사용자가 특정 리소스 또는 기능에 접근할 권한이 있는지를 확인하는 절차.
- **의미**: "인증된 사용자가 이 리소스를 쓸 수 있는 자격이 있나?"를 확인하는 절차.
- **예시**: 일반 사용자는 관리자 페이지에 접근할 수 없음.
    - `/admin` 페이지는 ROLE_ADMIN만 접근 가능.
- **Spring Security 적용 방식**:
    - `@PreAuthorize("hasRole('ADMIN')")`
    - `http.authorizeRequests().antMatchers("/admin/**").hasRole("ADMIN")`

## 세션과 토큰
세션은 요즘 잘 안 쓰고 토큰을 많이 씀.
| 구분 | 세션(Session) | 토큰(Token) |
| --- | --- | --- |
| **보안 상태** | 서버가 사용자 상태를 **기억함** | 서버는 상태를 **기억하지 않음(stateless)** |
| **저장 위치** | 서버 메모리 or DB | 클라이언트(브라우저 로컬스토리지, 쿠키 등) |
| **적용 사례** | 전통적인 웹사이트 (JSP, MVC) | SPA, 모바일 앱, REST API 백엔드 |
| **단점** | 서버 확장 시 세션 동기화 필요 | 탈취 시 악용 가능, 보안 관리 중요 |

## 액세스 토큰(Access Token)과 리프레시 토큰(Refresh Token)
| 구분 | Access Token | Refresh Token |
| --- | --- | --- |
| **용도** | API 요청 시 사용자 인증 | Access Token 재발급 |
| **유효기간** | 짧음 (예: 15분~1시간) | 김 (예: 7일~30일) |
| **저장 위치** | 주로 클라이언트 (ex. localStorage) | 서버 또는 HttpOnly 쿠키 |
| **보안 고려** | 탈취 시 빠르게 만료 | 탈취 시 장기 사용 가능 → 보안 관리 중요 |

access token: 처음 받는? 토큰

refresh token : access가 만료 되면 발급

**JWT 기반**: 주로 Access Token과 Refresh Token 모두 JWT(JSON Web Token)로 구성.

- Access Token에는 사용자 ID, 권한 등의 정보를 담고 서명(signature)을 통해 위조 방지.