CREATE TABLE mentors (
  name      VARCHAR(30) NOT NULL,
  years  INT NOT NULL,
  address   VARCHAR(120),
  lenguage     VARCHAR(120) NOT NULL
);

CREATE TABLE students (
  name      VARCHAR(30) NOT NULL,
  address   VARCHAR(120),
  graduated  BOOLEAN
);

CREATE TABLE classes (
  id            SERIAL PRIMARY KEY,
  mentor        VARCHAR(30) NOT NULL,
  topic         VARCHAR(120),
  date          TIMESTAMP,
  location      VARCHAR(120)
);

INSERT INTO mentors (name, years, address, lenguage) VALUES ('LAEKEN', 3 ,'carretera 5', 'REACT');
INSERT INTO mentors (name, years, address, lenguage) VALUES ('VALERIA', 20 ,'carretera 10', 'JAVASCRIPT');
INSERT INTO mentors (name, years, address, lenguage) VALUES ('VANESSA', 1 ,'carretera 234', 'HTML');
INSERT INTO mentors (name, years, address, lenguage) VALUES ('YHENIFER', 5 ,'carretera 59', 'CSS');
INSERT INTO mentors (name, years, address, lenguage) VALUES ('DIEGO', 3 ,'carretera 115', 'SQL');

SELECT * FROM mentors;

INSERT INTO students (name,address,graduated) VALUES('LINDA', 'CARRETERA DE VIC,', FALSE );
INSERT INTO students (name,address,graduated) VALUES('JORGELINA', 'SANTPEDOR', FALSE );
INSERT INTO students (name,address,graduated) VALUES('VANESSA', 'MANRESA', TRUE );
INSERT INTO students (name,address,graduated) VALUES('MATHEW', 'CONVENTO', TRUE );
INSERT INTO students (name,address,graduated) VALUES('GLORIA', 'CONVENTO', TRUE );
INSERT INTO students (name,address,graduated) VALUES('YHENIFER', 'SANT BOI', FALSE );
INSERT INTO students (name,address,graduated) VALUES('DEIGO', 'CASTELFER', TRUE );
INSERT INTO students (name,address,graduated) VALUES('XAVIER', 'OLLER DE MAR', FALSE );
INSERT INTO students (name,address,graduated) VALUES('LAEKEN', 'LHOSPITALE', TRUE );
INSERT INTO students (name,address,graduated) VALUES('VALERIA', 'SANT VICENT', FALSE );

SELECT * FROM students;

INSERT INTO classes (mentor, topic, date, location) VALUES ('ALEJANDRO', 'JAVASCRIPT','2022-01-01 13:00:00','CAIXA FORUMS, BARCELONA');
INSERT INTO classes (mentor, topic, date, location) VALUES ('RICARD', 'CSS','2022-07-10 16:00:00','CAIXA FORUMS, BARCELONA');
INSERT INTO classes (mentor, topic, date, location) VALUES ('RICARDO', 'HTML','2022-08-23 18:45:00','CAIXA FORUMS, BARCELONA');
INSERT INTO classes (mentor, topic, date, location) VALUES ('SANTI', 'REACT','2022-10-06 21:30:00','CAIXA FORUMS, BARCELONA');

SELECT * FROM classes


SELECT name,years FROM mentors WHERE years > 5;
SELECT name,LENGUAGE FROM mentors WHERE lenguage = 'JAVASCRIPT';
SELECT name FROM students WHERE graduated = true;
SELECT * FROM classes WHERE date < '2022-06-01';