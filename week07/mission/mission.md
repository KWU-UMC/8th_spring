## senior mission
[hannho velog](https://velog.io/@hann1233/UMC-8th-Senior-Mission-chapter.7)
## Mission
[H4nnhoi github repo](https://github.com/H4nnhoi/UMC_8th_study/pull/6)
### restControllerAdvice 장점

Spring Boot는 **AOP(Aspect-Oriented Programming, 관점 지향 프로그래밍)** 개념을 적극적으로 지향한다.

AOP는 핵심 비즈니스 로직과 부가적인 기능(예: 로깅, 보안, 트랜잭션, 예외 처리 등)을 **관심사(Aspect)** 단위로 분리함으로써, **코드의 응집도는 높이고 중복은 줄이는** 설계 패턴이다.

조금 더 쉽게 말하자면, 기존의 계층(Layer) 기반 설계에서 한 단계 나아가, **공통된 관심사들을 별도의 모듈로 분리하여 처리하는 방식**이다. 이런 방식은 핵심 비즈니스 로직에 집중할 수 있게 하며, 유지보수와 테스트 측면에서도 효율적이다.

예외 처리 역시 대표적인 부가 기능이며, 이를 AOP 관점에서 처리하는 것이 `@RestControllerAdvice`의 역할이다.

이 어노테이션을 사용하면 **모든 컨트롤러에서 발생하는 예외를 전역적으로 처리**할 수 있어, 각 로직에 매번 `try-catch` 블록을 작성할 필요가 없다. 결과적으로 중복 코드를 줄이고, 예외 응답 포맷의 일관성을 유지하며, 예외 처리 로직의 재사용성을 극대화할 수 있다.

반대로 `@RestControllerAdvice`가 없다면, 예외가 발생할 수 있는 모든 위치에 `try-catch` 구문을 일일이 작성해야 하며, 이는 **코드의 중복**과 **응답 포맷의 불일치**, **유지보수의 어려움**으로 이어진다.

### 미션 목록 조회(진행중, 진행 완료) API 명세서 작성하기

🤝 **GET /api/missions**

- query String : X
- request body: X
- request Header: AccessToken
- **response**
~~~json
{
	"isSuccess ": true,
	"code" : "2000",
	"message" : "OK",
	"result" : [
              {
                "missionId": 1,
                "missionTitle": "메뉴 한가지만 10개 먹기",
                "status": "IN_PROGRESS"
              },
              {
                "missionId": 2,
                "missionTitle": "좋아요 누르기",
                "status": "COMPLETED"
              },
              {
                "missionId": 3,
                "missionTitle": "포장해가기",
                "status": "IN_PROGRESS"
              }
    ]
		
}
~~~