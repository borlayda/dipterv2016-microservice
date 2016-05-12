# Add permission to databases
GRANT ALL PRIVILEGES ON bookstore.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON bookstore.* TO 'root'@'localhost';
# Create Tables
CREATE TABLE store
(
	store_id int NOT NULL AUTO_INCREMENT,
	book_name varchar(255) NOT NULL,
	count int NOT NULL,
	PRIMARY KEY (store_id)
);
CREATE TABLE reservation
(
	reservation_id int NOT NULL AUTO_INCREMENT,
	username varchar(255) NOT NULL,
	book_name varchar(255) NOT NULL,
	count int NOT NULL,
	res_date varchar(255),
	PRIMARY KEY (reservation_id)
);
# Fill Tables
INSERT INTO store (book_name, count) VALUES ("Harry Potter and the Goblet of fire", 10);
INSERT INTO store (book_name, count) VALUES ("Harry Potter and the Philosopher's Stone", 10);
INSERT INTO store (book_name, count) VALUES ("Harry Potter and the Chamber of Secret", 10);
INSERT INTO store (book_name, count) VALUES ("Lord of the Rings: Fellowship of the ring", 3);
INSERT INTO store (book_name, count) VALUES ("Lord of the Rings: The Two Towers", 3);
INSERT INTO store (book_name, count) VALUES ("Lord of the Rings: The Return of the King", 0);
