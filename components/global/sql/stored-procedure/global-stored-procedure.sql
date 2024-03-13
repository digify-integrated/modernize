DELIMITER //

CREATE PROCEDURE generateLogNotes(IN p_table_name VARCHAR(255), IN p_reference_id INT)
BEGIN
	SELECT log, changed_by, changed_at
    FROM audit_log
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY changed_at DESC;
END //