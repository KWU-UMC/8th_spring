#  RestContollerAdvice

## 💡 정의

- Spring Framework에서 전역 예외 처리를 위한 어노테이션으로,

  `@ControllerAdvice` + `@ResponseBody` 의 조합이다.

- REST API의 예외를 JSON/XML 형식으로 일관되게 처리한다.

## 👉 목적

- 모든 컨트롤러의 예외를 단일 클래스에서 중앙 집중식으로 관리
- 클라이언트에 일관된 에러 응답 구조 제공

## ✅ 핵심 기능

  | **기능** | **설명** |
    | --- | --- |
  | **`@ExceptionHandler`** | 특정 예외 유형별 처리 로직 분리 |
  | HTTP 상태 코드 + 커스텀 코드 | `400 BAD_REQUEST` + `"code": "MEMBER4001"`처럼 세부 코드 추가 |
  | REST 최적화 | **`@ResponseBody`** 내장으로 JSON 응답 자동 생성 |

## ❔ vs `@ControllerAdvice`

- `@RestControllerAdvice` = `@ControllerAdvice` = `@ResponseBody`
- `@ControllerAdvice`는 뷰 기반 애플리케이션에 적합, `@RestControllerAdvice`는 REST API에 특화

추가 사항은 미션 기록에 서술
# lombok

## 💡 정의

- Java의 보일러플레이트 코드를 줄이기 위한 라이브러리로, 어노테이션 기반으로 Getter/Setter/생성자 등을 자동으로 생성한다.

## 👉 목적

- 반복적인 코드 작성을 최소화하여 가독성과 생산성 향상
- 불변 객체(Immutable Object) 생성 지원

## ❕ 핵심 어노테이션

  | **어노테이션** | **설명** |
    | --- | --- |
  | **`@Getter`**/**`@Setter`** | 필드의 Getter/Setter 자동 생성 |
  | **`@NoArgsConstructor`** | 기본 생성자 생성 |
  | **`@AllArgsConstructor`** | 모든 필드를 포함한 생성자 생성 |
  | **`@Data`** | **`@Getter`** + **`@Setter`** + **`@ToString`** + **`@EqualsAndHashCode`** |
  | **`@Builder`** | 빌더 패턴 구현 |

## ✅ 장점

- **코드 간결화**: 수동으로 작성할 메서드를 80% 이상 줄임
- **유지보수 용이:** 필드 변경 시 관련 메서드 자동 갱신
- **불변성 지원**: `@Value`로 immutable 클래스 생성

## ⚠️ 주의사항

- **IDE 플러그인 필수**: ImtelliJ/Eclipse에서 Lombok 플러그인 설치 필요
- **디버깅 어려움**: 생성된 코드가 소스에 노출되지 않아 추적이 어려울 수 있음