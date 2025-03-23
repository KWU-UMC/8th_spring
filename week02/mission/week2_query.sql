SELECT
    UM.user_mission_id,
    M.title AS mission_title,
    M.description AS mission_description,
    UM.status AS mission_status,
    UM.completed_at AS completion_date,
    UP.points AS user_points
FROM
    User_Mission UM
        JOIN
    Mission M ON UM.mission_id = M.mission_id
        JOIN
    User_Points UP ON UM.user_id = UP.user_id
WHERE
    UM.user_id = ? -- 특정 사용자 ID를 입력
  AND (
    (UP.points < ?)
        OR (UP.points = ? AND UM.completed_at < ?)
    )
ORDER BY
    UP.points DESC, -- 포인트 기준 내림차순 정렬
    UM.completed_at DESC -- 완료일 기준 내림차순 정렬
    LIMIT ?; -- 한 페이지에 표시할 레코드 수

INSERT INTO Review (
    user_mission_id,
    content,
    rating,
    created_at
)
VALUES (
           ?,              -- 특정 User_Mission ID (사용자가 완료한 미션의 ID)
           ?,              -- 리뷰 내용
           ?,              -- 평점 (1~5 사이의 값)
           CURRENT_TIMESTAMP -- 리뷰 작성 시간 (현재 시간)
       );

SELECT
    M.mission_id,
    M.title AS mission_title,
    M.description AS mission_description,
    M.points_reward,
    R.region_name
FROM
    Mission M
        JOIN
    Region R ON M.region_id = R.region_id
WHERE
    R.region_id = ? -- 선택된 지역 ID를 입력
ORDER BY
    M.mission_id ASC -- 미션 ID 기준으로 정렬 (필요에 따라 변경 가능)
    LIMIT ? OFFSET ?; -- 페이징: 한 페이지에 표시할 개수와 시작점

-- 내 정보 및 포인트 조회
SELECT
    U.user_id, U.username, U.email, UP.points
FROM
    User U JOIN User_Points UP ON U.user_id = UP.user_id
WHERE
    U.user_id = ?;
-- 내가 작성한 리뷰 조회
SELECT
    R.review_id, M.title AS mission_title, R.content AS review_content, R.rating, R.created_at AS review_date
FROM
    Review R JOIN User_Mission UM ON R.user_mission_id = UM.user_mission_id JOIN Mission M ON UM.mission_id = M.mission_id
WHERE
    UM.user_id = ?
ORDER BY R.created_at DESC;

-- 알림 설정 조회
SELECT
    user_id, notification_type, is_enabled
FROM
    Notification_Settings WHERE user_id = ?;

-- 1:1 문의 조회
SELECT
    inquiry_id, subject, content, created_at AS inquiry_date, status
FROM
    User_Inquiries WHERE user_id = ?
ORDER BY created_at DESC;
