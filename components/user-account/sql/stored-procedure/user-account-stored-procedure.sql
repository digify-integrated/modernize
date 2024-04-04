DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkUserAccountExist(IN p_user_account_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE checkUserAccountEmailExist(IN p_email VARCHAR(255))
BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email;
END //

CREATE PROCEDURE checkUserAccountEmailUpdateExist(IN p_user_account_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email AND user_account_id != p_user_account_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertUserAccount(IN p_file_as VARCHAR(300), IN p_email VARCHAR(255), IN p_password VARCHAR(255), IN p_password_expiry_date DATE, IN p_last_password_change DATETIME, IN p_last_log_by INT, OUT p_user_account_id INT)
BEGIN
    INSERT INTO user_account (file_as, email, password, password_expiry_date, last_password_change, last_log_by) 
	VALUES(p_file_as, p_email, p_password, p_password_expiry_date, p_last_password_change, p_last_log_by);
	
    SET p_user_account_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateUserAccount(IN p_user_account_id INT, IN p_file_as VARCHAR(300), IN p_email VARCHAR(255), IN p_password VARCHAR(255), IN p_password_expiry_date DATE, IN p_last_password_change DATETIME, IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_user_account
    SET file_as = p_file_as,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;

    IF p_password IS NOT NULL AND p_password != '' THEN
        UPDATE user_account
        SET file_as = p_file_as,
            email = p_email,
            password = p_password,
            password_expiry_date = p_password_expiry_date,
            last_password_change = p_last_password_change,
            last_log_by = p_last_log_by
        WHERE user_account_id = p_user_account_id;
    ELSE
        UPDATE user_account
        SET file_as = p_file_as,
            email = p_email,
            last_log_by = p_last_log_by
        WHERE user_account_id = p_user_account_id;
    END IF;

    COMMIT;
END //

CREATE PROCEDURE updateUserAccountStatus(IN p_user_account_id INT, IN p_active VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE user_account
    SET active = p_active,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END //

CREATE PROCEDURE updateUserAccountLock(IN p_user_account_id INT, IN p_locked VARCHAR(5), IN p_account_lock_duration INT, IN p_last_log_by INT)
BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedures */

CREATE PROCEDURE deleteUserAccount(IN p_user_account_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_user_account WHERE user_account_id = p_user_account_id;
    DELETE FROM user_account WHERE user_account_id = p_user_account_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getUserAccount(IN p_user_account_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedures */

CREATE PROCEDURE generateUserAccountTable(IN p_filter_by_user_account_status VARCHAR(10), IN p_filter_by_user_account_lock_status VARCHAR(10), IN p_filter_password_expiry_start_date DATE, IN p_filter_password_expiry_end_date DATE, IN p_filter_last_connection_start_date DATE, IN p_filter_last_connection_end_date DATE)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT * 
        FROM user_account 
        WHERE 1');

    IF p_filter_by_user_account_status IS NOT NULL AND p_filter_by_user_account_status != '' THEN
        SET query = CONCAT(query, ' AND active = ', QUOTE(p_filter_by_user_account_status));
    END IF;

    IF p_filter_by_user_account_lock_status IS NOT NULL AND p_filter_by_user_account_lock_status != '' THEN
        SET query = CONCAT(query, ' AND locked = ', QUOTE(p_filter_by_user_account_lock_status));
    END IF;

    IF p_filter_password_expiry_start_date IS NOT NULL AND p_filter_password_expiry_end_date IS NOT NULL THEN
        SET query = CONCAT(query, ' AND password_expiry_date BETWEEN ', QUOTE(p_filter_password_expiry_start_date), ' AND ', QUOTE(p_filter_password_expiry_end_date));
    END IF;

    IF p_filter_last_connection_start_date IS NOT NULL AND p_filter_last_connection_end_date IS NOT NULL THEN
        SET query = CONCAT(query, ' AND DATE(last_connection_date) BETWEEN ', QUOTE(p_filter_last_connection_start_date), ' AND ', QUOTE(p_filter_last_connection_end_date));
    END IF;

    SET query = CONCAT(query, ' ORDER BY file_as');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */