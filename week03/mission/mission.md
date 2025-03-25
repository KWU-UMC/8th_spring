## 

### 1차 설계

1. region 미션 클리어 개수 조회 api


🔑 GET /missions/users/**{userId}**/regions/**{regionId}**



1. 마이 포인트 조회 api


🔑 GET points/users/**{userId}**



1. 마이 미션 (진행 가능 목록) 조회 api


🔑 GET /users/**{userId}**/missions



1. 미션 도전 api(미션 도전 시에 마이 미션에 등록되는 설계 시)


🔑 POST /missions/**{missionId}**/users/**{userId}**



도메인별, 기능별로 api를 나누게 되면 위와 같이 나눌 수 있다. 이렇게 하면 제일 직관적으로, 그리고 도메인 카테고리 별로 api를 생성할 수 있다.

### 고찰

하지만 해당 api별로 쿼리를 생성해야하기 때문에 낭비가 될 수도 있다. 그리고 전 챕터에서 학습한 sql을 사용하면 같은 도메인이 아니더라도 연관관계의 데이터를 불러올 수도 있다.

그렇다면 홈에서 불러올 모든 조회 api를 모두 하나에 몰아서 사용하는게 좋을까? 당연히 query량을 줄인다는 점에서 효율적이다. 하지만 유지보수 또한 cost를 줄일 수 있는 요소이다. 우리는 코드를 작성할 때에도 하나의 클래스에는 하나의 역할을 부여하기 마련이다. 이렇게 설계를 해야 나중에 비슷한 기능을 재활용할 수 있기 때문이다. 처음에는 최대한 기능별로 분리를 하고, 불필요한 분리를 합치는 방식이 훨씬 유지보수에 좋다는 생각이다. 이런 접근에서는 1번 api안에 2번 api의 결과를 포함시키면 좋을 것으로 보인다. 어차피 point라는 데이터를 불러올때는 user엔티티로부터 가져오기 때문에 user의 정보를 조회하기만 하면 충분한 커스텀이 가능하기 때문이다.

우리는 path뿐만 아니라 request param, request body, header등을 활용하여 데이터에 대한 접근이 가능하다. 여기서 고려해볼 법한 것은 user의 pk 노출이다. 유저의 정보는 굉장히 민감하기 때문에 노출을 지양해야한다. 하지만 이렇게 엔드포인트를 설정하게 된다면 데이터베이스에 직접 쿼리를 보내, 결과를 조회하는 방법이 가능하다. 그렇기 때문에 우리는 토큰을 사용하는 것이 좋다. 토큰은 헤더에 key-value로 Authorization - Beaerer {token value}와 같이 넣어주면 된다. 서버에서는 token value를 읽어 user의 정보를 조회할 것이다. 만약 “본인”의 데이터를 강조하고자 한다면 path에 “me”나 “my”같은 표현을 추가하면 조금 더 직관적일 것이다.

### 2차 설계

모두 헤더에 액세스 토큰이 들어가있다는 가정이다.

1. region 미션 클리어 개수 조회 및 내 포인트 조회 api


🔑 GET /missions/regions/**{regionId}**



1. 마이 미션 (진행 가능 목록) 조회 api


🔑

GET /missions



아래는 status로 조회할 때 결과이다. status를 request Param으로 필터링하여 결과를 가져오는 것이다. 이때 페이지네이션까지 적용한 결과이다.


🔑

GET /missions?status=before&page=0&size=5



1. 미션 도전 api(미션 도전 시에 마이 미션에 등록되는 설계 시)


🔑 POST /missions/**{missionId}**



혹은 (status 변경 시)


🔑 PATCH /missions/**{missionId}**



### 마이페이지 리뷰 작성

(마이페이지 리뷰 작성 api가 리뷰를 작성하는 api인지, 아니면 마이페이지에 작성한 리뷰를 조회하는 api인지 모르겠어서 후자를 택하여 답하겠습니다)

🔑 GET /reviews/me?page=0&size=10


마찬가지로 액세스토큰을 헤더에 넣은 상태이며 별다른 표현 없이 “내 리뷰” 조회하기에 초점을 맞췄다. 내 리뷰 조회하기라면 지역또한 전체지역을 나타내고 있을테며 오로지 작성자=나 임만이 필터링의 기준이 될 것이다. 이는 액세스 토큰이 해줄 것이기에 위와 같이 표현할 수 있다.

### **미션 목록 조회(진행중, 진행 완료)**

🔑 GET /missions/me


엔티티 설계 시에 여러 도메인이 생겨도 이를 어느정도 카테고리별로 묶는 것도 프론트 입장에서 난잡하지 않도록 해주는 것이기에 중요하다. 홈화면에서 사용한 mission 조회에서는 단순히 GET /missions만을 작성했지만 위에는 “내 미션”임을 나타낸다. 우리가 erd를 설계할 때는 my-mission이라는 데이터가 존재하지만 mission으로 묶은 뒤 소유를 나타내주어 프론트는 이에 대해 신경 쓸 필요 없도록 만들어주는 것이다.

### **미션 성공 누르기**

🔑 PATCH /missions/{missionId}

이렇게 하면 의문이 생길 수 있다. 우리가 성공을 눌러야하는 건 my_mission아닌가? 맞는 말이지만 missionId와 userId를 통해 my_mission을 구할 수 있다. 따라서 fk두개를 통해 my_mission을 불러와 status를 바꿔주도록 한다.

일부 수정 : PATCH

전체 수정 : PUT

이기 때문에 메서드는 패치를 사용했다.

### **회원 가입 하기(소셜 로그인 고려 X)**

🔑 POST /users/sign-up


회원가입과 로그인이 restful의 규칙을 가장 지키기 어려운 부분이다. 물론 회원가입의 경우 단순히 /users와 같이 작성해도 되지만 로그인과 회원가입을 같은 카테고리로 묶어 회원가입 또한 규칙을 깨는 방식으로 작성하는 것도 프로젝트 내에서는 통일성 있는 설계라고 볼 수있다.

여기서는 액세스 토큰이 들어가지 않는다. 대신 requestbody에 회원가입에 필요한 데이터들을 넣어주도록 한다.

~~~json
{
		"nickname" : "user_1",
		"name" : "han",
		"password" : "hannho1234"
}
~~~

# Senior mission
[hannho_velog](https://velog.io/@hann1233/UMC-8th-Senior-Mission-chapter.3)