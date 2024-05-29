-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 29, 2024 at 11:38 AM
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
DROP PROCEDURE IF EXISTS `buildMenuGroup`$$
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

DROP PROCEDURE IF EXISTS `buildMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildMenuItem` (IN `p_user_account_id` INT, IN `p_menu_group_id` INT)   BEGIN
    SELECT mi.menu_item_id, mi.menu_item_name, mi.menu_group_id, mi.menu_item_url, mi.parent_id, mi.menu_item_icon
    FROM menu_item AS mi
    INNER JOIN role_permission AS mar ON mi.menu_item_id = mar.menu_item_id
    INNER JOIN role_user_account AS ru ON mar.role_id = ru.role_id
    WHERE mar.read_access = 1 AND ru.user_account_id = p_user_account_id AND mi.menu_group_id = p_menu_group_id
    ORDER BY mi.order_sequence;
END$$

DROP PROCEDURE IF EXISTS `checkAccessRights`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAccessRights` (IN `p_user_account_id` INT, IN `p_menu_item_id` INT, IN `p_access_type` VARCHAR(10))   BEGIN
	IF p_access_type = 'read' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where read_access = 1 AND menu_item_id = p_menu_item_id);
    ELSEIF p_access_type = 'write' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where write_access = 1 AND menu_item_id = p_menu_item_id);
    ELSEIF p_access_type = 'create' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where create_access = 1 AND menu_item_id = p_menu_item_id);       
    ELSE
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where delete_access = 1 AND menu_item_id = p_menu_item_id);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `checkEmailNotificationTemplateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmailNotificationTemplateExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting_email_template
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmailSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmailSettingExist` (IN `p_email_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM email_setting
    WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkFileExtensionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkFileExtensionExist` (IN `p_file_extension_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM file_extension
    WHERE file_extension_id = p_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `checkFileTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkFileTypeExist` (IN `p_file_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM file_type
    WHERE file_type_id = p_file_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkLoginCredentialsExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLoginCredentialsExist` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

DROP PROCEDURE IF EXISTS `checkMenuGroupExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkMenuGroupExist` (IN `p_menu_group_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM menu_group
    WHERE menu_group_id = p_menu_group_id;
END$$

DROP PROCEDURE IF EXISTS `checkMenuItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkMenuItemExist` (IN `p_menu_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM menu_item
    WHERE menu_item_id = p_menu_item_id;
END$$

DROP PROCEDURE IF EXISTS `checkNotificationSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkNotificationSettingExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkRoleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleExist` (IN `p_role_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role
    WHERE role_id = p_role_id;
END$$

DROP PROCEDURE IF EXISTS `checkRolePermissionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRolePermissionExist` (IN `p_role_permission_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_permission
    WHERE role_permission_id = p_role_permission_id;
END$$

DROP PROCEDURE IF EXISTS `checkRoleSystemActionPermissionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleSystemActionPermissionExist` (IN `p_role_system_action_permission_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_system_action_permission
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

DROP PROCEDURE IF EXISTS `checkRoleUserAccountExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleUserAccountExist` (IN `p_role_user_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_user_account
    WHERE role_user_account_id = p_role_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkSecuritySettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSecuritySettingExist` (IN `p_security_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM security_setting
    WHERE security_setting_id = p_security_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkSMSNotificationTemplateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSMSNotificationTemplateExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting_sms_template
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkSystemActionAccessRights`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemActionAccessRights` (IN `p_user_account_id` INT, IN `p_system_action_id` INT)   BEGIN
    SELECT COUNT(role_id) AS total
    FROM role_system_action_permission 
    WHERE system_action_id = p_system_action_id AND system_action_access = 1 AND role_id IN (SELECT role_id FROM role_user_account WHERE user_account_id = p_user_account_id);
END$$

DROP PROCEDURE IF EXISTS `checkSystemActionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemActionExist` (IN `p_system_action_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM system_action
    WHERE system_action_id = p_system_action_id;
END$$

DROP PROCEDURE IF EXISTS `checkSystemNotificationTemplateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemNotificationTemplateExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting_system_template
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkSystemSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemSettingExist` (IN `p_system_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM system_setting
    WHERE system_setting_id = p_system_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkUploadSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUploadSettingExist` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM upload_setting
    WHERE upload_setting_id = p_upload_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkUploadSettingFileExtensionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUploadSettingFileExtensionExist` (IN `p_upload_setting_file_extension_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM upload_setting_file_extension
    WHERE upload_setting_file_extension_id = p_upload_setting_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountEmailExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountEmailExist` (IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountEmailUpdateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountEmailUpdateExist` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email AND user_account_id != p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountExist` (IN `p_user_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmailSetting` (IN `p_email_setting_id` INT)   BEGIN
   DELETE FROM email_setting WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `deleteFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteFileExtension` (IN `p_file_extension_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE file_extension_id = p_file_extension_id;
    DELETE FROM file_extension WHERE file_extension_id = p_file_extension_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteFileType` (IN `p_file_type_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE file_extension_id IN (SELECT file_extension_id FROM file_extension WHERE file_type_id = p_file_type_id);
    DELETE FROM file_extension WHERE file_type_id = p_file_type_id;
    DELETE FROM file_type WHERE file_type_id = p_file_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMenuGroup` (IN `p_menu_group_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM menu_group WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteMenuItem`$$
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

DROP PROCEDURE IF EXISTS `deleteNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteNotificationSetting` (IN `p_notification_setting_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM notification_setting_email_template WHERE notification_setting_id = p_notification_setting_id;
    DELETE FROM notification_setting_system_template WHERE notification_setting_id = p_notification_setting_id;
    DELETE FROM notification_setting_sms_template WHERE notification_setting_id = p_notification_setting_id;
    DELETE FROM notification_setting WHERE notification_setting_id = p_notification_setting_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteRole`$$
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

DROP PROCEDURE IF EXISTS `deleteRolePermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRolePermission` (IN `p_role_permission_id` INT)   BEGIN
   DELETE FROM role_permission WHERE role_permission_id = p_role_permission_id;
END$$

DROP PROCEDURE IF EXISTS `deleteRoleSystemActionPermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoleSystemActionPermission` (IN `p_role_system_action_permission_id` INT)   BEGIN
   DELETE FROM role_system_action_permission WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

DROP PROCEDURE IF EXISTS `deleteRoleUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoleUserAccount` (IN `p_role_user_account_id` INT)   BEGIN
   DELETE FROM role_user_account WHERE role_user_account_id = p_role_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `deleteSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSecuritySetting` (IN `p_security_setting_id` INT)   BEGIN
   DELETE FROM security_setting WHERE security_setting_id = p_security_setting_id;
END$$

DROP PROCEDURE IF EXISTS `deleteSystemAction`$$
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

DROP PROCEDURE IF EXISTS `deleteSystemSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSystemSetting` (IN `p_system_setting_id` INT)   BEGIN
   DELETE FROM system_setting WHERE system_setting_id = p_system_setting_id;
END$$

DROP PROCEDURE IF EXISTS `deleteUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUploadSetting` (IN `p_upload_setting_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE upload_setting_id = p_upload_setting_id;
    DELETE FROM upload_setting WHERE upload_setting_id = p_upload_setting_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteUploadSettingFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUploadSettingFileExtension` (IN `p_upload_setting_file_extension_id` INT)   BEGIN
    DELETE FROM upload_setting_file_extension WHERE upload_setting_file_extension_id = p_upload_setting_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `deleteUserAccount`$$
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

DROP PROCEDURE IF EXISTS `generateEmailSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmailSettingTable` ()   BEGIN
    SELECT email_setting_id, email_setting_name, email_setting_description 
    FROM email_setting
    ORDER BY email_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateFileExtensionDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileExtensionDualListBoxOptions` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT file_extension_id, file_extension_name, file_extension
    FROM file_extension 
    WHERE file_extension_id NOT IN (SELECT file_extension_id FROM upload_setting_file_extension WHERE upload_setting_id = p_upload_setting_id)
    ORDER BY file_extension_name;
END$$

DROP PROCEDURE IF EXISTS `generateFileExtensionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileExtensionTable` (IN `p_filter_by_file_type` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT file_extension_id, file_extension_name, file_extension, file_type_name 
        FROM file_extension 
        WHERE 1');

    IF p_filter_by_file_type IS NOT NULL THEN
        SET query = CONCAT(query, ' AND file_type_id = ', p_filter_by_file_type);
    END IF;

    SET query = CONCAT(query, ' ORDER BY file_extension_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateFileTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileTypeOptions` ()   BEGIN
	SELECT file_type_id, file_type_name 
    FROM file_type 
    ORDER BY file_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateFileTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileTypeTable` ()   BEGIN
	SELECT file_type_id, file_type_name 
    FROM file_type 
    ORDER BY file_type_id;
END$$

DROP PROCEDURE IF EXISTS `generateInternalNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateInternalNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT)   BEGIN
	SELECT internal_notes_id, internal_note, internal_note_by, internal_note_date
    FROM internal_notes
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY internal_note_date DESC;
END$$

DROP PROCEDURE IF EXISTS `generateLogNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLogNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT)   BEGIN
	SELECT log, changed_by, changed_at
    FROM audit_log
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY changed_at DESC;
END$$

DROP PROCEDURE IF EXISTS `generateMenuGroupOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuGroupOptions` ()   BEGIN
	SELECT menu_group_id, menu_group_name 
    FROM menu_group 
    ORDER BY menu_group_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuGroupTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuGroupTable` ()   BEGIN
	SELECT menu_group_id, menu_group_name, order_sequence 
    FROM menu_group 
    ORDER BY menu_group_id;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemOptions` ()   BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    ORDER BY menu_item_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemRoleDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemRoleDualListBoxOptions` (IN `p_menu_item_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_permission WHERE menu_item_id = p_menu_item_id)
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemRolePermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemRolePermissionTable` (IN `p_menu_item_id` INT)   BEGIN
	SELECT role_permission_id, role_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE menu_item_id = p_menu_item_id
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemTable`$$
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

DROP PROCEDURE IF EXISTS `generateNotificationSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateNotificationSettingTable` ()   BEGIN
    SELECT notification_setting_id, notification_setting_name, notification_setting_description 
    FROM notification_setting
    ORDER BY notification_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleMenuItemDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleMenuItemDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    WHERE menu_item_id NOT IN (SELECT menu_item_id FROM role_permission WHERE role_id = p_role_id)
    ORDER BY menu_item_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleMenuItemPermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleMenuItemPermissionTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_permission_id, menu_item_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE role_id = p_role_id
    ORDER BY menu_item_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleSystemActionDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleSystemActionDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT system_action_id, system_action_name
    FROM system_action 
    WHERE system_action_id NOT IN (SELECT system_action_id FROM role_system_action_permission WHERE role_id = p_role_id)
    ORDER BY system_action_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleSystemActionPermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleSystemActionPermissionTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_system_action_permission_id, system_action_name, system_action_access 
    FROM role_system_action_permission
    WHERE role_id = p_role_id
    ORDER BY system_action_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleTable` ()   BEGIN
	SELECT role_id, role_name, role_description
    FROM role 
    ORDER BY role_id;
END$$

DROP PROCEDURE IF EXISTS `generateRoleUserAccountDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleUserAccountDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT user_account_id, file_as 
    FROM user_account 
    WHERE user_account_id NOT IN (SELECT user_account_id FROM role_user_account WHERE role_id = p_role_id)
    ORDER BY file_as;
END$$

DROP PROCEDURE IF EXISTS `generateRoleUserAccountTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleUserAccountTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_user_account_id, user_account_id, file_as 
    FROM role_user_account
    WHERE role_id = p_role_id
    ORDER BY file_as;
END$$

DROP PROCEDURE IF EXISTS `generateSecuritySettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSecuritySettingTable` ()   BEGIN
    SELECT security_setting_id, security_setting_name, security_setting_description, value
    FROM security_setting
    ORDER BY security_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateSubmenuItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSubmenuItemTable` (IN `p_parent_id` INT)   BEGIN
	SELECT * FROM menu_item
	WHERE parent_id = p_parent_id AND parent_id IS NOT NULL;
END$$

DROP PROCEDURE IF EXISTS `generateSystemActionRoleDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionRoleDualListBoxOptions` (IN `p_system_action_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_system_action_permission WHERE system_action_id = p_system_action_id)
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateSystemActionRolePermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionRolePermissionTable` (IN `p_system_action_id` INT)   BEGIN
	SELECT role_system_action_permission_id, role_name, system_action_access 
    FROM role_system_action_permission
    WHERE system_action_id = p_system_action_id
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateSystemActionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionTable` ()   BEGIN
	SELECT system_action_id, system_action_name, system_action_description
    FROM system_action 
    ORDER BY system_action_id;
END$$

DROP PROCEDURE IF EXISTS `generateSystemSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemSettingTable` ()   BEGIN
    SELECT system_setting_id, system_setting_name, system_setting_description, value
    FROM system_setting
    ORDER BY system_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateUploadSettingFileExtensionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUploadSettingFileExtensionTable` (IN `p_upload_setting_id` INT)   BEGIN
    SELECT upload_setting_file_extension_id, file_extension_name, file_extension 
    FROM upload_setting_file_extension 
    WHERE upload_setting_id = p_upload_setting_id
    ORDER BY file_extension_name;
END$$

DROP PROCEDURE IF EXISTS `generateUploadSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUploadSettingTable` ()   BEGIN
    SELECT upload_setting_id, upload_setting_name, upload_setting_description, max_file_size 
    FROM upload_setting
    ORDER BY upload_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateUserAccountRoleDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountRoleDualListBoxOptions` (IN `p_user_account_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_user_account WHERE user_account_id = p_user_account_id)
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateUserAccountRoleList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountRoleList` (IN `p_user_account_id` INT)   BEGIN
	SELECT role_user_account_id, role_name, date_assigned
    FROM role_user_account
    WHERE user_account_id = p_user_account_id
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateUserAccountTable`$$
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

DROP PROCEDURE IF EXISTS `getEmailNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmailNotificationTemplate` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting_email_template
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmailSetting` (IN `p_email_setting_id` INT)   BEGIN
	SELECT * FROM email_setting
    WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFileExtension` (IN `p_file_extension_id` INT)   BEGIN
	SELECT * FROM file_extension
	WHERE file_extension_id = p_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `getFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFileType` (IN `p_file_type_id` INT)   BEGIN
	SELECT * FROM file_type
	WHERE file_type_id = p_file_type_id;
END$$

DROP PROCEDURE IF EXISTS `getInternalNotesAttachment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getInternalNotesAttachment` (IN `p_internal_notes_id` INT)   BEGIN
	SELECT * FROM internal_notes_attachment
	WHERE internal_notes_id = p_internal_notes_id;
END$$

DROP PROCEDURE IF EXISTS `getLoginCredentials`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLoginCredentials` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

DROP PROCEDURE IF EXISTS `getMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMenuGroup` (IN `p_menu_group_id` INT)   BEGIN
	SELECT * FROM menu_group
	WHERE menu_group_id = p_menu_group_id;
END$$

DROP PROCEDURE IF EXISTS `getMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMenuItem` (IN `p_menu_item_id` INT)   BEGIN
	SELECT * FROM menu_item
	WHERE menu_item_id = p_menu_item_id;
END$$

DROP PROCEDURE IF EXISTS `getNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getNotificationSetting` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getPasswordHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPasswordHistory` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM password_history
	WHERE user_account_id = p_user_account_id OR email = BINARY p_email;
END$$

DROP PROCEDURE IF EXISTS `getRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRole` (IN `p_role_id` INT)   BEGIN
	SELECT * FROM role
    WHERE role_id = p_role_id;
END$$

DROP PROCEDURE IF EXISTS `getSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSecuritySetting` (IN `p_security_setting_id` INT)   BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getSMSNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSMSNotificationTemplate` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting_sms_template
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getSystemAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemAction` (IN `p_system_action_id` INT)   BEGIN
	SELECT * FROM system_action
    WHERE system_action_id = p_system_action_id;
END$$

DROP PROCEDURE IF EXISTS `getSystemNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemNotificationTemplate` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting_system_template
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getSystemSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemSetting` (IN `p_system_setting_id` INT)   BEGIN
	SELECT * FROM system_setting
	WHERE system_setting_id = p_system_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUploadSetting` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT * FROM upload_setting
	WHERE upload_setting_id = p_upload_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getUploadSettingFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUploadSettingFileExtension` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT * FROM upload_setting_file_extension
	WHERE upload_setting_id = p_upload_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserAccount` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

DROP PROCEDURE IF EXISTS `insertEmailNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmailNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_email_notification_subject` VARCHAR(200), IN `p_email_notification_body` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO notification_setting_email_template (notification_setting_id, email_notification_subject, email_notification_body, last_log_by) 
	VALUES(p_notification_setting_id, p_email_notification_subject, p_email_notification_body, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmailSetting` (IN `p_email_setting_name` VARCHAR(100), IN `p_email_setting_description` VARCHAR(200), IN `p_mail_host` VARCHAR(100), IN `p_port` VARCHAR(10), IN `p_smtp_auth` INT(1), IN `p_smtp_auto_tls` INT(1), IN `p_mail_username` VARCHAR(200), IN `p_mail_password` VARCHAR(250), IN `p_mail_encryption` VARCHAR(20), IN `p_mail_from_name` VARCHAR(200), IN `p_mail_from_email` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_email_setting_id` INT)   BEGIN
    INSERT INTO email_setting (email_setting_name, email_setting_description, mail_host, port, smtp_auth, smtp_auto_tls, mail_username, mail_password, mail_encryption, mail_from_name, mail_from_email, last_log_by) 
	VALUES(p_email_setting_name, p_email_setting_description, p_mail_host, p_port, p_smtp_auth, p_smtp_auto_tls, p_mail_username, p_mail_password, p_mail_encryption, p_mail_from_name, p_mail_from_email, p_last_log_by);
	
    SET p_email_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertFileExtension` (IN `p_file_extension_name` VARCHAR(100), IN `p_file_extension` VARCHAR(10), IN `p_file_type_id` INT, IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_file_extension_id` INT)   BEGIN
    INSERT INTO file_extension (file_extension_name, file_extension, file_type_id, file_type_name, last_log_by) 
	VALUES(p_file_extension_name, p_file_extension, p_file_type_id, p_file_type_name, p_last_log_by);
	
    SET p_file_extension_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertFileType` (IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_file_type_id` INT)   BEGIN
    INSERT INTO file_type (file_type_name, last_log_by) 
	VALUES(p_file_type_name, p_last_log_by);
	
    SET p_file_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertInternalNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertInternalNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT, IN `p_internal_note` VARCHAR(5000), IN `p_internal_note_by` INT, OUT `p_internal_notes_id` INT)   BEGIN
    INSERT INTO internal_notes (table_name, reference_id, internal_note, internal_note_by) 
	VALUES(p_table_name, p_reference_id, p_internal_note, p_internal_note_by);

    SET p_internal_notes_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertInternalNotesAttachment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertInternalNotesAttachment` (IN `p_internal_notes_id` INT, IN `p_attachment_file_name` VARCHAR(500), IN `p_attachment_file_size` DOUBLE, IN `p_attachment_path_file` VARCHAR(500))   BEGIN
    INSERT INTO internal_notes_attachment (internal_notes_id, attachment_file_name, attachment_file_size, attachment_path_file) 
	VALUES(p_internal_notes_id, p_attachment_file_name, p_attachment_file_size, p_attachment_path_file);
END$$

DROP PROCEDURE IF EXISTS `insertMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMenuGroup` (IN `p_menu_group_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_menu_group_id` INT)   BEGIN
    INSERT INTO menu_group (menu_group_name, order_sequence, last_log_by) 
	VALUES(p_menu_group_name, p_order_sequence, p_last_log_by);
	
    SET p_menu_group_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMenuItem` (IN `p_menu_item_name` VARCHAR(100), IN `p_menu_item_url` VARCHAR(50), IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_parent_id` INT, IN `p_parent_name` VARCHAR(100), IN `p_menu_item_icon` VARCHAR(50), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_menu_item_id` INT)   BEGIN
    INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) 
	VALUES(p_menu_item_name, p_menu_item_url, p_menu_group_id, p_menu_group_name, p_parent_id, p_parent_name, p_menu_item_icon, p_order_sequence, p_last_log_by);
	
    SET p_menu_item_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertNotificationSetting` (IN `p_notification_setting_name` VARCHAR(100), IN `p_notification_setting_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_notification_setting_id` INT)   BEGIN
    INSERT INTO notification_setting (notification_setting_name, notification_setting_description, last_log_by) 
	VALUES(p_notification_setting_name, p_notification_setting_description, p_last_log_by);
	
    SET p_notification_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertPasswordHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPasswordHistory` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_last_password_change` DATETIME)   BEGIN
    INSERT INTO password_history (user_account_id, email, password, password_change_date) 
    VALUES (p_user_account_id, p_email, p_password, p_last_password_change);
END$$

DROP PROCEDURE IF EXISTS `insertRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRole` (IN `p_role_name` VARCHAR(100), IN `p_role_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_role_id` INT)   BEGIN
    INSERT INTO role (role_name, role_description, last_log_by) 
	VALUES(p_role_name, p_role_description, p_last_log_by);
	
    SET p_role_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertRolePermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRolePermission` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_menu_item_id, p_menu_item_name, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertRoleSystemActionPermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRoleSystemActionPermission` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_system_action_id` INT, IN `p_system_action_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_system_action_id, p_system_action_name, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertRoleUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRoleUserAccount` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_user_account_id` INT, IN `p_file_as` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, last_log_by) 
	VALUES(p_role_id, p_role_name, p_user_account_id, p_file_as, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSecuritySetting` (IN `p_security_setting_name` VARCHAR(100), IN `p_security_setting_description` VARCHAR(200), IN `p_value` VARCHAR(1000), IN `p_last_log_by` INT, OUT `p_security_setting_id` INT)   BEGIN
    INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) 
	VALUES(p_security_setting_name, p_security_setting_description, p_value, p_last_log_by);
	
    SET p_security_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertSMSNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSMSNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_sms_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO notification_setting_sms_template (notification_setting_id, sms_notification_message, last_log_by) 
	VALUES(p_notification_setting_id, p_sms_notification_message, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertSystemAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSystemAction` (IN `p_system_action_name` VARCHAR(100), IN `p_system_action_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_system_action_id` INT)   BEGIN
    INSERT INTO system_action (system_action_name, system_action_description, last_log_by) 
	VALUES(p_system_action_name, p_system_action_description, p_last_log_by);
	
    SET p_system_action_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertSystemNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSystemNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_system_notification_title` VARCHAR(200), IN `p_system_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO notification_setting_system_template (notification_setting_id, system_notification_title, system_notification_message, last_log_by) 
	VALUES(p_notification_setting_id, p_system_notification_title, p_system_notification_message, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertSystemSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSystemSetting` (IN `p_system_setting_name` VARCHAR(100), IN `p_system_setting_description` VARCHAR(200), IN `p_value` VARCHAR(1000), IN `p_last_log_by` INT, OUT `p_system_setting_id` INT)   BEGIN
    INSERT INTO system_setting (system_setting_name, system_setting_description, value, last_log_by) 
	VALUES(p_system_setting_name, p_system_setting_description, p_value, p_last_log_by);
	
    SET p_system_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUploadSetting` (IN `p_upload_setting_name` VARCHAR(100), IN `p_upload_setting_description` VARCHAR(200), IN `p_max_file_size` DOUBLE, IN `p_last_log_by` INT, OUT `p_upload_setting_id` INT)   BEGIN
    INSERT INTO upload_setting (upload_setting_name, upload_setting_description, max_file_size, last_log_by) 
	VALUES(p_upload_setting_name, p_upload_setting_description, p_max_file_size, p_last_log_by);
	
    SET p_upload_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertUploadSettingFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUploadSettingFileExtension` (IN `p_upload_setting_id` INT, IN `p_upload_setting_name` VARCHAR(100), IN `p_file_extension_id` INT, IN `p_file_extension_name` VARCHAR(100), IN `p_file_extension` VARCHAR(10), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO upload_setting_file_extension (upload_setting_id, upload_setting_name, file_extension_id, file_extension_name, file_extension, last_log_by) 
	VALUES(p_upload_setting_id, p_upload_setting_name, p_file_extension_id, p_file_extension_name, p_file_extension, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUserAccount` (IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_password_change` DATETIME, IN `p_last_log_by` INT, OUT `p_user_account_id` INT)   BEGIN
    INSERT INTO user_account (file_as, email, password, password_expiry_date, last_password_change, last_log_by) 
	VALUES(p_file_as, p_email, p_password, p_password_expiry_date, p_last_password_change, p_last_log_by);
	
    SET p_user_account_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `updateAccountLock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmailNotificationChannelStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmailNotificationChannelStatus` (IN `p_notification_setting_id` INT, IN `p_email_notification` INT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET email_notification = p_email_notification,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmailNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmailNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_email_notification_subject` VARCHAR(200), IN `p_email_notification_body` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting_email_template
    SET email_notification_subject = p_email_notification_subject,
        email_notification_body = p_email_notification_body,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmailSetting` (IN `p_email_setting_id` INT, IN `p_email_setting_name` VARCHAR(100), IN `p_email_setting_description` VARCHAR(200), IN `p_mail_host` VARCHAR(100), IN `p_port` VARCHAR(10), IN `p_smtp_auth` INT(1), IN `p_smtp_auto_tls` INT(1), IN `p_mail_username` VARCHAR(200), IN `p_mail_password` VARCHAR(250), IN `p_mail_encryption` VARCHAR(20), IN `p_mail_from_name` VARCHAR(200), IN `p_mail_from_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE email_setting
    SET email_setting_name = p_email_setting_name,
        email_setting_description = p_email_setting_description,
        mail_host = p_mail_host,
        port = p_port,
        smtp_auth = p_smtp_auth,
        smtp_auto_tls = p_smtp_auto_tls,
        mail_username = p_mail_username,
        mail_password = p_mail_password,
        mail_encryption = p_mail_encryption,
        mail_from_name = p_mail_from_name,
        mail_from_email = p_mail_from_email,
        last_log_by = p_last_log_by
    WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateFailedOTPAttempts`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFailedOTPAttempts` (IN `p_user_account_id` INT, IN `p_failed_otp_attempts` INT)   BEGIN
	UPDATE user_account 
    SET failed_otp_attempts = p_failed_otp_attempts
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFileExtension` (IN `p_file_extension_id` INT, IN `p_file_extension_name` VARCHAR(100), IN `p_file_extension` VARCHAR(10), IN `p_file_type_id` INT, IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE upload_setting_file_extension
    SET file_extension_name = p_file_extension_name,
        file_extension = p_file_extension,
        last_log_by = p_last_log_by
    WHERE file_extension_id = p_file_extension_id;

    UPDATE file_extension
    SET file_extension_name = p_file_extension_name,
        file_extension = p_file_extension,
        file_type_id = p_file_type_id,
        file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_extension_id = p_file_extension_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFileType` (IN `p_file_type_id` INT, IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE file_extension
    SET file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_type_id = p_file_type_id;

    UPDATE file_type
    SET file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_type_id = p_file_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateLastConnection`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLastConnection` (IN `p_user_account_id` INT, IN `p_session_token` VARCHAR(255), IN `p_last_connection_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET session_token = p_session_token, last_connection_date = p_last_connection_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateLoginAttempt`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLoginAttempt` (IN `p_user_account_id` INT, IN `p_failed_login_attempts` INT, IN `p_last_failed_login_attempt` DATETIME)   BEGIN
	UPDATE user_account 
    SET failed_login_attempts = p_failed_login_attempts, last_failed_login_attempt = p_last_failed_login_attempt
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateMenuGroup`$$
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

DROP PROCEDURE IF EXISTS `updateMenuItem`$$
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

DROP PROCEDURE IF EXISTS `updateMultipleLoginSessionsStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMultipleLoginSessionsStatus` (IN `p_user_account_id` INT, IN `p_multiple_session` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET multiple_session = p_multiple_session,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateNotificationSetting` (IN `p_notification_setting_id` INT, IN `p_notification_setting_name` VARCHAR(100), IN `p_notification_setting_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET notification_setting_name = p_notification_setting_name,
        notification_setting_description = p_notification_setting_description,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateOTP`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOTP` (IN `p_user_account_id` INT, IN `p_otp` VARCHAR(255), IN `p_otp_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET otp = p_otp, otp_expiry_date = p_otp_expiry_date, failed_otp_attempts = 0
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateOTPAsExpired`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOTPAsExpired` (IN `p_user_account_id` INT, IN `p_otp_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET otp_expiry_date = p_otp_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateResetToken`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateResetToken` (IN `p_user_account_id` INT, IN `p_reset_token` VARCHAR(255), IN `p_reset_token_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET reset_token = p_reset_token, reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateResetTokenAsExpired`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateResetTokenAsExpired` (IN `p_user_account_id` INT, IN `p_reset_token_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateRole`$$
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

DROP PROCEDURE IF EXISTS `updateRolePermission`$$
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

DROP PROCEDURE IF EXISTS `updateRoleSystemActionPermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoleSystemActionPermission` (IN `p_role_system_action_permission_id` INT, IN `p_system_action_access` TINYINT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE role_system_action_permission
    SET system_action_access = p_system_action_access,
        last_log_by = p_last_log_by
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

DROP PROCEDURE IF EXISTS `updateSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSecuritySetting` (IN `p_security_setting_id` INT, IN `p_security_setting_name` VARCHAR(100), IN `p_security_setting_description` VARCHAR(200), IN `p_value` VARCHAR(1000), IN `p_last_log_by` INT)   BEGIN
    UPDATE security_setting
    SET security_setting_name = p_security_setting_name,
        security_setting_description = p_security_setting_description,
        value = p_value,
        last_log_by = p_last_log_by
    WHERE security_setting_id = p_security_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSMSNotificationChannelStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSMSNotificationChannelStatus` (IN `p_notification_setting_id` INT, IN `p_sms_notification` INT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET sms_notification = p_sms_notification,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSMSNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSMSNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_sms_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting_sms_template
    SET sms_notification_message = p_sms_notification_message,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSystemAction`$$
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

DROP PROCEDURE IF EXISTS `updateSystemNotificationChannelStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemNotificationChannelStatus` (IN `p_notification_setting_id` INT, IN `p_system_notification` INT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET system_notification = p_system_notification,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSystemNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_system_notification_title` VARCHAR(200), IN `p_system_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting_system_template
    SET system_notification_title = p_system_notification_title,
        system_notification_message = p_system_notification_message,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSystemSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemSetting` (IN `p_system_setting_id` INT, IN `p_system_setting_name` VARCHAR(100), IN `p_system_setting_description` VARCHAR(200), IN `p_value` VARCHAR(1000), IN `p_last_log_by` INT)   BEGIN
    UPDATE system_setting
    SET system_setting_name = p_system_setting_name,
        system_setting_description = p_system_setting_description,
        value = p_value,
        last_log_by = p_last_log_by
    WHERE system_setting_id = p_system_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateTwoFactorAuthenticationStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTwoFactorAuthenticationStatus` (IN `p_user_account_id` INT, IN `p_two_factor_auth` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET two_factor_auth = p_two_factor_auth,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUploadSetting` (IN `p_upload_setting_id` INT, IN `p_upload_setting_name` VARCHAR(100), IN `p_upload_setting_description` VARCHAR(200), IN `p_max_file_size` DOUBLE, IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE upload_setting_file_extension
    SET upload_setting_name = p_upload_setting_name,
        last_log_by = p_last_log_by
    WHERE upload_setting_id = p_upload_setting_id;

    UPDATE upload_setting
    SET upload_setting_name = p_upload_setting_name,
        upload_setting_description = p_upload_setting_description,
        max_file_size = p_max_file_size,
        last_log_by = p_last_log_by
    WHERE upload_setting_id = p_upload_setting_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccount`$$
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

DROP PROCEDURE IF EXISTS `updateUserAccountLock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT, IN `p_last_log_by` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountPassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountPassword` (IN `p_user_account_id` INT, IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_log_by` INT)   BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        last_log_by = p_last_log_by
    WHERE p_user_account_id = user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountProfilePicture`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountProfilePicture` (IN `p_user_account_id` INT, IN `p_profile_picture` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET profile_picture = p_profile_picture,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountStatus` (IN `p_user_account_id` INT, IN `p_active` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET active = p_active,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserPassword`$$
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

DROP TABLE IF EXISTS `audit_log`;
CREATE TABLE IF NOT EXISTS `audit_log` (
  `audit_log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) NOT NULL,
  `reference_id` int(11) NOT NULL,
  `log` text NOT NULL,
  `changed_by` int(10) UNSIGNED NOT NULL,
  `changed_at` datetime NOT NULL,
  PRIMARY KEY (`audit_log_id`),
  KEY `audit_log_index_audit_log_id` (`audit_log_id`),
  KEY `audit_log_index_table_name` (`table_name`),
  KEY `audit_log_index_reference_id` (`reference_id`),
  KEY `audit_log_index_changed_by` (`changed_by`)
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `audit_log`
--

TRUNCATE TABLE `audit_log`;
--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`) VALUES
(1, 'system_action', 13, 'System action created. <br/><br/>System Action Name: Add File Extension Access<br/>System Action Description: Access to assign the file extension to the upload setting.', 1, '2024-05-13 10:45:22'),
(2, 'system_action', 14, 'System action created. <br/><br/>System Action Name: Delete File Extension Access<br/>System Action Description: Access to delete the file extension to the upload setting.', 1, '2024-05-13 10:45:22'),
(3, 'role_system_action_permission', 13, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add File Extension Access<br/>System Action Access: 1<br/>Date Assigned: 2024-05-13 10:46:07', 1, '2024-05-13 10:46:07'),
(4, 'role_system_action_permission', 14, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete File Extension Access<br/>System Action Access: 1<br/>Date Assigned: 2024-05-13 10:46:07', 1, '2024-05-13 10:46:07'),
(5, 'email_setting', 2, 'Email Setting created. <br/><br/>Email Setting Name: Test<br/>Email Setting Description: test<br/>Host: test<br/>Port: 12<br/>Mail Username: test<br/>Mail Encryption: none<br/>Mail From Name: te<br/>Mail From Email: te', 2, '2024-05-13 16:25:43'),
(6, 'email_setting', 2, 'Email Setting Name: Test -> Test2<br/>Email Setting Description: test -> test2<br/>Host: test -> test2<br/>Port: 12 -> 122<br/>SMTP Authentication: 0 -> 1<br/>SMTP Auto TLS: 0 -> 1<br/>Mail Username: test -> test2<br/>Mail Encryption: none -> starttls<br/>Mail From Name: te -> te2<br/>Mail From Email: te -> te2<br/>', 2, '2024-05-13 16:28:36'),
(7, 'email_setting', 3, 'Email Setting created. <br/><br/>Email Setting Name: test<br/>Email Setting Description: te<br/>Host: t<br/>Port: te<br/>Mail Username: t<br/>Mail Encryption: none<br/>Mail From Name: t<br/>Mail From Email: t', 2, '2024-05-13 16:29:06'),
(8, 'email_setting', 4, 'Email Setting created. <br/><br/>Email Setting Name: t<br/>Email Setting Description: t<br/>Host: t<br/>Port: t<br/>Mail Username: t<br/>Mail Encryption: starttls<br/>Mail From Name: t<br/>Mail From Email: t', 2, '2024-05-13 16:29:14'),
(9, 'security_setting', 8, 'Security Setting created. <br/><br/>Security Setting Name: asd<br/>Security Setting Description: asd<br/>Value: asd', 2, '2024-05-13 17:27:12'),
(10, 'security_setting', 9, 'Security Setting created. <br/><br/>Security Setting Name: asdasd<br/>Security Setting Description: asdasd<br/>Value: asd', 2, '2024-05-13 17:27:18'),
(11, 'security_setting', 10, 'Security Setting created. <br/><br/>Security Setting Name: asdasd<br/>Security Setting Description: asdasd<br/>Value: asdasdasd', 2, '2024-05-13 17:27:23'),
(12, 'user_account', 2, 'Last Connection Date: 2024-05-13 10:43:01 -> 2024-05-14 16:52:31<br/>', 2, '2024-05-14 16:52:31'),
(13, 'system_setting', 2, 'System Setting created. <br/><br/>System Setting Name: asd<br/>System Setting Description: asd<br/>Value: asd', 2, '2024-05-14 17:08:22'),
(14, 'system_setting', 3, 'System Setting created. <br/><br/>System Setting Name: asd<br/>System Setting Description: asd<br/>Value: asd', 2, '2024-05-14 17:08:33'),
(15, 'system_setting', 4, 'System Setting created. <br/><br/>System Setting Name: asd<br/>System Setting Description: asd<br/>Value: asd', 2, '2024-05-14 17:08:39'),
(16, 'system_setting', 4, 'System Setting Name: asd -> asd2<br/>System Setting Description: asd -> asd2<br/>Value: asd -> asd2<br/>', 2, '2024-05-14 17:08:47'),
(17, 'user_account', 2, 'Last Connection Date: 2024-05-14 16:52:31 -> 2024-05-14 17:25:38<br/>', 2, '2024-05-14 17:25:38'),
(18, 'user_account', 2, 'Last Connection Date: 2024-05-14 17:25:38 -> 2024-05-20 16:30:17<br/>', 2, '2024-05-20 16:30:17'),
(19, 'user_account', 2, 'Last Connection Date: 2024-05-20 16:30:17 -> 2024-05-21 15:15:27<br/>', 2, '2024-05-21 15:15:27'),
(20, 'user_account', 2, 'Last Connection Date: 2024-05-21 15:15:27 -> 2024-05-23 13:41:07<br/>', 2, '2024-05-23 13:41:07'),
(21, 'user_account', 2, 'Last Connection Date: 2024-05-23 13:41:07 -> 2024-05-24 14:49:20<br/>', 2, '2024-05-24 14:49:20'),
(22, 'notification_setting_email_template', 2, 'Email Notification Template created. <br/><br/>Email Notification Subject: Login OTP - Secure Access to Your Account<br/>Email Notification Body: <p>To ensure the security of', 2, '2024-05-24 16:35:40'),
(23, 'notification_setting_email_template', 2, 'Email Notification Body: <p>To ensure the security of -> To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:\n\nOTP: {OTP_CODE}\n\nPlease note that this OTP is valid for {OTP_VALIDITY}. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.\n\nIf you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.\n\nNote: This is an automatically generated email. Please do not reply to this address.<br/>', 2, '2024-05-24 16:37:34'),
(24, 'notification_setting_email_template', 2, 'Email Notification Body: To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:\n\nOTP: {OTP_CODE}\n\nPlease note that this OTP is valid for {OTP_VALIDITY}. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.\n\nIf you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.\n\nNote: This is an automatically generated email. Please do not reply to this address. -> <p>To ensure the security of<br/>', 2, '2024-05-24 16:37:53'),
(25, 'notification_setting_email_template', 2, 'Email Notification Body: <p>To ensure the security of -> <p>To ensure the security of&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>, we have generated a unique One-Time Password (<span class=\"il\">OTP</span>) for you to use during the&nbsp;<span class=\"il\">login</span>&nbsp;process. Please use the following&nbsp;<span class=\"il\">OTP</span>&nbsp;to&nbsp;<span class=\"il\">access</span>&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>:</p>\n<p><span class=\"il\">OTP</span>:&nbsp;<strong>{OTP_CODE}</strong></p>\n<p>Please note that this&nbsp;<span class=\"il\">OTP</span> is valid for <strong>{OTP_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.</p>\n<p>If you did not initiate this&nbsp;<span class=\"il\">login</span>&nbsp;or believe it was sent to you in error, please disregard this email and delete it immediately.&nbsp;<span class=\"il\">Your</span>&nbsp;<span class=\"il\">account</span>\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p><br/>', 2, '2024-05-24 16:44:37'),
(26, 'notification_setting_email_template', 2, 'Email Notification Body: <p>To ensure the security of&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>, we have generated a unique One-Time Password (<span class=\"il\">OTP</span>) for you to use during the&nbsp;<span class=\"il\">login</span>&nbsp;process. Please use the following&nbsp;<span class=\"il\">OTP</span>&nbsp;to&nbsp;<span class=\"il\">access</span>&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>:</p>\n<p><span class=\"il\">OTP</span>:&nbsp;<strong>{OTP_CODE}</strong></p>\n<p>Please note that this&nbsp;<span class=\"il\">OTP</span> is valid for <strong>{OTP_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.</p>\n<p>If you did not initiate this&nbsp;<span class=\"il\">login</span>&nbsp;or believe it was sent to you in error, please disregard this email and delete it immediately.&nbsp;<span class=\"il\">Your</span>&nbsp;<span class=\"il\">account</span>\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p> -> <p>To ensure the security of&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>, we have generated a unique One-Time Password (<span class=\"il\">OTP</span>) for you to use during the&nbsp;<span class=\"il\">login</span>&nbsp;process. Please use the following&nbsp;<span class=\"il\">OTP</span>&nbsp;to&nbsp;<span class=\"il\">access</span>&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>:</p>\n<p><span class=\"il\">OTP</span>: <strong>#{OTP_CODE}</strong></p>\n<p>Please note that this&nbsp;<span class=\"il\">OTP</span> is valid for <strong>#{OTP_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.</p>\n<p>If you did not initiate this&nbsp;<span class=\"il\">login</span>&nbsp;or believe it was sent to you in error, please disregard this email and delete it immediately.&nbsp;<span class=\"il\">Your</span>&nbsp;<span class=\"il\">account</span>\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p><br/>', 2, '2024-05-24 16:49:12'),
(27, 'notification_setting_email_template', 2, 'Email Notification Subject: Login OTP - Secure Access to Your Account -> Password Reset Request - Action Required<br/>Email Notification Body: <p>To ensure the security of&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>, we have generated a unique One-Time Password (<span class=\"il\">OTP</span>) for you to use during the&nbsp;<span class=\"il\">login</span>&nbsp;process. Please use the following&nbsp;<span class=\"il\">OTP</span>&nbsp;to&nbsp;<span class=\"il\">access</span>&nbsp;<span class=\"il\">your</span>&nbsp;<span class=\"il\">account</span>:</p>\n<p><span class=\"il\">OTP</span>: <strong>#{OTP_CODE}</strong></p>\n<p>Please note that this&nbsp;<span class=\"il\">OTP</span> is valid for <strong>#{OTP_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.</p>\n<p>If you did not initiate this&nbsp;<span class=\"il\">login</span>&nbsp;or believe it was sent to you in error, please disregard this email and delete it immediately.&nbsp;<span class=\"il\">Your</span>&nbsp;<span class=\"il\">account</span>\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p> -> <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:<br><strong>#{RESET_LINK}</strong></p>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p><br/>', 2, '2024-05-24 16:52:02'),
(28, 'notification_setting_email_template', 1, 'Email Notification Template created. <br/><br/>Email Notification Subject: Login OTP - Secure Access to Your Account<br/>Email Notification Body: <p>Your One-Time Password (OTP) for accessing your account is:</p>\n<p><strong>#{OTP_CODE}</strong></p>\n<p>Please enter this code on the verification page to proceed. Remember, this OTP is valid for only <strong>#{OTP_CODE_VALIDITY}</strong> and should not be shared with anyone.</p>\n<p>If you did not request this code, please contact our support team immediately to ensure your account\'s security.</p>', 2, '2024-05-24 16:53:49'),
(29, 'notification_setting_email_template', 2, 'Email Notification Body: <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:<br><strong>#{RESET_LINK}</strong></p>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p> -> <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div>&lt;a href=\\\"<strong>#{RESET_LINK}</strong>\\\"&gt;<strong>Reset Password</strong></div>\n<div>&nbsp;</div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p><br/>', 2, '2024-05-24 17:13:44'),
(30, 'user_account', 2, 'Last Connection Date: 2024-05-24 14:49:20 -> 2024-05-27 15:51:27<br/>', 2, '2024-05-27 15:51:27'),
(31, 'user_account', 2, 'Last Connection Date: 2024-05-27 15:51:27 -> 2024-05-27 16:19:05<br/>', 2, '2024-05-27 16:19:05'),
(32, 'notification_setting_email_template', 2, 'Email Notification Body: <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div>&lt;a href=\\\"<strong>#{RESET_LINK}</strong>\\\"&gt;<strong>Reset Password</strong></div>\n<div>&nbsp;</div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p> -> <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div>&lt;a href=\"<strong>#{RESET_LINK}</strong>\"&gt;<strong>Reset Password</strong>&lt;/a&gt;</div>\n<div>&nbsp;</div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p><br/>', 2, '2024-05-27 16:19:42'),
(33, 'user_account', 2, 'Last Connection Date: 2024-05-27 16:19:05 -> 2024-05-27 16:33:15<br/>', 2, '2024-05-27 16:33:15'),
(34, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-05-27 16:33:29'),
(35, 'user_account', 2, 'Last Connection Date: 2024-05-27 16:33:15 -> 2024-05-27 16:37:04<br/>', 2, '2024-05-27 16:37:04'),
(36, 'user_account', 2, 'Last Connection Date: 2024-05-27 16:37:04 -> 2024-05-27 16:46:09<br/>', 2, '2024-05-27 16:46:09'),
(37, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-05-27 16:46:37'),
(38, 'notification_setting_email_template', 2, 'Email Notification Body: <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div>&lt;a href=\"<strong>#{RESET_LINK}</strong>\"&gt;<strong>Reset Password</strong>&lt;/a&gt;</div>\n<div>&nbsp;</div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p> -> <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div><a href=\"#{RESET_LINK}\"><strong>Reset Password</strong></a></div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p><br/>', 2, '2024-05-27 16:58:02'),
(39, 'notification_setting_email_template', 2, 'Email Notification Body: <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div><a href=\"#{RESET_LINK}\"><strong>Reset Password</strong></a></div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p> -> <p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div><a href=\"#{RESET_LINK}\"><strong>Reset Password</strong></a></div>\n<div>&nbsp;</div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p><br/>', 2, '2024-05-27 16:58:10'),
(40, 'user_account', 2, 'Last Connection Date: 2024-05-27 16:46:09 -> 2024-05-27 17:05:56<br/>', 2, '2024-05-27 17:05:56'),
(41, 'user_account', 2, 'Last Connection Date: 2024-05-27 17:05:56 -> 2024-05-27 17:08:12<br/>', 2, '2024-05-27 17:08:12'),
(42, 'user_account', 2, 'Last Connection Date: 2024-05-27 17:08:12 -> 2024-05-27 17:08:40<br/>', 2, '2024-05-27 17:08:40'),
(43, 'user_account', 2, 'Last Connection Date: 2024-05-27 17:08:40 -> 2024-05-28 08:58:10<br/>', 2, '2024-05-28 08:58:10'),
(44, 'upload_setting', 2, 'Upload Setting created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>Upload Setting Description: Sets the upload setting when uploading internal notes attachment.<br/>Max File Size: 1000', 2, '2024-05-28 11:30:45'),
(45, 'upload_setting_file_extension', 4, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: JPEG<br/>File Extension: jpeg<br/>Date Assigned: 2024-05-28 11:30:52', 2, '2024-05-28 11:30:52'),
(46, 'upload_setting_file_extension', 5, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: JPG<br/>File Extension: jpg<br/>Date Assigned: 2024-05-28 11:30:52', 2, '2024-05-28 11:30:52'),
(47, 'upload_setting_file_extension', 6, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: PDF<br/>File Extension: pdf<br/>Date Assigned: 2024-05-28 11:30:52', 2, '2024-05-28 11:30:52'),
(48, 'upload_setting_file_extension', 7, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: PNG<br/>File Extension: png<br/>Date Assigned: 2024-05-28 11:30:52', 2, '2024-05-28 11:30:52'),
(49, 'user_account', 2, 'Last Connection Date: 2024-05-28 08:58:10 -> 2024-05-28 15:13:07<br/>', 2, '2024-05-28 15:13:07'),
(50, 'user_account', 2, 'Failed Login Attempts: 0 -> 1<br/>', 2, '2024-05-29 09:37:36'),
(51, 'user_account', 2, 'Failed Login Attempts: 1 -> 0<br/>', 2, '2024-05-29 09:37:41'),
(52, 'user_account', 2, 'Last Connection Date: 2024-05-28 15:13:07 -> 2024-05-29 09:37:41<br/>', 2, '2024-05-29 09:37:41'),
(53, 'menu_item', 18, 'Menu Item created. <br/><br/>Menu Item Name: Localization<br/>Menu Group: Technical<br/>Menu Item Icon: ti ti-map-2<br/>Order Sequence: 12', 2, '2024-05-29 16:31:50'),
(54, 'role_permission', 18, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Localization<br/>Date Assigned: 2024-05-29 16:31:56', 2, '2024-05-29 16:31:56'),
(55, 'role_permission', 18, 'Read Access: 0 -> 1<br/>', 2, '2024-05-29 16:31:58'),
(56, 'menu_item', 19, 'Menu Item created. <br/><br/>Menu Item Name: Country<br/>Menu Item URL: country.php<br/>Menu Group: Technical<br/>Parent: Localization<br/>Order Sequence: 3', 2, '2024-05-29 16:33:41'),
(57, 'role_permission', 19, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Country<br/>Date Assigned: 2024-05-29 16:33:48', 2, '2024-05-29 16:33:48'),
(58, 'role_permission', 19, 'Read Access: 0 -> 1<br/>', 2, '2024-05-29 16:33:49'),
(59, 'role_permission', 19, 'Create Access: 0 -> 1<br/>', 2, '2024-05-29 16:33:50'),
(60, 'role_permission', 19, 'Write Access: 0 -> 1<br/>', 2, '2024-05-29 16:33:52'),
(61, 'role_permission', 19, 'Delete Access: 0 -> 1<br/>', 2, '2024-05-29 16:33:53'),
(62, 'menu_item', 20, 'Menu Item created. <br/><br/>Menu Item Name: City<br/>Menu Item URL: city.php<br/>Menu Group: Technical<br/>Parent: Localization<br/>Order Sequence: 4', 2, '2024-05-29 16:34:26'),
(63, 'role_permission', 20, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: City<br/>Date Assigned: 2024-05-29 16:34:32', 2, '2024-05-29 16:34:32'),
(64, 'role_permission', 20, 'Read Access: 0 -> 1<br/>', 2, '2024-05-29 16:34:33'),
(65, 'role_permission', 20, 'Create Access: 0 -> 1<br/>', 2, '2024-05-29 16:34:34'),
(66, 'role_permission', 20, 'Write Access: 0 -> 1<br/>', 2, '2024-05-29 16:34:35'),
(67, 'role_permission', 20, 'Delete Access: 0 -> 1<br/>', 2, '2024-05-29 16:34:35'),
(68, 'menu_item', 21, 'Menu Item created. <br/><br/>Menu Item Name: State<br/>Menu Item URL: state.php<br/>Menu Group: Technical<br/>Parent: Localization<br/>Order Sequence: 19', 2, '2024-05-29 16:36:57'),
(69, 'role_permission', 21, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: State<br/>Date Assigned: 2024-05-29 16:37:03', 2, '2024-05-29 16:37:03'),
(70, 'role_permission', 21, 'Read Access: 0 -> 1<br/>', 2, '2024-05-29 16:37:04'),
(71, 'role_permission', 21, 'Create Access: 0 -> 1<br/>', 2, '2024-05-29 16:37:05'),
(72, 'role_permission', 21, 'Write Access: 0 -> 1<br/>', 2, '2024-05-29 16:37:06'),
(73, 'role_permission', 21, 'Delete Access: 0 -> 1<br/>', 2, '2024-05-29 16:37:07'),
(74, 'menu_item', 22, 'Menu Item created. <br/><br/>Menu Item Name: Currency<br/>Menu Item URL: currency.php<br/>Menu Group: Technical<br/>Parent: Localization<br/>Order Sequence: 1', 2, '2024-05-29 16:53:16'),
(75, 'role_permission', 22, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Currency<br/>Date Assigned: 2024-05-29 16:53:22', 2, '2024-05-29 16:53:22'),
(76, 'role_permission', 22, 'Read Access: 0 -> 1<br/>', 2, '2024-05-29 16:53:23'),
(77, 'role_permission', 22, 'Create Access: 0 -> 1<br/>', 2, '2024-05-29 16:53:24'),
(78, 'role_permission', 22, 'Write Access: 0 -> 1<br/>', 2, '2024-05-29 16:53:25'),
(79, 'role_permission', 22, 'Delete Access: 0 -> 1<br/>', 2, '2024-05-29 16:53:25');

-- --------------------------------------------------------

--
-- Table structure for table `email_setting`
--

DROP TABLE IF EXISTS `email_setting`;
CREATE TABLE IF NOT EXISTS `email_setting` (
  `email_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `email_setting_name` varchar(100) NOT NULL,
  `email_setting_description` varchar(200) NOT NULL,
  `mail_host` varchar(100) NOT NULL,
  `port` varchar(10) NOT NULL,
  `smtp_auth` int(1) NOT NULL,
  `smtp_auto_tls` int(1) NOT NULL,
  `mail_username` varchar(200) NOT NULL,
  `mail_password` varchar(250) NOT NULL,
  `mail_encryption` varchar(20) DEFAULT NULL,
  `mail_from_name` varchar(200) DEFAULT NULL,
  `mail_from_email` varchar(200) DEFAULT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`email_setting_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `email_setting_index_email_setting_id` (`email_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `email_setting`
--

TRUNCATE TABLE `email_setting`;
--
-- Dumping data for table `email_setting`
--

INSERT INTO `email_setting` (`email_setting_id`, `email_setting_name`, `email_setting_description`, `mail_host`, `port`, `smtp_auth`, `smtp_auto_tls`, `mail_username`, `mail_password`, `mail_encryption`, `mail_from_name`, `mail_from_email`, `last_log_by`) VALUES
(1, 'Security Email Setting', '\r\nEmail setting for security emails.', 'smtp.hostinger.com', '465', 1, 0, 'cgmi-noreply@christianmotors.ph', 'UsDpF0dYRC6M9v0tT3MHq%2BlrRJu01%2Fb95Dq%2BAeCfu2Y%3D', 'ssl', 'cgmi-noreply@christianmotors.ph', 'cgmi-noreply@christianmotors.ph', 1);

--
-- Triggers `email_setting`
--
DROP TRIGGER IF EXISTS `email_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `email_setting_trigger_insert` AFTER INSERT ON `email_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Email Setting created. <br/>';

    IF NEW.email_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Setting Name: ", NEW.email_setting_name);
    END IF;

    IF NEW.email_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Setting Description: ", NEW.email_setting_description);
    END IF;

    IF NEW.mail_host <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Host: ", NEW.mail_host);
    END IF;

    IF NEW.port <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Port: ", NEW.port);
    END IF;

    IF NEW.smtp_auth <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMTP Authentication: ", NEW.smtp_auth);
    END IF;

    IF NEW.smtp_auto_tls <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMTP Auto TLS: ", NEW.smtp_auto_tls);
    END IF;

    IF NEW.mail_username <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail Username: ", NEW.mail_username);
    END IF;

    IF NEW.mail_encryption <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail Encryption: ", NEW.mail_encryption);
    END IF;

    IF NEW.mail_from_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail From Name: ", NEW.mail_from_name);
    END IF;

    IF NEW.mail_from_email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail From Email: ", NEW.mail_from_email);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('email_setting', NEW.email_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `email_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `email_setting_trigger_update` AFTER UPDATE ON `email_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.email_setting_name <> OLD.email_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Email Setting Name: ", OLD.email_setting_name, " -> ", NEW.email_setting_name, "<br/>");
    END IF;

    IF NEW.email_setting_description <> OLD.email_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Email Setting Description: ", OLD.email_setting_description, " -> ", NEW.email_setting_description, "<br/>");
    END IF;

    IF NEW.mail_host <> OLD.mail_host THEN
        SET audit_log = CONCAT(audit_log, "Host: ", OLD.mail_host, " -> ", NEW.mail_host, "<br/>");
    END IF;

    IF NEW.port <> OLD.port THEN
        SET audit_log = CONCAT(audit_log, "Port: ", OLD.port, " -> ", NEW.port, "<br/>");
    END IF;

    IF NEW.smtp_auth <> OLD.smtp_auth THEN
        SET audit_log = CONCAT(audit_log, "SMTP Authentication: ", OLD.smtp_auth, " -> ", NEW.smtp_auth, "<br/>");
    END IF;

    IF NEW.smtp_auto_tls <> OLD.smtp_auto_tls THEN
        SET audit_log = CONCAT(audit_log, "SMTP Auto TLS: ", OLD.smtp_auto_tls, " -> ", NEW.smtp_auto_tls, "<br/>");
    END IF;

    IF NEW.mail_username <> OLD.mail_username THEN
        SET audit_log = CONCAT(audit_log, "Mail Username: ", OLD.mail_username, " -> ", NEW.mail_username, "<br/>");
    END IF;

    IF NEW.mail_encryption <> OLD.mail_encryption THEN
        SET audit_log = CONCAT(audit_log, "Mail Encryption: ", OLD.mail_encryption, " -> ", NEW.mail_encryption, "<br/>");
    END IF;

    IF NEW.mail_from_name <> OLD.mail_from_name THEN
        SET audit_log = CONCAT(audit_log, "Mail From Name: ", OLD.mail_from_name, " -> ", NEW.mail_from_name, "<br/>");
    END IF;

    IF NEW.mail_from_email <> OLD.mail_from_email THEN
        SET audit_log = CONCAT(audit_log, "Mail From Email: ", OLD.mail_from_email, " -> ", NEW.mail_from_email, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('email_setting', NEW.email_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `file_extension`
--

DROP TABLE IF EXISTS `file_extension`;
CREATE TABLE IF NOT EXISTS `file_extension` (
  `file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_extension_name` varchar(100) NOT NULL,
  `file_extension` varchar(10) NOT NULL,
  `file_type_id` int(11) NOT NULL,
  `file_type_name` varchar(100) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`file_extension_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `file_extension_index_file_extension_id` (`file_extension_id`),
  KEY `file_extension_index_file_type_id` (`file_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `file_extension`
--

TRUNCATE TABLE `file_extension`;
--
-- Dumping data for table `file_extension`
--

INSERT INTO `file_extension` (`file_extension_id`, `file_extension_name`, `file_extension`, `file_type_id`, `file_type_name`, `last_log_by`) VALUES
(1, 'PNG', 'png', 1, 'Image', 1),
(2, 'JPG', 'jpg', 1, 'Image', 1),
(3, 'JPEG', 'jpeg', 1, 'Image', 1),
(4, 'PDF', 'pdf', 2, 'Document', 1);

--
-- Triggers `file_extension`
--
DROP TRIGGER IF EXISTS `file_extension_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `file_extension_trigger_insert` AFTER INSERT ON `file_extension` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'File Extension created. <br/>';

    IF NEW.file_extension_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension Name: ", NEW.file_extension_name);
    END IF;

    IF NEW.file_extension <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension: ", NEW.file_extension);
    END IF;

    IF NEW.file_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Type: ", NEW.file_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('file_extension', NEW.file_extension_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `file_extension_trigger_update`;
DELIMITER $$
CREATE TRIGGER `file_extension_trigger_update` AFTER UPDATE ON `file_extension` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.file_extension_name <> OLD.file_extension_name THEN
        SET audit_log = CONCAT(audit_log, "File Extension Name: ", OLD.file_extension_name, " -> ", NEW.file_extension_name, "<br/>");
    END IF;

    IF NEW.file_extension <> OLD.file_extension THEN
        SET audit_log = CONCAT(audit_log, "File Extension: ", OLD.file_extension, " -> ", NEW.file_extension, "<br/>");
    END IF;

    IF NEW.file_type_name <> OLD.file_type_name THEN
        SET audit_log = CONCAT(audit_log, "File Type: ", OLD.file_type_name, " -> ", NEW.file_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('file_extension', NEW.file_extension_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `file_type`
--

DROP TABLE IF EXISTS `file_type`;
CREATE TABLE IF NOT EXISTS `file_type` (
  `file_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `file_type_name` varchar(100) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`file_type_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `file_type_index_file_type_id` (`file_type_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `file_type`
--

TRUNCATE TABLE `file_type`;
--
-- Dumping data for table `file_type`
--

INSERT INTO `file_type` (`file_type_id`, `file_type_name`, `last_log_by`) VALUES
(1, 'Image', 1),
(2, 'Document', 1);

--
-- Triggers `file_type`
--
DROP TRIGGER IF EXISTS `file_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `file_type_trigger_insert` AFTER INSERT ON `file_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'File type created. <br/>';

    IF NEW.file_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Type Name: ", NEW.file_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('file_type', NEW.file_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `file_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `file_type_trigger_update` AFTER UPDATE ON `file_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.file_type_name <> OLD.file_type_name THEN
        SET audit_log = CONCAT(audit_log, "File Type Name: ", OLD.file_type_name, " -> ", NEW.file_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('file_type', NEW.file_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `internal_notes`
--

DROP TABLE IF EXISTS `internal_notes`;
CREATE TABLE IF NOT EXISTS `internal_notes` (
  `internal_notes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `table_name` varchar(255) NOT NULL,
  `reference_id` int(11) NOT NULL,
  `internal_note` varchar(5000) NOT NULL,
  `internal_note_by` int(10) UNSIGNED NOT NULL,
  `internal_note_date` datetime NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`internal_notes_id`),
  KEY `internal_note_by` (`internal_note_by`),
  KEY `internal_notes_index_internal_notes_id` (`internal_notes_id`),
  KEY `internal_notes_index_table_name` (`table_name`),
  KEY `internal_notes_index_reference_id` (`reference_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `internal_notes`
--

TRUNCATE TABLE `internal_notes`;
-- --------------------------------------------------------

--
-- Table structure for table `internal_notes_attachment`
--

DROP TABLE IF EXISTS `internal_notes_attachment`;
CREATE TABLE IF NOT EXISTS `internal_notes_attachment` (
  `internal_notes_attachment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `internal_notes_id` int(10) UNSIGNED NOT NULL,
  `attachment_file_name` varchar(500) NOT NULL,
  `attachment_file_size` double NOT NULL,
  `attachment_path_file` varchar(500) NOT NULL,
  PRIMARY KEY (`internal_notes_attachment_id`),
  KEY `internal_notes_attachment_index_internal_notes_id` (`internal_notes_attachment_id`),
  KEY `internal_notes_attachment_index_table_name` (`internal_notes_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `internal_notes_attachment`
--

TRUNCATE TABLE `internal_notes_attachment`;
-- --------------------------------------------------------

--
-- Table structure for table `menu_group`
--

DROP TABLE IF EXISTS `menu_group`;
CREATE TABLE IF NOT EXISTS `menu_group` (
  `menu_group_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `menu_group_name` varchar(100) NOT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`menu_group_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `menu_group_index_menu_group_id` (`menu_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `menu_group`
--

TRUNCATE TABLE `menu_group`;
--
-- Dumping data for table `menu_group`
--

INSERT INTO `menu_group` (`menu_group_id`, `menu_group_name`, `order_sequence`, `last_log_by`) VALUES
(1, 'Technical', 127, 1),
(2, 'Administration', 100, 1);

--
-- Triggers `menu_group`
--
DROP TRIGGER IF EXISTS `menu_group_trigger_insert`;
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
DROP TRIGGER IF EXISTS `menu_group_trigger_update`;
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

DROP TABLE IF EXISTS `menu_item`;
CREATE TABLE IF NOT EXISTS `menu_item` (
  `menu_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `menu_item_name` varchar(100) NOT NULL,
  `menu_item_url` varchar(50) DEFAULT NULL,
  `menu_group_id` int(11) NOT NULL,
  `menu_group_name` varchar(100) NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_name` varchar(100) DEFAULT NULL,
  `menu_item_icon` varchar(50) DEFAULT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`menu_item_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `menu_item_index_menu_item_id` (`menu_item_id`),
  KEY `menu_item_index_menu_group_id` (`menu_group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `menu_item`
--

TRUNCATE TABLE `menu_item`;
--
-- Dumping data for table `menu_item`
--

INSERT INTO `menu_item` (`menu_item_id`, `menu_item_name`, `menu_item_url`, `menu_group_id`, `menu_group_name`, `parent_id`, `parent_name`, `menu_item_icon`, `order_sequence`, `last_log_by`) VALUES
(1, 'User Interface', '', 1, 'Technical', 0, '', 'ti ti-template', 21, 1),
(2, 'Menu Group', 'menu-group.php', 1, 'Technical', 1, 'User Interface', '', 13, 1),
(3, 'Menu Item', 'menu-item.php', 1, 'Technical', 1, 'User Interface', '', 13, 1),
(4, 'System Action', 'system-action.php', 1, 'Technical', 1, 'User Interface', '', 19, 1),
(5, 'Users & Companies', '', 2, 'Administration', 0, '', 'ti ti-users', 21, 1),
(6, 'User Account', 'user-account.php', 2, 'Administration', 5, 'Users & Companies', '', 21, 1),
(7, 'Role', 'role.php', 2, 'Administration', 5, 'Users & Companies', '', 18, 1),
(8, 'Company', 'company.php', 2, 'Administration', 5, 'Users & Companies', '', 3, 1),
(9, 'Settings', '', 2, 'Administration', 0, '', 'ti ti-settings-2', 19, 1),
(10, 'Upload Setting', 'upload-setting.php', 2, 'Administration', 9, 'Settings', '', 21, 1),
(11, 'Security Setting', 'security-setting.php', 2, 'Administration', 9, 'Settings', '', 19, 1),
(12, 'Email Setting', 'email-setting.php', 2, 'Administration', 9, 'Settings', '', 5, 1),
(13, 'Notification Setting', 'notification-setting.php', 2, 'Administration', 9, 'Settings', '', 14, 1),
(14, 'System Setting', 'system-setting.php', 2, 'Administration', 9, 'Settings', '', 19, 1),
(15, 'Configurations', '', 1, 'Technical', 0, '', 'ti ti-settings', 3, 1),
(16, 'File Type', 'file-type.php', 1, 'Technical', 15, 'Configurations', '', 6, 1),
(17, 'File Extension', 'file-extension.php', 1, 'Technical', 15, 'Configurations', '', 6, 1),
(18, 'Localization', '', 1, 'Technical', 0, NULL, 'ti ti-map-2', 12, 2),
(19, 'Country', 'country.php', 1, 'Technical', 18, 'Localization', '', 3, 2),
(20, 'City', 'city.php', 1, 'Technical', 18, 'Localization', '', 4, 2),
(21, 'State', 'state.php', 1, 'Technical', 18, 'Localization', '', 19, 2),
(22, 'Currency', 'currency.php', 1, 'Technical', 18, 'Localization', '', 1, 2);

--
-- Triggers `menu_item`
--
DROP TRIGGER IF EXISTS `menu_item_trigger_insert`;
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
DROP TRIGGER IF EXISTS `menu_item_trigger_update`;
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

DROP TABLE IF EXISTS `notification_setting`;
CREATE TABLE IF NOT EXISTS `notification_setting` (
  `notification_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_setting_name` varchar(100) NOT NULL,
  `notification_setting_description` varchar(200) NOT NULL,
  `system_notification` int(1) NOT NULL DEFAULT 1,
  `email_notification` int(1) NOT NULL DEFAULT 0,
  `sms_notification` int(1) NOT NULL DEFAULT 0,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`notification_setting_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `notification_setting_index_notification_setting_id` (`notification_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `notification_setting`
--

TRUNCATE TABLE `notification_setting`;
--
-- Dumping data for table `notification_setting`
--

INSERT INTO `notification_setting` (`notification_setting_id`, `notification_setting_name`, `notification_setting_description`, `system_notification`, `email_notification`, `sms_notification`, `last_log_by`) VALUES
(1, 'Login OTP', 'Notification setting for Login OTP received by the users.', 0, 1, 0, 2),
(2, 'Forgot Password', 'Notification setting when the user initiates forgot password.', 0, 1, 0, 2);

--
-- Triggers `notification_setting`
--
DROP TRIGGER IF EXISTS `notification_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_trigger_insert` AFTER INSERT ON `notification_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Notification Setting created. <br/>';

    IF NEW.notification_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Notification Setting Name: ", NEW.notification_setting_name);
    END IF;

    IF NEW.notification_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Notification Setting Description: ", NEW.notification_setting_description);
    END IF;

    IF NEW.system_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Notification: ", NEW.system_notification);
    END IF;

    IF NEW.email_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Notification: ", NEW.email_notification);
    END IF;

    IF NEW.sms_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMS Notification: ", NEW.sms_notification);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_trigger_update` AFTER UPDATE ON `notification_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.notification_setting_name <> OLD.notification_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Notification Setting Name: ", OLD.notification_setting_name, " -> ", NEW.notification_setting_name, "<br/>");
    END IF;

    IF NEW.notification_setting_description <> OLD.notification_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Notification Setting Description: ", OLD.notification_setting_description, " -> ", NEW.notification_setting_description, "<br/>");
    END IF;

    IF NEW.system_notification <> OLD.system_notification THEN
        SET audit_log = CONCAT(audit_log, "System Notification: ", OLD.system_notification, " -> ", NEW.system_notification, "<br/>");
    END IF;

    IF NEW.email_notification <> OLD.email_notification THEN
        SET audit_log = CONCAT(audit_log, "Email Notification: ", OLD.email_notification, " -> ", NEW.email_notification, "<br/>");
    END IF;

    IF NEW.sms_notification <> OLD.sms_notification THEN
        SET audit_log = CONCAT(audit_log, "SMS Notification: ", OLD.sms_notification, " -> ", NEW.sms_notification, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting_email_template`
--

DROP TABLE IF EXISTS `notification_setting_email_template`;
CREATE TABLE IF NOT EXISTS `notification_setting_email_template` (
  `notification_setting_email_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `email_notification_subject` varchar(200) NOT NULL,
  `email_notification_body` longtext NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`notification_setting_email_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `notification_setting_email_index_notification_setting_email_id` (`notification_setting_email_id`),
  KEY `notification_setting_email_index_notification_setting_id` (`notification_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `notification_setting_email_template`
--

TRUNCATE TABLE `notification_setting_email_template`;
--
-- Dumping data for table `notification_setting_email_template`
--

INSERT INTO `notification_setting_email_template` (`notification_setting_email_id`, `notification_setting_id`, `email_notification_subject`, `email_notification_body`, `last_log_by`) VALUES
(1, 2, 'Password Reset Request - Action Required', '<p>We received a request to reset the password for your account associated with this email address. If you did not make this request, please ignore this email.</p>\n<p>To set a new password, please click on the link below:</p>\n<div>\n<div><a href=\"#{RESET_LINK}\"><strong>Reset Password</strong></a></div>\n<div>&nbsp;</div>\n</div>\n<p>This link will expire in <strong>#{RESET_LINK_VALIDITY} </strong>for security reasons. If you need further assistance, please contact our support team.</p>', 2),
(2, 1, 'Login OTP - Secure Access to Your Account', '<p>Your One-Time Password (OTP) for accessing your account is:</p>\n<p><strong>#{OTP_CODE}</strong></p>\n<p>Please enter this code on the verification page to proceed. Remember, this OTP is valid for only <strong>#{OTP_CODE_VALIDITY}</strong> and should not be shared with anyone.</p>\n<p>If you did not request this code, please contact our support team immediately to ensure your account\'s security.</p>', 2);

--
-- Triggers `notification_setting_email_template`
--
DROP TRIGGER IF EXISTS `notification_setting_email_template_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_email_template_trigger_insert` AFTER INSERT ON `notification_setting_email_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Email Notification Template created. <br/>';

    IF NEW.email_notification_subject <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Notification Subject: ", NEW.email_notification_subject);
    END IF;

    IF NEW.email_notification_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Notification Body: ", NEW.email_notification_body);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting_email_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_email_template_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_email_template_trigger_update` AFTER UPDATE ON `notification_setting_email_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.email_notification_subject <> OLD.email_notification_subject THEN
        SET audit_log = CONCAT(audit_log, "Email Notification Subject: ", OLD.email_notification_subject, " -> ", NEW.email_notification_subject, "<br/>");
    END IF;

    IF NEW.email_notification_body <> OLD.email_notification_body THEN
        SET audit_log = CONCAT(audit_log, "Email Notification Body: ", OLD.email_notification_body, " -> ", NEW.email_notification_body, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting_email_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting_sms_template`
--

DROP TABLE IF EXISTS `notification_setting_sms_template`;
CREATE TABLE IF NOT EXISTS `notification_setting_sms_template` (
  `notification_setting_sms_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `sms_notification_message` varchar(500) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`notification_setting_sms_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `notification_setting_sms_index_notification_setting_sms_id` (`notification_setting_sms_id`),
  KEY `notification_setting_sms_index_notification_setting_id` (`notification_setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `notification_setting_sms_template`
--

TRUNCATE TABLE `notification_setting_sms_template`;
--
-- Triggers `notification_setting_sms_template`
--
DROP TRIGGER IF EXISTS `notification_setting_sms_template_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_sms_template_trigger_insert` AFTER INSERT ON `notification_setting_sms_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'SMS Notification Template created. <br/>';

    IF NEW.sms_notification_message <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMS Notification Message: ", NEW.sms_notification_message);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting_sms_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_sms_template_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_sms_template_trigger_update` AFTER UPDATE ON `notification_setting_sms_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.sms_notification_message <> OLD.sms_notification_message THEN
        SET audit_log = CONCAT(audit_log, "SMS Notification Message: ", OLD.sms_notification_message, " -> ", NEW.sms_notification_message, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting_sms_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting_system_template`
--

DROP TABLE IF EXISTS `notification_setting_system_template`;
CREATE TABLE IF NOT EXISTS `notification_setting_system_template` (
  `notification_setting_system_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `system_notification_title` varchar(200) NOT NULL,
  `system_notification_message` varchar(500) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`notification_setting_system_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `notification_setting_system_index_notification_setting_system_id` (`notification_setting_system_id`),
  KEY `notification_setting_system_index_notification_setting_id` (`notification_setting_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `notification_setting_system_template`
--

TRUNCATE TABLE `notification_setting_system_template`;
--
-- Triggers `notification_setting_system_template`
--
DROP TRIGGER IF EXISTS `notification_setting_system_template_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_system_template_trigger_insert` AFTER INSERT ON `notification_setting_system_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'System Notification Template created. <br/>';

    IF NEW.system_notification_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Notification Title: ", NEW.system_notification_title);
    END IF;

    IF NEW.system_notification_message <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Notification Message: ", NEW.system_notification_message);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting_system_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_system_template_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_system_template_trigger_update` AFTER UPDATE ON `notification_setting_system_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.system_notification_title <> OLD.system_notification_title THEN
        SET audit_log = CONCAT(audit_log, "System Notification Title: ", OLD.system_notification_title, " -> ", NEW.system_notification_title, "<br/>");
    END IF;

    IF NEW.system_notification_message <> OLD.system_notification_message THEN
        SET audit_log = CONCAT(audit_log, "System Notification Message: ", OLD.system_notification_message, " -> ", NEW.system_notification_message, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting_system_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

DROP TABLE IF EXISTS `password_history`;
CREATE TABLE IF NOT EXISTS `password_history` (
  `password_history_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `password_change_date` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`password_history_id`),
  KEY `password_history_index_password_history_id` (`password_history_id`),
  KEY `password_history_index_user_account_id` (`user_account_id`),
  KEY `password_history_index_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `password_history`
--

TRUNCATE TABLE `password_history`;
-- --------------------------------------------------------

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
CREATE TABLE IF NOT EXISTS `role` (
  `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_name` varchar(100) NOT NULL,
  `role_description` varchar(200) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `role_index_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `role`
--

TRUNCATE TABLE `role`;
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
DROP TRIGGER IF EXISTS `role_trigger_insert`;
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
DROP TRIGGER IF EXISTS `role_trigger_update`;
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

DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE IF NOT EXISTS `role_permission` (
  `role_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `menu_item_id` int(10) UNSIGNED NOT NULL,
  `menu_item_name` varchar(100) NOT NULL,
  `read_access` tinyint(1) NOT NULL DEFAULT 0,
  `write_access` tinyint(1) NOT NULL DEFAULT 0,
  `create_access` tinyint(1) NOT NULL DEFAULT 0,
  `delete_access` tinyint(1) NOT NULL DEFAULT 0,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_permission_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `role_permission_index_role_permission_id` (`role_permission_id`),
  KEY `role_permission_index_menu_item_id` (`menu_item_id`),
  KEY `role_permission_index_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `role_permission`
--

TRUNCATE TABLE `role_permission`;
--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`role_permission_id`, `role_id`, `role_name`, `menu_item_id`, `menu_item_name`, `read_access`, `write_access`, `create_access`, `delete_access`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'Administrator', 1, 'User Interface', 1, 0, 0, 0, '2024-05-13 10:38:33', 1),
(2, 1, 'Administrator', 2, 'Menu Group', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(3, 1, 'Administrator', 3, 'Menu Item', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(4, 1, 'Administrator', 4, 'System Action', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(5, 1, 'Administrator', 5, 'Users & Companies', 1, 0, 0, 0, '2024-05-13 10:38:33', 1),
(6, 1, 'Administrator', 6, 'User Account', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(7, 1, 'Administrator', 7, 'Role', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(8, 1, 'Administrator', 8, 'Company', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(9, 1, 'Administrator', 9, 'Settings', 1, 0, 0, 0, '2024-05-13 10:38:33', 1),
(10, 1, 'Administrator', 10, 'Upload Setting', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(11, 1, 'Administrator', 11, 'Security Setting', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(12, 1, 'Administrator', 12, 'Email Setting', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(13, 1, 'Administrator', 13, 'Notification Setting', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(14, 1, 'Administrator', 14, 'System Setting', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(15, 1, 'Administrator', 15, 'Configurations', 1, 0, 0, 0, '2024-05-13 10:38:33', 1),
(16, 1, 'Administrator', 16, 'File Type', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(17, 1, 'Administrator', 17, 'File Extension', 1, 1, 1, 1, '2024-05-13 10:38:33', 1),
(18, 1, 'Administrator', 18, 'Localization', 1, 0, 0, 0, '2024-05-29 16:31:56', 2),
(19, 1, 'Administrator', 19, 'Country', 1, 1, 1, 1, '2024-05-29 16:33:48', 2),
(20, 1, 'Administrator', 20, 'City', 1, 1, 1, 1, '2024-05-29 16:34:32', 2),
(21, 1, 'Administrator', 21, 'State', 1, 1, 1, 1, '2024-05-29 16:37:03', 2),
(22, 1, 'Administrator', 22, 'Currency', 1, 1, 1, 1, '2024-05-29 16:53:22', 2);

--
-- Triggers `role_permission`
--
DROP TRIGGER IF EXISTS `role_permission_trigger_insert`;
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
DROP TRIGGER IF EXISTS `role_permission_trigger_update`;
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

DROP TABLE IF EXISTS `role_system_action_permission`;
CREATE TABLE IF NOT EXISTS `role_system_action_permission` (
  `role_system_action_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `system_action_id` int(10) UNSIGNED NOT NULL,
  `system_action_name` varchar(100) NOT NULL,
  `system_action_access` tinyint(1) NOT NULL DEFAULT 0,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_system_action_permission_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `role_system_action_permission_index_system_action_permission_id` (`role_system_action_permission_id`),
  KEY `role_system_action_permission_index_system_action_id` (`system_action_id`),
  KEY `role_system_action_permissionn_index_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `role_system_action_permission`
--

TRUNCATE TABLE `role_system_action_permission`;
--
-- Dumping data for table `role_system_action_permission`
--

INSERT INTO `role_system_action_permission` (`role_system_action_permission_id`, `role_id`, `role_name`, `system_action_id`, `system_action_name`, `system_action_access`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'Administrator', 1, 'Activate User Account', 1, '2024-05-13 10:39:21', 1),
(2, 1, 'Administrator', 2, 'Deactivate User Account', 1, '2024-05-13 10:39:21', 1),
(3, 1, 'Administrator', 3, 'Lock User Account', 1, '2024-05-13 10:39:21', 1),
(4, 1, 'Administrator', 4, 'Unlock User Account', 1, '2024-05-13 10:39:21', 1),
(5, 1, 'Administrator', 5, 'Add Role User Account', 1, '2024-05-13 10:39:21', 1),
(6, 1, 'Administrator', 6, 'Delete Role User Account', 1, '2024-05-13 10:39:21', 1),
(7, 1, 'Administrator', 7, 'Add Role Access', 1, '2024-05-13 10:39:21', 1),
(8, 1, 'Administrator', 8, 'Update Role Access', 1, '2024-05-13 10:39:21', 1),
(9, 1, 'Administrator', 9, 'Delete Role Access', 1, '2024-05-13 10:39:21', 1),
(10, 1, 'Administrator', 10, 'Add Role System Action Access', 1, '2024-05-13 10:39:21', 1),
(11, 1, 'Administrator', 11, 'Update Role System Action Access', 1, '2024-05-13 10:39:21', 1),
(12, 1, 'Administrator', 12, 'Delete Role System Action Access', 1, '2024-05-13 10:39:21', 1),
(13, 1, 'Administrator', 13, 'Add File Extension Access', 1, '2024-05-13 10:46:07', 1),
(14, 1, 'Administrator', 14, 'Delete File Extension Access', 1, '2024-05-13 10:46:07', 1);

--
-- Triggers `role_system_action_permission`
--
DROP TRIGGER IF EXISTS `role_system_action_permission_trigger_insert`;
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
DROP TRIGGER IF EXISTS `role_system_action_permission_trigger_update`;
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

DROP TABLE IF EXISTS `role_user_account`;
CREATE TABLE IF NOT EXISTS `role_user_account` (
  `role_user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `file_as` varchar(300) NOT NULL,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`role_user_account_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `role_user_account_index_role_user_account_id` (`role_user_account_id`),
  KEY `role_user_account_permission_index_user_account_id` (`user_account_id`),
  KEY `role_user_account_permissionn_index_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `role_user_account`
--

TRUNCATE TABLE `role_user_account`;
--
-- Dumping data for table `role_user_account`
--

INSERT INTO `role_user_account` (`role_user_account_id`, `role_id`, `role_name`, `user_account_id`, `file_as`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'Administrator', 2, 'Administrator', '2024-05-13 10:38:33', 1);

--
-- Triggers `role_user_account`
--
DROP TRIGGER IF EXISTS `role_user_account_trigger_insert`;
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
DROP TRIGGER IF EXISTS `role_user_account_trigger_update`;
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

DROP TABLE IF EXISTS `security_setting`;
CREATE TABLE IF NOT EXISTS `security_setting` (
  `security_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `security_setting_name` varchar(100) NOT NULL,
  `security_setting_description` varchar(200) NOT NULL,
  `value` varchar(1000) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`security_setting_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `security_setting_index_security_setting_id` (`security_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `security_setting`
--

TRUNCATE TABLE `security_setting`;
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

--
-- Triggers `security_setting`
--
DROP TRIGGER IF EXISTS `security_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `security_setting_trigger_insert` AFTER INSERT ON `security_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Security Setting created. <br/>';

    IF NEW.security_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Security Setting Name: ", NEW.security_setting_name);
    END IF;

    IF NEW.security_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Security Setting Description: ", NEW.security_setting_description);
    END IF;

    IF NEW.value <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Value: ", NEW.value);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('security_setting', NEW.security_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `security_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `security_setting_trigger_update` AFTER UPDATE ON `security_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.security_setting_name <> OLD.security_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Security Setting Name: ", OLD.security_setting_name, " -> ", NEW.security_setting_name, "<br/>");
    END IF;

    IF NEW.security_setting_description <> OLD.security_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Security Setting Description: ", OLD.security_setting_description, " -> ", NEW.security_setting_description, "<br/>");
    END IF;

    IF NEW.value <> OLD.value THEN
        SET audit_log = CONCAT(audit_log, "Value: ", OLD.value, " -> ", NEW.value, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('security_setting', NEW.security_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `system_action`
--

DROP TABLE IF EXISTS `system_action`;
CREATE TABLE IF NOT EXISTS `system_action` (
  `system_action_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `system_action_name` varchar(100) NOT NULL,
  `system_action_description` varchar(200) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`system_action_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `system_action_index_system_action_id` (`system_action_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `system_action`
--

TRUNCATE TABLE `system_action`;
--
-- Dumping data for table `system_action`
--

INSERT INTO `system_action` (`system_action_id`, `system_action_name`, `system_action_description`, `last_log_by`) VALUES
(1, 'Activate User Account', 'Access to activate the user account.', 1),
(2, 'Deactivate User Account', 'Access to deactivate the user account.', 1),
(3, 'Lock User Account', 'Access to lock the user account.', 1),
(4, 'Unlock User Account', 'Access to unlock the user account.', 1),
(5, 'Add Role User Account', 'Access to assign roles to user account.', 1),
(6, 'Delete Role User Account', 'Access to delete roles to user account.', 1),
(7, 'Add Role Access', 'Access to add role access.', 1),
(8, 'Update Role Access', 'Access to update role access.', 1),
(9, 'Delete Role Access', 'Access to delete role access.', 1),
(10, 'Add Role System Action Access', 'Access to add the role system action access.', 1),
(11, 'Update Role System Action Access', 'Access to update the role system action access.', 1),
(12, 'Delete Role System Action Access', 'Access to delete the role system action access.', 1),
(13, 'Add File Extension Access', 'Access to assign the file extension to the upload setting.', 1),
(14, 'Delete File Extension Access', 'Access to delete the file extension to the upload setting.', 1);

--
-- Triggers `system_action`
--
DROP TRIGGER IF EXISTS `system_action_trigger_insert`;
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
DROP TRIGGER IF EXISTS `system_action_trigger_update`;
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
-- Table structure for table `system_setting`
--

DROP TABLE IF EXISTS `system_setting`;
CREATE TABLE IF NOT EXISTS `system_setting` (
  `system_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `system_setting_name` varchar(100) NOT NULL,
  `system_setting_description` varchar(200) NOT NULL,
  `value` varchar(1000) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`system_setting_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `system_setting_index_system_setting_id` (`system_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `system_setting`
--

TRUNCATE TABLE `system_setting`;
--
-- Dumping data for table `system_setting`
--

INSERT INTO `system_setting` (`system_setting_id`, `system_setting_name`, `system_setting_description`, `value`, `last_log_by`) VALUES
(1, 'File As Arrangement', 'This sets the arrangement of the file as.', '{last_name}, {first_name} {suffix} {middle_name}', 1);

--
-- Triggers `system_setting`
--
DROP TRIGGER IF EXISTS `system_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `system_setting_trigger_insert` AFTER INSERT ON `system_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'System Setting created. <br/>';

    IF NEW.system_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Setting Name: ", NEW.system_setting_name);
    END IF;

    IF NEW.system_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Setting Description: ", NEW.system_setting_description);
    END IF;

    IF NEW.value <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Value: ", NEW.value);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('system_setting', NEW.system_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `system_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `system_setting_trigger_update` AFTER UPDATE ON `system_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.system_setting_name <> OLD.system_setting_name THEN
        SET audit_log = CONCAT(audit_log, "System Setting Name: ", OLD.system_setting_name, " -> ", NEW.system_setting_name, "<br/>");
    END IF;

    IF NEW.system_setting_description <> OLD.system_setting_description THEN
        SET audit_log = CONCAT(audit_log, "System Setting Description: ", OLD.system_setting_description, " -> ", NEW.system_setting_description, "<br/>");
    END IF;

    IF NEW.value <> OLD.value THEN
        SET audit_log = CONCAT(audit_log, "Value: ", OLD.value, " -> ", NEW.value, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('system_setting', NEW.system_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `upload_setting`
--

DROP TABLE IF EXISTS `upload_setting`;
CREATE TABLE IF NOT EXISTS `upload_setting` (
  `upload_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `upload_setting_name` varchar(100) NOT NULL,
  `upload_setting_description` varchar(200) NOT NULL,
  `max_file_size` double NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`upload_setting_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `upload_setting_index_upload_setting_id` (`upload_setting_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `upload_setting`
--

TRUNCATE TABLE `upload_setting`;
--
-- Dumping data for table `upload_setting`
--

INSERT INTO `upload_setting` (`upload_setting_id`, `upload_setting_name`, `upload_setting_description`, `max_file_size`, `last_log_by`) VALUES
(1, 'User Account Profile Picture', 'Sets the upload setting when uploading user account profile picture.', 800, 1),
(2, 'Internal Notes Attachment', 'Sets the upload setting when uploading internal notes attachment.', 1000, 2);

--
-- Triggers `upload_setting`
--
DROP TRIGGER IF EXISTS `upload_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `upload_setting_trigger_insert` AFTER INSERT ON `upload_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Upload Setting created. <br/>';

    IF NEW.upload_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Upload Setting Name: ", NEW.upload_setting_name);
    END IF;

    IF NEW.upload_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Upload Setting Description: ", NEW.upload_setting_description);
    END IF;

    IF NEW.max_file_size <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Max File Size: ", NEW.max_file_size);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('upload_setting', NEW.upload_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `upload_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `upload_setting_trigger_update` AFTER UPDATE ON `upload_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.upload_setting_name <> OLD.upload_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Upload Setting Name: ", OLD.upload_setting_name, " -> ", NEW.upload_setting_name, "<br/>");
    END IF;

    IF NEW.upload_setting_description <> OLD.upload_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Upload Setting Description: ", OLD.upload_setting_description, " -> ", NEW.upload_setting_description, "<br/>");
    END IF;

    IF NEW.max_file_size <> OLD.max_file_size THEN
        SET audit_log = CONCAT(audit_log, "Max File Size: ", OLD.max_file_size, " -> ", NEW.max_file_size, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('upload_setting', NEW.upload_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `upload_setting_file_extension`
--

DROP TABLE IF EXISTS `upload_setting_file_extension`;
CREATE TABLE IF NOT EXISTS `upload_setting_file_extension` (
  `upload_setting_file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `upload_setting_id` int(10) UNSIGNED NOT NULL,
  `upload_setting_name` varchar(100) NOT NULL,
  `file_extension_id` int(10) UNSIGNED NOT NULL,
  `file_extension_name` varchar(100) NOT NULL,
  `file_extension` varchar(10) NOT NULL,
  `date_assigned` datetime DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`upload_setting_file_extension_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `upload_setting_file_ext_index_upload_setting_file_extension_id` (`upload_setting_file_extension_id`),
  KEY `upload_setting_file_ext_index_upload_setting_id` (`upload_setting_id`),
  KEY `upload_setting_file_ext_index_file_extension_id` (`file_extension_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `upload_setting_file_extension`
--

TRUNCATE TABLE `upload_setting_file_extension`;
--
-- Dumping data for table `upload_setting_file_extension`
--

INSERT INTO `upload_setting_file_extension` (`upload_setting_file_extension_id`, `upload_setting_id`, `upload_setting_name`, `file_extension_id`, `file_extension_name`, `file_extension`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'User Account Profile Picture', 1, 'PNG', 'png', '2024-05-13 10:40:31', 1),
(2, 1, 'User Account Profile Picture', 2, 'JPG', 'jpg', '2024-05-13 10:40:31', 1),
(3, 1, 'User Account Profile Picture', 3, 'JPEG', 'jpeg', '2024-05-13 10:40:31', 1),
(4, 2, 'Internal Notes Attachment', 3, 'JPEG', 'jpeg', '2024-05-28 11:30:52', 2),
(5, 2, 'Internal Notes Attachment', 2, 'JPG', 'jpg', '2024-05-28 11:30:52', 2),
(6, 2, 'Internal Notes Attachment', 4, 'PDF', 'pdf', '2024-05-28 11:30:52', 2),
(7, 2, 'Internal Notes Attachment', 1, 'PNG', 'png', '2024-05-28 11:30:52', 2);

--
-- Triggers `upload_setting_file_extension`
--
DROP TRIGGER IF EXISTS `upload_setting_file_extension_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `upload_setting_file_extension_trigger_insert` AFTER INSERT ON `upload_setting_file_extension` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Upload Setting File Extension created. <br/>';

    IF NEW.upload_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Upload Setting Name: ", NEW.upload_setting_name);
    END IF;

    IF NEW.file_extension_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension Name: ", NEW.file_extension_name);
    END IF;

    IF NEW.file_extension <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension: ", NEW.file_extension);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('upload_setting_file_extension', NEW.upload_setting_file_extension_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

DROP TABLE IF EXISTS `user_account`;
CREATE TABLE IF NOT EXISTS `user_account` (
  `user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
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
  `last_log_by` int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`user_account_id`),
  KEY `last_log_by` (`last_log_by`),
  KEY `user_account_index_user_account_id` (`user_account_id`),
  KEY `user_account_index_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Truncate table before insert `user_account`
--

TRUNCATE TABLE `user_account`;
--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_account_id`, `file_as`, `email`, `password`, `profile_picture`, `locked`, `active`, `last_failed_login_attempt`, `failed_login_attempts`, `last_connection_date`, `password_expiry_date`, `reset_token`, `reset_token_expiry_date`, `receive_notification`, `two_factor_auth`, `otp`, `otp_expiry_date`, `failed_otp_attempts`, `last_password_change`, `account_lock_duration`, `last_password_reset`, `multiple_session`, `session_token`, `last_log_by`) VALUES
(1, 'CGMI Bot', 'cgmids@christianmotors.ph', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', NULL, 1),
(2, 'Administrator', 'lawrenceagulto.317@gmail.com', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', './components/user-account/image/profile_image/2/WLL9.jpg', 'No', 'Yes', NULL, 0, '2024-05-29 09:37:41', '2025-12-30', 'otiRVqTPjtq8CBQxhELQVUrJPm0myQ2x3f5uWpGlbj4%3D', '2024-05-27 17:06:18', 'Yes', 'No', 'vMZI%2BbbYvh9V5m%2BU%2FdQQJlY9Q2YvRK6itGrkl7dfB74%3D', '2024-05-27 16:50:54', 0, NULL, 0, NULL, 'Yes', 'ZnquUkoyvZbRkYptBpHOgATe1QjBcnG1sF5dufY%2Ba98%3D', 2);

--
-- Triggers `user_account`
--
DROP TRIGGER IF EXISTS `user_account_trigger_insert`;
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
DROP TRIGGER IF EXISTS `user_account_trigger_update`;
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
-- Constraints for table `file_extension`
--
ALTER TABLE `file_extension`
  ADD CONSTRAINT `file_extension_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `file_type`
--
ALTER TABLE `file_type`
  ADD CONSTRAINT `file_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `internal_notes`
--
ALTER TABLE `internal_notes`
  ADD CONSTRAINT `internal_notes_ibfk_1` FOREIGN KEY (`internal_note_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `internal_notes_attachment`
--
ALTER TABLE `internal_notes_attachment`
  ADD CONSTRAINT `internal_notes_attachment_ibfk_1` FOREIGN KEY (`internal_notes_id`) REFERENCES `internal_notes` (`internal_notes_id`);

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
-- Constraints for table `notification_setting_email_template`
--
ALTER TABLE `notification_setting_email_template`
  ADD CONSTRAINT `notification_setting_email_template_ibfk_1` FOREIGN KEY (`notification_setting_id`) REFERENCES `notification_setting` (`notification_setting_id`),
  ADD CONSTRAINT `notification_setting_email_template_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `notification_setting_sms_template`
--
ALTER TABLE `notification_setting_sms_template`
  ADD CONSTRAINT `notification_setting_sms_template_ibfk_1` FOREIGN KEY (`notification_setting_id`) REFERENCES `notification_setting` (`notification_setting_id`),
  ADD CONSTRAINT `notification_setting_sms_template_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `notification_setting_system_template`
--
ALTER TABLE `notification_setting_system_template`
  ADD CONSTRAINT `notification_setting_system_template_ibfk_1` FOREIGN KEY (`notification_setting_id`) REFERENCES `notification_setting` (`notification_setting_id`),
  ADD CONSTRAINT `notification_setting_system_template_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `system_setting`
--
ALTER TABLE `system_setting`
  ADD CONSTRAINT `system_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `upload_setting`
--
ALTER TABLE `upload_setting`
  ADD CONSTRAINT `upload_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `upload_setting_file_extension`
--
ALTER TABLE `upload_setting_file_extension`
  ADD CONSTRAINT `upload_setting_file_extension_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `user_account`
--
ALTER TABLE `user_account`
  ADD CONSTRAINT `user_account_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
