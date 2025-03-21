- **미션 기록**

  ![umc 1주차 미션.png](attachment:2b6b3060-a29e-4181-9fa9-b232e79cf5fa:08d0a8b0-9128-4a02-b301-020b0f844147.png)

    1. ERD 설계
        - 관계 고려

          사용자:장르 → n:m

          사용자:리뷰 → 1:n

          사용자:미션 → n:m

          미션:가게 → 1:1

          장소(지역):가게 → 1:n

          이와 같은 관계를 고려해서 설계함.

        - id들은 모두 확장성을 고려하여 bigint 타입으로 둠.

  ![image.png](attachment:0638bcfa-3d10-4dec-ad0c-2879f77347ae:image.png)

    1. 테이블 생성
        - sql문

            ```sql
            CREATE TABLE user (
                id BIGINT NOT NULL PRIMARY KEY,
                name VARCHAR(30) NOT NULL,
                gender VARCHAR(10) NULL,
                birth DATETIME NULL,
                address VARCHAR(100) NULL,
                email VARCHAR(30) NULL,
                created_at DATETIME NULL,
                updated_at DATETIME NULL,
                point INT NULL
            );
            
            CREATE TABLE mission (
                id BIGINT NOT NULL PRIMARY KEY,
                store_id BIGINT NOT NULL,
                name VARCHAR(30) NOT NULL,
                description VARCHAR(50) NULL
            );
            
            CREATE TABLE genre (
                id BIGINT NOT NULL PRIMARY KEY,
                name VARCHAR(36) NOT NULL
            );
            
            CREATE TABLE user_genre (
                user_id BIGINT NOT NULL,
                genre_id BIGINT NOT NULL,
                PRIMARY KEY (user_id, genre_id)
            );
            
            CREATE TABLE user_mission (
                user_id BIGINT NOT NULL,
                mission_id BIGINT NOT NULL,
                status VARCHAR(15) NOT NULL,
                created_at DATETIME NULL,
                updated_at DATETIME NULL,
                PRIMARY KEY (user_id, mission_id)
            );
            
            CREATE TABLE review (
                user_id BIGINT NOT NULL,
                store_id BIGINT NOT NULL,
                score VARCHAR(10) NULL,
                description VARCHAR(500) NULL,
                photo_url VARCHAR(255) NULL,
                PRIMARY KEY (user_id, store_id)
            );
            
            CREATE TABLE region (
                id BIGINT NOT NULL PRIMARY KEY,
                region_name VARCHAR(20) NOT NULL
            );
            
            CREATE TABLE store (
                id BIGINT NOT NULL PRIMARY KEY,
                region_id BIGINT NOT NULL,
                store_name VARCHAR(20) NOT NULL,
                store_address VARCHAR(100) NULL
            );
            
            ALTER TABLE mission
            ADD CONSTRAINT FK_store_TO_mission_1 FOREIGN KEY (store_id)
            REFERENCES store (id);
            
            ALTER TABLE user_genre
            ADD CONSTRAINT FK_user_TO_user_genre_1 FOREIGN KEY (user_id)
            REFERENCES user (id);
            
            ALTER TABLE user_genre
            ADD CONSTRAINT FK_genre_TO_user_genre_1 FOREIGN KEY (genre_id)
            REFERENCES genre (id);
            
            ALTER TABLE user_mission
            ADD CONSTRAINT FK_user_TO_user_mission_1 FOREIGN KEY (user_id)
            REFERENCES user (id);
            
            ALTER TABLE user_mission
            ADD CONSTRAINT FK_mission_TO_user_mission_1 FOREIGN KEY (mission_id)
            REFERENCES mission (id);
            
            ALTER TABLE review
            ADD CONSTRAINT FK_user_TO_review_1 FOREIGN KEY (user_id)
            REFERENCES user (id);
            
            ALTER TABLE review
            ADD CONSTRAINT FK_store_TO_review_1 FOREIGN KEY (store_id)
            REFERENCES store (id);
            
            ALTER TABLE store
            ADD CONSTRAINT FK_region_TO_store_1 FOREIGN KEY (region_id)
            REFERENCES region (id);
            
            ```