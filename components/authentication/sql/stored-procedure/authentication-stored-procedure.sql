DELIMITER //

CREATE PROCEDURE checkLoginCredentialsExist(IN p_user_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT COUNT(*) AS total
    FROM users
    WHERE user_id = p_user_id OR email = p_email;
END //

CREATE PROCEDURE getLoginCredentials(IN p_user_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM users
    WHERE user_id = p_user_id OR email = p_email;
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

CREATE PROCEDURE updateOTP(IN p_user_id INT, IN p_otp VARCHAR(255), IN p_otp_expiry_date DATETIME)
BEGIN
	UPDATE users 
    SET otp = p_otp, otp_expiry_date = p_otp_expiry_date, failed_otp_attempts = 0
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE updateLastConnection(IN p_user_id INT, IN p_session_token VARCHAR(255), IN p_last_connection_date DATETIME)
BEGIN
	UPDATE users 
    SET session_token = p_session_token, last_connection_date = p_last_connection_date
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE updateFailedOTPAttempts(IN p_user_id INT, IN p_failed_otp_attempts INT)
BEGIN
	UPDATE users 
    SET failed_otp_attempts = p_failed_otp_attempts
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE updateOTPAsExpired(IN p_user_id INT, IN p_otp_expiry_date DATETIME)
BEGIN
	UPDATE users 
    SET otp_expiry_date = p_otp_expiry_date
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE updateResetToken(IN p_user_id INT, IN p_reset_token VARCHAR(255), IN p_reset_token_expiry_date DATETIME)
BEGIN
	UPDATE users 
    SET reset_token = p_reset_token, reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE updateUserPassword(IN p_user_id INT, IN p_email VARCHAR(255), IN p_password VARCHAR(255), IN p_password_expiry_date DATE, IN p_last_password_change DATETIME)
BEGIN
	UPDATE users 
    SET password = p_password, password_expiry_date = p_password_expiry_date, last_password_change = p_last_password_change, locked = 'No', failed_login_attempts = 0, account_lock_duration = 0
    WHERE p_user_id = user_id OR email = BINARY p_email;
END //

CREATE PROCEDURE updateResetTokenAsExpired(IN p_user_id INT, IN p_reset_token_expiry_date DATETIME)
BEGIN
	UPDATE users 
    SET reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_id = p_user_id;
END //

CREATE PROCEDURE insertPasswordHistory(IN p_user_id INT, IN p_email VARCHAR(255), IN p_password VARCHAR(255), IN p_last_password_change DATETIME)
BEGIN
    INSERT INTO password_history (user_id, email, password, password_change_date) 
    VALUES (p_user_id, p_email, p_password, p_last_password_change);
END //

CREATE PROCEDURE getPasswordHistory(IN p_user_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM password_history
	WHERE user_id = p_user_id OR email = BINARY p_email;
END //