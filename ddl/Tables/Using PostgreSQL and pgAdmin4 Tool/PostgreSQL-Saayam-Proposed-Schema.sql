-- PostgreSQL Script generated by conversion from MySQL

-- Drop schema if it exists
DROP SCHEMA IF EXISTS proposed_saayam CASCADE;

-- Create schema
CREATE SCHEMA IF NOT EXISTS proposed_saayam;

-- Set schema for following operations
SET search_path TO proposed_saayam;

-- Table: action
CREATE TABLE IF NOT EXISTS action (
    action_id SERIAL PRIMARY KEY,
    action_desc VARCHAR(30) NOT NULL,
    created_dt DATE,
    created_by VARCHAR(30),
    last_upd_by VARCHAR(30),
    last_upd_dt DATE,
    UNIQUE (action_id)
);

-- Table: country
CREATE TABLE IF NOT EXISTS country (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL,
    phone_country_code INT NOT NULL,
    last_update_date TIMESTAMP,
    UNIQUE (country_id)
);

-- Table: identity_type
CREATE TABLE IF NOT EXISTS identity_type (
    identity_type_id SERIAL PRIMARY KEY,
    identity_value VARCHAR(255) NOT NULL,
    identity_type_dsc VARCHAR(255),
    last_updated_date TIMESTAMP,
    UNIQUE (identity_type_id)
);

-- Table: request_priority
CREATE TABLE IF NOT EXISTS request_priority (
    priority_id SERIAL PRIMARY KEY,
    priority_value VARCHAR(255) NOT NULL,
    priority_description VARCHAR(255),
    last_updated_date TIMESTAMP,
    UNIQUE (priority_id)
);

-- Table: state
CREATE TABLE IF NOT EXISTS state (
    state_id SERIAL PRIMARY KEY,
    country_id INT NOT NULL,
    state_name VARCHAR(255) NOT NULL,
    last_update_date TIMESTAMP,
    UNIQUE (country_id, state_id),
    FOREIGN KEY (country_id) REFERENCES country (country_id)
);

-- Table: city
CREATE TABLE IF NOT EXISTS city (
    city_id SERIAL PRIMARY KEY,
    state_id INT NOT NULL,
    city_name VARCHAR(30) NOT NULL,
    lattitude DECIMAL(9, 6),
    longitude DECIMAL(9, 6),
    last_update_date TIMESTAMP,
    UNIQUE (city_id),
    FOREIGN KEY (state_id) REFERENCES state (state_id)
);

-- Table: user_status
CREATE TABLE IF NOT EXISTS user_status (
    user_status_id SERIAL PRIMARY KEY,
    user_status VARCHAR(255) NOT NULL,
    user_status_desc VARCHAR(255),
    last_update DATE,
    UNIQUE (user_status_id)
);

-- Table: user_category
CREATE TABLE IF NOT EXISTS user_category (
    user_category_id SERIAL PRIMARY KEY,
    user_category VARCHAR(255) NOT NULL,
    user_category_desc VARCHAR(255),
    last_update_date TIMESTAMP,
    UNIQUE (user_category_id)
);

-- Table: users
CREATE TABLE IF NOT EXISTS users (
    user_id VARCHAR(255) PRIMARY KEY,
    state_id INT NOT NULL,
    country_id INT NOT NULL,
    user_status_id INT NOT NULL,
    user_category_id INT NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    last_name VARCHAR(255),
    email_address VARCHAR(255),
    phone_number VARCHAR(255),
    addr_ln1 VARCHAR(255),
    addr_ln2 VARCHAR(255),
    addr_ln3 VARCHAR(255),
	city_name VARCHAR(255) NOT NULL,
    zip_code VARCHAR(255) NOT NULL,
    last_update_date TIMESTAMP,
    time_zone VARCHAR(255) NOT NULL,
    profile_picture_path VARCHAR(255) NULL,
	passport_doc VARCHAR(255) NULL,  
    drivers_license VARCHAR(255) NULL,  
    UNIQUE (user_id),
    FOREIGN KEY (country_id) REFERENCES country (country_id),
    FOREIGN KEY (state_id) REFERENCES state (state_id),
    FOREIGN KEY (user_status_id) REFERENCES user_status (user_status_id),
    FOREIGN KEY (user_category_id) REFERENCES user_category (user_category_id)
);

-- Table: request_status
CREATE TABLE IF NOT EXISTS request_status (
    request_status_id SERIAL PRIMARY KEY,
    request_status VARCHAR(255) NOT NULL,
    request_status_desc VARCHAR(255),
    last_updated_date TIMESTAMP
);

-- Table: request_type
CREATE TABLE IF NOT EXISTS request_type (
    request_type_id SERIAL PRIMARY KEY,
    request_type VARCHAR(255),
    request_type_desc VARCHAR(255),
    last_updated_date TIMESTAMP
);

-- Table: request_category
CREATE TABLE IF NOT EXISTS request_category (
    request_category_id SERIAL PRIMARY KEY,
    request_category VARCHAR(255) NOT NULL,
    request_category_desc VARCHAR(255),
    last_updated_date TIMESTAMP
);

-- Table: request
CREATE TABLE IF NOT EXISTS request (
    request_id VARCHAR(255) PRIMARY KEY,
    request_user_id VARCHAR(255) NOT NULL,
    request_status_id INT NOT NULL,
    request_priority_id INT NOT NULL,
    request_type_id INT NOT NULL,
    request_category_id INT NOT NULL,
	city_name VARCHAR(255) NOT NULL,
    zip_code VARCHAR(255) NOT NULL,
    request_desc VARCHAR(255) NOT NULL,
    request_for VARCHAR(255) NOT NULL,
    submission_date TIMESTAMP,
    lead_volunteer_user_id INT,
    serviced_date TIMESTAMP,
    last_update_date TIMESTAMP,
    UNIQUE (request_id),
    FOREIGN KEY (request_user_id) REFERENCES users (user_id),
    FOREIGN KEY (request_status_id) REFERENCES request_status (request_status_id),
    FOREIGN KEY (request_priority_id) REFERENCES request_priority (priority_id),
    FOREIGN KEY (request_type_id) REFERENCES request_type (request_type_id),
    FOREIGN KEY (request_category_id) REFERENCES request_category (request_category_id)
);

-- Table: skill_lst
CREATE TABLE IF NOT EXISTS skill_lst (
    skill_lst_id SERIAL PRIMARY KEY,
    skill_level INT NOT NULL,
    level_desc VARCHAR(100) NOT NULL,
    skill_last_used DATE,
    is_actv VARCHAR(1),
    created_by VARCHAR(30),
    created_dt DATE,
    last_update_by VARCHAR(30),
    last_update DATE,
    UNIQUE (skill_lst_id)
);

-- Table: sla
CREATE TABLE IF NOT EXISTS sla (
    sla_id SERIAL PRIMARY KEY,
    sla_hours INT NOT NULL,
    sla_description VARCHAR(255) NOT NULL,
    no_of_cust_impct INT,
    last_updated_date TIMESTAMP,
    UNIQUE (sla_id)
);

-- Table: user_skills
CREATE TABLE IF NOT EXISTS user_skills (
    user_id VARCHAR(255),
    skill_id INT,
    created_by VARCHAR(30),
    created_dt DATE,
    last_update_by VARCHAR(30),
    last_update DATE,
    FOREIGN KEY (skill_id) REFERENCES skill_lst (skill_lst_id),
    FOREIGN KEY (user_id) REFERENCES users (user_id)
);

CREATE SEQUENCE user_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

CREATE FUNCTION generate_sid()
RETURNS TRIGGER AS $$
DECLARE
    seq_id INT;
    new_id VARCHAR(20);
BEGIN
    seq_id := nextval('user_id_seq');
    new_id := 'SID-00-' || LPAD(FLOOR(seq_id / 1000000)::TEXT, 3, '0') || '-' || 
              LPAD(FLOOR((seq_id % 1000000) / 1000)::TEXT, 3, '0') || '-' || 
              LPAD((seq_id % 1000)::TEXT, 3, '0');
    NEW.user_id := new_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_users
BEFORE INSERT ON users
FOR EACH ROW
EXECUTE FUNCTION generate_sid();


-- Create the sequence for request IDs
CREATE SEQUENCE request_id_seq
START WITH 1
INCREMENT BY 1
NO MINVALUE
NO MAXVALUE
CACHE 1;

-- Create the function to generate the formatted request ID
CREATE FUNCTION generate_request_id()
RETURNS TRIGGER AS $$
DECLARE
    seq_id INT;
    new_id VARCHAR(30);
BEGIN
    seq_id := nextval('request_id_seq');
    new_id := 'REQ-' || LPAD(FLOOR(seq_id / 100000000)::TEXT, 2, '0') || '-' || 
              LPAD(FLOOR((seq_id % 100000000) / 100000)::TEXT, 3, '0') || '-' || 
              LPAD(FLOOR((seq_id % 100000) / 1000)::TEXT, 3, '0') || '-' || 
              LPAD((seq_id % 1000)::TEXT, 4, '0');
    NEW.request_id := new_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_insert_requests
BEFORE INSERT ON request
FOR EACH ROW
EXECUTE FUNCTION generate_request_id();
