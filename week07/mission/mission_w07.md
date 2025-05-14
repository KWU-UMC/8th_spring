> **github 링크**
>
>
> https://github.com/heexji/umc_spring/tree/mission7
>
  ## RestControllerAdvice의 장점

  API 전역에서 발생하는 예외를 하나의 클래스에서 처리할 수 있다.

  **→ 코드 중복 없이, 예외 처리를 일관되게 관리할 수 있다.**

    - 모든 Controller의 예외를 한곳에서 처리
    - 에러 응답 형식을 통일할 수 있음 (ex. 공통 에러 메시지 포맷)
    - 실제 서비스에서는 공통된 에러코드, HTTP 상태코드를 자동으로 반환 가능

  ## RestControllerAdvice가 없으면 불편한 점

    - 각 컨트롤러마다 `try-catch`를 매번 작성해야 함
    - 예외 처리 로직이 분산돼서 코드가 지저분해짐
    - API 응답 포맷이 Controller마다 달라져서 클라이언트가 일관성 있게 사용하기 어려움
    - 유지보수 시 예외 처리 위치를 일일이 찾아야 해서 번거로움

  → 에러가 자주 나오는 서비스일수록 **RestControllerAdvice 없이 개발하면 비효율이 심해진다.**

  ## 미션 목록 조회 API 명세서

  진행중/완료된 미션들을 구분하여 조회하는 API에 대한 설계 문서.

  **→ 클라이언트가 미션 목록을 필터링해서 요청할 수 있도록 도와준**

  | 항목 | 내용 |
      | --- | --- |
  | **URL** | `/missions` |
  | **Method** | `GET` |
  | **Query Params** | `status` (string)`→ 진행중(IN_PROGRESS), 완료(COMPLETED)` |
  | **응답코드** | 200 OK |
  | **응답 예시** |  |

    ```json
    
    [
      {
        "id": 1,
        "title": "하루 1만보 걷기",
        "status": "IN_PROGRESS"
      },
      {
        "id": 2,
        "title": "물 2L 마시기",
        "status": "COMPLETED"
      }
    ]
    
    ```

- 프론트에서 ?status=IN_PROGRESS 붙여서 진행중만 요청 가능
- 필터링 조건 없으면 전체 조회도 허용 가능

  → API 명세서를 미리 만들어두면 프론트와 협업 시 빠르고 정확하게 개발 가능하다.