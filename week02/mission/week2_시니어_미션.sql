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
