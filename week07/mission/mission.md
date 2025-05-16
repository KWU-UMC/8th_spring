# 미션

## RestControllerAdvice

💡 장점
        
- 컨트롤러에서 예외를 직접 처리하지 않아도 됨
- @RequestControllerAdvoice가 선언된 클래스에서 해당 예외를 캐치하고 적절한 응답을 반환함
- 응답 형식을 통일할 수 있어 클라이언트 처리가 용이
- 매 컨트롤러마다 try-catch를 반복할 필요가 없어 중복 코드를 제거할 수 있음
        
💡  없을 경우 어떤 점이 불편할까?
        
- 컨트롤러마다 예외 처리를 일일이 구현해야 하므로 코드 중복과 복잡도 증가
- 변경이 필요할 경우 여러 컨트롤러를 모두 수정해야 하므로 유지보수가 어려움
- 예외가 발생할 때마다 응답을 수동으로 구성해야 하므로 생산성 저하
- 응답 형식이 일관되지 않아 클라이언트가 에러 처리하기 어려움

## 미션 목록 조회 API 명세서
        
### API endpoint
        
GET `/api/missions?status={CHALLENGING | COMPLETE}`
        
### Request Header
        
```json
{
  "Authorization" : "accessToken"
  "Content-Type": "application/json"
}
```
        
### Response Body

```jsx
{
  "isSuccess": true,
  "code": "COMMON200",
  "message": "미션 조회 성공",
  "result": {
    "member_id": 123,
    "status": "COMPLETE",
    "missions": [
      {
        "member_mission_id": 123,
        "mission_id": 1,
        "store_name": "가게이름a",
        "mission_description": "12,000원 이상의 식사를 하세요!",
        "reward": 500
      },
      {
        "member_mission_id": 123,
        "mission_id": 1,
        "store_name": "가게이름a",
        "mission_description": "12,000원 이상의 식사를 하세요!",
        "reward": 500
      },
    ]
  }
}

```
        
## 워크북 진행과정
        
### 성공시

1. ErrorReasonDTO / ReasonDTO 작성
2. BaseCode / BaseErrorCode 작성
3. **SuccessStatus 작성**
4. TempResponse 내부에 TempTestDTO(성공시) 작성
5. TempConverter 내부에 TempTestDTO빌더 작
6. TempRestController `/temp/test` endpoint 작성
7. `localhost:8080/temp/test` 호출
8. 응답
```jsx
{
  "isSuccess": true,
  "code": "COMMOM200",
  "message": "성공입니다.",
  "result": {
    "testString": "This is Test"
  }
}
```

### 에러 핸들러

1. ErrorStatus 작성 (BaseErrorCode 상속받도록)
2. **GeneralException 작성**
3. `implementation 'org.springframework.boot:spring-boot-starter-validation'` 의존성 추가
4. **ExceptionAdvice 작성**
5. TempHandler 작성
6. TempResponse 내부에 TempExceptionDTO(에러발생시) 작성
7. TempConverter 내부에 TempExceptionDTO빌더 작성
8. TempRestController `/temp/exception` endpoint 작성
9. TempService / TempServiceImpl 작성
10. `localhost:8080/temp/exception?flag={1|2}`호출
11. 응답

```java
{
  "isSuccess": false,
  "code": "TEMP4001",
  "message": "이것은 테스트"
}
```

```java
{
  "isSuccess": true,
  "code": "COMMOM200",
  "message": "성공입니다.",
  "result": {
    "flag": 2
  }
}
```

> **github 링크**
>
>
> https://github.com/sunninz/UMC-Spring-Study/tree/feat/week7


---
# 시니어 미션

https://velog.io/@sunnin/UMC-SpringBoot에서-500-에러-발생-시-디스코드로-자동-알림-보내기