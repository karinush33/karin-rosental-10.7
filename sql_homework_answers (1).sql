-- ✅ שאלה 1: יצירת טבלאות ללא איכלוס
CREATE TABLE IF NOT EXISTS taxis (
    id INTEGER PRIMARY KEY,
    driver_name TEXT NOT NULL,
    car_type TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS passengers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    destination TEXT,
    taxi_id INTEGER,
    FOREIGN KEY(taxi_id) REFERENCES taxis(id)
);

-- ✅ שאלה 2: הכנסת נתונים
INSERT INTO taxis(id, driver_name, car_type) VALUES
(1, 'Moshe Levi', 'Van'),
(2, 'Rina Cohen', 'Sedan'),
(3, 'David Azulay', 'Minibus'),
(4, 'Maya Bar', 'Electric'),
(5, 'Yossi Peretz', 'SUV');

INSERT INTO passengers(id, name, destination, taxi_id) VALUES
(1, 'Tamar', 'Jerusalem', 1),
(2, 'Eitan', 'Haifa', 2),
(3, 'Noa', 'Tel Aviv', NULL),
(4, 'Lior', 'Eilat', 1),
(5, 'Dana', 'Beer Sheva', NULL),
(6, 'Gil', 'Ashdod', 3),
(7, 'Moran', 'Netanya', NULL);

-- ✅ שאלה 3: שאילתות JOIN
-- 🔹 נוסעים עם מונית
SELECT p.name, t.driver_name, t.car_type 
FROM passengers p 
INNER JOIN taxis t ON p.taxi_id = t.id;

-- 🔹 כל הנוסעים כולל מי שאין לו מונית
SELECT p.name, p.destination, t.driver_name, t.car_type
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id;

-- 🔹 רק נוסעים שאין להם מונית
SELECT p.*
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id
WHERE t.id IS NULL;

-- 🔹 נוסעים עם מונית, בלי מונית, ומוניות בלי נוסעים
SELECT p.*, t.*
FROM passengers p
FULL JOIN taxis t ON p.taxi_id = t.id;

-- 🔹 כל הצירופים האפשריים בין נוסעים למוניות
SELECT p.name AS passenger_name, t.id AS taxi_id, t.car_type AS taxi
FROM passengers p
CROSS JOIN taxis t;

-- ✅ שאלה 4: פייתון להרצת כל השלבים
-- (מוגש בקובץ נפרד עם כל קוד ה-Python כולל יצירת DB, הכנסת נתונים והרצת כל השאילתות למעלה)
