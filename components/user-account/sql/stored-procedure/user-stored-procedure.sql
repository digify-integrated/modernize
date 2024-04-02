DELIMITER //

/* Get Stored Procedures */

CREATE PROCEDURE getUser(IN p_user_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM users
    WHERE user_id = p_user_id OR email = p_email;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedures */

CREATE PROCEDURE generateUserAccountTable(IN p_filter_by_user_account_status VARCHAR(10), IN p_filter_by_user_account_lock_status VARCHAR(10), IN p_filter_password_expiry_start_date DATE, IN p_filter_password_expiry_end_date DATE, IN p_filter_last_connection_start_date DATE, IN p_filter_last_connection_end_date DATE)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT * 
        FROM users 
        WHERE 1');

    /*IF p_filter_by_user_account_status IS NOT NULL THEN
        SET query = CONCAT(query, ' AND active = ', QUOTE(p_filter_by_user_account_status));
    END IF;

    IF p_filter_by_user_account_lock_status IS NOT NULL THEN
        SET query = CONCAT(query, ' AND locked = ', QUOTE(p_filter_by_user_account_lock_status));
    END IF;

    IF p_filter_password_expiry_start_date IS NOT NULL AND p_filter_password_expiry_end_date IS NOT NULL THEN
        SET query = CONCAT(query, ' AND password_expiry_date BETWEEN ', QUOTE(p_filter_password_expiry_start_date), ' AND ', QUOTE(p_filter_password_expiry_end_date));
    END IF;

    IF p_filter_last_connection_start_date IS NOT NULL AND p_filter_last_connection_end_date IS NOT NULL THEN
        SET query = CONCAT(query, ' AND last_connection_date BETWEEN ', QUOTE(p_filter_last_connection_start_date), ' AND ', QUOTE(p_filter_last_connection_end_date));
    END IF;*/

    SET query = CONCAT(query, ' ORDER BY file_as');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */