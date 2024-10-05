CREATE TABLE taluka(
    id SERIAL PRIMARY KEY,
    taluka TEXT
);

CREATE TABLE employees(
    id SERIAL PRIMARY KEY,
    full_name TEXT,
    hashed_password TEXT,
    is_admin INTEGER,
    phone_number TEXT
);

CREATE TABLE polling_stations(
    id SERIAL PRIMARY KEY,
    polling_station TEXT,
    polling_address TEXT,
    taluka INTEGER,
    FOREIGN KEY(taluka) REFERENCES taluka(id)
);

CREATE TABLE cameras (
    id SERIAL PRIMARY KEY,
    PS INTEGER,
    FOREIGN KEY (PS) REFERENCES polling_stations(id),
    serial_number TEXT,
    sent_at TEXT,
    removed_at TEXT,
    is_active BOOLEAN,
    supervisor INTEGER,
    FOREIGN KEY (supervisor) REFERENCES employees(id)
);

CREATE TABLE streams(
    id SERIAL PRIMARY KEY,
    camera INTEGER,
    FOREIGN KEY(camera) REFERENCES cameras(id),
    start_time TEXT,
    end_time TEXT
);