# 📄 JOIN Queries & Python Script

## 🔹 3. שאילתות JOIN

### 1. נוסעים שהשיגו מונית יחד עם פרטי המונית (INNER JOIN):
```sql
SELECT p.name, t.driver_name, t.car_type 
FROM passengers p 
INNER JOIN taxis t ON p.taxi_id = t.id;
```

### 2. כל הנוסעים כולל כאלה שמצאו מונית וכאלה שלא (LEFT JOIN):
```sql
SELECT p.name, p.destination, t.driver_name, t.car_type
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id;
```

### 3. רק הנוסעים שלא מצאו מונית (LEFT JOIN + WHERE t.id IS NULL):
```sql
SELECT p.*
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id
WHERE t.id IS NULL;
```

### 4. כל הנוסעים וכל המוניות — גם אם אין התאמה ביניהם (FULL JOIN):
```sql
SELECT p.*, t.* 
FROM passengers p
FULL JOIN taxis t ON p.taxi_id = t.id;
```

> אם SQLite לא תומך ב-FULL JOIN:
```sql
SELECT p.name, p.destination, t.driver_name, t.car_type
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id

UNION

SELECT p.name, p.destination, t.driver_name, t.car_type
FROM passengers p
RIGHT JOIN taxis t ON p.taxi_id = t.id;
```

### 5. כל הצירופים האפשריים בין נוסעים למוניות (CROSS JOIN):
```sql
SELECT p.name AS passenger_name, t.id AS taxi_id, t.car_type AS taxi
FROM passengers p
CROSS JOIN taxis t;
```

---

## 🔹 4. סקריפט Python להרצת השאילתות והצגת תוצאות:
```python
import sqlite3
import os

if os.path.exists("10.7.25copy.db"):
    os.remove("10.7.25copy.db")

conn = sqlite3.connect('10.7.25copy.db')
conn.row_factory = sqlite3.Row
cursor = conn.cursor()

# יצירת טבלאות
cursor.execute('''
CREATE TABLE IF NOT EXISTS taxis (
    id INTEGER PRIMARY KEY,
    driver_name TEXT NOT NULL,
    car_type TEXT NOT NULL
);
''')

cursor.execute('''
CREATE TABLE IF NOT EXISTS passengers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    destination TEXT,
    taxi_id INTEGER,
    FOREIGN KEY(taxi_id) REFERENCES taxis(id)
);
''')

# הכנסת נתונים
cursor.executemany('''
INSERT INTO taxis(id, driver_name, car_type)
VALUES (?, ?, ?);
''', [
    (1, 'Moshe Levi', 'Van'),
    (2, 'Rina Cohen', 'Sedan'),
    (3, 'David Azulay', 'Minibus'),
    (4, 'Maya Bar', 'Electric'),
    (5, 'Yossi Peretz', 'SUV')
])

cursor.executemany('''
INSERT INTO passengers(id, name, destination, taxi_id)
VALUES (?, ?, ?, ?);
''', [
    (1, 'Tamar', 'Jerusalem', 1),
    (2, 'Eitan', 'Haifa', 2),
    (3, 'Noa', 'Tel Aviv', None),
    (4, 'Lior', 'Eilat', 1),
    (5, 'Dana', 'Beer Sheva', None),
    (6, 'Gil', 'Ashdod', 3),
    (7, 'Moran', 'Netanya', None)
])

# הרצת שאילתות והצגת תוצאות

def run_query(title, query):
    print("\n" + title)
    cursor.execute(query)
    for row in cursor.fetchall():
        print(dict(row))

run_query("INNER JOIN: נוסעים שהשיגו מונית", """
SELECT p.name, t.driver_name, t.car_type 
FROM passengers p 
INNER JOIN taxis t ON p.taxi_id = t.id;
""")

run_query("LEFT JOIN: כל הנוסעים כולל כאלה שמצאו מונית וכאלה שלא", """
SELECT p.name, p.destination, t.driver_name, t.car_type
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id;
""")

run_query("LEFT JOIN עם סינון: רק נוסעים שלא מצאו מונית", """
SELECT p.*
FROM passengers p
LEFT JOIN taxis t ON p.taxi_id = t.id
WHERE t.id IS NULL;
""")

run_query("CROSS JOIN: כל הצירופים האפשריים בין נוסעים למוניות", """
SELECT p.name AS passenger_name, t.id AS taxi_id, t.car_type AS taxi
FROM passengers p
CROSS JOIN taxis t;
""")

conn.commit()
conn.close()
