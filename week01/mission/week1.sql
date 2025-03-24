--유저 테이블
CREATE TABLE User (
                      user_id INT AUTO_INCREMENT PRIMARY KEY,
                      username VARCHAR(50) NOT NULL,
                      password VARCHAR(255) NOT NULL,
                      email VARCHAR(100) NOT NULL UNIQUE,
                      created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE User_Points (
                             user_id INT PRIMARY KEY,
                             points INT DEFAULT 0,
                             FOREIGN KEY (user_id) REFERENCES User(user_id)
);

--지역 테이블
CREATE TABLE Region (
                        region_id INT AUTO_INCREMENT PRIMARY KEY,
                        region_name VARCHAR(100) NOT NULL UNIQUE
);

--가게 테이블
CREATE TABLE Store (
                       store_id INT AUTO_INCREMENT PRIMARY KEY,
                       name VARCHAR(100) NOT NULL,
                       address TEXT NOT NULL,
                       phone_number VARCHAR(20),
                       region_id INT NOT NULL,
                       FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

--미션 테이블
CREATE TABLE Mission (
                         mission_id INT AUTO_INCREMENT PRIMARY KEY,
                         title VARCHAR(100) NOT NULL,
                         description TEXT,
                         points_reward INT DEFAULT 100,
                         region_id INT NOT NULL,
                         FOREIGN KEY (region_id) REFERENCES Region(region_id)
);

--유저 미션 테이블
CREATE TABLE User_Mission (
                              user_mission_id INT AUTO_INCREMENT PRIMARY KEY,
                              user_id INT NOT NULL,
                              mission_id INT NOT NULL,
                              status ENUM('진행중', '완료') DEFAULT '진행중',
                              completed_at TIMESTAMP NULL,
                              FOREIGN KEY (user_id) REFERENCES User(user_id),
                              FOREIGN KEY (mission_id) REFERENCES Mission(mission_id)
);

--리뷰 테이블
CREATE TABLE Review (
                        review_id INT AUTO_INCREMENT PRIMARY KEY,
                        user_mission_id INT NOT NULL,
                        content TEXT NOT NULL,
                        rating INT CHECK(rating BETWEEN 1 AND 5),
                        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        FOREIGN KEY (user_mission_id) REFERENCES User_Mission(user_mission_id)
);

--알림 테이블
CREATE TABLE Notification (
                              notification_id INT AUTO_INCREMENT PRIMARY KEY,
                              user_id INT NOT NULL,
                              type ENUM('새로운 미션', '리뷰 요청') NOT NULL,
                              message TEXT NOT NULL,
                              created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (user_id) REFERENCES User(user_id)
);