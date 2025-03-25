## Q1. 미션 모아보기 쿼리(진행중, 진행완료)(페이징)

- A1.

  아래는 마이미션이 무조건적으로 미션과 유저를 잇는 테이블이 아닌, 미션 도전을 활성화 했을 때를 가정한 쿼리이다.

    ```sql
    select mm.*, m* from my_mission as mm
    		join mission as m on mm.mission_id = m.id
    		where mm.user_id = {사용자 id} 
    order by created_at DESC
    limit 10 offset 0;
    ```

  erd 설계 시 my_mission은 진행 중과 진행 완료를 위한 테이블로 만들었기 때문에 “누구”의 미션을 가져올 지만 정하면 된다.

  아래는 my_mission이 모두 user와 mission이 생성되었을 때 자동으로 이어져서 status가 ‘NOT_STARTED’, ‘IN_PROGRESS’, ‘COMPLETED’가 존재할 때의 쿼리이다.

    ```sql
    select mm.*, m.* from my_mission as mm
    		join mission as m on mm.mission_id=m.id 
    		where mm.user_id = {사용자 id} AND
    		mm.status in ('IN_PROGRESS', 'COMPLETED') 
    order by created_at DESC 
    limit 10 offset 0;
    ```

  미션은 게시글과 달리, 생성과 조회가 “본인”에 의해서만 작용되기 때문에 커서 쿼리가 필요하지 않다고 생각했고, 그럼에도 커서 쿼리를 적용한다면 아래와 같다.

    ```sql
    select mm.*, m.* from my_mission as mm
    		join mission as m on mm.mission_id = m.id
    		where mm.user_id = {사용자 id} AND
    		mm.status in ('IN_PROGRESS', 'COMPLETED') AND
    		(mm.created_at < '2024-03-01 10:00:00' OR 
    				(mm.created_at = '2024-03-01 10:00:00' AND mm.id < 10))
    order by mm.created_at DESC, mm.id DESC
    limit 10;
    ```

  +누락된 칼럼값이 존재한다.

  기획을 보면 mission은 restaurant과 다대일 관계이다. 그리고 미션을 조회할 때는 restaurant의 name칼럼이 필요하다. 따라서 이를 추가하면 아래와 같다.

    ```sql
    select mm.*, m.*, r.name  
    from my_mission AS mm
    		join mission AS m on mm.mission_id = m.id
    		join restaurant AS r on r.id = mm.restaurant_id
    		where mm.user_id = {사용자 id} AND
    		mm.status in ('IN_PROGRESS', 'COMPLETED') AND
    		(mm.created_at < '2024-03-01 10:00:00' OR 
    				(mm.created_at = '2024-03-01 10:00:00' AND mm.id < 10))
    order by mm.created_at DESC, mm.id DESC
    limit 10;
    ```


## Q2. 리뷰 작성 쿼리 (사진제외)

- A2.

  우선, 테이블이 어떻게 만들어져있는지를 확인해야 한다.

  아래 코드를 확인하면 pk자동 생성이 되도록 설정했으며 created_at과 modified_at은 데이터베이스에 입력 시 입력 시간을 자동으로 insert하도록 설정이 되어있다. 따라서 직접 데이터베이스에 명령문으로 넣어주면 되는 칼럼은 (user_id, restaurant_id, content, rating)이다.

    ```sql
    create table review (
      id INT AUTO_INCREMENT PRIMARY KEY,
      user_id INT,
      restaurant_id INT,
      content TEXT,
      rating DECIMAL(2,1),
      created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
      modified_at DATETIME DEFAULT CURRENT_TIMESTAMP
    );
    ```

  따라서 입력은 아래와 같이 작성하면 된다.

    ```sql
    insert INTO review (user_id, restaurant_id, content, rating) 
    		VALUES (1, 2, 'nice menu! have a good day~', 4.0);
    ```


## Q3. 홈화면(도전 가능 미션 목록 + 페이징, 현 미션 포인트와 지역 클리어 미션 개수 조회)

- A3.

  (두가지 케이스 중에, [my_mission이 도전 수락의 활성화 데이터] 사용되는 케이스만을 다룸)

  my_mission이 도전 수락의 활성화 데이터일 때이다. 이때는 마이 미션에 존재하지 않은 것들을 가져와야하기 때문에 left join을 해서 my_mission의 user_id 가 null 인 경우를 찾아야한다. 이는 아래와 같다.

  (사용자 pk = 4 / 지역 pk = 5일 때)

    ```sql
    select m.* from mission AS m 
    		LEFT JOIN my_mission AS mm ON mm.mission_id = m.id AND mm.user_id = 4
    				WHERE mm.id IS NULL AND
    		m.restaurant_id IN (
    				select r.id from restaurant AS r WHERE r.region_id = 5)
    order by m.created_at DESC
    limit 10 offset 0;
    ```

  누락된 부분이 존재한다. user의 point와 region에서 수행한 미션의 카운트 값 또한 홈페이지에서 필요한 데이터이기 때문에 같이 불러줘야한다. 우선 user point를 추가하면 아래 코드와 같다.

    ```sql
    select m.*, u.point from mission AS m 
    		LEFT JOIN my_mission AS mm ON mm.mission_id = m.id AND mm.user_id = 4
    		JOIN users as u ON u.id = 4
    				WHERE mm.id IS NULL AND
    		m.restaurant_id IN (
    				select r.id from restaurant AS r WHERE r.region_id = 5)
    order by m.created_at DESC
    limit 10 offset 0;
    ```

  이때 user내의 point값을 가져와야하기 때문에 user를 inner join하게 되는데, ON [u.id](http://u.id) = 4와 같이하는 이유는 join의 조건으로 사용해야지 더욱 효과적이기 때문이다. 만약 where과 같이 필터링을 하게 되면 user와 mission을 inner join을 우선한 뒤, 필요없는 데이터를 버리는 과정을 거치기 때문에 불필요한 과정이 추가되는 셈이다.

  마지막으로 카운트를 추가해주면 아래와 같다.

    ```sql
    select
    m.*,
    u.point,
    (select count(*) from my_mission AS mm2
    			JOIN mission AS m2 ON mm2.mission_id = m2.id
    			WHERE mm2.user_id = 4 AND
    			m2.restaurant_id IN 
    					(select r2.id from restaurant as r
    								WHERE r2.region_id = 5)) 
    AS mission_count
    from mission AS m
    		LEFT JOIN my_mission AS mm ON mm.mission_id = m.id AND mm.user_id = 4
    		JOIN users as u ON u.id = 4
    				WHERE mm.id IS NULL AND
    		m.restaurant_id IN (
    				select r.id from restaurant AS r WHERE r.region_id = 5)
    order by m.created_at DESC
    limit 10 offset 0;
    ```

  마찬가지로 본인이 활성화를 하지 않는 이상 페이징의 결과가 달라지지 않기 때문에 위와 같이 보여주어도 된다고 생각한다. 그럼에도 커서 페이징을 추가하면 아래와 같다.

    ```sql
    SELECT
      m.*,
      u.point,
      (
        SELECT COUNT(*)
        FROM my_mission AS mm2
        JOIN mission AS m2 ON mm2.mission_id = m2.id
        WHERE mm2.user_id = 4
          AND m2.restaurant_id IN (
            SELECT r2.id
            FROM restaurant AS r2
            WHERE r2.region_id = 5
          )
      ) AS mission_count
    FROM mission AS m
    LEFT JOIN my_mission AS mm 
      ON mm.mission_id = m.id AND mm.user_id = 4
    JOIN users AS u 
      ON u.id = 4
    WHERE mm.id IS NULL
      AND m.restaurant_id IN (
        SELECT r.id
        FROM restaurant AS r
        WHERE r.region_id = 5
      )
      AND (
        m.created_at < '2024-03-21 14:00:00'
        OR (m.created_at = '2024-03-21 14:00:00' AND m.id < 20)
      )
    ORDER BY m.created_at DESC, m.id DESC
    LIMIT 10;
    ```


## Q4. 마이페이지

- A4.

    ```sql
    select u.nickname, u.email, u.point, u.profile
    	 from users AS u where u.id = 4;
    ```


## SENIOR
https://velog.io/@hann1233/UMC-8th-Senior-Mission-chapter.2