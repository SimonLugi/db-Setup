-- Drop tables if they already exist (for dev/testing)
DROP TABLE IF EXISTS building CASCADE;
DROP TABLE IF EXISTS admin CASCADE;
DROP TABLE IF EXISTS appointment CASCADE;
DROP TABLE IF EXISTS registration CASCADE;

-- Building Table
CREATE TABLE building (
                          id_building SERIAL PRIMARY KEY,
                          name VARCHAR(20),
                          street VARCHAR(20),
                          house_number VARCHAR(7),  -- Changed to VARCHAR to handle alphanumeric house numbers
                          city VARCHAR(20),
                          postcode INT
);

-- Admin Table
CREATE TABLE admin (
                       id_admin SERIAL PRIMARY KEY,
                       username VARCHAR(50),
                       password VARCHAR(100),
                       building_id INT REFERENCES building(id_building)
);

-- Appointment Table
CREATE TABLE appointment (
                             id_appointment SERIAL PRIMARY KEY,
                             start_time TIMESTAMP NOT NULL,
                             end_time TIMESTAMP NOT NULL,
                             max_prospective_apprentice INT,
                             profession VARCHAR(20),  -- Using ENUM for profession
                             building_id INT REFERENCES building(id_building)
);

-- Registration Table
CREATE TABLE registration (
                              id_registration SERIAL PRIMARY KEY,
                              firstname VARCHAR(20),
                              lastname VARCHAR(20),
                              email VARCHAR(40),
                              tel_number VARCHAR(25),
                              street VARCHAR(20),
                              house_number VARCHAR(7),  -- Changed to VARCHAR to handle alphanumeric house numbers
                              city VARCHAR(20),
                              postcode INT,
                              status VARCHAR(20),  -- Using ENUM for status
                              appointment_id INT REFERENCES appointment(id_appointment)
);