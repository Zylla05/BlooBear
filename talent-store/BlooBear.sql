DROP DATABASE IF EXISTS BlooBear;
CREATE DATABASE BlooBear;

USE BlooBear;

CREATE TABLE Cat_User_Status(
    id_user_status INTEGER NOT NULL UNIQUE PRIMARY KEY,
    user_status NVARCHAR(512) NOT NULL UNIQUE
);

CREATE TABLE Clients(
    id_client INTEGER NOT NULL UNIQUE PRIMARY KEY,
    name_client NVARCHAR(512) NOT NULL,
    mail_client NVARCHAR(512) NOT NULL UNIQUE,
    wallet NVARCHAR(512) NOT NULL UNIQUE,
    id_user_status INTEGER NOT NULL,
    CONSTRAINT fk_client_id_user_status
    FOREIGN KEY (id_user_status)
    REFERENCES Cat_User_Status(id_user_status)
);

CREATE TABLE Super_Users(
    id_admin INTEGER NOT NULL UNIQUE PRIMARY KEY,
    name_admin NVARCHAR(512) NOT NULL,
    mail_admin NVARCHAR(512) NOT NULL UNIQUE,
    pass NVARCHAR(512) NOT NULL,
    id_user_status INTEGER NOT NULL,
    CONSTRAINT fk_admin_id_user_status
    FOREIGN KEY (id_user_status)
    REFERENCES Cat_User_Status(id_user_status)
);

CREATE TABLE Cat_Car_Types(
    id_car_type INTEGER NOT NULL UNIQUE PRIMARY KEY,
    car_type NVARCHAR(512) NOT NULL UNIQUE
);

CREATE TABLE Cat_Car_Status(
    id_car_status INTEGER NOT NULL UNIQUE PRIMARY KEY,
    car_status NVARCHAR(512) NOT NULL UNIQUE
);

CREATE TABLE Cat_Ticket_Status(
    id_ticket_status INTEGER NOT NULL UNIQUE PRIMARY KEY,
    ticket_status NVARCHAR(512) NOT NULL UNIQUE
);

CREATE TABLE Cars(
    id_car INTEGER NOT NULL UNIQUE PRIMARY KEY,
    model NVARCHAR(512) NOT NULL,
    brand NVARCHAR(512) NOT NULL,
    plate NVARCHAR(512) NOT NULL UNIQUE,
    motor NVARCHAR(512) NOT NULL UNIQUE,
    NIV NVARCHAR(512) NOT NULL UNIQUE,
    TC NVARCHAR(512) NOT NULL UNIQUE,
    id_car_type INTEGER NOT NULL,
    id_car_status INTEGER NOT NULL,
    CONSTRAINT fk_id_car_type
    FOREIGN KEY (id_car_type)
    REFERENCES Cat_Car_Types(id_car_type),
    CONSTRAINT fk_id_car_status
    FOREIGN KEY (id_car_status)
    REFERENCES Cat_Car_Status(id_car_status)
);

CREATE TABLE Trips(
    id_trip INTEGER NOT NULL UNIQUE PRIMARY KEY,
    id_client INTEGER NOT NULL,
    id_car INTEGER NOT NULL,
    trip_date DATE NOT NULL,
    origin NVARCHAR(512),
    destination NVARCHAR(512),
    fare FLOAT,
    CONSTRAINT fk_id_client
    FOREIGN KEY (id_client)
    REFERENCES Clients(id_client),
    CONSTRAINT fk_id_car
    FOREIGN KEY (id_car)
    REFERENCES Cars(id_car)
);

CREATE TABLE Tickets(
    id_ticket INTEGER NOT NULL UNIQUE PRIMARY KEY,
    id_trip INTEGER NOT NULL,
    ticket_desc NVARCHAR(512) NOT NULL,
    id_ticket_status INTEGER NOT NULL,
    CONSTRAINT fk_id_trip
    FOREIGN KEY (id_trip)
    REFERENCES Trips(id_trip),
    CONSTRAINT fk_id_ticket_status
    FOREIGN KEY (id_ticket_status)
    REFERENCES Cat_Ticket_Status(id_ticket_status)
);

CREATE TABLE Monitoring(
    id_monitor INTEGER NOT NULL UNIQUE PRIMARY KEY,
    id_admin INTEGER NOT NULL,
    id_ticket INTEGER NOT NULL,
    monitor_desc NVARCHAR(512) NOT NULL,
    CONSTRAINT fk_id_admin
    FOREIGN KEY (id_admin)
    REFERENCES Super_Users(id_admin),
    CONSTRAINT fk_id_ticket
    FOREIGN KEY (id_ticket)
    REFERENCES Tickets(id_ticket)
);

INSERT
INTO Cat_User_Status
VALUES
(
	1,
	"Activo"
),
(
	2,
	"Baja"
);

INSERT
INTO Cat_Car_Types
VALUES
(
	1,
	"Diesel"
),
(
	2,
	"Gasolina"
),
(
	3,
	"Hibrido"
),
(
	4,
	"Electrico"
);

INSERT
INTO Cat_Car_Status
VALUES
(
	1,
    "Ingreso"
),
(
	2,
	"Activo"
),
(
	3,
	"Reparacion"
),
(
	4,
    "Baja"
);