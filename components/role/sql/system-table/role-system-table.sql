/* Role Table */

CREATE TABLE role(
	role_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	role_name VARCHAR(100) NOT NULL,
	role_description VARCHAR(200) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
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

/* Role Users Table */

CREATE TABLE role_users(
	role_id INT NOT NULL,
	user_id INT NOT NULL,
	date_assigned DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX role_users_index_role_id ON role_users(role_id);
CREATE INDEX role_users_index_user_id ON role_users(user_id);

INSERT INTO role_users (role_id, user_id) VALUES ('1', '2');

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
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX role_permission_index_menu_item_id ON role_permission(menu_item_id);
CREATE INDEX role_permission_index_role_id ON role_permission(role_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */