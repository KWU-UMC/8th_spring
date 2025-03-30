### 🚀 RESTful API 설계 원칙: **DB 구조에 억지로 맞추지 말자!**

---

### **✅ 결론: "DB와 비슷하게, 하지만 유연하게!"**

📌 **DB 스키마를 기반으로 Request Body를 설계하되, 필요하면 변형할 수 있다!**

✔ **백엔드에서 변환 처리가 가능하다면, 더 직관적인 필드명을 사용할 수 있음**

✔ **하지만 DB 구조와 너무 다르면, 변환 로직이 복잡해질 수 있음**

✔ **무조건 따를 필요는 없지만, "최대한 비슷하게 + API에 맞게 조정"하는 것이 핵심!** 🚀

# API 명세서

## 1. 홈 화면 데이터 조회

### **Endpoint**

```
GET /home

```

### **Request Body**

없음 (GET 메서드라 필요 없음)

### **Request Header**

```
Authorization: accessToken (String)

```

### **Query String**

```
GET /home?location=안암동

```

(이미지에 안암동이 표시됨)

---

## 2. 마이페이지 리뷰 작성

### **Endpoint**

```
POST /user/{user_id}/reviews

```

### **Request Body**

```json
{
  "user_id": 1,
  "store_id": 2,
  "store_name": "김밥 천국",
  "score": 3.5,
  "description": "음식이 맛있고 분위기가 좋았어요!"
}

```

### **Request Header**

```
Authorization: accessToken (String)

```

### **Query String**

```
GET /user/{user_id}/reviews?store_name=김밥 천국

```

### **Path Variable**

없음

---

## 3. 미션 목록 조회 (진행 중 / 진행 완료)

### **Endpoint**

```
GET /user/mission

```

### **Request Body**

없음

### **Request Header**

```
Authorization: accessToken (String)

```

### **Query String**

```
GET /user/mission?state=진행중
or
GET /user/mission?state=진행완료
```

### **Path Variable**

없음

---

## 4. 미션 성공 처리

### **Endpoint**

```
POST /user/mission/{mission_id}/complete

```

### **Request Body**

```json
{
  "message": "미션이 완료되었습니다.",
  "missionId": 15
}

```

### **Request Header**

```
Authorization: accessToken (String)

```

### **Query String**

없음

### **Path Variable**

없음

---

## 5. 회원 가입 (소셜 로그인 고려 X)

### **Endpoint**

```
POST /user/login

```

### **Request Body**

```json
{
  "name": "김철순",
  "phone_num": "010-1234-5678",
  "gender": "M",
  "address": "서울시 강남구",
  "marketing_agree": true,
  "location_agree": false
}

```

### **Request Header**

로그인 전 상태라 필요 없음

### **Query String**

없음

### **Path Variable**

없음