- **미션 기록**
    - 미션1

      > ❗ Repository에 접근하는 계층은 오직 Service만 해야 한다.
      >
        
      ---

      ## 무슨 말이냐면?

      ### 🔴 지금 잘못된 코드

        ```java
        java
        복사편집
        public class CategoriesExistValidator implements ConstraintValidator<...> {
        
            private final FoodCategoryRepository foodCategoryRepository; // ❌ Validator가 직접 DB 접근
        
            public boolean isValid(List<Long> values, ConstraintValidatorContext context) {
                return values.stream()
                    .allMatch(value -> foodCategoryRepository.existsById(value));
            }
        }
        
        ```

        - 이 코드는 **Validator가 직접 Repository (DB)** 에 접근해요.
        - 근데 Spring에서는 **DB는 무조건 Service만 접근해야 해요.**
        - 즉, **Validator → Repository 직접 접근은 잘못된 설계**예요.

        ---

      ## 올바른 구조는?

      ### 1. ⭐ Service에서 DB 조회만 담당

        ```java
        java
        복사편집
        @Service
        @RequiredArgsConstructor
        public class CategoryValidationService {
        
            private final FoodCategoryRepository foodCategoryRepository;
        
            public boolean allExistByIds(List<Long> ids) {
                return ids.stream().allMatch(id -> foodCategoryRepository.existsById(id));
            }
        }
        
        ```

        - DB 접근은 여기서만!
        - 이건 그냥 검증을 도와주는 **Service 용도**예요.

        ---

      ### 2.  Validator에서는 Service만 부르기

        ```java
        java
        복사편집
        @Component
        @RequiredArgsConstructor
        public class CategoriesExistValidator implements ConstraintValidator<ExistCategories, List<Long>> {
        
            private final CategoryValidationService categoryValidationService; // ✅ DB 직접 접근 X
        
            @Override
            public boolean isValid(List<Long> values, ConstraintValidatorContext context) {
                boolean isValid = categoryValidationService.allExistByIds(values); // DB 조회는 여기로 위임
        
                if (!isValid) {
                    context.disableDefaultConstraintViolation();
                    context.buildConstraintViolationWithTemplate("카테고리가 존재하지 않습니다")
                           .addConstraintViolation();
                }
        
                return isValid;
            }
        }
        
        ```

        - Validator는 오직 **검증만** 함.
        - 진짜 DB 조회는 전부 Service에서 처리함.

        ---

      ## 정리

      | 역할 | 할 일 | Repository 접근 |
              | --- | --- | --- |
      | **Repository** | DB 작업 (find, save 등) | O |
      | **Service** | DB 접근 포함된 비즈니스 로직 | ✅ 반드시 여기에만 |
      | **Validator** | 값이 맞는지 확인만 함 | ❌ 직접 접근 금지 |
        
      ---

      ## 외우기 쉽게 비유

        - **Repository = 부동산 등기소 (데이터 보관소)**
        - **Service = 공인중개사 (등기소에서 서류 꺼내옴)**
        - **Validator = 아파트 입주 조건 검사관 (그냥 보고 "합격"만 외침)**

      → 검사관(Validator)은 등기소에 들어가면 안 되고, 중개사(Service)에게 물어봐야 해요.

    - 1.

    ### DTO 만들기

      ```java
      
      // StoreRequestDTO.java
      public class StoreRequestDTO {
      
          @Getter
          public static class AddStoreDTO {
              @NotBlank
              private String name;
      
              @NotBlank
              private String address;
      
              @NotNull
              private Float score;
      
              @NotNull
              private Long regionId; // 중요!
          }
      }
      
      ```

      ```java
      
      // StoreResponseDTO.java
      public class StoreResponseDTO {
      
          @Builder
          @Getter
          @NoArgsConstructor
          @AllArgsConstructor
          public static class AddStoreResultDTO {
              private Long storeId;
              private LocalDateTime createdAt;
          }
      }
      
      ```
      
    ---

    ### 컨버터 만들기

      ```java
      // StoreConverter.java
      public class StoreConverter {
      
          public static StoreResponseDTO.AddStoreResultDTO toAddStoreResultDTO(Store store) {
              return StoreResponseDTO.AddStoreResultDTO.builder()
                      .storeId(store.getId())
                      .createdAt(store.getCreatedAt())
                      .build();
          }
      
          public static Store toStore(StoreRequestDTO.AddStoreDTO dto, Region region) {
              return Store.builder()
                      .name(dto.getName())
                      .address(dto.getAddress())
                      .score(dto.getScore())
                      .region(region)
                      .build();
          }
      }
      
      ```
      
    ---

    ### Repository 만들기

      ```java
      
      public interface RegionRepository extends JpaRepository<Region, Long> {}
      
      ```
      
    ---

    ### Service 만들기

      ```java
      
      @Service
      @RequiredArgsConstructor
      public class StoreCommandService {
      
          private final StoreRepository storeRepository;
          private final RegionRepository regionRepository;
      
          @Transactional
          public Store addStore(StoreRequestDTO.AddStoreDTO dto) {
              Region region = regionRepository.findById(dto.getRegionId())
                      .orElseThrow(() -> new RuntimeException("Region not found"));
      
              Store store = StoreConverter.toStore(dto, region);
              return storeRepository.save(store);
          }
      }
      
      ```
      
    ---

    ### Controller 만들기

      ```java
      
      @RestController
      @RequiredArgsConstructor
      @RequestMapping("/stores")
      public class StoreRestController {
      
          private final StoreCommandService storeCommandService;
      
          @PostMapping("/")
          public ApiResponse<StoreResponseDTO.AddStoreResultDTO> addStore(@RequestBody @Valid StoreRequestDTO.AddStoreDTO dto) {
              Store saved = storeCommandService.addStore(dto);
              return ApiResponse.onSuccess(StoreConverter.toAddStoreResultDTO(saved));
          }
      }
      
      ```

    ![image.png](attachment:7d3d94f1-3eea-4936-9c48-cb636c080871:image.png)

    - 2.

    **리뷰를 특정 가게에 추가하는 API**를 만들 것

    예시: `POST /stores/{storeId}/reviews`
      
    ---

    ## 전체 구조

        - `DTO`: 요청(Request)과 응답(Response) 데이터 정의
        - `Converter`: DTO ↔ Entity 변환
        - `Repository`: DB 접근 (Review, Store, Member 등)
        - `Service`: 비즈니스 로직
        - `Controller`: 외부 API 진입점
        - `@Valid`, 커스텀 어노테이션으로 유효성 검증

      ---

    ## 1. DTO 생성

    ### `ReviewRequestDTO.java`

      ```java
      
      @Getter
      public class ReviewRequestDTO {
      
          @Getter
          public static class ReviewCreateDTO {
              @NotNull
              private Float score;
      
              @NotBlank
              private String content;
          }
      }
      
      ```

    ### `ReviewResponseDTO.java`

      ```java
      
      @Getter
      @Builder
      @AllArgsConstructor
      @NoArgsConstructor
      public class ReviewResponseDTO {
          private Long reviewId;
          private String content;
          private Float score;
      }
      
      ```
      
    ---

    ## 2. Converter 생성

    ### `ReviewConverter.java`

      ```java
      
      public class ReviewConverter {
      
          public static Review toReview(ReviewRequestDTO.ReviewCreateDTO dto, Member member, Store store) {
              return Review.builder()
                      .score(dto.getScore())
                      .content(dto.getContent())
                      .member(member)
                      .store(store)
                      .build();
          }
      
          public static ReviewResponseDTO toResponseDTO(Review review) {
              return ReviewResponseDTO.builder()
                      .reviewId(review.getId())
                      .content(review.getContent())
                      .score(review.getScore())
                      .build();
          }
      }
      
      ```
      
    ---

    ## 4. Service

    ### `ReviewCommandService.java`

      ```java
      
      public interface ReviewCommandService {
          Review addReview(Long storeId, ReviewRequestDTO.ReviewCreateDTO dto);
      }
      
      ```

    ### `ReviewCommandServiceImpl.java`

      ```java
      @Service
      @RequiredArgsConstructor
      public class ReviewCommandServiceImpl implements ReviewCommandService {
      
          private final ReviewRepository reviewRepository;
          private final StoreRepository storeRepository;
          private final MemberRepository memberRepository;
      
          @Override
          @Transactional
          public Review addReview(Long storeId, ReviewRequestDTO.ReviewCreateDTO dto) {
              Store store = storeRepository.findById(storeId)
                      .orElseThrow(() -> newTemphandler(ErrorStatus.STORE_NOT_FOUND));
      
              // 테스트용 멤버 하드코딩 (1번 회원 고정)
              Member member = memberRepository.findById(1L)
                      .orElseThrow(() -> new Temphandler(ErrorStatus.MEMBER_NOT_FOUND));
      
              Review review = ReviewConverter.toReview(dto, member, store);
              return reviewRepository.save(review);
          }
      }
      
      ```
      
    ---

    ## 5. Controller

    ### `ReviewRestController.java`

      ```java
      @RestController
      @RequiredArgsConstructor
      @RequestMapping("/stores")
      public class ReviewRestController {
      
          private final ReviewCommandService reviewCommandService;
      
          @PostMapping("/{storeId}/reviews")
          public ApiResponse<ReviewResponseDTO> addReview(
                  @PathVariable Long storeId,
                  @RequestBody @Valid ReviewRequestDTO.ReviewCreateDTO dto) {
      
              Review review = reviewCommandService.addReview(storeId, dto);
              return ApiResponse.onSuccess(ReviewConverter.toResponseDTO(review));
          }
      }
      
      ```

    ![image.png](attachment:de143cb0-6fea-48f7-8d80-2fd23e6440a6:image.png)

    - 4.

    ## 1. Request DTO

      ```java
      @Getter
      public class MissionChallengeRequestDTO {
      
          @NotNull(message = "memberId는 필수입니다.")
          private Long memberId;
      
          @NotNull(message = "missionId는 필수입니다.")
          @NotAlreadyChallenging // ← 커스텀 어노테이션 (미션 중복 도전 방지)
          private Long missionId;
      }
      
      ```
      
    ---

    ## 2. Response DTO

      ```java
      @Getter
      @Builder
      @AllArgsConstructor
      public class MissionChallengeResponseDTO {
      
          private Long memberId;
          private Long missionId;
          private LocalDateTime challengedAt;
      }
      
      ```
      
    ---

    ## 3. 커스텀 어노테이션

    ### Annotation

      ```java
      
      @Documented
      @Constraint(validatedBy = NotAlreadyChallengingValidator.class)
      @Target({ElementType.FIELD})
      @Retention(RetentionPolicy.RUNTIME)
      public @interface NotAlreadyChallenging {
          String message() default "이미 도전 중인 미션입니다.";
          Class<?>[] groups() default {};
          Class<? extends Payload>[] payload() default {};
      }
      
      ```

    ### Validator

      ```java
      
      @Component
      @RequiredArgsConstructor
      public class NotAlreadyChallengingValidator implements ConstraintValidator<NotAlreadyChallenging, Long> {
      
          private final MemberMissionRepository memberMissionRepository;
      
          @Override
          public boolean isValid(Long missionId, ConstraintValidatorContext context) {
              // 하드코딩된 MemberId 사용 중 (혹은 Validator에 MemberId 주입하는 구조로 변경 가능)
              Long memberId = 1L; // 나중에는 request.getMemberId와 연동해야 더 자연스럽습니다
              return !memberMissionRepository.existsByMemberIdAndMissionId(memberId, missionId);
          }
      }
      
      ```
      
    ---

    ## 4. Service

      ```java
      
      @Service
      @RequiredArgsConstructor
      public class MissionCommandServiceImpl implements MissionCommandService {
      
          private final MemberRepository memberRepository;
          private final MissionRepository missionRepository;
          private final MemberMissionRepository memberMissionRepository;
      
          @Transactional
          public MissionChallengeResponseDTO challengeMission(MissionChallengeRequestDTO request) {
              Member member = memberRepository.findById(request.getMemberId())
                      .orElseThrow(() -> new CustomException(MEMBER_NOT_FOUND));
      
              Mission mission = missionRepository.findById(request.getMissionId())
                      .orElseThrow(() -> new CustomException(MISSION_NOT_FOUND));
      
              MemberMission memberMission = MemberMission.builder()
                      .member(member)
                      .mission(mission)
                      .challengedAt(LocalDateTime.now())
                      .build();
      
              memberMissionRepository.save(memberMission);
      
              return MissionChallengeResponseDTO.builder()
                      .memberId(member.getId())
                      .missionId(mission.getId())
                      .challengedAt(memberMission.getChallengedAt())
                      .build();
          }
      }
      
      ```
      
    ---

    ## 5. Controller