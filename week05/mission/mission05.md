# 5주차 미션

## Userinfo 엔티티 정리
- @Entity   // DB에서 userinfo 테이블과 매핑
@Table(name = "userinfo")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserInfo {
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private Integer uid; // 유저 고유 식별자 / PK로 설정해서 유일한 값 자동 생성

    @Column(nullable = false, length = 50)
    private String upassword; // 유저 비밀번호 / null 허용하지 않음

    @Column(nullable = false, length = 40)
    private String uname; // 유저 이름 / null 허용하지 않음

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Gender gender; // 성별 / ENUM('남자','여자','선택안함') 중 하나 선택

    @Enumerated(EnumType.STRING)
    @Column(columnDefinition = "ENUM('Active','delete') DEFAULT 'Active'")
    private UDelete udelete = UDelete.Active; // 유저 활성/삭제 상태 관리용 / 기본값 Active

    @Column(nullable = false, length = 100)
    private String address; // 유저 주소 / null 허용하지 않음

    @Column(nullable = false)
    private Integer birthYear; // 생년

    @Column(nullable = false)
    private Integer birthMonth; // 생월

    @Column(nullable = false)
    private Integer birthDay; // 생일

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserFood> userFoods; // 유저가 좋아하는 음식 리스트와 연결

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<Review> reviews; // 유저가 작성한 리뷰 리스트와 연결

    @OneToMany(mappedBy = "user", cascade = CascadeType.ALL)
    private List<UserMission> missions; // 유저가 진행 중인 미션 리스트와 연결
}
- 한 테이블만 예시로 설명하였고, 본인 깃허브에 업로드 완료
- https://github.com/EunSe-o/UMC_Spring.git

## 과제를 해결하며 문제점
- 작성한 엔티티와 DB 매핑이 제대로 되지 않아 많은 오류 발생.
- Gradle과 Application.java 파일 등을 여러번 실행, 설정을 바꾸며 문제 해결
- 버전이 맞지 않아 발생한 오류, 변수 이름이 달라서 발생한 오류가 있었음