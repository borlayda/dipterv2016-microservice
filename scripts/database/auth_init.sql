# Add permission to databases
GRANT ALL PRIVILEGES ON authenticate.* TO 'store'@'%';
GRANT ALL PRIVILEGES ON authenticate.* TO 'store'@'localhost';
# Create Tables
CREATE TABLE user_auth
(
	user_id int NOT NULL AUTO_INCREMENT, 
	username varchar(255) NOT NULL,
	password varchar(255) NOT NULL,
	credential varchar(255),
	PRIMARY KEY (user_id)
);
# Fill Tables
INSERT INTO user_auth (username, password) VALUES ("test", "testpassword");
