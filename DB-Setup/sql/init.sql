-- Enum-Typen zuerst definieren
CREATE TYPE profession_enum AS ENUM ('Informatiker EFZ', 'Mediamatiker EFZ', 'Interactive Media Designer EFZ');
CREATE TYPE status_enum AS ENUM ('offen', 'bestätigt', 'abgelehnt', 'besucht', 'abgemeldet', 'nicht besucht');

-- Admin-Tabelle
CREATE TABLE admin (
    id_admin SERIAL PRIMARY KEY,
    nickname VARCHAR(50),
    password VARCHAR(100)
);

CREATE TABLE building (
    id_building SERIAL PRIMARY KEY,
    name VARCHAR(20),
    street varchar(20),
    house_number int,
    city varchar(20),
    postcode int
);

-- Termin-Tabelle
CREATE TABLE appointment (
    id_appointment SERIAL PRIMARY KEY,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    max_prospective_apprentice INT,
    profession profession_enum,
    building_id INT REFERENCES building(id_building)
);

-- Anmeldung-Tabelle
CREATE TABLE registration  (
    id_registration SERIAL PRIMARY KEY,
    firstname VARCHAR(20),
    lastname VARCHAR(20),
    email VARCHAR(40),
    tel_number INT,
    street VARCHAR(20),
    house_number INT,
    city VARCHAR(20),
    postcode INT,
    status status_enum,
    appointment_id INT REFERENCES appointment(id_appointment)
);


