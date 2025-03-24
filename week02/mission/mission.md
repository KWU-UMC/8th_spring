# 미션

## 내가 진행중, 진행 완료한 미션 모아서 보는 쿼리(페이징 포함)
      ## 진행 중인 미션
      SELECT
         member_mission.id,
         member_mission.status,
         mission.reward,
         mission.mission_spec,
         store.name
      FROM member_mission
         JOIN mission ON mission.id=member_mission.id
         JOIN store ON store.id=mission.store_id
      WHERE member_mission.member_id={사용자id}
         AND member_mission.status= '진행중'
      LIMIT {페이지 당 갯수} OFFSET {건너 뛸 갯수};

      ## 진행 완료한 미션
      SELECT
         member_mission.id,
         member_mission.status,
         mission.reward,
         mission.mission_spec,
         store.name
      FROM member_mission
         JOIN mission ON mission.id=member_mission.id
         JOIN store ON store.id=mission.store_id
      WHERE member_mission.member_id={사용자id}
         AND member_mission.status= '진행 완료'
      LIMIT {페이지 당 갯수} OFFSET {건너 뛸 갯수};

   ### 스터디
      - 이 서비스 같은 경우에는 본인의 데이터를 본인만 사용하는 거이기 때문에 중간에 데이터가 추가되면서 바뀌는 경우가 없을 수 있기 때문에 굳이 offset을 쓸 필요가 있을까 싶음
      - 진행 중, 진행 완료 query를 2개 따로 짤 필요 없이, 한번에 짜는 게 좋음 → WHERE 절에 IN으로 조건 나열해서 써주기
       (WHERE member_mission.member_id={사용자id} 
         AND member_mission.status IN {‘진행중’, '진행 완료'})
      
## 리뷰 작성하는 쿼리,  * 사진의 경우는 일단 배제
      INSERT INTO review (member_id, store_id, body, score)
      VALUES ({사용자id}, {가게id}, {리뷰 내용}, {별점});

## 홈 화면 쿼리  (현재 선택 된 지역에서 도전이 가능한 미션 목록, 페이징 포함)
      SELECT
	     mission.id,
	     mission.reward,
	     mission.deadline,
	     mission.mission_spec,
	     store.id,
	     store.name,
	     region.id,
	     region.name
      FROM mission
         JOIN store ON store.id=mission.store_id
         JOIN region ON region.id=store.region_id
      WHERE region.id={선택된지역id}
      ORDER BY mission.deadline DESC, mission.id ASC
      LIMIT {페이지  갯수} OFFSET {건너 뛸 갯수};

   ### 스터디
      mission.deadline DESC : DESC → ASC

## 마이 페이지 화면 쿼리
      SELECT
	     member.name
	     member.email
	  CASE
         WHEN member.status='verified' THEN member.phone
		 ELSE '미인증' 
	  END AS phone
      FROM member
      WHERE member.id={사용자id}
