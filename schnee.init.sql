-- Create the database
CREATE DATABASE "Schnuppitool";

-- Connect to the database
\c "Schnuppitool"

-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS Schnuppi_Termin CASCADE;
DROP TABLE IF EXISTS Termin CASCADE;
DROP TABLE IF EXISTS Schnuppi CASCADE;
DROP TABLE IF EXISTS Admin CASCADE;
DROP TABLE IF EXISTS Status CASCADE;
DROP TABLE IF EXISTS Berufe CASCADE;

-- 1. Berufe Table
CREATE TABLE Berufe (
                        id_beruf SERIAL PRIMARY KEY,
                        name VARCHAR(100) NOT NULL
);

-- 2. Status Table
CREATE TABLE Status (
                        id_status SERIAL PRIMARY KEY,
                        status VARCHAR(50) NOT NULL
    -- Consider making status UNIQUE if status names are distinct
);

-- 3. Schnuppi Table
CREATE TABLE Schnuppi (
                          id_schnuppi SERIAL PRIMARY KEY,
                          firstname VARCHAR(20) NOT NULL,
                          lastname VARCHAR(20) NOT NULL,
                          email VARCHAR(40) NOT NULL UNIQUE,
                          tel_number INT,
                          street VARCHAR(20),
                          house_number INT,
                          city VARCHAR(20),
                          postalcode INT
);

-- 4. Admin Table
CREATE TABLE Admin (
                       id_admin SERIAL PRIMARY KEY,
                       nickname VARCHAR(30) NOT NULL UNIQUE,
                       password VARCHAR(100) NOT NULL
    -- Consider hashing/storing securely in app layer
);

-- 5. Termin Table
CREATE TABLE Termin (
                        id_termin SERIAL PRIMARY KEY,
                        start_time TIMESTAMP NOT NULL,
                        end_time TIMESTAMP NOT NULL,
                        street VARCHAR(20),
                        housenumber INT,
                        city VARCHAR(20),
                        postalcode INT,
                        max_schnuppis INT NOT NULL,
                        beruf_id INT REFERENCES Berufe(id_beruf) ON DELETE SET NULL
);

-- 6. Schnuppi_Termin Join Table
CREATE TABLE Schnuppi_Termin (
                                 schnuppi_id INT REFERENCES Schnuppi(id_schnuppi) ON DELETE CASCADE,
                                 termin_id INT REFERENCES Termin(id_termin) ON DELETE CASCADE,
                                 status_id INT REFERENCES Status(id_status) ON DELETE SET NULL,
                                 PRIMARY KEY (schnuppi_id, termin_id)
);
