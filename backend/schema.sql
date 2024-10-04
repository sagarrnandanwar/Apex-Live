CREATE TABLE locations(
    id SERIAL PRIMARY KEY,
    loc_name TEXT
);

CREATE TABLE employees(
    id SERIAL PRIMARY KEY,
    full_name TEXT,
    hashed_password TEXT,
    is_admin INTEGER,
    phone_number TEXT
);

CREATE TABLE camera (
    id SERIAL PRIMARY KEY,
    loc_name INTEGER,
    FOREIGN KEY (loc_name) REFERENCES locations(id)
    serial_number TEXT,
    sent_at TEXT,
    removed_at TEXT,
    is_active BOOLEAN
);
