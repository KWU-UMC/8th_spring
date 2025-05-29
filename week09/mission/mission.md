memberId는 1로 하드코딩한 후 진행했습니다.

## 1. 내가 작성한 리뷰 목록 조회
### API 명세서

| API Endpoint | GET /{storeId}/reviews/my-review |
| --- | --- |
| Request Body | - |
| Request Header | Authorization: Bearer {access Token} |
| Query String | ?page={page} |
| Path Variable | storeId |

### 응답 형식

```json
{
  "isSuccess": true,
  "code": "COMMON200",
  "message": "성공입니다.",
  "result": {
    "reviewList": [
      {
        "ownerNickname": "김주현",
        "rating": 4,
        "content": "맛있어요!",
        "createdAt": "2025.05.27"
      },
      {
        "ownerNickname": "김주현",
        "rating": 5,
        "content": "또 오고 싶어요.",
        "createdAt": "2025.05.28"
      }
    ],
    "totalElements": 2,
    "totalPages": 1,
    "listSize": 2,
    "isFirst": true,
    "isLast": true
  }
}

```

### 1. Controller
/{storeId}/reviews/my-review로 GET 요청이 오면

```java
// swagger 설정은 생략
@GetMapping("/{storeId}/reviews/my-review")
public ApiResponse<ReviewResponseDTO.ReviewPreViewListDTO> getMyReviewList(
        @ExistStore @PathVariable Long storeId, @ValidatedPage Integer page) {
    Long memberIdWithToken = 1L; // 멤버 id 임의로 설정
    Page<Review> reviewList = reviewCommandService.getMyReviewList(memberIdWithToken, storeId, page);
    return ApiResponse.onSuccess(ReviewConverter.reviewPreViewListDTO(reviewList));
}
```

Service로 memberId, storeId, page를 넘긴 후, 결과를 컨버터를 이용해 DTO로 변경한 후, 응답한다.

### 2. Service
```java
public Page<Review> getMyReviewList(Long memberId, Long storeId, Integer page) {
    Member member = memberRepository.findById(memberId)
            .orElseThrow(() -> new TempHandler(ErrorStatus.MEMBER_NOT_FOUND));
    Store store = storeRepository.findById(storeId).get();
    return reviewRepository.findAllByMemberAndStore(member, store, PageRequest.of(page, 10));
}
```

Repository에 member, store, pageRequest를 넘긴 후, 결과를 반환한다.

### 3. Repository
```java
public interface ReviewRepository extends JpaRepository<Review, Long> {

    Page<Review> findAllByMemberAndStore(Member member, Store store, PageRequest pageRequest);
}
```

### 결과 사진
![결과 1-1](images/결과%201-1.png)

![결과 1-2](images/결과%201-2.png)

## 2. 특정 가게의 미션 목록 조회
### API 명세서

| API Endpoint | GET /{storeId}/missions |
| --- | --- |
| Request Body | - |
| Request Header | Authorization: Bearer {access Token} |
| Query String | ?page={page} |
| Path Variable | storeId |

### 응답 형식

```json
{
  "isSuccess": true,
  "code": "COMMON200",
  "message": "성공입니다.",
  "result": {
    "missionList": [
      {
        "missionId": 10
        "missionSpec": "Store 7- 미션 1",
        "point": 1000,
        "requiredPrice": 20000,
        "createdAt": "2025.05.27"
      },
      {
        "missionId": 12
        "missionSpec": "Store 7- 미션 2",
        "point": 2000,
        "requiredPrice": 30000,
        "createdAt": "2025.05.28"
      }
    ],
    "totalElements": 2,
    "totalPages": 1,
    "listSize": 2,
    "isFirst": true,
    "isLast": true
  }
}

```

### 1. Controller
/{storeId}/missions로 GET 요청이 오면

```java
// swagger 설정은 생략
@GetMapping("/{storeId}/missions")
public ApiResponse<MissionResponseDTO.MissionListDTO<MissionResponseDTO.MissionPreViewDTO>> getMissionList(
          @ExistStore @PathVariable Long storeId, @ValidatedPage Integer page) {
      Page<Mission> missionList = missionCommandService.getMissionList(storeId, page);
      return ApiResponse.onSuccess(MissionConverter.missionPreViewListDTO(missionList));
}
```

Service로 storeId, page를 넘긴 후, 결과를 컨버터를 이용해 DTO로 변경하고 응답한다.

### 2. Service
```java
public Page<Mission> getMissionList(Long storeId, Integer page) {
    Store store = storeRepository.findById(storeId).get();
    return missionRepository.findAllByStore(store, PageRequest.of(page, 10));
}
```

### 3. Repository
```java
public interface MissionRepository extends JpaRepository<Mission, Long> {
    
    Page<Mission> findAllByStore(Store store, PageRequest pageRequest);
}
```

### 결과 사진
![결과 2-1](images/결과%202-1.png)

![결과 2-2](images/결과%202-2.png)

## 3. 내가 진행중인 미션 목록 조회
### API 명세서

| API Endpoint | GET /members/missions?state=CHALLENGING |
| --- | --- |
| Request Body | - |
| Request Header | Authorization: Bearer {access Token} |
| Query String | ?page={page}&state=CHALLENGING |
| Path Variable |  |

### 응답 형식

```json
{
  "isSuccess": true,
  "code": "COMMON200",
  "message": "성공입니다.",
  "result": {
    "missionList": [
      {
        "missionId": 1,
        "missionSpec": "Store 7 - 미션 1",
        "point": 1000,
        "requiredPrice": 20000,
        "storeId": 1,
        "storeName": "광운대카페",
        "createdAt": "2025.05.27"
      },
      {
        "missionId": 2,
        "missionSpec": "Store 7 - 미션 2",
        "point": 2000,
        "requiredPrice": 30000,
        "storeId": 1,
        "storeName": "광운대카페",
        "createdAt": "2025.05.28"
      }
    ],
    "totalElements": 2,
    "totalPages": 1,
    "listSize": 2,
    "isFirst": true,
    "isLast": true
  }
}

```

### 1. Controller
/members/missions?state=CHALLENGING 로 GET 요청이 오면

```java
// swagger 설정은 생략
@GetMapping("/members/missions")
public ApiResponse<MissionResponseDTO.MissionListDTO<MissionResponseDTO.MissionWithMemberDTO>> getMissionListWithMember(
        @ValidatedPage Integer page, @RequestParam MissionState state) {
    Long memberIdWithToken = 1L; // 멤버 id 임의로 설정
    Page<MissionMember> missionList = missionCommandService.getMissionListWithMember(memberIdWithToken, state, page);
    return ApiResponse.onSuccess(MissionConverter.missionWithMemberListDTO(missionList));
}
```

Service로 memberId,state, page를 넘긴 후, 결과를 컨버터를 이용해 DTO로 변경하고 응답한다.

### 2. Service
```java
public Page<MissionMember> getMissionListWithMember(Long memberId, MissionState missionState, Integer page) {
    return missionMemberRepository.findAllByMemberIdAndState(memberId, missionState, PageRequest.of(page, 10));
}
```

Repository에 memberId, missionState, pageRequest를 넘긴 후, 결과를 반환한다.

(진행중/진행 완료 미션을 조회할 수 있도록 설정)

### 3. Repository
```java
public interface MissionMemberRepository extends JpaRepository<MissionMember, Long> {

    Page<MissionMember> findAllByMemberIdAndState(Long memberId, MissionState missionState, PageRequest pageRequest);
}
```

### 결과 사진
![결과 3-1](images/결과%203-1.png)

![결과 3-2](images/결과%203-2.png)

## 4. 페이지 검증 커스텀 어노테이션
1. `PageArgumentResolver` 는 컨트롤러 메서드의 파라미터 중 `@ValidatedPage` 어노테이션이 붙고, 타입이 `Integer`인 경우를 감지하여 동작한다.
2. `resolveArgument()` 메서드에서 요청 파라미터 `“page”` 값을 가져온 후 다음과 같이 처리한다:
    - 값이 `null` 이거나 파싱 불가능한 경우 → 기본값 1로 설정
    - 값이 `1`보다 작을 경우 → 커스텀 예외 `TempHandler(PAGE_PARAM_INVALID)`를 throw한다.
        - 이는 `ExceptionAdvice`에서 `GeneralException`으로 감지되어,
        - `ApiResponse.onFailure(...)` 형태로 처리된다.
3. 값이 `1` 이상일 경우 → `page - 1` 값을 반환한다.

   (프론트 기준 페이지 1이 백엔드에서는 0부터 시작되도록)
### PageArgumentResolver
```java
@Component
public class PageArgumentResolver implements HandlerMethodArgumentResolver {
    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        return parameter.hasParameterAnnotation(ValidatedPage.class)
                && parameter.getParameterType().equals(Integer.class);
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer, NativeWebRequest webRequest, WebDataBinderFactory binderFactory) throws Exception {
        String pageStr = webRequest.getParameter("page");
        int page;

        try {
            page = Integer.parseInt(pageStr);
        } catch (Exception e) {
            page = 1;
        }

        if (page < 1) {
            throw new TempHandler(ErrorStatus.PAGE_PARAM_INVALID);
        }

        return page - 1;
    }
}
```
<br>
다음과 같이 페이지 번호를 -1이나

![페이지 에러 1](images/페이지%20에러%201.png)

0으로 설정했을 때 에러 메시지가 반환된다.

![페이지 에러 2](images/페이지%20에러%202.png)

> **github 링크**
>
>
> https://github.com/kjhyeon0620/umc8th/tree/feature/%234
>