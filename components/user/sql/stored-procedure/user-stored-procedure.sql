DELIMITER //

CREATE PROCEDURE getUser(IN p_user_id INT, IN p_email VARCHAR(255))
BEGIN
	SELECT * FROM users
    WHERE user_id = p_user_id OR email = p_email;
END //