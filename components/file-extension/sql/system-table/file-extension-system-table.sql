/* Menu Item Table */

CREATE TABLE file_extension (
    file_extension_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    file_extension_name VARCHAR(100) NOT NULL,
    file_type_id INT NOT NULL,
    file_type_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX file_extension_index_file_extension_id ON file_extension(file_extension_id);
CREATE INDEX file_extension_index_file_type_id ON file_extension(file_type_id);

INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('User Interface', '', 1, 'Technical', 0, '', 'ti ti-template', 21, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Menu Group', 'menu-group.php', 1, 'Technical', 1, 'User Interface', '', 13, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Menu Item', 'menu-item.php', 1, 'Technical', 1, 'User Interface', '', 13, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('System Action', 'system-action.php', 1, 'Technical', 1, 'User Interface', '', 19, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Users & Companies', '', 2, 'Administration', 0, '', 'ti ti-users', 21, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('User Account', 'user-account.php', 2, 'Administration', 5, 'Users & Companies', '', 21, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Role', 'role.php', 2, 'Administration', 5, 'Users & Companies', '', 18, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Company', 'company.php', 2, 'Administration', 5, 'Users & Companies', '', 3, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Settings', '', 2, 'Administration', 0, '', 'ti ti-settings-2', 19, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Upload Setting', 'upload-setting.php', 2, 'Administration', 9, 'Settings', '', 21, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Security Setting', 'security-setting.php', 2, 'Administration', 9, 'Settings', '', 19, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Email Setting', 'email-setting.php', 2, 'Administration', 9, 'Settings', '', 5, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Notification Setting', 'notification-setting.php', 2, 'Administration', 9, 'Settings', '', 14, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('System Setting', 'system-setting.php', 2, 'Administration', 9, 'Settings', '', 19, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('Configurations', '', 1, 'Technical', 0, '', 'ti ti-settings', 3, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('File Type', 'file-type.php', 1, 'Technical', 15, 'Configurations', '', 6, 1);
INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('File Extension', 'file-extension.php', 1, 'Technical', 15, 'Configurations', '', 6, 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */