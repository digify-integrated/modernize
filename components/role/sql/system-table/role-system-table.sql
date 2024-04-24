/* Role Table */

CREATE TABLE role(
	role_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	role_description VARCHAR(200) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_index_role_id ON role(role_id);

INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', '1');
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Manager', 'Access to manage specific aspects of the system or resources related to their teams or departments.', '1');
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Employee', 'The typical user account with standard access to use the system features and functionalities.', '1');
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Human Resources', 'Access to manage HR-related functionalities and employee data.', '1');
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Sales Proposal Approver', 'Access to approve or reject requests and transactions.', '1');
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Accounting', 'Access to financial and accounting-related functionalities.', '1');
INSERT INTO role (role_name, role_description, last_log_by) VALUES ('Sales', 'Access to sales-related functionalities and customer management.', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Role Permission Table */

CREATE TABLE role_permission(
	role_permission_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	menu_item_id INT UNSIGNED NOT NULL,
	menu_item_name VARCHAR(100) NOT NULL,
	read_access TINYINT(1) NOT NULL DEFAULT 0,
    write_access TINYINT(1) NOT NULL DEFAULT 0,
    create_access TINYINT(1) NOT NULL DEFAULT 0,
    delete_access TINYINT(1) NOT NULL DEFAULT 0,
    date_assigned DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (menu_item_id) REFERENCES menu_item(menu_item_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_permission_index_role_permission_id ON role_permission(role_permission_id);
CREATE INDEX role_permission_index_menu_item_id ON role_permission(menu_item_id);
CREATE INDEX role_permission_index_role_id ON role_permission(role_id);

INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 1, 'User Interface', 1, 0, 0, 0, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 2, 'Menu Group', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 3, 'Menu Item', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 4, 'System Action', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 5, 'Users & Companies', 1, 0, 0, 0, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 6, 'User Account', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 7, 'Role', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 8, 'Company', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 9, 'Settings', 1, 0, 0, 0, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 10, 'Upload Setting', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 11, 'Security Setting', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 12, 'Email Setting', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 13, 'Notification Setting', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 14, 'System Setting', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 15, 'Configurations', 1, 0, 0, 0, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 16, 'File Type', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, read_access, write_access, create_access, delete_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 17, 'File Extension', 1, 1, 1, 1, CURRENT_TIMESTAMP, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Role System Action Permission Table */

CREATE TABLE role_system_action_permission(
	role_system_action_permission_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	system_action_id INT UNSIGNED NOT NULL,
	system_action_name VARCHAR(100) NOT NULL,
	system_action_access TINYINT(1) NOT NULL DEFAULT 0,
    date_assigned DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (system_action_id) REFERENCES system_action(system_action_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_system_action_permission_index_system_action_permission_id ON role_system_action_permission(role_system_action_permission_id);
CREATE INDEX role_system_action_permission_index_system_action_id ON role_system_action_permission(system_action_id);
CREATE INDEX role_system_action_permissionn_index_role_id ON role_system_action_permission(role_id);

INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 1, 'Activate User Account', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 2, 'Deactivate User Account', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 3, 'Lock User Account', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 4, 'Unlock User Account', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 5, 'Add Role User Account', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 6, 'Delete Role User Account', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 7, 'Add Role Access', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 8, 'Update Role Access', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 9, 'Delete Role Access', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 10, 'Add Role System Action Access', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 11, 'Update Role System Action Access', 1, CURRENT_TIMESTAMP, '1');
INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, system_action_access, date_assigned, last_log_by) VALUES (1, 'Administrator', 12, 'Delete Role System Action Access', 1, CURRENT_TIMESTAMP, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Role User Account Table */

CREATE TABLE role_user_account(
	role_user_account_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_id INT UNSIGNED NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	user_account_id INT UNSIGNED NOT NULL,
	file_as VARCHAR(300) NOT NULL,
    date_assigned DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (user_account_id) REFERENCES user_account(user_account_id),
    FOREIGN KEY (role_id) REFERENCES role(role_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX role_user_account_index_role_user_account_id ON role_user_account(role_user_account_id);
CREATE INDEX role_user_account_permission_index_user_account_id ON role_user_account(user_account_id);
CREATE INDEX role_user_account_permissionn_index_role_id ON role_user_account(role_id);

INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, date_assigned, last_log_by) VALUES (1, 'Administrator', 2, 'Administrator', CURRENT_TIMESTAMP, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */