-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 12, 2024 at 11:33 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `modernizedb`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildMenuGroup` (IN `p_user_account_id` INT)   BEGIN
    SELECT DISTINCT(mg.menu_group_id) as menu_group_id, mg.menu_group_name
    FROM menu_group mg
    JOIN menu_item mi ON mi.menu_group_id = mg.menu_group_id
    WHERE EXISTS (
        SELECT 1
        FROM role_permission mar
        WHERE mar.menu_item_id = mi.menu_item_id
        AND mar.read_access = 1
        AND mar.role_id IN (
            SELECT role_id
            FROM role_user_account
            WHERE user_account_id = p_user_account_id
        )
    )
    ORDER BY mg.order_sequence;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buildMenuItem` (IN `p_user_account_id` INT, IN `p_menu_group_id` INT)   BEGIN
    SELECT mi.menu_item_id, mi.menu_item_name, mi.menu_group_id, mi.menu_item_url, mi.parent_id, mi.menu_item_icon
    FROM menu_item AS mi
    INNER JOIN role_permission AS mar ON mi.menu_item_id = mar.menu_item_id
    INNER JOIN role_user_account AS ru ON mar.role_id = ru.role_id
    WHERE mar.read_access = 1 AND ru.user_account_id = p_user_account_id AND mi.menu_group_id = p_menu_group_id
    ORDER BY mi.order_sequence;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLoginCredentialsExist` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkMenuGroupExist` (IN `p_menu_group_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM menu_group
    WHERE menu_group_id = p_menu_group_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkMenuItemExist` (IN `p_menu_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM menu_item
    WHERE menu_item_id = p_menu_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleExist` (IN `p_role_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role
    WHERE role_id = p_role_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRolePermissionExist` (IN `p_role_permission_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_permission
    WHERE role_permission_id = p_role_permission_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleSystemActionPermissionExist` (IN `p_role_system_action_permission_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_system_action_permission
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleUserAccountExist` (IN `p_role_user_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_user_account
    WHERE role_user_account_id = p_role_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemActionExist` (IN `p_system_action_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM system_action
    WHERE system_action_id = p_system_action_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountEmailExist` (IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountEmailUpdateExist` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email AND user_account_id != p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountExist` (IN `p_user_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMenuGroup` (IN `p_menu_group_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM menu_group WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMenuItem` (IN `p_menu_item_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_permission WHERE menu_item_id = p_menu_item_id;
    DELETE FROM menu_item WHERE menu_item_id = p_menu_item_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRole` (IN `p_role_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_permission WHERE role_id = p_role_id;
    DELETE FROM role_system_action_permission WHERE role_id = p_role_id;
    DELETE FROM role WHERE role_id = p_role_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRolePermission` (IN `p_role_permission_id` INT)   BEGIN
   DELETE FROM role_permission WHERE role_permission_id = p_role_permission_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoleSystemActionPermission` (IN `p_role_system_action_permission_id` INT)   BEGIN
   DELETE FROM role_system_action_permission WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoleUserAccount` (IN `p_role_user_account_id` INT)   BEGIN
   DELETE FROM role_user_account WHERE role_user_account_id = p_role_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSystemAction` (IN `p_system_action_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_system_action_permission WHERE system_action_id = p_system_action_id;
    DELETE FROM system_action WHERE system_action_id = p_system_action_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUserAccount` (IN `p_user_account_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_user_account WHERE user_account_id = p_user_account_id;
    DELETE FROM password_history WHERE user_account_id = p_user_account_id;
    DELETE FROM user_account WHERE user_account_id = p_user_account_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLogNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT)   BEGIN
	SELECT log, changed_by, changed_at
    FROM audit_log
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY changed_at DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuGroupOptions` ()   BEGIN
	SELECT menu_group_id, menu_group_name 
    FROM menu_group 
    ORDER BY menu_group_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuGroupTable` ()   BEGIN
	SELECT menu_group_id, menu_group_name, order_sequence 
    FROM menu_group 
    ORDER BY menu_group_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemOptions` ()   BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    ORDER BY menu_item_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemRoleDualListBoxOptions` (IN `p_menu_item_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_permission WHERE menu_item_id = p_menu_item_id)
    ORDER BY role_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemRolePermissionTable` (IN `p_menu_item_id` INT)   BEGIN
	SELECT role_permission_id, role_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE menu_item_id = p_menu_item_id
    ORDER BY role_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemTable` (IN `p_filter_by_menu_group` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT menu_item_id, menu_item_name, menu_group_name, order_sequence 
        FROM menu_item 
        WHERE 1');

    IF p_filter_by_menu_group IS NOT NULL THEN
        SET query = CONCAT(query, ' AND menu_group_id = ', p_filter_by_menu_group);
    END IF;

    SET query = CONCAT(query, ' ORDER BY menu_item_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleMenuItemDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    WHERE menu_item_id NOT IN (SELECT menu_item_id FROM role_permission WHERE role_id = p_role_id)
    ORDER BY menu_item_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleMenuItemPermissionTable` (IN `p_role_id` INT)   BEGIN
	SELECT  role_permission_id, menu_item_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE role_id = p_role_id
    ORDER BY menu_item_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleSystemActionDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT system_action_id, system_action_name
    FROM system_action 
    WHERE system_action_id NOT IN (SELECT system_action_id FROM role_system_action_permission WHERE role_id = p_role_id)
    ORDER BY system_action_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleSystemActionPermissionTable` (IN `p_role_id` INT)   BEGIN
	SELECT  role_system_action_permission_id, system_action_name, system_action_access 
    FROM role_system_action_permission
    WHERE role_id = p_role_id
    ORDER BY system_action_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleTable` ()   BEGIN
	SELECT role_id, role_name, role_description
    FROM role 
    ORDER BY role_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleUserAccountDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT user_account_id, file_as 
    FROM user_account 
    WHERE user_account_id NOT IN (SELECT user_account_id FROM role_user_account WHERE role_id = p_role_id)
    ORDER BY file_as;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleUserAccountTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_user_account_id, user_account_id, file_as 
    FROM role_user_account
    WHERE role_id = p_role_id
    ORDER BY file_as;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSubmenuItemTable` (IN `p_parent_id` INT)   BEGIN
	SELECT * FROM menu_item
	WHERE parent_id = p_parent_id AND parent_id IS NOT NULL;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionRoleDualListBoxOptions` (IN `p_system_action_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_system_action_permission WHERE system_action_id = p_system_action_id)
    ORDER BY role_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionRolePermissionTable` (IN `p_system_action_id` INT)   BEGIN
	SELECT role_system_action_permission_id, role_name, system_action_access 
    FROM role_system_action_permission
    WHERE system_action_id = p_system_action_id
    ORDER BY role_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionTable` ()   BEGIN
	SELECT system_action_id, system_action_name, system_action_description
    FROM system_action 
    ORDER BY system_action_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountRoleDualListBoxOptions` (IN `p_user_account_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_user_account WHERE user_account_id = p_user_account_id)
    ORDER BY role_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountRoleList` (IN `p_user_account_id` INT)   BEGIN
	SELECT role_user_account_id, role_name, date_assigned
    FROM role_user_account
    WHERE user_account_id = p_user_account_id
    ORDER BY role_name;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountTable` (IN `p_filter_by_user_account_status` VARCHAR(10), IN `p_filter_by_user_account_lock_status` VARCHAR(10), IN `p_filter_password_expiry_start_date` DATE, IN `p_filter_password_expiry_end_date` DATE, IN `p_filter_last_connection_start_date` DATE, IN `p_filter_last_connection_end_date` DATE)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmailSetting` (IN `p_email_setting_id` INT)   BEGIN
	SELECT * FROM email_setting
    WHERE email_setting_id = p_email_setting_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getLoginCredentials` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMenuGroup` (IN `p_menu_group_id` INT)   BEGIN
	SELECT * FROM menu_group
	WHERE menu_group_id = p_menu_group_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getMenuItem` (IN `p_menu_item_id` INT)   BEGIN
	SELECT * FROM menu_item
	WHERE menu_item_id = p_menu_item_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getNotificationSetting` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting
    WHERE notification_setting_id = p_notification_setting_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getPasswordHistory` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM password_history
	WHERE user_account_id = p_user_account_id OR email = BINARY p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getRole` (IN `p_role_id` INT)   BEGIN
	SELECT * FROM role
    WHERE role_id = p_role_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSecuritySetting` (IN `p_security_setting_id` INT)   BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemAction` (IN `p_system_action_id` INT)   BEGIN
	SELECT * FROM system_action
    WHERE system_action_id = p_system_action_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserAccount` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMenuGroup` (IN `p_menu_group_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_menu_group_id` INT)   BEGIN
    INSERT INTO menu_group (menu_group_name, order_sequence, last_log_by) 
	VALUES(p_menu_group_name, p_order_sequence, p_last_log_by);
	
    SET p_menu_group_id = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMenuItem` (IN `p_menu_item_name` VARCHAR(100), IN `p_menu_item_url` VARCHAR(50), IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_parent_id` INT, IN `p_parent_name` VARCHAR(100), IN `p_menu_item_icon` VARCHAR(50), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_menu_item_id` INT)   BEGIN
    INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) 
	VALUES(p_menu_item_name, p_menu_item_url, p_menu_group_id, p_menu_group_name, p_parent_id, p_parent_name, p_menu_item_icon, p_order_sequence, p_last_log_by);
	
    SET p_menu_item_id = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPasswordHistory` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_last_password_change` DATETIME)   BEGIN
    INSERT INTO password_history (user_account_id, email, password, password_change_date) 
    VALUES (p_user_account_id, p_email, p_password, p_last_password_change);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRole` (IN `p_role_name` VARCHAR(100), IN `p_role_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_role_id` INT)   BEGIN
    INSERT INTO role (role_name, role_description, last_log_by) 
	VALUES(p_role_name, p_role_description, p_last_log_by);
	
    SET p_role_id = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRolePermission` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_menu_item_id, p_menu_item_name, p_last_log_by);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRoleSystemActionPermission` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_system_action_id` INT, IN `p_system_action_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_system_action_id, p_system_action_name, p_last_log_by);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRoleUserAccount` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_user_account_id` INT, IN `p_file_as` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, last_log_by) 
	VALUES(p_role_id, p_role_name, p_user_account_id, p_file_as, p_last_log_by);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSystemAction` (IN `p_system_action_name` VARCHAR(100), IN `p_system_action_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_system_action_id` INT)   BEGIN
    INSERT INTO system_action (system_action_name, system_action_description, last_log_by) 
	VALUES(p_system_action_name, p_system_action_description, p_last_log_by);
	
    SET p_system_action_id = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUserAccount` (IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_password_change` DATETIME, IN `p_last_log_by` INT, OUT `p_user_account_id` INT)   BEGIN
    INSERT INTO user_account (file_as, email, password, password_expiry_date, last_password_change, last_log_by) 
	VALUES(p_file_as, p_email, p_password, p_password_expiry_date, p_last_password_change, p_last_log_by);
	
    SET p_user_account_id = LAST_INSERT_ID();
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFailedOTPAttempts` (IN `p_user_account_id` INT, IN `p_failed_otp_attempts` INT)   BEGIN
	UPDATE user_account 
    SET failed_otp_attempts = p_failed_otp_attempts
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLastConnection` (IN `p_user_account_id` INT, IN `p_session_token` VARCHAR(255), IN `p_last_connection_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET session_token = p_session_token, last_connection_date = p_last_connection_date
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLoginAttempt` (IN `p_user_account_id` INT, IN `p_failed_login_attempts` INT, IN `p_last_failed_login_attempt` DATETIME)   BEGIN
	UPDATE user_account 
    SET failed_login_attempts = p_failed_login_attempts, last_failed_login_attempt = p_last_failed_login_attempt
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMenuGroup` (IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE menu_item
    SET menu_group_name = p_menu_group_name,
        last_log_by = p_last_log_by
    WHERE menu_group_id = p_menu_group_id;

    UPDATE menu_group
    SET menu_group_name = p_menu_group_name,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMenuItem` (IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_menu_item_url` VARCHAR(50), IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_parent_id` INT, IN `p_parent_name` VARCHAR(100), IN `p_menu_item_icon` VARCHAR(50), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_permission
    SET menu_item_name = p_menu_item_name,
        last_log_by = p_last_log_by
    WHERE menu_item_id = p_menu_item_id;

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

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMultipleLoginSessionsStatus` (IN `p_user_account_id` INT, IN `p_multiple_session` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET multiple_session = p_multiple_session,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOTP` (IN `p_user_account_id` INT, IN `p_otp` VARCHAR(255), IN `p_otp_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET otp = p_otp, otp_expiry_date = p_otp_expiry_date, failed_otp_attempts = 0
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOTPAsExpired` (IN `p_user_account_id` INT, IN `p_otp_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET otp_expiry_date = p_otp_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateResetToken` (IN `p_user_account_id` INT, IN `p_reset_token` VARCHAR(255), IN `p_reset_token_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET reset_token = p_reset_token, reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateResetTokenAsExpired` (IN `p_user_account_id` INT, IN `p_reset_token_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRole` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_role_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_permission
    SET role_name = p_role_name,
        last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

    UPDATE role_system_action_permission
    SET role_name = p_role_name,
        last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

    UPDATE role_user_account
    SET role_name = p_role_name,
        last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

	UPDATE role
    SET role_name = p_role_name,
    role_name = p_role_name,
    role_description = p_role_description,
    last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRolePermission` (IN `p_role_permission_id` INT, IN `p_access_type` VARCHAR(10), IN `p_access` TINYINT(1), IN `p_last_log_by` INT)   BEGIN
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
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoleSystemActionPermission` (IN `p_role_system_action_permission_id` INT, IN `p_system_action_access` TINYINT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE role_system_action_permission
    SET system_action_access = p_system_action_access,
        last_log_by = p_last_log_by
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemAction` (IN `p_system_action_id` INT, IN `p_system_action_name` VARCHAR(100), IN `p_system_action_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_system_action_permission
    SET system_action_name = p_system_action_name,
        last_log_by = p_last_log_by
    WHERE system_action_id = p_system_action_id;

	UPDATE system_action
    SET system_action_name = p_system_action_name,
        system_action_description = p_system_action_description,
        last_log_by = p_last_log_by
    WHERE system_action_id = p_system_action_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTwoFactorAuthenticationStatus` (IN `p_user_account_id` INT, IN `p_two_factor_auth` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET two_factor_auth = p_two_factor_auth,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccount` (IN `p_user_account_id` INT, IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_user_account
    SET file_as = p_file_as,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;

    UPDATE user_account
    SET file_as = p_file_as,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;

    COMMIT;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT, IN `p_last_log_by` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountPassword` (IN `p_user_account_id` INT, IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_log_by` INT)   BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        last_log_by = p_last_log_by
    WHERE p_user_account_id = user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountStatus` (IN `p_user_account_id` INT, IN `p_active` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET active = p_active,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserPassword` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE)   BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        locked = 'No',
        failed_login_attempts = 0, 
        account_lock_duration = 0,
        last_log_by = p_user_account_id
    WHERE p_user_account_id = user_account_id OR email = BINARY p_email;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

CREATE TABLE `audit_log` (
  `audit_log_id` int(10) UNSIGNED NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `reference_id` int(11) NOT NULL,
  `log` text NOT NULL,
  `changed_by` int(10) UNSIGNED NOT NULL,
  `changed_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`) VALUES
(1, 'user_account', 3, 'User account created. <br/><br/>File As: test<br/>Email: test@gmail.com<br/>Locked: No<br/>Active: No<br/>Password Expiry Date: 2024-10-01<br/>Receive Notification: Yes<br/>Two-Factor Authentication: Yes<br/>Last Password Change: 2024-04-04 12:19:11<br/>Multiple Session: Yes', 2, '2024-04-04 12:19:11'),
(2, 'user_account', 3, 'Email: test@gmail.com -> test@gmail.coms<br/>', 2, '2024-04-05 15:52:29'),
(3, 'user_account', 3, 'Email: test@gmail.coms -> test@gmail.com<br/>', 2, '2024-04-05 15:52:33'),
(4, 'user_account', 4, 'User account created. <br/><br/>File As: test<br/>Email: test@gmail.com<br/>Locked: No<br/>Active: No<br/>Password Expiry Date: 2024-10-02<br/>Receive Notification: Yes<br/>Two-Factor Authentication: Yes<br/>Last Password Change: 2024-04-05 16:17:37<br/>Multiple Session: Yes', 2, '2024-04-05 16:17:37'),
(5, 'user_account', 4, 'File As: test -> Lawrence<br/>Email: test@gmail.com -> benidickbelizario@christianmotors.p<br/>', 2, '2024-04-05 16:18:11'),
(6, 'user_account', 4, 'Email: benidickbelizario@christianmotors.p -> benidickbelizario@christianmotors.ph<br/>', 2, '2024-04-05 16:18:18'),
(7, 'user_account', 4, 'File As: Lawrence -> Christian Edward Baguisa<br/>', 2, '2024-04-05 16:18:37'),
(8, 'user_account', 2, 'Last Connection Date: 2024-04-05 14:01:49 -> 2024-04-08 09:44:01<br/>', 1, '2024-04-08 09:44:01'),
(9, 'user_account', 4, 'Two-Factor Authentication: Yes -> 2<br/>', 2, '2024-04-08 11:12:42'),
(10, 'user_account', 4, 'Multiple Session: Yes -> 2<br/>', 2, '2024-04-08 11:12:45'),
(11, 'user_account', 4, 'Two-Factor Authentication: 2 -> Yes<br/>', 2, '2024-04-08 11:14:13'),
(12, 'user_account', 4, 'Two-Factor Authentication: Yes -> 2<br/>', 2, '2024-04-08 11:18:35'),
(13, 'user_account', 4, 'Two-Factor Authentication: 2 -> <br/>', 2, '2024-04-08 11:27:33'),
(14, 'user_account', 4, 'Two-Factor Authentication:  -> Yes<br/>', 2, '2024-04-08 11:30:01'),
(15, 'user_account', 4, 'Two-Factor Authentication: Yes -> 2<br/>', 2, '2024-04-08 11:30:05'),
(16, 'user_account', 4, 'Two-Factor Authentication: 2 -> No<br/>', 2, '2024-04-08 11:30:11'),
(17, 'user_account', 4, 'Two-Factor Authentication: No -> 2<br/>', 2, '2024-04-08 11:30:15'),
(18, 'user_account', 4, 'Two-Factor Authentication: 2 -> No<br/>', 2, '2024-04-08 11:30:20'),
(19, 'user_account', 4, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-08 11:31:42'),
(20, 'user_account', 4, 'Multiple Session: 2 -> Yes<br/>', 2, '2024-04-08 11:31:44'),
(21, 'user_account', 4, 'Multiple Session: Yes -> No<br/>', 2, '2024-04-08 11:31:46'),
(22, 'user_account', 4, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-08 11:31:48'),
(23, 'user_account', 4, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-08 11:38:16'),
(24, 'user_account', 4, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-08 11:38:45'),
(25, 'user_account', 4, 'Multiple Session: No -> Yes<br/>', 2, '2024-04-08 11:38:48'),
(26, 'user_account', 4, 'Active: No -> Yes<br/>', 2, '2024-04-08 11:48:15'),
(27, 'user_account', 4, 'Active: Yes -> No<br/>', 2, '2024-04-08 11:48:18'),
(28, 'user_account', 4, 'Locked: No -> Yes<br/>', 2, '2024-04-08 11:48:21'),
(29, 'user_account', 4, 'Locked: Yes -> No<br/>', 2, '2024-04-08 11:48:24'),
(30, 'user_account', 4, 'Password Expiry Date: 2024-10-02 -> 2024-10-05<br/>Last Password Change: 2024-04-05 16:17:37 -> 2024-04-08 12:23:33<br/>', 2, '2024-04-08 12:23:33'),
(31, 'user_account', 4, 'Last Password Change: 2024-04-08 12:23:33 -> 2024-04-08 12:24:25<br/>', 2, '2024-04-08 12:24:25'),
(32, 'user_account', 4, 'Active: No -> Yes<br/>', 2, '2024-04-08 12:24:56'),
(33, 'user_account', 4, 'Active: Yes -> No<br/>', 2, '2024-04-08 12:29:15'),
(34, 'user_account', 4, 'Active: No -> Yes<br/>', 2, '2024-04-08 12:29:18'),
(35, 'user_account', 4, 'Active: Yes -> No<br/>', 2, '2024-04-08 12:51:34'),
(36, 'user_account', 4, 'Active: No -> Yes<br/>', 2, '2024-04-08 12:51:40'),
(37, 'user_account', 4, 'Locked: No -> Yes<br/>', 2, '2024-04-08 12:51:42'),
(38, 'user_account', 4, 'Locked: Yes -> No<br/>', 2, '2024-04-08 12:51:44'),
(39, 'role_user_account', 1, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 14:52:18', 2, '2024-04-08 14:52:18'),
(40, 'role_user_account', 2, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: CGMI Bot<br/>Date Assigned: 2024-04-08 14:52:18', 2, '2024-04-08 14:52:18'),
(41, 'role_user_account', 3, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Christian Edward Baguisa<br/>Date Assigned: 2024-04-08 14:52:18', 2, '2024-04-08 14:52:18'),
(42, 'role_user_account', 4, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 15:13:40', 2, '2024-04-08 15:13:40'),
(43, 'role_user_account', 5, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: CGMI Bot<br/>Date Assigned: 2024-04-08 15:13:40', 2, '2024-04-08 15:13:40'),
(44, 'role_user_account', 6, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Christian Edward Baguisa<br/>Date Assigned: 2024-04-08 15:13:40', 2, '2024-04-08 15:13:40'),
(45, 'role_user_account', 7, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 15:25:00', 2, '2024-04-08 15:25:00'),
(46, 'role_user_account', 8, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:24:28', 2, '2024-04-08 16:24:28'),
(47, 'role_user_account', 9, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:24:28', 2, '2024-04-08 16:24:28'),
(48, 'role_user_account', 10, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:25:38', 2, '2024-04-08 16:25:38'),
(49, 'role_user_account', 11, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:25:38', 2, '2024-04-08 16:25:38'),
(50, 'role_user_account', 12, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:26:02', 2, '2024-04-08 16:26:02'),
(51, 'role_user_account', 13, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:26:02', 2, '2024-04-08 16:26:02'),
(52, 'role_user_account', 14, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:29:30', 2, '2024-04-08 16:29:30'),
(53, 'role_user_account', 15, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:29:30', 2, '2024-04-08 16:29:30'),
(54, 'role_user_account', 16, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:31:48', 2, '2024-04-08 16:31:48'),
(55, 'role_user_account', 17, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:31:59', 2, '2024-04-08 16:31:59'),
(56, 'role_user_account', 18, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:31:59', 2, '2024-04-08 16:31:59'),
(57, 'role_user_account', 19, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:31:59', 2, '2024-04-08 16:31:59'),
(58, 'role_user_account', 20, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:31:59', 2, '2024-04-08 16:31:59'),
(59, 'role_user_account', 21, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:32:09', 2, '2024-04-08 16:32:09'),
(60, 'role_user_account', 22, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:32:09', 2, '2024-04-08 16:32:09'),
(61, 'role_user_account', 23, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:41:08', 2, '2024-04-08 16:41:08'),
(62, 'role_user_account', 24, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:41:14', 2, '2024-04-08 16:41:14'),
(63, 'role_user_account', 25, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:41:14', 2, '2024-04-08 16:41:14'),
(64, 'role_user_account', 26, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:41:27', 2, '2024-04-08 16:41:27'),
(65, 'role_user_account', 27, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:41:27', 2, '2024-04-08 16:41:27'),
(66, 'role_user_account', 28, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:42:02', 2, '2024-04-08 16:42:02'),
(67, 'role_user_account', 29, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:42:16', 2, '2024-04-08 16:42:16'),
(68, 'role_user_account', 30, 'Role user account created. <br/><br/>Role Name: Human Resources<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:42:27', 2, '2024-04-08 16:42:27'),
(69, 'role_user_account', 31, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:42:51', 2, '2024-04-08 16:42:51'),
(70, 'role_user_account', 32, 'Role user account created. <br/><br/>Role Name: Sales Proposal Approver<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:42:55', 2, '2024-04-08 16:42:55'),
(71, 'role_user_account', 33, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:04', 2, '2024-04-08 16:43:04'),
(72, 'role_user_account', 34, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:07', 2, '2024-04-08 16:43:07'),
(73, 'role_user_account', 35, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:07', 2, '2024-04-08 16:43:07'),
(74, 'role_user_account', 36, 'Role user account created. <br/><br/>Role Name: Human Resources<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:07', 2, '2024-04-08 16:43:07'),
(75, 'role_user_account', 37, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:07', 2, '2024-04-08 16:43:07'),
(76, 'role_user_account', 38, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:07', 2, '2024-04-08 16:43:07'),
(77, 'role_user_account', 39, 'Role user account created. <br/><br/>Role Name: Sales Proposal Approver<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:07', 2, '2024-04-08 16:43:07'),
(78, 'role_user_account', 40, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:22', 2, '2024-04-08 16:43:22'),
(79, 'role_user_account', 41, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:43:22', 2, '2024-04-08 16:43:22'),
(80, 'role_user_account', 42, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:50:07', 2, '2024-04-08 16:50:07'),
(81, 'role_user_account', 43, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:50:07', 2, '2024-04-08 16:50:07'),
(82, 'role_user_account', 44, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:52:55', 2, '2024-04-08 16:52:55'),
(83, 'role_user_account', 45, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:52:55', 2, '2024-04-08 16:52:55'),
(84, 'role_user_account', 46, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:23', 2, '2024-04-08 16:53:23'),
(85, 'role_user_account', 47, 'Role user account created. <br/><br/>Role Name: Human Resources<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:26', 2, '2024-04-08 16:53:26'),
(86, 'role_user_account', 48, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:28', 2, '2024-04-08 16:53:28'),
(87, 'role_user_account', 49, 'Role user account created. <br/><br/>Role Name: Sales Proposal Approver<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:31', 2, '2024-04-08 16:53:31'),
(88, 'role_user_account', 50, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:34', 2, '2024-04-08 16:53:34'),
(89, 'role_user_account', 51, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:36', 2, '2024-04-08 16:53:36'),
(90, 'role_user_account', 52, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:39', 2, '2024-04-08 16:53:39'),
(91, 'role_user_account', 53, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:53:56', 2, '2024-04-08 16:53:56'),
(92, 'role_user_account', 54, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:54:31', 2, '2024-04-08 16:54:31'),
(93, 'role_user_account', 55, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:54:35', 2, '2024-04-08 16:54:35'),
(94, 'role_user_account', 56, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:54:39', 2, '2024-04-08 16:54:39'),
(95, 'role_user_account', 57, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:54:39', 2, '2024-04-08 16:54:39'),
(96, 'role_user_account', 58, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 16:54:47', 2, '2024-04-08 16:54:47'),
(97, 'role_user_account', 59, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:00:22', 2, '2024-04-08 17:00:22'),
(98, 'role_user_account', 60, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:00:22', 2, '2024-04-08 17:00:22'),
(99, 'role_user_account', 61, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:00:31', 2, '2024-04-08 17:00:31'),
(100, 'role_user_account', 62, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:00:31', 2, '2024-04-08 17:00:31'),
(101, 'role_user_account', 63, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:00:38', 2, '2024-04-08 17:00:38'),
(102, 'role_user_account', 64, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(103, 'role_user_account', 65, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(104, 'role_user_account', 66, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(105, 'role_user_account', 67, 'Role user account created. <br/><br/>Role Name: Human Resources<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(106, 'role_user_account', 68, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(107, 'role_user_account', 69, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(108, 'role_user_account', 70, 'Role user account created. <br/><br/>Role Name: Sales Proposal Approver<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:33', 2, '2024-04-08 17:04:33'),
(109, 'role_user_account', 71, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:48', 2, '2024-04-08 17:04:48'),
(110, 'role_user_account', 72, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:52', 2, '2024-04-08 17:04:52'),
(111, 'role_user_account', 73, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(112, 'role_user_account', 74, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(113, 'role_user_account', 75, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(114, 'role_user_account', 76, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(115, 'role_user_account', 77, 'Role user account created. <br/><br/>Role Name: Human Resources<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(116, 'role_user_account', 78, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(117, 'role_user_account', 79, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(118, 'role_user_account', 80, 'Role user account created. <br/><br/>Role Name: Sales Proposal Approver<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:04:59', 2, '2024-04-08 17:04:59'),
(119, 'role_user_account', 81, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:08:34', 2, '2024-04-08 17:08:34'),
(120, 'role_user_account', 82, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:08:40', 2, '2024-04-08 17:08:40'),
(121, 'role_user_account', 83, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:08:50', 2, '2024-04-08 17:08:50'),
(122, 'role_user_account', 84, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-08 17:08:55', 2, '2024-04-08 17:08:55'),
(123, 'user_account', 2, 'Last Connection Date: 2024-04-08 09:44:01 -> 2024-04-11 11:49:08<br/>', 1, '2024-04-11 11:49:08'),
(124, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:37:40'),
(125, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:02'),
(126, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:03'),
(127, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:03'),
(128, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:03'),
(129, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:03'),
(130, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:04'),
(131, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:04'),
(132, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:04'),
(133, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:04'),
(134, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:04'),
(135, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:05'),
(136, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:05'),
(137, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:05'),
(138, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:05'),
(139, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:06'),
(140, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:06'),
(141, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:06'),
(142, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:07'),
(143, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:08'),
(144, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:08'),
(145, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:08'),
(146, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:09'),
(147, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:09'),
(148, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:10'),
(149, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:10'),
(150, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:10'),
(151, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:11'),
(152, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:11'),
(153, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:40:11'),
(154, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:40:12'),
(155, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-11 15:48:56'),
(156, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-04-11 15:48:58'),
(157, 'user_account', 2, 'Multiple Session: Yes -> No<br/>', 2, '2024-04-11 15:49:40'),
(158, 'user_account', 2, 'Multiple Session: No -> Yes<br/>', 2, '2024-04-11 15:49:40'),
(159, 'user_account', 2, 'Multiple Session: Yes -> No<br/>', 2, '2024-04-11 15:49:40'),
(160, 'user_account', 2, 'Multiple Session: No -> Yes<br/>', 2, '2024-04-11 15:49:40'),
(161, 'user_account', 2, 'Multiple Session: Yes -> No<br/>', 2, '2024-04-11 15:49:41'),
(162, 'user_account', 2, 'Last Connection Date: 2024-04-11 11:49:08 -> 2024-04-11 16:13:51<br/>', 2, '2024-04-11 16:13:51'),
(163, 'user_account', 2, 'Last Connection Date: 2024-04-11 16:13:51 -> 2024-04-11 16:27:02<br/>', 2, '2024-04-11 16:27:02'),
(164, 'user_account', 2, 'Last Connection Date: 2024-04-11 16:27:02 -> 2024-04-11 16:28:26<br/>', 2, '2024-04-11 16:28:26'),
(165, 'user_account', 2, 'Last Connection Date: 2024-04-11 16:28:26 -> 2024-04-11 16:35:31<br/>', 2, '2024-04-11 16:35:31'),
(166, 'user_account', 2, 'Last Connection Date: 2024-04-11 16:35:31 -> 2024-04-12 08:35:47<br/>', 2, '2024-04-12 08:35:47'),
(167, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-04-12 08:48:05'),
(168, 'user_account', 2, 'Multiple Session: No -> Yes<br/>', 2, '2024-04-12 08:48:06'),
(169, 'role_user_account', 85, 'Role user account created. <br/><br/>Role Name: Accounting<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(170, 'role_user_account', 86, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(171, 'role_user_account', 87, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(172, 'role_user_account', 88, 'Role user account created. <br/><br/>Role Name: Human Resources<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(173, 'role_user_account', 89, 'Role user account created. <br/><br/>Role Name: Manager<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(174, 'role_user_account', 90, 'Role user account created. <br/><br/>Role Name: Sales<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(175, 'role_user_account', 91, 'Role user account created. <br/><br/>Role Name: Sales Proposal Approver<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:52:46', 2, '2024-04-12 08:52:46'),
(176, 'role_user_account', 92, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:53:00', 2, '2024-04-12 08:53:00'),
(177, 'role_user_account', 93, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 08:53:09', 2, '2024-04-12 08:53:09'),
(178, 'role_user_account', 94, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 09:49:02', 2, '2024-04-12 09:49:02'),
(179, 'role_user_account', 95, 'Role user account created. <br/><br/>Role Name: Employee<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 09:49:02', 2, '2024-04-12 09:49:02'),
(180, 'user_account', 4, 'Locked: No -> Yes<br/>', 2, '2024-04-12 10:44:54'),
(181, 'user_account', 4, 'Active: Yes -> No<br/>', 2, '2024-04-12 10:55:07'),
(182, 'user_account', 4, 'Active: No -> Yes<br/>', 2, '2024-04-12 10:55:12'),
(183, 'user_account', 2, 'Active: Yes -> No<br/>', 2, '2024-04-12 10:55:18'),
(184, 'user_account', 2, 'Active: No -> Yes<br/>', 2, '2024-04-12 10:56:36'),
(185, 'user_account', 2, 'Last Connection Date: 2024-04-12 08:35:47 -> 2024-04-12 10:56:44<br/>', 2, '2024-04-12 10:56:44'),
(186, 'user_account', 1, 'Active: Yes -> No<br/>', 2, '2024-04-12 11:02:30'),
(187, 'user_account', 4, 'Active: Yes -> No<br/>', 2, '2024-04-12 11:02:30'),
(188, 'user_account', 1, 'Active: No -> Yes<br/>', 2, '2024-04-12 11:02:33'),
(189, 'user_account', 4, 'Active: No -> Yes<br/>', 2, '2024-04-12 11:02:33'),
(190, 'user_account', 1, 'Locked: No -> Yes<br/>', 2, '2024-04-12 11:02:36'),
(191, 'user_account', 1, 'Locked: Yes -> No<br/>', 2, '2024-04-12 11:02:46'),
(192, 'user_account', 4, 'Locked: Yes -> No<br/>', 2, '2024-04-12 11:02:46'),
(193, 'menu_group', 1, 'Menu group created. <br/><br/>Menu Group Name: Technical<br/>Order Sequence: 127', 2, '2024-04-12 14:05:12'),
(194, 'menu_item', 1, 'Menu Item created. <br/><br/>Menu Item Name: User Interface<br/>Menu Group: Technical<br/>Menu Item Icon: ti ti-layout<br/>Order Sequence: 13', 2, '2024-04-12 14:25:09'),
(195, 'role', 1, 'Role created. <br/><br/>Role Name: Administrator<br/>Role Description: Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', 1, '2024-04-12 14:25:49'),
(196, 'role', 2, 'Role created. <br/><br/>Role Name: Manager<br/>Role Description: Access to manage specific aspects of the system or resources related to their teams or departments.', 1, '2024-04-12 14:25:49'),
(197, 'role', 3, 'Role created. <br/><br/>Role Name: Employee<br/>Role Description: The typical user account with standard access to use the system features and functionalities.', 1, '2024-04-12 14:25:49'),
(198, 'role', 4, 'Role created. <br/><br/>Role Name: Human Resources<br/>Role Description: Access to manage HR-related functionalities and employee data.', 1, '2024-04-12 14:25:49'),
(199, 'role', 5, 'Role created. <br/><br/>Role Name: Sales Proposal Approver<br/>Role Description: Access to approve or reject requests and transactions.', 1, '2024-04-12 14:25:49'),
(200, 'role', 6, 'Role created. <br/><br/>Role Name: Accounting<br/>Role Description: Access to financial and accounting-related functionalities.', 1, '2024-04-12 14:25:50'),
(201, 'role', 7, 'Role created. <br/><br/>Role Name: Sales<br/>Role Description: Access to sales-related functionalities and customer management.', 1, '2024-04-12 14:25:50'),
(202, 'role_permission', 1, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: User Interface<br/>Date Assigned: 2024-04-12 14:26:03', 2, '2024-04-12 14:26:03'),
(203, 'role_permission', 1, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 14:26:05'),
(204, 'menu_item', 2, 'Menu Item created. <br/><br/>Menu Item Name: Menu Group<br/>Menu Item URL: menu-group.php<br/>Menu Group: Technical<br/>Parent: User Interface<br/>Order Sequence: 13', 2, '2024-04-12 14:31:55'),
(205, 'role_permission', 2, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Menu Group<br/>Date Assigned: 2024-04-12 14:32:02', 2, '2024-04-12 14:32:02'),
(206, 'role_permission', 2, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 14:32:03'),
(207, 'role_permission', 2, 'Create Access: 0 -> 1<br/>', 2, '2024-04-12 14:32:04'),
(208, 'role_permission', 2, 'Write Access: 0 -> 1<br/>', 2, '2024-04-12 14:32:05'),
(209, 'role_permission', 2, 'Delete Access: 0 -> 1<br/>', 2, '2024-04-12 14:32:05'),
(210, 'menu_item', 1, 'Order Sequence: 13 -> 21<br/>', 2, '2024-04-12 15:09:25'),
(211, 'menu_item', 3, 'Menu Item created. <br/><br/>Menu Item Name: Menu Item<br/>Menu Item URL: menu-item.php<br/>Menu Group: Technical<br/>Parent: User Interface<br/>Order Sequence: 13', 2, '2024-04-12 15:10:18'),
(212, 'menu_item', 4, 'Menu Item created. <br/><br/>Menu Item Name: System Action<br/>Menu Item URL: system-action.php<br/>Menu Group: Technical<br/>Parent: User Interface<br/>Order Sequence: 19', 2, '2024-04-12 15:24:01'),
(213, 'menu_group', 2, 'Menu group created. <br/><br/>Menu Group Name: Administration<br/>Order Sequence: 100', 2, '2024-04-12 15:26:12'),
(214, 'menu_item', 5, 'Menu Item created. <br/><br/>Menu Item Name: Users &amp; Companies<br/>Menu Group: Administration<br/>Menu Item Icon: ti ti-users<br/>Order Sequence: 21', 2, '2024-04-12 15:28:16'),
(215, 'role_permission', 3, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Users &amp; Companies<br/>Date Assigned: 2024-04-12 15:28:21', 2, '2024-04-12 15:28:21'),
(216, 'role_permission', 3, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:23'),
(217, 'role_permission', 4, 'Role permission created. <br/><br/>Role Name: Employee<br/>Menu Item Name: Menu Item<br/>Date Assigned: 2024-04-12 15:28:32', 2, '2024-04-12 15:28:32'),
(218, 'role_permission', 4, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:34'),
(219, 'role_permission', 4, 'Create Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:35'),
(220, 'role_permission', 4, 'Write Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:36'),
(221, 'role_permission', 4, 'Delete Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:36'),
(222, 'role_permission', 5, 'Role permission created. <br/><br/>Role Name: Employee<br/>Menu Item Name: System Action<br/>Date Assigned: 2024-04-12 15:28:48', 2, '2024-04-12 15:28:48'),
(223, 'role_permission', 5, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:51'),
(224, 'role_permission', 5, 'Create Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:51'),
(225, 'role_permission', 5, 'Write Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:52'),
(226, 'role_permission', 5, 'Delete Access: 0 -> 1<br/>', 2, '2024-04-12 15:28:53'),
(227, 'role_permission', 3, 'Menu Item: Users &amp; Companies -> Users & Companies<br/>', 2, '2024-04-12 15:33:16'),
(228, 'menu_item', 5, 'Menu Item Name: Users &amp; Companies -> Users & Companies<br/>', 2, '2024-04-12 15:33:16'),
(229, 'menu_item', 6, 'Menu Item created. <br/><br/>Menu Item Name: User Account<br/>Menu Item URL: user-account.php<br/>Menu Group: Administration<br/>Parent: Users & Companies<br/>Order Sequence: 21', 2, '2024-04-12 15:37:20'),
(230, 'role_user_account', 1, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-04-12 16:08:26', 2, '2024-04-12 16:08:26'),
(231, 'role_permission', 6, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Menu Item<br/>Date Assigned: 2024-04-12 16:21:22', 2, '2024-04-12 16:21:22'),
(232, 'role_permission', 6, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 16:21:24'),
(233, 'role_permission', 6, 'Create Access: 0 -> 1<br/>', 2, '2024-04-12 16:21:25'),
(234, 'role_permission', 6, 'Write Access: 0 -> 1<br/>', 2, '2024-04-12 16:21:26'),
(235, 'role_permission', 6, 'Delete Access: 0 -> 1<br/>', 2, '2024-04-12 16:21:27'),
(236, 'role_permission', 7, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: User Account<br/>Date Assigned: 2024-04-12 17:01:56', 2, '2024-04-12 17:01:56'),
(237, 'role_permission', 7, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 17:01:58'),
(238, 'role_permission', 7, 'Create Access: 0 -> 1<br/>', 2, '2024-04-12 17:01:59'),
(239, 'role_permission', 7, 'Write Access: 0 -> 1<br/>', 2, '2024-04-12 17:01:59'),
(240, 'role_permission', 7, 'Delete Access: 0 -> 1<br/>', 2, '2024-04-12 17:02:00'),
(241, 'role_permission', 8, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: System Action<br/>Date Assigned: 2024-04-12 17:18:42', 2, '2024-04-12 17:18:42'),
(242, 'role_permission', 8, 'Read Access: 0 -> 1<br/>', 2, '2024-04-12 17:18:43'),
(243, 'role_permission', 8, 'Create Access: 0 -> 1<br/>', 2, '2024-04-12 17:18:43'),
(244, 'role_permission', 8, 'Write Access: 0 -> 1<br/>', 2, '2024-04-12 17:18:44'),
(245, 'role_permission', 8, 'Delete Access: 0 -> 1<br/>', 2, '2024-04-12 17:18:45');

-- --------------------------------------------------------

--
-- Table structure for table `email_setting`
--

CREATE TABLE `email_setting` (
  `email_setting_id` int(10) UNSIGNED NOT NULL,
  `email_setting_name` varchar(100) NOT NULL,
  `email_setting_description` varchar(200) NOT NULL,
  `mail_host` varchar(100) NOT NULL,
  `port` int(11) NOT NULL,
  `smtp_auth` int(1) NOT NULL,
  `smtp_auto_tls` int(1) NOT NULL,
  `mail_username` varchar(200) NOT NULL,
  `mail_password` varchar(250) NOT NULL,
  `mail_encryption` varchar(20) DEFAULT NULL,
  `mail_from_name` varchar(200) DEFAULT NULL,
  `mail_from_email` varchar(200) DEFAULT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `email_setting`
--

INSERT INTO `email_setting` (`email_setting_id`, `email_setting_name`, `email_setting_description`, `mail_host`, `port`, `smtp_auth`, `smtp_auto_tls`, `mail_username`, `mail_password`, `mail_encryption`, `mail_from_name`, `mail_from_email`, `last_log_by`) VALUES
(1, 'Security Email Setting', '\r\nEmail setting for security emails.', 'smtp.hostinger.com', 465, 1, 0, 'cgmi-noreply@christianmotors.ph', 'UsDpF0dYRC6M9v0tT3MHq%2BlrRJu01%2Fb95Dq%2BAeCfu2Y%3D', 'ssl', 'cgmi-noreply@christianmotors.ph', 'cgmi-noreply@christianmotors.ph', 1);

-- --------------------------------------------------------

--
-- Table structure for table `menu_group`
--

CREATE TABLE `menu_group` (
  `menu_group_id` int(10) UNSIGNED NOT NULL,
  `menu_group_name` varchar(100) NOT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_group`
--

INSERT INTO `menu_group` (`menu_group_id`, `menu_group_name`, `order_sequence`, `last_log_by`) VALUES
(1, 'Technical', 127, 2),
(2, 'Administration', 100, 2);

--
-- Triggers `menu_group`
--
DELIMITER $$
CREATE TRIGGER `menu_group_trigger_insert` AFTER INSERT ON `menu_group` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Menu group created. <br/>';

    IF NEW.menu_group_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Group Name: ", NEW.menu_group_name);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('menu_group', NEW.menu_group_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `menu_group_trigger_update` AFTER UPDATE ON `menu_group` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.menu_group_name <> OLD.menu_group_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Group Name: ", OLD.menu_group_name, " -> ", NEW.menu_group_name, "<br/>");
    END IF;

    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('menu_group', NEW.menu_group_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `menu_item`
--

CREATE TABLE `menu_item` (
  `menu_item_id` int(10) UNSIGNED NOT NULL,
  `menu_item_name` varchar(100) NOT NULL,
  `menu_item_url` varchar(50) DEFAULT NULL,
  `menu_group_id` int(11) NOT NULL,
  `menu_group_name` varchar(100) NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_name` varchar(100) DEFAULT NULL,
  `menu_item_icon` varchar(50) DEFAULT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_item`
--

INSERT INTO `menu_item` (`menu_item_id`, `menu_item_name`, `menu_item_url`, `menu_group_id`, `menu_group_name`, `parent_id`, `parent_name`, `menu_item_icon`, `order_sequence`, `last_log_by`) VALUES
(1, 'User Interface', '', 1, 'Technical', NULL, NULL, 'ti ti-layout', 21, 2),
(2, 'Menu Group', 'menu-group.php', 1, 'Technical', 1, 'User Interface', '', 13, 2),
(3, 'Menu Item', 'menu-item.php', 1, 'Technical', 1, 'User Interface', '', 13, 2),
(4, 'System Action', 'system-action.php', 1, 'Technical', 1, 'User Interface', '', 19, 2),
(5, 'Users & Companies', '', 2, 'Administration', NULL, NULL, 'ti ti-users', 21, 2),
(6, 'User Account', 'user-account.php', 2, 'Administration', 5, 'Users & Companies', '', 21, 2);

--
-- Triggers `menu_item`
--
DELIMITER $$
CREATE TRIGGER `menu_item_trigger_insert` AFTER INSERT ON `menu_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Menu Item created. <br/>';

    IF NEW.menu_item_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Name: ", NEW.menu_item_name);
    END IF;

    IF NEW.menu_item_url <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item URL: ", NEW.menu_item_url);
    END IF;

    IF NEW.menu_group_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Group: ", NEW.menu_group_name);
    END IF;

    IF NEW.parent_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Parent: ", NEW.parent_name);
    END IF;

    IF NEW.menu_item_icon <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Icon: ", NEW.menu_item_icon);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('menu_item', NEW.menu_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `menu_item_trigger_update` AFTER UPDATE ON `menu_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.menu_item_name <> OLD.menu_item_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Item Name: ", OLD.menu_item_name, " -> ", NEW.menu_item_name, "<br/>");
    END IF;

    IF NEW.menu_item_url <> OLD.menu_item_url THEN
        SET audit_log = CONCAT(audit_log, "Menu Item URL: ", OLD.menu_item_url, " -> ", NEW.menu_item_url, "<br/>");
    END IF;

    IF NEW.menu_group_name <> OLD.menu_group_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Group: ", OLD.menu_group_name, " -> ", NEW.menu_group_name, "<br/>");
    END IF;

    IF NEW.parent_name <> OLD.parent_name THEN
        SET audit_log = CONCAT(audit_log, "Parent: ", OLD.parent_name, " -> ", NEW.parent_name, "<br/>");
    END IF;

    IF NEW.menu_item_icon <> OLD.menu_item_icon THEN
        SET audit_log = CONCAT(audit_log, "Menu Item Icon: ", OLD.menu_item_icon, " -> ", NEW.menu_item_icon, "<br/>");
    END IF;

    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('menu_item', NEW.menu_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting`
--

CREATE TABLE `notification_setting` (
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `notification_setting_name` varchar(100) NOT NULL,
  `notification_setting_description` varchar(200) NOT NULL,
  `system_notification` int(1) NOT NULL DEFAULT 1,
  `email_notification` int(1) NOT NULL DEFAULT 0,
  `sms_notification` int(1) NOT NULL DEFAULT 0,
  `system_notification_title` varchar(200) DEFAULT NULL,
  `system_notification_message` varchar(200) DEFAULT NULL,
  `email_notification_subject` varchar(200) DEFAULT NULL,
  `email_notification_body` longtext DEFAULT NULL,
  `sms_notification_message` varchar(500) DEFAULT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_setting`
--

INSERT INTO `notification_setting` (`notification_setting_id`, `notification_setting_name`, `notification_setting_description`, `system_notification`, `email_notification`, `sms_notification`, `system_notification_title`, `system_notification_message`, `email_notification_subject`, `email_notification_body`, `sms_notification_message`, `last_log_by`) VALUES
(1, 'Login OTP', 'Notification setting for Login OTP received by the users.', 0, 1, 0, NULL, NULL, 'Login OTP - Secure Access to Your Account', '<p>To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:</p>\r\n<p>OTP: <strong>{OTP_CODE}</strong></p>\r\n<p>Please note that this OTP is valid for &lt;strong&gt;5 minutes&lt;/strong&gt;. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.</p>\r\n<p>If you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\r\n<p>&nbsp;</p>\r\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', NULL, 1),
(2, 'Forgot Password', 'Notification setting when the user initiates forgot password.', 0, 1, 0, NULL, NULL, 'Password Reset Request - Action Required', '<p>We have received a request to reset your password. To ensure the security of your account, please follow the instructions below:</p>\r\n<p>1. Click on the link below to reset your password:</p>\r\n<p><a href=\"{RESET_LINK}\"><strong>Reset Password</strong></a></p>\r\n<p>2. If the button does not work, you can copy and paste the following link into your browser\'s address bar:</p>\r\n<p><strong>{RESET_LINK}</strong></p>\r\n<p>Please note that this link is time-sensitive and will expire after <strong>{RESET_DURATION} minutes</strong>. If you do not reset your password within this timeframe, you may need to request another password reset.</p>\r\n<p>If you did not initiate this password reset request or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\r\n<p>&nbsp;</p>\r\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

CREATE TABLE `password_history` (
  `password_history_id` int(10) UNSIGNED NOT NULL,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `password_change_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `password_history`
--

INSERT INTO `password_history` (`password_history_id`, `user_account_id`, `email`, `password`, `password_change_date`) VALUES
(2, 4, 'test@gmail.com', '5RvsHIk1NKOcqYF7%2BUiM7sdELANPUQCIy5iMNS9e47o%3D', '2024-04-05 16:17:37'),
(3, 4, 'benidickbelizario@christianmotors.ph', 'uAEQIiQf%2FwUa2hVPV89U4PlGBkD%2FtS9pBdl4RB4CVi0%3D', '2024-04-08 12:24:25');

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `role_description` varchar(200) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`role_id`, `role_name`, `role_description`, `last_log_by`) VALUES
(1, 'Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', 1),
(2, 'Manager', 'Access to manage specific aspects of the system or resources related to their teams or departments.', 1),
(3, 'Employee', 'The typical user account with standard access to use the system features and functionalities.', 1),
(4, 'Human Resources', 'Access to manage HR-related functionalities and employee data.', 1),
(5, 'Sales Proposal Approver', 'Access to approve or reject requests and transactions.', 1),
(6, 'Accounting', 'Access to financial and accounting-related functionalities.', 1),
(7, 'Sales', 'Access to sales-related functionalities and customer management.', 1);

--
-- Triggers `role`
--
DELIMITER $$
CREATE TRIGGER `role_trigger_insert` AFTER INSERT ON `role` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.role_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Description: ", NEW.role_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role', NEW.role_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `role_trigger_update` AFTER UPDATE ON `role` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.role_description <> OLD.role_description THEN
        SET audit_log = CONCAT(audit_log, "Role Description: ", OLD.role_description, " -> ", NEW.role_description, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role', NEW.role_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

CREATE TABLE `role_permission` (
  `role_permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `menu_item_id` int(10) UNSIGNED NOT NULL,
  `menu_item_name` varchar(100) NOT NULL,
  `read_access` tinyint(1) NOT NULL DEFAULT 0,
  `write_access` tinyint(1) NOT NULL DEFAULT 0,
  `create_access` tinyint(1) NOT NULL DEFAULT 0,
  `delete_access` tinyint(1) NOT NULL DEFAULT 0,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`role_permission_id`, `role_id`, `role_name`, `menu_item_id`, `menu_item_name`, `read_access`, `write_access`, `create_access`, `delete_access`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'Administrator', 1, 'User Interface', 1, 0, 0, 0, '2024-04-12 14:26:03', 2),
(2, 1, 'Administrator', 2, 'Menu Group', 1, 1, 1, 1, '2024-04-12 14:32:02', 2),
(3, 1, 'Administrator', 5, 'Users & Companies', 1, 0, 0, 0, '2024-04-12 15:28:21', 2),
(6, 1, 'Administrator', 3, 'Menu Item', 1, 1, 1, 1, '2024-04-12 16:21:22', 2),
(7, 1, 'Administrator', 6, 'User Account', 1, 1, 1, 1, '2024-04-12 17:01:56', 2),
(8, 1, 'Administrator', 4, 'System Action', 1, 1, 1, 1, '2024-04-12 17:18:42', 2);

--
-- Triggers `role_permission`
--
DELIMITER $$
CREATE TRIGGER `role_permission_trigger_insert` AFTER INSERT ON `role_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role permission created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.menu_item_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Name: ", NEW.menu_item_name);
    END IF;

    IF NEW.read_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Read Access: ", NEW.read_access);
    END IF;

    IF NEW.write_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Write Access: ", NEW.write_access);
    END IF;

    IF NEW.create_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Create Access: ", NEW.create_access);
    END IF;

    IF NEW.delete_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Delete Access: ", NEW.delete_access);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role_permission', NEW.role_permission_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `role_permission_trigger_update` AFTER UPDATE ON `role_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.menu_item_name <> OLD.menu_item_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Item: ", OLD.menu_item_name, " -> ", NEW.menu_item_name, "<br/>");
    END IF;

    IF NEW.read_access <> OLD.read_access THEN
        SET audit_log = CONCAT(audit_log, "Read Access: ", OLD.read_access, " -> ", NEW.read_access, "<br/>");
    END IF;

    IF NEW.write_access <> OLD.write_access THEN
        SET audit_log = CONCAT(audit_log, "Write Access: ", OLD.write_access, " -> ", NEW.write_access, "<br/>");
    END IF;

    IF NEW.create_access <> OLD.create_access THEN
        SET audit_log = CONCAT(audit_log, "Create Access: ", OLD.create_access, " -> ", NEW.create_access, "<br/>");
    END IF;

    IF NEW.delete_access <> OLD.delete_access THEN
        SET audit_log = CONCAT(audit_log, "Delete Access: ", OLD.delete_access, " -> ", NEW.delete_access, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role_permission', NEW.role_permission_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `role_system_action_permission`
--

CREATE TABLE `role_system_action_permission` (
  `role_system_action_permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `system_action_id` int(10) UNSIGNED NOT NULL,
  `system_action_name` varchar(100) NOT NULL,
  `system_action_access` tinyint(1) NOT NULL DEFAULT 0,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `role_system_action_permission`
--
DELIMITER $$
CREATE TRIGGER `role_system_action_permission_trigger_insert` AFTER INSERT ON `role_system_action_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role system action permission created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.system_action_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Name: ", NEW.system_action_name);
    END IF;

    IF NEW.system_action_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Access: ", NEW.system_action_access);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role_system_action_permission', NEW.role_system_action_permission_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `role_system_action_permission_trigger_update` AFTER UPDATE ON `role_system_action_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.system_action_name <> OLD.system_action_name THEN
        SET audit_log = CONCAT(audit_log, "System Action: ", OLD.system_action_name, " -> ", NEW.system_action_name, "<br/>");
    END IF;

    IF NEW.system_action_access <> OLD.system_action_access THEN
        SET audit_log = CONCAT(audit_log, "System Action Access: ", OLD.system_action_access, " -> ", NEW.system_action_access, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role_system_action_permission', NEW.role_system_action_permission_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `role_user_account`
--

CREATE TABLE `role_user_account` (
  `role_user_account_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `file_as` varchar(300) NOT NULL,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_user_account`
--

INSERT INTO `role_user_account` (`role_user_account_id`, `role_id`, `role_name`, `user_account_id`, `file_as`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'Administrator', 2, 'Administrator', '2024-04-12 16:08:26', 2);

--
-- Triggers `role_user_account`
--
DELIMITER $$
CREATE TRIGGER `role_user_account_trigger_insert` AFTER INSERT ON `role_user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role user account created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.file_as <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>User Account Name: ", NEW.file_as);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role_user_account', NEW.role_user_account_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `role_user_account_trigger_update` AFTER UPDATE ON `role_user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.file_as <> OLD.file_as THEN
        SET audit_log = CONCAT(audit_log, "User Account Name: ", OLD.file_as, " -> ", NEW.file_as, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role_user_account', NEW.role_user_account_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `security_setting`
--

CREATE TABLE `security_setting` (
  `security_setting_id` int(10) UNSIGNED NOT NULL,
  `security_setting_name` varchar(100) NOT NULL,
  `security_setting_description` varchar(200) NOT NULL,
  `value` varchar(1000) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `security_setting`
--

INSERT INTO `security_setting` (`security_setting_id`, `security_setting_name`, `security_setting_description`, `value`, `last_log_by`) VALUES
(1, 'Max Failed Login Attempt', 'This sets the maximum failed login attempt before the user is locked-out.', '5', 1),
(2, 'Max Failed OTP Attempt', 'This sets the maximum failed OTP attempt before the user is needs a new OTP code.', '5', 1),
(3, 'Default Forgot Password Link', 'This sets the default forgot password link.', 'http://localhost/modernize/password-reset.php?id=', 1),
(4, 'Password Expiry Duration', 'The duration after which user passwords expire (in days).', '180', 1),
(5, 'Session Timeout Duration', 'The duration after which a user is automatically logged out (in minutes).', '240', 1),
(6, 'OTP Duration', 'The time window during which a one-time password (OTP) is valid for user authentication (in minutes).', '5', 1),
(7, 'Reset Password Token Duration', 'The time window during which a reset password token remains valid for user account recovery (in minutes).', '10', 1);

-- --------------------------------------------------------

--
-- Table structure for table `system_action`
--

CREATE TABLE `system_action` (
  `system_action_id` int(10) UNSIGNED NOT NULL,
  `system_action_name` varchar(100) NOT NULL,
  `system_action_description` varchar(200) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `system_action`
--
DELIMITER $$
CREATE TRIGGER `system_action_trigger_insert` AFTER INSERT ON `system_action` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'System action created. <br/>';

    IF NEW.system_action_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Name: ", NEW.system_action_name);
    END IF;

    IF NEW.system_action_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Description: ", NEW.system_action_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('system_action', NEW.system_action_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `system_action_trigger_update` AFTER UPDATE ON `system_action` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.system_action_name <> OLD.system_action_name THEN
        SET audit_log = CONCAT(audit_log, "System Action Name: ", OLD.system_action_name, " -> ", NEW.system_action_name, "<br/>");
    END IF;

    IF NEW.system_action_description <> OLD.system_action_description THEN
        SET audit_log = CONCAT(audit_log, "System Action Description: ", OLD.system_action_description, " -> ", NEW.system_action_description, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('system_action', NEW.system_action_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

CREATE TABLE `user_account` (
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `file_as` varchar(300) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_picture` varchar(500) DEFAULT NULL,
  `locked` varchar(5) NOT NULL DEFAULT 'No',
  `active` varchar(5) NOT NULL DEFAULT 'No',
  `last_failed_login_attempt` datetime DEFAULT NULL,
  `failed_login_attempts` int(11) NOT NULL DEFAULT 0,
  `last_connection_date` datetime DEFAULT NULL,
  `password_expiry_date` date NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry_date` datetime DEFAULT NULL,
  `receive_notification` varchar(5) NOT NULL DEFAULT 'Yes',
  `two_factor_auth` varchar(5) NOT NULL DEFAULT 'Yes',
  `otp` varchar(255) DEFAULT NULL,
  `otp_expiry_date` datetime DEFAULT NULL,
  `failed_otp_attempts` int(11) NOT NULL DEFAULT 0,
  `last_password_change` datetime DEFAULT NULL,
  `account_lock_duration` int(11) NOT NULL DEFAULT 0,
  `last_password_reset` datetime DEFAULT NULL,
  `multiple_session` varchar(5) DEFAULT 'Yes',
  `session_token` varchar(255) DEFAULT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_account_id`, `file_as`, `email`, `password`, `profile_picture`, `locked`, `active`, `last_failed_login_attempt`, `failed_login_attempts`, `last_connection_date`, `password_expiry_date`, `reset_token`, `reset_token_expiry_date`, `receive_notification`, `two_factor_auth`, `otp`, `otp_expiry_date`, `failed_otp_attempts`, `last_password_change`, `account_lock_duration`, `last_password_reset`, `multiple_session`, `session_token`, `last_log_by`) VALUES
(1, 'CGMI Bot', 'cgmids@christianmotors.ph', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', NULL, 2),
(2, 'Administrator', 'lawrenceagulto.317@gmail.com', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, '2024-04-12 10:56:44', '2025-12-30', NULL, NULL, 'Yes', 'No', 'lIT0AN4gu3eEQZNQ4FYhayb83RUOCBEjxDrOx1Hns0U%3D', '2024-04-12 08:40:18', 0, NULL, 0, NULL, 'Yes', 'C5jBEk7R0AkSGVELgNH%2FOTZmS1U1PO2MFtITYxKHaPc%3D', 2),
(4, 'Christian Edward Baguisa', 'benidickbelizario@christianmotors.ph', 'uAEQIiQf%2FwUa2hVPV89U4PlGBkD%2FtS9pBdl4RB4CVi0%3D', NULL, 'No', 'Yes', NULL, 0, '2024-04-08 12:25:04', '2024-10-05', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, '2024-04-08 12:24:25', 0, NULL, 'Yes', 'hRIvgBlBnoCgxiTo4Jt8dXaKNW5S3CxtiJOpieNNrCM%3D', 2);

--
-- Triggers `user_account`
--
DELIMITER $$
CREATE TRIGGER `user_account_trigger_insert` AFTER INSERT ON `user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'User account created. <br/>';

    IF NEW.file_as <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File As: ", NEW.file_as);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.locked <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Locked: ", NEW.locked);
    END IF;

    IF NEW.active <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Active: ", NEW.active);
    END IF;

    IF NEW.last_failed_login_attempt <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Failed Login Attempt: ", NEW.last_failed_login_attempt);
    END IF;

    IF NEW.failed_login_attempts <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Failed Login Attempts: ", NEW.failed_login_attempts);
    END IF;

    IF NEW.last_connection_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Connection Date: ", NEW.last_connection_date);
    END IF;

    IF NEW.password_expiry_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Password Expiry Date: ", NEW.password_expiry_date);
    END IF;

    IF NEW.receive_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Receive Notification: ", NEW.receive_notification);
    END IF;

    IF NEW.two_factor_auth <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Two-Factor Authentication: ", NEW.two_factor_auth);
    END IF;

    IF NEW.last_password_change <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Password Change: ", NEW.last_password_change);
    END IF;

    IF NEW.last_password_reset <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Password Reset: ", NEW.last_password_reset);
    END IF;

    IF NEW.multiple_session <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Multiple Session: ", NEW.multiple_session);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('user_account', NEW.user_account_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `user_account_trigger_update` AFTER UPDATE ON `user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.file_as <> OLD.file_as THEN
        SET audit_log = CONCAT(audit_log, "File As: ", OLD.file_as, " -> ", NEW.file_as, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.locked <> OLD.locked THEN
        SET audit_log = CONCAT(audit_log, "Locked: ", OLD.locked, " -> ", NEW.locked, "<br/>");
    END IF;

    IF NEW.active <> OLD.active THEN
        SET audit_log = CONCAT(audit_log, "Active: ", OLD.active, " -> ", NEW.active, "<br/>");
    END IF;

    IF NEW.last_failed_login_attempt <> OLD.last_failed_login_attempt THEN
        SET audit_log = CONCAT(audit_log, "Last Failed Login Attempt: ", OLD.last_failed_login_attempt, " -> ", NEW.last_failed_login_attempt, "<br/>");
    END IF;

    IF NEW.failed_login_attempts <> OLD.failed_login_attempts THEN
        SET audit_log = CONCAT(audit_log, "Failed Login Attempts: ", OLD.failed_login_attempts, " -> ", NEW.failed_login_attempts, "<br/>");
    END IF;

    IF NEW.last_connection_date <> OLD.last_connection_date THEN
        SET audit_log = CONCAT(audit_log, "Last Connection Date: ", OLD.last_connection_date, " -> ", NEW.last_connection_date, "<br/>");
    END IF;

    IF NEW.password_expiry_date <> OLD.password_expiry_date THEN
        SET audit_log = CONCAT(audit_log, "Password Expiry Date: ", OLD.password_expiry_date, " -> ", NEW.password_expiry_date, "<br/>");
    END IF;

    IF NEW.receive_notification <> OLD.receive_notification THEN
        SET audit_log = CONCAT(audit_log, "Receive Notification: ", OLD.receive_notification, " -> ", NEW.receive_notification, "<br/>");
    END IF;

    IF NEW.two_factor_auth <> OLD.two_factor_auth THEN
        SET audit_log = CONCAT(audit_log, "Two-Factor Authentication: ", OLD.two_factor_auth, " -> ", NEW.two_factor_auth, "<br/>");
    END IF;

    IF NEW.last_password_change <> OLD.last_password_change THEN
        SET audit_log = CONCAT(audit_log, "Last Password Change: ", OLD.last_password_change, " -> ", NEW.last_password_change, "<br/>");
    END IF;

    IF NEW.last_password_reset <> OLD.last_password_reset THEN
        SET audit_log = CONCAT(audit_log, "Last Password Reset: ", OLD.last_password_reset, " -> ", NEW.last_password_reset, "<br/>");
    END IF;

    IF NEW.multiple_session <> OLD.multiple_session THEN
        SET audit_log = CONCAT(audit_log, "Multiple Session: ", OLD.multiple_session, " -> ", NEW.multiple_session, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('user_account', NEW.user_account_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`audit_log_id`),
  ADD KEY `audit_log_index_audit_log_id` (`audit_log_id`),
  ADD KEY `audit_log_index_table_name` (`table_name`),
  ADD KEY `audit_log_index_reference_id` (`reference_id`),
  ADD KEY `audit_log_index_changed_by` (`changed_by`);

--
-- Indexes for table `email_setting`
--
ALTER TABLE `email_setting`
  ADD PRIMARY KEY (`email_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `email_setting_index_email_setting_id` (`email_setting_id`);

--
-- Indexes for table `menu_group`
--
ALTER TABLE `menu_group`
  ADD PRIMARY KEY (`menu_group_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `menu_group_index_menu_group_id` (`menu_group_id`);

--
-- Indexes for table `menu_item`
--
ALTER TABLE `menu_item`
  ADD PRIMARY KEY (`menu_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `menu_item_index_menu_item_id` (`menu_item_id`),
  ADD KEY `menu_item_index_menu_group_id` (`menu_group_id`);

--
-- Indexes for table `notification_setting`
--
ALTER TABLE `notification_setting`
  ADD PRIMARY KEY (`notification_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `notification_setting_index_notification_setting_id` (`notification_setting_id`);

--
-- Indexes for table `password_history`
--
ALTER TABLE `password_history`
  ADD PRIMARY KEY (`password_history_id`),
  ADD KEY `password_history_index_password_history_id` (`password_history_id`),
  ADD KEY `password_history_index_user_account_id` (`user_account_id`),
  ADD KEY `password_history_index_email` (`email`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`role_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_index_role_id` (`role_id`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`role_permission_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_permission_index_role_permission_id` (`role_permission_id`),
  ADD KEY `role_permission_index_menu_item_id` (`menu_item_id`),
  ADD KEY `role_permission_index_role_id` (`role_id`);

--
-- Indexes for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  ADD PRIMARY KEY (`role_system_action_permission_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_system_action_permission_index_system_action_permission_id` (`role_system_action_permission_id`),
  ADD KEY `role_system_action_permission_index_system_action_id` (`system_action_id`),
  ADD KEY `role_system_action_permissionn_index_role_id` (`role_id`);

--
-- Indexes for table `role_user_account`
--
ALTER TABLE `role_user_account`
  ADD PRIMARY KEY (`role_user_account_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_user_account_index_role_user_account_id` (`role_user_account_id`),
  ADD KEY `role_user_account_permission_index_user_account_id` (`user_account_id`),
  ADD KEY `role_user_account_permissionn_index_role_id` (`role_id`);

--
-- Indexes for table `security_setting`
--
ALTER TABLE `security_setting`
  ADD PRIMARY KEY (`security_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `security_setting_index_security_setting_id` (`security_setting_id`);

--
-- Indexes for table `system_action`
--
ALTER TABLE `system_action`
  ADD PRIMARY KEY (`system_action_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `system_action_index_system_action_id` (`system_action_id`);

--
-- Indexes for table `user_account`
--
ALTER TABLE `user_account`
  ADD PRIMARY KEY (`user_account_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `user_account_index_user_account_id` (`user_account_id`),
  ADD KEY `user_account_index_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `audit_log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=246;

--
-- AUTO_INCREMENT for table `email_setting`
--
ALTER TABLE `email_setting`
  MODIFY `email_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `menu_group`
--
ALTER TABLE `menu_group`
  MODIFY `menu_group_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `menu_item`
--
ALTER TABLE `menu_item`
  MODIFY `menu_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `notification_setting`
--
ALTER TABLE `notification_setting`
  MODIFY `notification_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `password_history`
--
ALTER TABLE `password_history`
  MODIFY `password_history_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `role_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  MODIFY `role_system_action_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role_user_account`
--
ALTER TABLE `role_user_account`
  MODIFY `role_user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `security_setting`
--
ALTER TABLE `security_setting`
  MODIFY `security_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `system_action`
--
ALTER TABLE `system_action`
  MODIFY `system_action_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_account`
--
ALTER TABLE `user_account`
  MODIFY `user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`changed_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `email_setting`
--
ALTER TABLE `email_setting`
  ADD CONSTRAINT `email_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `menu_group`
--
ALTER TABLE `menu_group`
  ADD CONSTRAINT `menu_group_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `menu_item`
--
ALTER TABLE `menu_item`
  ADD CONSTRAINT `menu_item_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `notification_setting`
--
ALTER TABLE `notification_setting`
  ADD CONSTRAINT `notification_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `password_history`
--
ALTER TABLE `password_history`
  ADD CONSTRAINT `password_history_ibfk_1` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role`
--
ALTER TABLE `role`
  ADD CONSTRAINT `role_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `role_permission_ibfk_1` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_item` (`menu_item_id`),
  ADD CONSTRAINT `role_permission_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `role_permission_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  ADD CONSTRAINT `role_system_action_permission_ibfk_1` FOREIGN KEY (`system_action_id`) REFERENCES `system_action` (`system_action_id`),
  ADD CONSTRAINT `role_system_action_permission_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `role_system_action_permission_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role_user_account`
--
ALTER TABLE `role_user_account`
  ADD CONSTRAINT `role_user_account_ibfk_1` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `role_user_account_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `role_user_account_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `security_setting`
--
ALTER TABLE `security_setting`
  ADD CONSTRAINT `security_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `system_action`
--
ALTER TABLE `system_action`
  ADD CONSTRAINT `system_action_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `user_account`
--
ALTER TABLE `user_account`
  ADD CONSTRAINT `user_account_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
