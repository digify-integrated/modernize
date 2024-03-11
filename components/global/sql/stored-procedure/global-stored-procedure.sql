DELIMITER //

CREATE PROCEDURE generateLogNotes(IN p_table_name VARCHAR(255), IN p_reference_id INT)
BEGIN
	SELECT log, changed_by, changed_at
    FROM audit_log
    ORDER BY changed_at DESC;
END //