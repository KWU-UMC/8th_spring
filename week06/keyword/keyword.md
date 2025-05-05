# 🎯핵심 키워드
- **지연로딩과 즉시로딩의 차이**

  ### **JPA에서의 즉시로딩과 지연로딩의 개념**

    - **즉시로딩 (xxToxx(fetch = fetchType.EAGER): 데이터를 조회할 때, 연관된 모든 객체의 데이터까지 한 번에 불러오는 것이다.**
        - join sql로 한번에 연관된 객체까지 미리 조회
        - 실무에서 가장 사용하지 않아야 할 로딩방식
    - **지연로딩 : @xxToxx(fetch = fetchType.LAZY)** :  필요한 시점에 연관된 객체의 데이터를 불러오는 것이다.

  ⇒ 즉시 로딩에서는 member와 연관된 Team이 1개여서 Team을 조회하는 쿼리가 나갔지만, 만약 Member를 조회하는 JPQL을 날렸는데 연관된 Team이 1000개라면? Member를 조회하는 쿼리를 하나 날렸을 뿐인데 Team을 조회하는 SQL 쿼리 1000개가 추가로 나가게 된다.

  그러므로, 지연로딩을 사용하는 것이 좋다.

  ### 기대했던 sql문

    ```java
    SELECT * FROM user;
    ```

  ### JPA가 실행한 sql문

    ```java
    1. SELECT * FROM user;   (모든 유저 조회) ➔ 1번
    2. SELECT * FROM article WHERE user_id = 1; ➔ 1번
    3. SELECT * FROM article WHERE user_id = 2; ➔ 1번
    4. SELECT * FROM article WHERE user_id = 3; ➔ 1번
    ...
    ```

- **Fetch Join**

  JPQL에서 성능 최적화를 위해 제공하는 조인의 종류.

  ### 해결 방법

    - jpql에서 fetch join 사용!
        - 하드코딩을 막기 위해서는 `@EntityGraph`를 사용하면 된다.

    ```java
    @EntityGraph(attributePaths = {"articles"}, type = EntityGraphType.FETCH)
    List<User> findAllEntityGraph();
    ```

- **@EntityGraph**

  ## @EntityGraph

  Spring Data JPA에서는 **`@EntityGraph`**를 사용해서 `메서드 이름으로 쿼리 생성 + fetch join` 해결

  **`@EntityGraph(attributePaths = {"fetch join 할 객체의 필드명"}`**

  ⇒ fetch join이 가능하다.

  ### 📁 MemberRepository

    ```java
        // Entity Graph
        @Override
        @EntityGraph(attributePaths = {"team"}) // 객체의 필드명
        List<Member> findAll();
    
        // JPQL에 Entity Graph추가(fetch join)
        @EntityGraph(attributePaths = {"team"})
        @Query("select m from Member m")
        List<Member> findMemberEntityGraph();
    
        // 메서드 이름으로 쿼리 생성 + EntityGraph추가(fetch join)
         @EntityGraph(attributePaths = {"team"})
        List<Member> findEntityGraphByUsername(@Param("username") String username);
    ```

- **JPQL**
    - (Java Persistence Query Language) 객체지향 쿼리로 **JPA가 지원하는 다양한 쿼리 방법 중 하나**
    - SQL과의 차이점
        - SQL : 테이블을 대상으로 쿼리
        - JPQL : 엔티티 객체를 대상으로 쿼리(테이블 대신 클래스 이름 사용)
            - 쿼리 결과 : 객체(entity)
            - 실제 사용 예시 :

            ```java
            // 예: 나이가 20보다 큰 회원 조회
            String jpql = "SELECT m FROM Member m WHERE m.age > 20";
            
            //쿼리 결과로 나오는 Member 엔티티들의 집합을 저장
            List<Member> result = em.createQuery(jpql, Member.class)
                                    .getResultList();
            ```
            
          - 
- **QueryDSL**

  ## query DSL이란?

  > 정적 타입을 이용해서 SQL, JPQL을 코드로 작성할 수 있도록 도와주는 오픈소스 빌더 API
  >
    - 어떻게 문자열 형태인 JPQL을 보완 했을가요?

      바로 쿼리에 대한 내용을 `함수 형태로 제공`하여 보완했습니다!


    ## 💡 QueryDSL을 사용하는 이유
    
    **1. 자바 코드로 쿼리를 작성함으로 컴파일 시점에 에러를 잡을 수 있다.**
    
    기존 JPQL은 쿼리를 문자열로 작성해야한다. 만약 오타가 있거나 잘못 작성한다해도 컴파일 시점에 에러가 발생하지 않고 런타임 시점에 발생하기 때문에 실행시키기 전에는 잘못된 부분을 알 수 없다. (**최악!**)
    
    하지만 QueryDSL은 자바 코드로 쿼리를 작성하기 때문에 **컴파일 시점에 에러를 잡을 수 있다**는 큰 장점이 있다.
    
    **2. 복잡한 동적 쿼리를 쉽게 다룰 수 있다.**
    
    JPQL을 이용해 동적 쿼리를 다루기 위해서는 문자열을 조건에 맞게 조합해서 사용해야한다. 이는 코드도 복잡해지고 런타임 에러를 발생시키는 치명적인 단점이 있다.
    
    QueryDSL은 복잡한 동적 쿼리도 Q클래스, 메서드를 활용하여 쉽게 다룰 수 있다.
    
    ### Q 클래스 방식
    
    - QMember 같은 클래스는 QueryDSL이 엔티티 기반으로 자동 생성해주는 클래스
- **N+1 문제를 해결할 수 있는 여러 가지 다른 방법들**
    1. **fetch join**
        1. JPA가 자동으로 먼저 생성해주는 Jpql을 통해서 우선적으로 쿼리를 만들다보니 연관관계가 걸려있어도 join이 바로 걸리지 않는다.
        2. ex)  쿼리를 날릴 때 article을 한번에 모두 가져옴

        ```java
        @Test
        @DisplayName("fetch join을 하면 N+1문제가 발생하지 않는다.")
        void fetchJoinTest() {
            System.out.println("== start ==");
            List<User> users = userRepository.findAllJPQLFetch();
            System.out.println("== find all ==");
            for (User user : users) {
                System.out.println(user.articles().size());
            }
        }
        ```

    2. **@EntityGraph**
        1. fetch join을 통해 바로 조회할 수 있음을 확인가능

        ```java
        @EntityGraph(attributePaths = {"articles"}, type = EntityGraphType.FETCH)
        @Query("select distinct u from User u left join u.articles")
        List<User> findAllEntityGraph();
        ```



# ☑️ 실습 인증
https://github.com/Seona12/UMC_mission5/tree/feature/week6