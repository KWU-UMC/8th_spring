- DB 에서 /home  이게 없는데 괜찮?

  `/home` 엔드포인트는 단순히 홈 화면에 필요한 데이터를 가져오는 API일 뿐.

  이 API가 데이터를 어디서 가져올지는 **DB 테이블을 조합해서 결정하면 됨.**
    
  ---

  ### 🔍 **현재 나의 DB 상태 분석**

  ✅ DB에 `home`이라는 테이블은 없지만,

  ✅ `users`, `missions`, `reviews` 등의 테이블이 존재해!

  ✅ 홈 화면에서 보여줄 데이터는 **이 테이블들에서 가져오면 됨**.
    
  ---

  ### 🛠 **홈 화면 API를 위한 데이터 조합**

    - `users` → **사용자 정보 (이름, 포인트 등)**
    - `missions` → **진행 중인 미션**
    - `reviews` → **사용자가 작성한 리뷰 목록**

  즉, **별도의 `home` 테이블이 없어도** `users`, `missions`, `reviews` 테이블을 조합해서 홈 화면 데이터를 구성하면 ok.
    
  ---

  ### ✅ **홈 화면 데이터 가져오는 쿼리 예시**

    ```sql
    sql
    복사편집
    -- 1. 사용자 정보 가져오기
    SELECT id, name, point FROM users WHERE id = 1;
    
    -- 2. 진행 중인 미션 가져오기
    SELECT id AS missionId, description, status
    FROM missions
    WHERE user_id = 1 AND status = '진행중';
    
    -- 3. 사용자가 작성한 리뷰 가져오기
    SELECT id AS reviewId, store_name, description
    FROM reviews
    WHERE user_id = 1;
    
    ```

  이렇게 여러 개의 쿼리를 실행해서 데이터를 합쳐서 프론트엔드에 보내면 ok!.



### 🚀 RESTful API 설계 원칙: **DB 구조에 억지로 맞추지 말자!**


---

### **✅ 결론: "DB와 비슷하게, 하지만 유연하게!"**

📌 **DB 스키마를 기반으로 Request Body를 설계하되, 필요하면 변형할 수 있다!**

✔ **백엔드에서 변환 처리가 가능하다면, 더 직관적인 필드명을 사용할 수 있음**

✔ **하지만 DB 구조와 너무 다르면, 변환 로직이 복잡해질 수 있음**

✔ **무조건 따를 필요는 없지만, "최대한 비슷하게 + API에 맞게 조정"하는 것이 핵심!** 🚀
