/* Menu Item Table */

CREATE TABLE file_extension (
    file_extension_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    file_extension_name VARCHAR(100) NOT NULL,
    file_extension VARCHAR(10) NOT NULL,
    file_type_id INT NOT NULL,
    file_type_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX file_extension_index_file_extension_id ON file_extension(file_extension_id);
CREATE INDEX file_extension_index_file_type_id ON file_extension(file_type_id);

INSERT INTO file_extension (file_extension_name, file_extension_url, file_type_id, file_type_name, parent_id, parent_name, file_extension_icon, order_sequence, last_log_by) VALUES ('User Interface', '', 1, 'Technical', 0, '', 'ti ti-template', 21, 1);

/* ----------------------------------------------------------------------------------------------------------------------------- */