### 미션 1, 2 - 인증 방식(profile 분리) 구현 정리
1. application.yml에서 spring.profiles.active=session 또는 jwt로 설정

2. @Profile("session"), @Profile("jwt") 어노테이션으로 각 SecurityConfig 분리

3. Session 방식은 formLogin() 기반, JWT 방식은 JwtAuthenticationFilter 등록
![분리.png](%EB%B6%84%EB%A6%AC.png)
4. Controller도 @Profile로 분리해서 구현 -> SessionAuthController, JwtAuthController)
![컨트롤러도 분리 구현.png](%EC%BB%A8%ED%8A%B8%EB%A1%A4%EB%9F%AC%EB%8F%84%20%EB%B6%84%EB%A6%AC%20%EA%B5%AC%ED%98%84.png)
5. 공통 서비스 로직(MemberCommandService, MemberQueryService)은 그대로 사용

6. 테스트는 Swagger에서 요청 확인 (join, login, info, logout)
### 미션 1. session 방식
1. 회원가입 및 db에 추가된 사진
![session join.png](session%20join.png)
![session db.png](session%20db.png)
2. 로그인
![session login.png](session%20login.png)

--- 
### 미션 2. jwt 방식
1. 회원가입 및 db에 추가된 사진
![jwt join.png](jwt%20join.png)
![jwt db.png](jwt%20db.png)
2. 로그인
![jwt login.png](jwt%20login.png)

---
> **GitHub 저장소 주소**
>
>
> https://github.com/heexji/umc_spring/tree/mission10
>