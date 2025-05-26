## Spring Data JPA의 Pagination

---

DB 마다 pagination을 위해 사용되는 쿼리는 다 다르고, 난이도도 천차만별이다.

- 예를 들어, MySQL에서는 `offset` , `limit` 으로 상대적으로 간단히 처리가 가능하지만, Oracle의 경우 상당히 복잡하다.

JPA는 이런 여러 DB 별 방언(dialect)을 추상화하여 하나의 방법으로 페이지네이션을 구현할 수 있도록 제공해준다.

하지만, JPA로 페이지네이션 기능을 구현하는 작업은 생각보다 까다롭다.

- 전체 데이터 개수를 가져와서 전체 페이지를 계산해야하고, 현재 페이지가 첫번째 페이지인지, 마지막 페이지인지도 계산해야하고, 예상치 못한 페이지 범위를 요청받았을 때 예외처리도 해야한다.
- 물론, JPA 없이 DB에 직접 쿼리하는 방식보다는 훨씬 편리하지만, 여전히 신경써야 할 부분들이 많이 보인다.

Spring Data JPA는 이런 pagination도 추상화되어 있다. 각 페이지의 설정만 조정하여 전달하면 DB에서 해당 설정에 맞는 부분의 데이터만 조회할 수 있다.

### Page와 Slice

PageRequest 객체를 통해 페이징을 할때 반환형으로 Page와 Slice를 사용한다.

두 객체의 결과물과 성능은 어떤 차이가 있는지 확인해보자

- Page
    - 레포지토리 선언

    ```java
    Page<Member> findPageBy(Pageable pageable);
    ```

    ```java
    
    Page<Member> findPageBy(Pageable pageable);
    ```

    - 테스트 : 조회쿼리 이후 전체 데이터 갯수를 한번더 조회하는 카운트 쿼리가 실행된다

    ```java
    select
        member0_.member_id as member_i1_0_,
        member0_.age as age2_0_,
        member0_.team_id as team_id4_0_,
        member0_.username as username3_0_ 
    from
        member member0_ 
    order by
        member0_.age asc limit ? offset ?
    ```

    ```java
    select
        count(member0_.member_id) as col_0_0_ 
    from
        member member0_
    ```

    - 게시판과 같이 총 데이터 갯수가 필요한 환경에서 주로 사용
    - - Slice
  - 레포지토리 선언

    ```java
    Slice<Member> findSliceBy(Pageable pageable);
    ```

    ```java
    Slice<Member> slice = memberRepository.findSliceBy(pageRequest);
    ```

    - 테스트 :  limit(size)+1 된 값을 가져옴
        - slice는 카운트쿼리가 나가지 않고 다음 slice가 존재하는지 여부만 확인할 수 있기때문에, 데이터 양이 많으면 많을수록 slice를 사용하는것이 성능상 유리하다.
        - slice는 모바일과 같이 총 데이터 갯수가 필요없는 환경에서(무한스크롤 등) 사용

    ```java
    select
        member0_.member_id as member_i1_0_,
        member0_.age as age2_0_,
        member0_.team_id as team_id4_0_,
        member0_.username as username3_0_ 
    from
        member member0_ 
    order by
        member0_.age asc limit ? offset ?
    ```

- 객체 그래프 탐색

  ### 객체 그래프 탐색이란?

    - **JPA에서 엔티티 간의 연관 관계를 따라가며 데이터를 꺼내는 것**
    - 예: `student.getSchool().getName();`

      → 학생 → 학교 → 학교 이름

      → 이렇게 연관된 객체들을 따라가며 값에 접근하는 것


    ---
    
    ### 📘 예시 코드
    
    ```java
    java
    복사편집
    @Entity
    public class Student {
        @Id
        private Long id;
        private String name;
    
        @ManyToOne
        private School school;
    }
    
    @Entity
    public class School {
        @Id
        private Long id;
        private String name;
    }
    
    ```
    
    ```java
    java
    복사편집
    Student student = em.find(Student.class, 1L);
    String schoolName = student.getSchool().getName();
    
    ```
    
    ---
    
    ### ⚠️ 주의: Getter 없으면 접근 불가
    
    - `student.getSchool()` → `Student` 클래스에 `getSchool()` 메서드가 필요
    - `.getName()` → `School` 클래스에 `getName()` 메서드가 필요
    - **둘 다 없으면 컴파일 에러!**
    
    ---
    
    ### 🔧 해결 방법
    
    1. **Lombok 사용**
    
    ```java
    
    @Getter
    @Setter
    @Entity
    public class Student {
        ...
    }
    
    ```
    
    1. **직접 메서드 정의**
    
    ```java
    
    public School getSchool() {
        return school;
    }
    
    ```
    
    - 객체 그래프 탐색 = 연관 객체를 따라가며 값 접근 (`A.getB().getC()`)
    - getter 없으면 접근 불가 → 직접 만들거나 Lombok 사용
    - DB의 JOIN 대신, **객체 지향적으로 접근**하는 방식

### 객체 그래프 탐색이란?

- **JPA에서 엔티티 간의 연관 관계를 따라가며 데이터를 꺼내는 것**
- 예: `student.getSchool().getName();`

  → 학생 → 학교 → 학교 이름

  → 이렇게 연관된 객체들을 따라가며 값에 접근하는 것


---

### 📘 예시 코드

```java
java
복사편집
@Entity
public class Student {
    @Id
    private Long id;
    private String name;

    @ManyToOne
    private School school;
}

@Entity
public class School {
    @Id
    private Long id;
    private String name;
}

```

```java
java
복사편집
Student student = em.find(Student.class, 1L);
String schoolName = student.getSchool().getName();

```

---

### ⚠️ 주의: Getter 없으면 접근 불가

- `student.getSchool()` → `Student` 클래스에 `getSchool()` 메서드가 필요
- `.getName()` → `School` 클래스에 `getName()` 메서드가 필요
- **둘 다 없으면 컴파일 에러!**

---

### 🔧 해결 방법

1. **Lombok 사용**

```java

@Getter
@Setter
@Entity
public class Student {
    ...
}

```

1. **직접 메서드 정의**

```java

public School getSchool() {
    return school;
}

```

- 객체 그래프 탐색 = 연관 객체를 따라가며 값 접근 (`A.getB().getC()`)
- getter 없으면 접근 불가 → 직접 만들거나 Lombok 사용
- DB의 JOIN 대신, **객체 지향적으로 접근**하는 방식