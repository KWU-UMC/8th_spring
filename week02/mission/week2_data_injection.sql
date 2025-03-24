-- User 테이블에 더미 데이터 삽입
INSERT INTO User (username, password, email, created_at)
VALUES
    ('홍길동', 'password123', 'hong@example.com', CURRENT_TIMESTAMP),
    ('김철수', 'password456', 'kim@example.com', CURRENT_TIMESTAMP),
    ('이영희', 'password789', 'lee@example.com', CURRENT_TIMESTAMP);

-- User_Points 테이블에 더미 데이터 삽입
INSERT INTO User_Points (user_id, points)
VALUES
    (1, 1200),
    (2, 800),
    (3, 500);

-- Region 테이블에 더미 데이터 삽입
INSERT INTO Region (region_name)
VALUES
    ('서울'),
    ('부산'),
    ('대구'),
    ('광주');

-- Store 테이블에 더미 데이터 삽입
INSERT INTO Store (name, address, phone_number, region_id)
VALUES
    ('가게1', '서울 강남구', '010-1234-5678', 1),
    ('가게2', '부산 해운대구', '010-2345-6789', 2),
    ('가게3', '대구 중구', '010-3456-7890', 3),
    ('가게4', '광주 동구', '010-4567-8901', 4);

-- Mission 테이블에 더미 데이터 삽입
INSERT INTO Mission (title, description, points_reward, region_id)
VALUES
    ('서울 미션1', '서울에서 첫 번째 미션입니다.', 100, 1),
    ('서울 미션2', '서울에서 두 번째 미션입니다.', 150, 1),
    ('부산 미션1', '부산에서 첫 번째 미션입니다.', 200, 2),
    ('대구 미션1', '대구에서 첫 번째 미션입니다.', 300, 3),
    ('광주 미션1', '광주에서 첫 번째 미션입니다.', 400, 4);

-- User_Mission 테이블에 더미 데이터 삽입
INSERT INTO User_Mission (user_id, mission_id, status, completed_at)
VALUES
    (1, 1, '진행중', NULL),
    (1, 2, '완료', '2025-03-20 14:00:00'),
    (2, 3, '진행중', NULL),
    (3, 4, '완료', '2025-03-18 12:00:00');

-- Review 테이블에 더미 데이터 삽입
INSERT INTO Review (user_mission_id, content, rating, created_at)
VALUES
    (2, '정말 재미있는 미션이었습니다.', 5, CURRENT_TIMESTAMP),
    (4, '조금 어려웠지만 보람 있었습니다.', 4, CURRENT_TIMESTAMP);

-- Notification_Settings 테이블에 더미 데이터 삽입
INSERT INTO Notification_Settings (user_id, notification_type, is_enabled)
VALUES
    (1, '새로운 미션', TRUE),
    (1, '리뷰 요청', FALSE),
    (2, '새로운 미션', TRUE),
    (3, '리뷰 요청', TRUE);

-- User_Inquiries 테이블에 더미 데이터 삽입
INSERT INTO User_Inquiries (user_id, subject, content, created_at, status)
VALUES
    (1, '포인트 관련 문의', '포인트 적립이 안 되었습니다.', CURRENT_TIMESTAMP, '답변 대기'),
    (2, '계정 문제 문의', '계정이 잠겼습니다.', CURRENT_TIMESTAMP, '답변 완료');
