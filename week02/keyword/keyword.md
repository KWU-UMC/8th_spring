INNER JOIN
```sql
SELECT <열 목록>
FROM <첫 번째 테이블>
    INNER JOIN <두 번째 테이블>
    ON <조인 조건> //두 테이블을 어떤 기준으로 묶을 건지
[WHERE 검색 조건] //조인된 결과에서 필요한 행만 걸러냄

#INNER JOIN을 JOIN이라고만 써도 INNER JOIN으로 인식합니다.
```

OUTER JOIN
```sql
SELECT <열 목록>
FROM <첫 번째 테이블(LEFT 테이블)>
    <LEFT | RIGHT | FULL> OUTER JOIN <두 번째 테이블(RIGHT 테이블)>
     ON <조인 조건>
[WHERE 검색 조건]
```