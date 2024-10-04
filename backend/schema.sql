CREATE TABLE locations(
    id SERIAL PRIMARY KEY,
    loc_name TEXT
);

CREATE TABLE taluka(
    id SERIAL PRIMARY KEY,
    taluka TEXT
)

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
    polling_profile TEXT,
    taluka INTEGER,
    FOREIGN KEY(taluka) REFERENCES taluka(id)
);

CREATE TABLE camera (
    id SERIAL PRIMARY KEY,
    loc_name INTEGER,
    FOREIGN KEY (loc_name) REFERENCES locations(id),
    PS INTEGER,
    FOREIGN KEY (PS) REFERENCES polling_stations(id),
    serial_number TEXT,
    sent_at TEXT,
    removed_at TEXT,
    is_active BOOLEAN
);
