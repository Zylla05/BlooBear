USE BlooBear;

DELIMITER $$

-- CLIENT

CREATE PROCEDURE CREATE_CLIENT
(
    client_name NVARCHAR(512),
    client_mail NVARCHAR(512),
    client_wallet NVARCHAR(512)
)
-- IS
BEGIN

DECLARE new_id INTEGER;
DECLARE user_amount INTEGER;
DECLARE aux_id INTEGER;

SET new_id = (SELECT id FROM (SELECT id_client AS id FROM Clients order by id_client desc limit 1) AS LAST_ID)+1;
SET user_amount = (SELECT count(*) FROM Clients WHERE mail_client = client_mail);

/*
    IF user_amount = 1
    THEN SET aux_id = (SELECT id_client FROM Clients WHERE mail_client = client_mail);
         CALL RESTORE_CLIENT(aux_id);
         SELECT aux_id AS id_client;
    ELSEIF user_amount = 0
*/

    INSERT
    INTO Clients
    VALUES (
        new_id,
        client_name,
        client_mail,
        client_wallet,
        1);

    SELECT new_id AS id_client;
/*
    ELSEIF user_amount > 1
    THEN SELECT "409 Conflict" AS Custom_Error;
    ELSE SELECT "500 Something Went Wrong" AS Custom_Error;
    END IF;
*/    
END$$

CREATE PROCEDURE GET_CLIENTS(

)
-- IS
BEGIN
    SELECT
        name_client,
        mail_client
        FROM Clients
    WHERE
        id_user_status = 1;
END$$

CREATE PROCEDURE GET_CLIENT_BY_MAIL (
	client_mail NVARCHAR(512)
)
-- IS
BEGIN
	DECLARE user_amount INTEGER;
    SET user_amount = (SELECT count(*) FROM Clients WHERE mail_client = client_mail AND id_user_status = 1);
    
    IF user_amount = 0
    THEN SIGNAL SQLSTATE '45404' SET MESSAGE_TEXT = 'Not Found';
    ELSEIF user_amount = 1
    THEN SELECT id_client, name_client, mail_client, wallet FROM Clients WHERE mail_client = client_mail AND id_user_status = 1;
    ELSEIF user_amount > 1
    THEN SIGNAL SQLSTATE '45409' SET MESSAGE_TEXT = 'Conflict';
    ELSE SIGNAL SQLSTATE '45500' SET MESSAGE_TEXT = 'Something Went Wrong';
    END IF;
END$$

CREATE PROCEDURE GET_CLIENT_BY_ID(
    client_id INTEGER
)
-- IS
BEGIN
    SELECT 
        name_client,
        mail_client
    FROM Clients
    WHERE 
        id_client = client_id
    AND id_user_status = 1;
END$$

CREATE PROCEDURE GET_CLIENT_WALLET_BY_ID(
    client_id INTEGER
)
-- IS
BEGIN
    SELECT 
        wallet 
    FROM Clients 
    WHERE 
        id_client = client_id
    AND id_user_status = 1;
END$$

CREATE PROCEDURE SET_CLIENT_NAME(
    client_id INTEGER,
    client_name NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Clients 
    SET
        name_client = client_name
    WHERE
        id_client = client_id;
END$$

CREATE PROCEDURE SET_CLIENT_MAIL(
    client_id INTEGER,
    client_mail NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Clients 
    SET
        mail_client = client_mail
    WHERE
        id_client = client_id;
END$$

CREATE PROCEDURE DELETE_CLIENT(
    client_id INTEGER
)
-- IS
BEGIN
    UPDATE Clients
    SET
        id_user_status=2
    WHERE
        id_client = client_id;
END$$

CREATE PROCEDURE RESTORE_CLIENT(
    client_id INTEGER
)
-- IS
BEGIN
    UPDATE Clients
    SET
        id_user_status=1
    WHERE
        id_client = client_id;
END$$

-- ADMIN

CREATE PROCEDURE CREATE_ADMIN
(
    admin_name NVARCHAR(512),
    admin_mail NVARCHAR(512),
    admin_pass NVARCHAR(512) 
)
-- IS
BEGIN

	DECLARE new_id INTEGER;

	SET new_id = (SELECT id FROM (SELECT id_admin FROM Super_Users order by id_admin desc limit 1) AS LAST_ID)+1;

    INSERT
    INTO Super_Users
    VALUES (
        new_id,
        admin_name,
        admin_mail,
        admin_pass,
        1);
END$$

CREATE PROCEDURE LOGIN_ADMIN(
    admin_mail NVARCHAR(512),
    admin_pass NVARCHAR(512)
)
-- IS
BEGIN
    DECLARE aux INTEGER;

    SET aux = (SELECT count(*) FROM Super_Users WHERE mail_admin = admin_mail AND id_user_status = 1);

    IF aux = 0
    THEN SIGNAL SQLSTATE '45404' SET MESSAGE_TEXT = 'Not Found';
    ELSEIF aux = 1
    THEN SELECT id_admin FROM Super_Users WHERE mail_admin = admin_mail AND id_user_status = 1;
    ELSEIF aux > 1
    THEN SIGNAL SQLSTATE '45409' SET MESSAGE_TEXT = 'Conflict';
    ELSE SIGNAL SQLSTATE '45500' SET MESSAGE_TEXT = 'Something Went Wrong';
    END IF;
END$$

CREATE PROCEDURE GET_ADMINS(

)
-- IS
BEGIN
    SELECT
        name_admin,
        mail_admin
    FROM Super_Users
    WHERE
        id_user_status = 1;
END$$

CREATE PROCEDURE GET_ADMIN_BY_ID(
    admin_id INTEGER
)
-- IS
BEGIN
    SELECT 
        name_admin,
        mail_admin
    FROM Super_Users
    WHERE 
        id_admin = admin_id
    AND id_user_status = 1;
END$$

CREATE PROCEDURE SET_ADMIN_NAME(
    admin_id INTEGER,
    admin_name NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Super_Users
    SET
        name_admin = admin_name
    WHERE
        id_admin = admin_id;
END$$

CREATE PROCEDURE SET_ADMIN_MAIL(
    admin_id INTEGER,
    admin_mail NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Super_Users
    SET
        mail_admin = admin_mail
    WHERE
        id_admin = admin_id;
END$$

CREATE PROCEDURE SET_ADMIN_PASS(
    admin_id INTEGER,
    admin_pass NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Super_Users
    SET
        pass = admin_pass
    WHERE
        id_admin = admin_id;
END$$

CREATE PROCEDURE DELETE_ADMIN(
    admin_id INTEGER
)
-- IS
BEGIN
    UPDATE Super_Users
    SET
        id_user_status=2
    WHERE
        id_admin = admin_id;
END$$

-- CAR

CREATE PROCEDURE CREATE_CAR
(
    car_model NVARCHAR(512),
    car_brand NVARCHAR(512),
    car_plate NVARCHAR(512),
    car_motor NVARCHAR(512),
    car_NIV NVARCHAR(512),
    car_TC NVARCHAR(512),
    car_type INTEGER
)
-- IS
BEGIN

DECLARE new_id INTEGER;

/*
    IF(
        (SELECT count(*)
        FROM Clients
        WHERE
            mail_client = client_mail;
        ) > 0
        ) BEGIN
        UPDATE Clients
        SET
            id_user_status = 1
        WHERE
            mail_client = client_mail;
    ELSE BEGIN
*/

SET new_id = (SELECT id FROM (SELECT id_car FROM Cars order by id_car desc limit 1) AS LAST_ID)+1;

    INSERT
    INTO Cars
    VALUES (
        new_id,
        car_model,
        car_brand,
        car_plate,
        car_motor,
        car_NIV,
        car_TC,
        car_type,
        1);
/*
    END$$
*/
	
    SELECT new_id AS id_car;
    
END$$

CREATE PROCEDURE GET_CARS(

)
-- IS
BEGIN
    SELECT
        Cars.model,
        Cars.brand,
        Cars.plate,
        Cars.motor,
        Cars.NIV,
        Cars.TC,
        Cat_Car_Types.car_type,
        Cat_Car_Status.car_status
	FROM ((Cars
	INNER JOIN Cat_Car_Types ON Cars.id_car_type = Cat_Car_Types.id_car_type)
    INNER JOIN Cat_Car_Status ON Cars.id_car_status = Cat_Car_Status.id_car_status);
END$$

CREATE PROCEDURE GET_CAR_BY_ID(
    car_id INTEGER
)
-- IS
BEGIN
    SELECT
        Cars.model,
        Cars.brand,
        Cars.plate,
        Cars.motor,
        Cars.NIV,
        Cars.TC,
        Cat_Car_Types.car_type,
        Cat_Car_Status.car_status
	FROM ((Cars
	INNER JOIN Cat_Car_Types ON Cars.id_car_type = Cat_Car_Types.id_car_type)
    INNER JOIN Cat_Car_Status ON Cars.id_car_status = Cat_Car_Status.id_car_status)
    WHERE 
        id_car = car_id;
END$$

CREATE PROCEDURE SET_CAR_PLATE(
    car_id INTEGER,
    car_plate NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Cars 
    SET
        plate = car_plate
    WHERE
        id_car = car_id;
END$$

CREATE PROCEDURE SET_CAR_TC(
    car_id INTEGER,
    car_TC NVARCHAR(512)
)
-- IS
BEGIN
    UPDATE Cars
    SET
        TC = car_TC
    WHERE
        id_car = car_id;
END$$

CREATE PROCEDURE REPAIR_CAR(
    car_id INTEGER
)
-- IS
BEGIN
    UPDATE Cars
    SET
        id_car_status = 2
    WHERE
        id_car = car_id;
END$$

CREATE PROCEDURE DELETE_CAR(
    client_id INTEGER
)
-- IS
BEGIN
    UPDATE Cars
    SET
        id_user_status=3
    WHERE
        id_car = car_id;
END$$

DELIMITER ;