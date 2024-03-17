DELIMITER //

CREATE PROCEDURE checkMenuItemExist(IN p_menu_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM menu_item
    WHERE menu_item_id = p_menu_item_id;
END //

CREATE PROCEDURE insertMenuItem(IN p_menu_item_name VARCHAR(100), IN p_menu_item_url VARCHAR(50), IN p_menu_group_id INT, IN p_menu_group_name VARCHAR(100), IN p_parent_id INT, IN p_parent_name VARCHAR(100), IN p_menu_item_icon VARCHAR(50), IN p_order_sequence TINYINT(10), IN p_last_log_by INT, OUT p_menu_item_id INT)
BEGIN
    INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) 
	VALUES(p_menu_item_name, p_menu_item_url, p_menu_group_id, p_menu_group_name, p_parent_id, p_parent_name, p_menu_item_icon, p_order_sequence, p_last_log_by);
	
    SET p_menu_item_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE updateMenuItem(IN p_menu_item_id INT, IN p_menu_item_name VARCHAR(100), IN p_menu_item_url VARCHAR(50), IN p_menu_group_id INT, IN p_menu_group_name VARCHAR(100), IN p_parent_id INT, IN p_parent_name VARCHAR(100), IN p_menu_item_icon VARCHAR(50), IN p_order_sequence TINYINT(10), IN p_last_log_by INT)
BEGIN
	UPDATE menu_item
    SET menu_item_name = p_menu_item_name,
    menu_item_url = p_menu_item_url,
    menu_group_id = p_menu_group_id,
    menu_group_name = p_menu_group_name,
    parent_id = p_parent_id,
    parent_name = p_parent_name,
    menu_item_icon = p_menu_item_icon,
    order_sequence = p_order_sequence,
    last_log_by = p_last_log_by
    WHERE menu_item_id = p_menu_item_id;
END //

CREATE PROCEDURE deleteMenuItem(IN p_menu_item_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM menu_item WHERE menu_item_id = p_menu_item_id;

    COMMIT;
END //

CREATE PROCEDURE getMenuItem(IN p_menu_item_id INT)
BEGIN
	SELECT * FROM menu_item
	WHERE menu_item_id = p_menu_item_id;
END //

CREATE PROCEDURE generateMenuItemTable(IN p_filter_by_menu_group INT)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT menu_item_id, menu_item_name, menu_group_name, order_sequence 
        FROM menu_item 
        WHERE 1 = 1');

    IF p_filter_by_menu_group IS NOT NULL THEN
        SET query = CONCAT(query, ' AND menu_group_id = ', p_filter_by_menu_group);
    END IF;

    SET query = CONCAT(query, ' ORDER BY menu_item_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateSubmenuItemTable(IN p_parent_id INT)
BEGIN
	SELECT * FROM menu_item
	WHERE parent_id = p_parent_id AND parent_id IS NOT NULL;
END //

CREATE PROCEDURE generateMenuItemOptions()
BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    ORDER BY menu_item_name;
END //