# 핵심 키워드

---

<aside>
💡 주요 내용들에 대해 조사해보고, 자신만의 생각을 통해 정리해보세요!
레퍼런스를 참고하여 정의, 속성, 장단점 등을 적어주셔도 됩니다.
조사는 공식 홈페이지 **Best**, 블로그(최신 날짜) **Not Bad**

</aside>

### Join

### join이란?

**서로 다른 각각의** 테이블 속 데이터를 **동시에 보여주려고 할 때** 사용하는 SQL문

- Inner Join(내부 조인): 두 테이블을 연결할 때 가장 많이 사용하는  것(교집합)

```jsx
SELECT <열 목록>
FROM <첫 번째 테이블>
    INNER JOIN <두 번째 테이블> // JOIN이라고 써도 무방
    ON <조인 조건>
[WHERE 검색 조건]
```

- outer join(외부 조인) : 한쪽에만 데이터가 있어도 결과가 나온다.
    - join 불가능한 테이블의 경우 값이 NULL로 채워진다.

```jsx
SELECT <열 목록>
FROM <첫 번째 테이블(LEFT 테이블)>
    <LEFT | RIGHT | FULL> OUTER JOIN <두 번째 테이블(RIGHT 테이블)>
     ON <조인 조건>
[WHERE 검색 조건]

// LEFT OUTER JOIN: 왼쪽 테이블의 모든 값이 출력
// RIGHT OUTER JOIN: 오른쪽 테이블의 모든 값이 출력
// FULL OUTER JOIN: 왼쪽 외부 조인과 오른쪽 외부 조인이 합쳐진 것
```

- cross join(상호 조인) : 한쪽 테이블의 모든 행과 다른 쪽 테이블의 모든 행을 조인시키는 기능 ⇒ **카티션 곱(CARTESIAN PRODUCT)**

### Subquery

### subquery란?

다른 쿼리 내부에 포함되어 있는 SELETE 문

- 서브쿼리를 포함하고 있는 쿼리 : 외부쿼리(outer query)
- 서브쿼리 : 내부쿼리(inner query)

실행순서 : 서브쿼리 실행 → 메인(부모) 쿼리 실행

### subquery를 왜 사용하는가?

- 서브쿼리가 쿼리를 구조화시키므로 쿼리의 각 부분을 명확히 구분할 수 있게 함
- 복잡한 join, union등의 동작을 수행할 수 있는 방법 제공 + 가독성이 좋게 한다.

### subquery 명칭(스칼라 서브쿼리, 인라인 뷰, 일반 서브쿼리)

```jsx
SELECT col1, (SELECT ...) -- 스칼라 서브쿼리(Scalar Sub Query): 하나의 컬럼처럼 사용 (표현 용도)
FROM (SELECT ...)         -- 인라인 뷰(Inline View): 하나의 테이블처럼 사용 (테이블 대체 용도)
WHERE col = (SELECT ...)  -- 일반 서브쿼리: 하나의 변수(상수)처럼 사용 (서브쿼리의 결과에 따라 달라지는 조건절)
출처: https://inpa.tistory.com/entry/MYSQL-📚-서브쿼리-정리 [Inpa Dev 👨‍💻:티스토리]
```

- 스칼라 서브쿼리 : SELECT 문에 나타나는 subquery
    - **하나의 레코드만 리턴 가능( 2개 이상 불가)**
    - 일치하는 데이터가 없으면 null값 리턴 가능
- 인라인 뷰 : From 문에 나타나는 서브쿼리
    - 무조건 subquery에 서브쿼리 별칭을 지정해줘야 한다.
- 중첩 서브쿼리 : WHERE 문에 나타나는 subquery
    - 조건 값을 select로 특정할때

    ```jsx
    select name, height 
    from userTbl
    where height > (select height from userTbl where name in ('김경호'));
    ```


### **조인(JOIN) vs 서브쿼리(Sub Query)**

**서브쿼리(Sub Query)**

- 복잡한 SQL 쿼리문에 많이 사용

**조인(JOIN)**

- 2개 혹은 그 이상의 테이블을 연결하고, 연결한 테이블로부터 필요한 열을 조회할 수 있도록 한다.

<aside>
💡

서브쿼리는 가독성이 좋지만 **성능이 조인에 비해 매우 좋지않다.**

⇒ 최신 MySQL은 사용자가 서브쿼리문을 사용하면 자체적으로 조인문으로 변환하여 실행시키도록 업데이트 되었다.

</aside>

### cusor based 페이징

- cursor : 사용자가 응답해 준 마지막 데이터의 식별자 값

  ⇒ 해당 cursor 기준으로 n개의 데이터를 응답해주는 방식으로 조회 횟수가 줄어들어 성능상 이점이 있다.

  ex) 마지막으로 읽은 데이터(1억번)의 다음 데이터(1억+1번) 부터 10개의 데이터 주세요→ 10개의 데이터만 읽음