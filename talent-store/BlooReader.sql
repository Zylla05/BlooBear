USE BlooBear;

DROP USER IF EXISTS 'BlooReader'@'localhost';

CREATE USER 'BlooReader'@'localhost' IDENTIFIED BY 'bloopass';

GRANT EXECUTE ON BlooBear.* TO 'BlooReader'@'localhost';