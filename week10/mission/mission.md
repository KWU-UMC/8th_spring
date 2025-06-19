# 실습 1
## Spring Security를 활용한 로그인 및 회원가입 구현 = Session 방식
![image.png](attachment:27b48bc5-6ffc-4f86-b2c9-ce8962e98b6e:image.png)
INSERT INTO food_category (name) VALUES ('한식'), ('중식'), ('일식');

![image.png](attachment:f8e9c2cd-d401-4c72-8d39-844f571270c2:image.png)

![image.png](attachment:b4dfcbd1-33ad-44ec-a396-656bd1636108:image.png)

![image.png](attachment:af29bb33-5667-4372-949c-684fb76789b9:image.png)

![image.png](attachment:6f084034-575b-4b14-bbfb-282909b066fe:image.png)

![image.png](attachment:9f17488d-cf48-45f7-afaa-c39769cbb8a3:image.png)

![image.png](attachment:aefc6a86-1d4d-478b-a2e8-d52d591745a2:image.png)
ADMIN으로 바꾸고 ctrl+Enter

![image.png](attachment:6190a25f-72fd-4289-a9f4-9f511e117dd8:image.png)

![image.png](attachment:7506e0a3-8e0d-4c34-9a99-de2d52cd2878:image.png)

![image.png](attachment:ac086ac6-54e1-4be8-9128-6614cdc042c0:image.png)
# 실습 2
## Spring Security를 활용한 로그인 및 회원가입 구현 = JWT 방식
1. 유저 회원가입 API
   **POST /members/join**
   ![image.png](attachment:005f0e96-8c3f-45d8-9103-1d48154c9efa:image.png)
   ![image.png](attachment:0b2c9ecc-1865-40d9-9d8b-86ef82e1deba:image.png)

2. 유저 로그인 API
   **POST /members/login**
   ![image.png](attachment:70b49378-a041-4f1f-8cf8-cf76464deafe:image.png)
   ![image.png](attachment:337bcd4d-de5e-4231-bded-2773cb5be116:image.png)

3. 유저 내 정보 조회 API
   **GET /members/info**
   ![image.png](attachment:9a197ee8-d1d5-4a13-8b3c-408956051550:image.png)

자잘한 오류가 많았는데 가장 기억에 나는 오류가 있다면 "COMMON500" 에러가 발생하였다.
"message": "서버 에러, 관리자에게 문의 바랍니다.",
"result": "Cannot invoke \"com.example.config.properties.JwtProperties$Expiration.getAccess()\" because the return value of \"com.example.config.properties.JwtProperties.getExpiration()\" is null"
jwtProperties.getExpiration()이 null인데 그 안의 getAccess()를 호출하려고 해서 에러가 발생하였다.
오류를 해결하기 위해 .yml과 JwtProperties 클래스를 확인해 주었더니 해결되었다.

첫 번째 오류가 해결되니 gender에서 오류가 발생하였다.
{
"isSuccess": false,
"code": "COMMON500",
"message": "서버 에러, 관리자에게 문의 바랍니다.",
"result": "Cannot invoke \"com.example.domain.enums.Gender.name()\" because the return value of \"com.example.domain.Member.getGender()\" is null"
}
.getGender()에서 null 값이 들어와 또 NullPointerException이 발생하였다.
코드를 다시 보니 MemberRequestDTO에서 gender가 Integer로 선언이 되어 있어서 Gender로 바꾸어 주었더니 해결되었다.


