
  클래스의 필드명이 `camelCase`이면 → DB 컬럼은 ****`snake_case`로 자동 변환됨

    - **홈 화면**
        - 달성도, 현재 포인트 등 홈 화면에서 필요한 정보들
            - **API Endpoint**

            ```
            	GET /api/home
            ```

            - **Request Body**
            - **Request Header**

            ```
            Authorization : accessToken (String)
            ```

        - NOT_STARTED 미션 리스트
            - **API Endpoint**

            ```
            GET /api/missions?cursorStatus=NOT_STARTED&cursorUpdatedAt=2025-03-25T09:30:00Z&cursorMissionId=32&size=10
            ```

          커서 페이지네이션 적용

            - **Request Body**
            - **Request Header**

            ```
            Authorization : accessToken (String)
            ```

          미션은 스크롤할 때마다 계속 요청되는데 달성도는 반복해서 불러올 필요 없기 때문에 API 분리

    - **리뷰 작성**
        - **API Endpoint**

        ```
        POST /api/stores/{storeId}/reviews
        ```

        - **Request Body**

        ```json
        {
          "score": 5,
          "content": "정말 맛있어요",
          "reviewImageUrl": [
        	  "이미지url",
        	  "이미지url"
          ]
        }
        ```

        - **Request Header**

        ```
        Authorization : accessToken (String)
        Content-Type: application/json
        ```

    - **마이 페이지**
        - **API Endpoint**

        ```
        GET /api/users/mypage
        ```

        - **Request Body**
        - **Request Header**

        ```
        Authorization : accessToken (String)
        Content-Type: application/json
        ```

    - **미션 목록 조회(진행중, 진행 완료)**
        - 진행중
            - **API Endpoint**

            ```
            GET /api/missions?cursorStatus=IN_PROGRESS&cursorUpdatedAt=2025-03-25T09:30:00Z&cursorMissionId=32&size=10
            ```

          커서 페이지네이션 적용

            - **Request Body**
            - **Request Header**

            ```
            Authorization : accessToken (String)
            ```

        - 진행완료
            - **API Endpoint**

            ```
            GET /api/missions?cursorStatus=COMPLETED&cursorUpdatedAt=2025-03-25T09:30:00Z&cursorMissionId=32&size=10
            ```

          커서 페이지네이션 적용

            - **Request Body**
            - **Request Header**

            ```
            Authorization : accessToken (String)
            ```


         따로따로 무한 스크롤 적용하기 위해 진행중, 진행 완료 api 분리
        
    - **미션 성공 누르기**
        - **API Endpoint**
        
        ```
        PATCH /api/missions/{missionId}
        ```
        
        - **Request Body**
        
        ```json
        {
          "status": "COMPLETED"
        }
        ```
        
        - **Request Header**
        
        ```
        Authorization : accessToken (String)
        Content-Type: application/json
        ```
        
    - **회원 가입 하기(소셜 로그인 고려 X)**
        - **API Endpoint**
        
        ```
        POST /api/users
        ```
        
        - **Request Body**
        
        ```json
        {
          "name": "김단하",
          "gender": "FEMALE",
          "age": 20030605,
          "address": "광운대학교",
          "locationAgree": true,
          "marketingAgree": true,
          "foodCategoryIds": [1, 3, 5]
        }
        ```
        
        - **Request Header**
        
        ```
        Content-Type: application/json
        ```
https://velog.io/@danha/RESTful-API-%EC%84%A4%EA%B3%84-%EC%9B%90%EC%B9%99%EB%B6%80%ED%84%B0-Control-URI%EA%B9%8C%EC%A7%80
https://velog.io/@danha/SQLJPA-Soft-Delete-Hard-Delete