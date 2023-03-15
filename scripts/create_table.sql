CREATE TABLE gym_members (
  id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(255),
  last_name VARCHAR(255),
  email VARCHAR(255),
  start_date DATE,
  duration INT,
  payment_type VARCHAR(255),
  medical_notes TEXT,
  PRIMARY KEY (id)
);





