# 5주차 키워드

## Domain
- 비즈니스 로직과 규칙을 담고 있는 애플리케이션의 핵심 모델 영역
- @Entity로 표시된 클래스들이 도메인 모델에 해당되며 고유 식별자 (@Id)를 가짐
- Repository : 도메인 객체를 저장하고 조회하는 인터페이스
- 도메인의 장점 : 한눈에 의미를 파악할 수 있음 / 응집도가 올라감 / 유지 보수에 좋음


## 양방향 매핑
- 두 엔티티가 서로를 참조하며 주인에서만 외래키를 관리하고, 역방향은 mappedby로 주인을 지정함
- 반드시 "order.addItem(item)" 과 같은 편의 메서드를 이용해 양쪽 필드를 동기화해야 함

#### cascade vs orphanRemoval
- cascade = ALL -> Order를 저장하면 OrderItem도 함께 저장됨
- orphanRemoval = true -> 컬렉션에서 제거된 자식은 DB에서 삭제함

#### OneToMany/ManyToOne
- Owner: @ManyToOne
- 역방향: @OneToMany(mappedBy)

#### OneToOne
- Owner: 한쪽에 @JoinColumn, 다른 쪽에 mappedBy
- 역방향: X

#### ManyToMany
- Owner: 양쪽 @ManyToMany + mappedBy 또는 중간 테이블 엔티티 사용
- 역방향: X

## N+1 문제
- 컬렉션 또는 @ManyToOne을 접근할 때, 매번 DB에 추가 조회 발생
- 네트워크 왕복 문제, 오버헤드 등으로 인해 성능에 영향을 줌
- @EntityGraph를 사용하거나, 배치 사이즈 조정 등을 통해 해결 가능
