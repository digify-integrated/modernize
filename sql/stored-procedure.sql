DELIMITER //

/* Login Credentials Stored Procedures */

CREATE PROCEDURE checkLoginCredentialsExist(IN p_email VARCHAR(255))
BEGIN
	SELECT COUNT(*) AS total
    FROM users
    WHERE email = p_email;
END //

CREATE PROCEDURE getLoginCredentials(IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM users
	WHERE email = p_email;
END //

CREATE PROCEDURE updateLoginAttempt(IN p_user_id INT, IN p_failed_login_attempts INT, IN p_last_failed_login_attempt DATETIME)
BEGIN
	UPDATE users 
    SET failed_login_attempts = p_failed_login_attempts, last_failed_login_attempt = p_last_failed_login_attempt
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE updateAccountLock(IN p_user_id INT, IN p_locked VARCHAR(5), IN p_account_lock_duration INT)
BEGIN
	UPDATE users 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_id = p_user_id;
END //

/* Security Setting Stored Procedures */

CREATE PROCEDURE getSecuritySetting(IN p_security_setting_id INT)
BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END //