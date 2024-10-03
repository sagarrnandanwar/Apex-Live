CREATE TABLE locations(
    id SERIAL PRIMARY KEY,
    loc_name TEXT,    
);

CREATE TABLE employees(
    id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    phone_number TEXT,
    phone_number2 TEXT
);

CREATE TABLE camera (
    id SERIAL PRIMARY KEY,
    loc_name INTEGER,
    FOREIGN KEY (loc_name) REFERENCES locations(id)
    serial_number TEXT,
    sent_at TEXT,
    installed_at TEXT,
    removed_at TEXT,
    responsible_id INTEGER
    FOREIGN KEY (responsible_id) REFERENCES employees(id)
    is_active BOOLEAN
);