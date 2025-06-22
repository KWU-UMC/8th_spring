email 대신 username(아이디)으로 미션을 진행했습니다.

## 실습 1
![signup](images/signup.png)

다음과 같이 회원 정보를 입력한 뒤 회원 가입을 완료하면

![signup_db](images/signup_db.png)

데이터베이스에 회원이 생성된다.

![invalid_login](images/invalid_login.png)

만약 가입하지 않은 정보로 로그인할 경우,

![login_error](images/login_error.png)

에러 메시지가 출력되며, 다시 로그인 폼으로 돌아온다.

![valid_login](images/valid_login.png)

가입되어 있는 정보로 로그인을 하면

![login_success](images/login_success.png)

홈페이지로 이동한다.

![invalid_admin](images/invalid_admin.png)

일반 사용자로 가입을 했으므로 admin 페이지의 접근은 제한된다.

![change_role](images/change_role.png)

Role을 ADMIN으로 변경하면 admin 페이지 접근이 가능해진다.

![admin_success](images/admin_success.png)

## 실습 2

![token_signup_success](images/token_signup_success.png)

아이디, 비밀번호, 이름 등의 회원 정보를 입력한 후 실행하면 회원 가입이 완료된다.

![token_signup_db](images/token_signup_db.png)

다음과 같이 db에도 저장된 것을 확인했다.

![token_login_success](images/token_login_success.png)

가입한 회원 정보로 로그인을 시도하면 성공 메시지가 반환되며 accessToken이 발급된다.

![token_info_success](images/token_info_success.png)

발급받은 토큰을 Authorization에 입력한 뒤 회원 정보를 조회하면 알맞은 정보가 출력된다.