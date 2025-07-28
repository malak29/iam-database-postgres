-- Enable UUID generation
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Reference tables first

CREATE TABLE authtype (
    authtypeid SERIAL PRIMARY KEY,
    authtypename VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    isactive BOOLEAN DEFAULT TRUE,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE userstatus (
    userstatusid SERIAL PRIMARY KEY,
    userstatusname VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    isactive BOOLEAN DEFAULT TRUE,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE usertype (
    usertypeid SERIAL PRIMARY KEY,
    usertypename VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    permissionlevel INTEGER DEFAULT 1,
    isactive BOOLEAN DEFAULT TRUE,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE department (
    departmentid SERIAL PRIMARY KEY,
    departmentname VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    isactive BOOLEAN DEFAULT TRUE,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Main tables

CREATE TABLE organization (
    orgid SERIAL PRIMARY KEY,
    orgname VARCHAR(255) NOT NULL,
    description VARCHAR(500),
    isactive BOOLEAN DEFAULT TRUE,
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE "users" (
    userid UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(255) NOT NULL,
    hashedpassword VARCHAR(255),
    orgid INTEGER NOT NULL REFERENCES organization(orgid),
    departmentid INTEGER NOT NULL REFERENCES department(departmentid),
    usertypeid INTEGER NOT NULL REFERENCES usertype(usertypeid),
    authtypeid INTEGER NOT NULL REFERENCES authtype(authtypeid),
    userstatusid INTEGER NOT NULL REFERENCES userstatus(userstatusid),
    createdat TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updatedat TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
