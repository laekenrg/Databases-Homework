-- 1)Create a new table mentors, for each mentor we want to save their name, how many years they lived in Glasgow, their address and their favourite programming language.
CREATE TABLE mentors (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(30) NOT NULL,
  yearsInGW   INT,
  address      VARCHAR(120),
  proLang      VARCHAR(120)
);


-- 2)Insert 5 mentors in the mentors table (you can make up the data, it doesn't need to be accurate
INSERT INTO mentors (name, yearsInGW, address, proLang)
             VALUES ('Rocio Afonso',1,'Carretera de Vic 181, Manresa','HTML'),
                    ('Piedad Jaen',4,'Alfafar 45, Valencia', 'CSS'),
                    ('Jose Jesus Maya',19,'Aravaca 85, Madrid','React'),
                    ('Juan Jose Alarcon',8,'Carrer Pau Casals 47, Girona','JavaScript'),
                    ('Antonio Jesus Díaz', 3,'C.Torcuato 33, Sevilla','Node JS'  );

SELECT * FROM mentors;

-- 3)Create a new table students, for each student we want to save their name, address and if they have graduated from Code Your Future.
CREATE TABLE students (
  id           SERIAL PRIMARY KEY,
  name         VARCHAR(30) NOT NULL,
  address      VARCHAR(120),
  graduated    BOOLEAN
);

-- 4)Insert 10 students in the students table.
INSERT INTO students (name, address, graduated)
              VALUES ('Judas Carvajal Pena','Plaza Colón, Viguera','TRUE'),
                     ('Eneas Sotelo Batista','C/ Señores Curas, Benasal','FALSE'),
                     ('Crisol Gracia Reyes','Paseo Junquera, San Rafael del Río','TRUE'),
                     ('Calfucir Cotto Valencia','La Fontanilla, El Guijo','TRUE'),
                     ('Boris Jaimes Tapia','Avda. Generalísimo, Vilamarín','FALSE'),
                     ('Cadmo Romero Juárez','C/ Libertad, Piedrahíta','FALSE'),
                     ('Rudy Carrasco Contreras','Escuadro, l Olleria','FALSE'),
                     ('Cesario Sauceda Molina','Camiño Real, Muxika','TRUE'),
                     ('Osmán Serrano Posada', 'Ctra. de Siles, Begonte','FALSE'),
                     ('Osmar Corral Galindo','Zumalakarregi etorbidea, Santa Eugènia','TRUE');



-- 5)Verify that the data you created for mentors and students are correctly stored in their respective tables (hint: use a select SQL statement).

SELECT * FROM mentors;

SELECT * FROM students;

SELECT * FROM classes;

SELECT * FROM studentsClass;

-- 6)Create a new classes table to record the following information:
--A class has a leading mentor
--A class has a topic (such as Javascript, NodeJS)
--A class is taught at a specific date and at a specific location
CREATE TABLE classes (
  id            SERIAL PRIMARY KEY,
  mentor_id        INT NOT NULL,
  topic_id         INT NOT NULL,
  date          TIMESTAMP,
  location      VARCHAR(120),
    CONSTRAINT fk_mentor FOREIGN KEY (mentor_id) REFERENCES mentors (id),
    CONSTRAINT fk_topic FOREIGN KEY (topic_id) REFERENCES mentors(id)
);

-- 7)Insert a few classes in the classes table.
INSERT INTO classes (mentor_id, topic_id, date, location)
             VALUES (1, 1,'2022-01-01 13:00:00', 'Caixa Forum, Barcelona'),
                    (2, 2,'2022-01-03 13:10:00', 'InfJobs 32, Barcelona'),
                    (3, 3,'2022-01-04 13:20:00', 'Rambla 23, Barcelona'),
                    (4, 4,'2022-01-05 13:30:00', 'Sagrada Familia, Barcelona'),
                    (5, 5,'2022-01-06 13:40:00', 'La Barceloneta, Barcelona');
-- 8)We now want to store who among the students attends a specific class. How would you store that? Come up with a solution and insert some data if you model this as a new table.
CREATE TABLE studentsClass (
    id          SERIAL PRIMARY KEY,
    student_id     INT NOT NULL ,
    class_id       INT NOT NULL,
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES students (id),
    CONSTRAINT fk_class FOREIGN KEY (class_id) REFERENCES classes(id)
)

INSERT INTO studentsClass (student_id,class_id)
                VALUES (1, 1),
                       (2, 2),
                       (3, 3),
                       (4, 4),
                       (5, 5),
                       (6, 5),
                       (7, 4),
                       (8, 3),
                       (9, 2),
                       (10,1);
-- 9)Answer the following questions using a select SQL statement:
-- 9.1)Retrieve all the mentors who lived more than 5 years in Glasgow
SELECT * FROM mentors WHERE yearsInGW > 5;
-- 9.2)Retrieve all the mentors whose favourite language is Javascript
SELECT * FROM mentors WHERE proLang = 'JavaScript';
-- 9.3)Retrieve all the students who are CYF graduates
SELECT * FROM students WHERE graduated = 'TRUE';
-- 9.4)Retrieve all the classes taught before June this year
SELECT * FROM classes WHERE date < '2022-06-01';
-- 9.5)Retrieve all the students (retrieving student ids only is fine) who attended the Javascript class (or any other class that you have in the classes table).
SELECT name,topic FROM studentsClass INNER JOIN students ON students.id = studentesClass.student_id 