/* Menu Item Table */

CREATE TABLE menu_item (
    menu_item_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    menu_item_name VARCHAR(100) NOT NULL,
    menu_item_url VARCHAR(50),
    menu_group_id INT NOT NULL,
    menu_group_name VARCHAR(100) NOT NULL,
	parent_id INT UNSIGNED,
    parent_name VARCHAR(100),
	menu_item_icon VARCHAR(50),
    order_sequence TINYINT(10) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX menu_item_index_menu_item_id ON menu_item(menu_item_id);
CREATE INDEX menu_item_index_menu_group_id ON menu_item(menu_group_id);

INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('User Interface', '', 1, 'Technical', 0, '', 'ti ti-template', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Menu Group', 'menu-group.php', 1, 'Technical', 1, 'User Interface', '', 13, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Menu Item', 'menu-item.php', 1, 'Technical', 1, 'User Interface', '', 13, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('System Action', 'system-action.php', 1, 'Technical', 1, 'User Interface', '', 19, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Users & Companies', '', 2, 'Administration', 0, '', 'ti ti-users', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('User Account', 'user-account.php', 2, 'Administration', 5, 'Users & Companies', '', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Role', 'role.php', 2, 'Administration', 5, 'Users & Companies', '', 18, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Company', 'company.php', 2, 'Administration', 5, 'Users & Companies', '', 3, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Settings', '', 2, 'Administration', 0, '', 'ti ti-settings-2', 19, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Upload Setting', 'upload-setting.php', 2, 'Administration', 9, 'Settings', '', 21, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Security Setting', 'security-setting.php', 2, 'Administration', 9, 'Settings', '', 19, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Email Setting', 'email-setting.php', 2, 'Administration', 9, 'Settings', '', 5, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Notification Setting', 'notification-setting.php', 2, 'Administration', 9, 'Settings', '', 14, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('System Setting', 'system-setting.php', 2, 'Administration', 9, 'Settings', '', 19, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('Configurations', '', 1, 'Technical', 0, '', 'ti ti-settings', 3, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('File Type', 'file-type.php', 1, 'Technical', 15, 'Configurations', '', 6, 1);
INSERT INTO menu_item (menu_item_name, menu_item_url, menu_group_id, menu_group_name, parent_id, parent_name, menu_item_icon, order_sequence, last_log_by) VALUES ('File Extension', 'file-extension.php', 1, 'Technical', 15, 'Configurations', '', 6, 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */