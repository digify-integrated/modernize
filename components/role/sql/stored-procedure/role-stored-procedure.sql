DELIMITER //

/* Check Stored Procedures */

CREATE PROCEDURE checkRoleExist(IN p_role_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM role
    WHERE role_id = p_role_id;
END //

CREATE PROCEDURE checkRolePermissionExist(IN p_role_permission_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM role_permission
    WHERE role_permission_id = p_role_permission_id;
END //

CREATE PROCEDURE checkRoleSystemActionPermissionExist(IN p_role_system_action_permission_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM role_system_action_permission
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedures */

CREATE PROCEDURE insertRole(IN p_role_name VARCHAR(100), IN p_role_description VARCHAR(200), IN p_last_log_by INT, OUT p_role_id INT)
BEGIN
    INSERT INTO role (role_name, role_description, last_log_by) 
	VALUES(p_role_name, p_role_description, p_last_log_by);
	
    SET p_role_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertRolePermission(IN p_role_id INT, IN p_role_name VARCHAR(100), IN p_menu_item_id INT, IN p_menu_item_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_menu_item_id, p_menu_item_name, p_last_log_by);
END //

CREATE PROCEDURE insertRoleSystemActionPermission(IN p_role_id INT, IN p_role_name VARCHAR(100), IN p_system_action_id INT, IN p_system_action_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_system_action_id, p_system_action_name, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedures */

CREATE PROCEDURE updateRole(IN p_role_id INT, IN p_role_name VARCHAR(100), IN p_role_description VARCHAR(200), IN p_last_log_by INT)
BEGIN
	UPDATE role
    SET role_name = p_role_name,
    role_name = p_role_name,
    role_description = p_role_description,
    last_log_by = p_last_log_by
    WHERE role_id = p_role_id;
END //

CREATE PROCEDURE updateRolePermission(IN p_role_permission_id INT, IN p_access_type VARCHAR(10), IN p_access TINYINT(1), IN p_last_log_by INT)
BEGIN
    IF p_access_type = 'read' THEN
        UPDATE role_permission
        SET read_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    ELSEIF p_access_type = 'write' THEN
        UPDATE role_permission
        SET write_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    ELSEIF p_access_type = 'create' THEN
        UPDATE role_permission
        SET create_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    ELSE
        UPDATE role_permission
        SET delete_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    END IF;
END //

CREATE PROCEDURE updateRoleSystemActionPermission(IN p_role_system_action_permission_id INT, IN p_system_action_access TINYINT(1), IN p_last_log_by INT)
BEGIN
    UPDATE role_system_action_permission
    SET system_action_access = p_system_action_access,
        last_log_by = p_last_log_by
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedures */

CREATE PROCEDURE deleteRole(IN p_role_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_permission WHERE role_id = p_role_id;
    DELETE FROM role_system_action_permission WHERE role_id = p_role_id;
    DELETE FROM role WHERE role_id = p_role_id;

    COMMIT;
END //

CREATE PROCEDURE deleteRolePermission(IN p_role_permission_id INT)
BEGIN
   DELETE FROM role_permission WHERE role_permission_id = p_role_permission_id;
END //

CREATE PROCEDURE deleteRoleSystemActionPermission(IN p_role_system_action_permission_id INT)
BEGIN
   DELETE FROM role_system_action_permission WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getRole(IN p_role_id INT)
BEGIN
	SELECT * FROM role
    WHERE role_id = p_role_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedures */

CREATE PROCEDURE generateRoleTable()
BEGIN
	SELECT role_id, role_name, role_description
    FROM role 
    ORDER BY role_id;
END //

CREATE PROCEDURE generateRoleMenuItemPermissionTable(IN p_role_id INT)
BEGIN
	SELECT  role_permission_id, menu_item_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE role_id = p_role_id
    ORDER BY menu_item_name;
END //

CREATE PROCEDURE generateRoleSystemActionPermissionTable(IN p_role_id INT)
BEGIN
	SELECT  role_system_action_permission_id, system_action_name, system_action_access 
    FROM role_system_action_permission
    WHERE role_id = p_role_id
    ORDER BY system_action_name;
END //

CREATE PROCEDURE generateMenuItemRolePermissionTable(IN p_menu_item_id INT)
BEGIN
	SELECT role_permission_id, role_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE menu_item_id = p_menu_item_id
    ORDER BY role_name;
END //

CREATE PROCEDURE generateSystemActionRolePermissionTable(IN p_system_action_id INT)
BEGIN
	SELECT role_system_action_permission_id, role_name, system_action_access 
    FROM role_system_action_permission
    WHERE system_action_id = p_system_action_id
    ORDER BY role_name;
END //

CREATE PROCEDURE generateMenuItemRoleDualListBoxOptions(IN p_menu_item_id INT)
BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_permission WHERE menu_item_id = p_menu_item_id)
    ORDER BY role_name;
END //

CREATE PROCEDURE generateSystemActionRoleDualListBoxOptions(IN p_system_action_id INT)
BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_system_action_permission WHERE system_action_id = p_system_action_id)
    ORDER BY role_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */