다양한 사이트에서 사용하는 API URL

1. **백준 온라인 저지**
- 회원가입: /register (https://www.acmicpc.net/register)
- 로그인: /login (https://www.acmicpc.net/login)
- 회원 정보: /user/{username}
- 문제 조회: /problem/{problem-id} (https://www.acmicpc.net/problem/1000 1000번 A+B)
- 문제 정답 제출: /submit/{problem-id} (https://www.acmicpc.net/submit/1000 1000번 A+B)

---

2. **깃허브**
- 회원가입: /signup (https://www.github.com/signup)
- 로그인: /login (https://www.github.com/login)
- 회원 정보: /username
- 리포지토리 목록: /username?tab=repositories
- 특정 리포지토리: /username/{repository-name}

---

3. **유튜브**
- 메인 페이지: /
- 특정 동영상 페이지: /watch?v={video-id}
- 특정 채널 페이지: /channel/{channel-id} 또는 /@{username}
- 검색: /results?search_query={query}

---

4. **인스타그램**
- 로그인: /accounts/login (https://www.instagram.com/accounts/login/)
- 특정 사용자 프로필: /{username}
- 특정 게시글: /p/{post-id}