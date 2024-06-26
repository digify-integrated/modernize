/* Upload Setting Table */

CREATE TABLE upload_setting(
	upload_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	upload_setting_name VARCHAR(100) NOT NULL,
	upload_setting_description VARCHAR(200) NOT NULL,
	max_file_size DOUBLE NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX upload_setting_index_upload_setting_id ON upload_setting(upload_setting_id);

INSERT INTO upload_setting (upload_setting_name, upload_setting_description, max_file_size, last_log_by) VALUES ('User Account Profile Picture', 'Sets the upload setting when uploading user account profile picture.', 800, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Upload Setting File Extension Table */

CREATE TABLE upload_setting_file_extension(
    upload_setting_file_extension_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	upload_setting_id INT UNSIGNED NOT NULL,
	upload_setting_name VARCHAR(100) NOT NULL,
	file_extension_id INT UNSIGNED NOT NULL,
	file_extension_name VARCHAR(100) NOT NULL,
	file_extension VARCHAR(10) NOT NULL,
	date_assigned DATETIME DEFAULT CURRENT_TIMESTAMP,
    last_log_by INT UNSIGNED NOT NULL,
	FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX upload_setting_file_ext_index_upload_setting_file_extension_id ON upload_setting_file_extension(upload_setting_file_extension_id);
CREATE INDEX upload_setting_file_ext_index_upload_setting_id ON upload_setting_file_extension(upload_setting_id);
CREATE INDEX upload_setting_file_ext_index_file_extension_id ON upload_setting_file_extension(file_extension_id);

INSERT INTO upload_setting_file_extension (upload_setting_id, upload_setting_name, file_extension_id, file_extension_name, file_extension, last_log_by) VALUES (1, 'User Account Profile Picture', 1, 'PNG', 'png', '1');
INSERT INTO upload_setting_file_extension (upload_setting_id, upload_setting_name, file_extension_id, file_extension_name, file_extension, last_log_by) VALUES (1, 'User Account Profile Picture', 2, 'JPG', 'jpg', '1');
INSERT INTO upload_setting_file_extension (upload_setting_id, upload_setting_name, file_extension_id, file_extension_name, file_extension, last_log_by) VALUES (1, 'User Account Profile Picture', 3, 'JPEG', 'jpeg', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */