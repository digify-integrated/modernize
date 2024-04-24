/* File Type Table */

CREATE TABLE file_type(
	file_type_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	file_type_name VARCHAR(100) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX file_type_index_file_type_id ON file_type(file_type_id);

INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Audio', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Compressed', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Disk and Media', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Data and Database', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Email', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Executable', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Font', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Image', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Internet Related', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Presentation', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Spreadsheet', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('System Related', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Video', '1');
INSERT INTO file_type (file_type_name, last_log_by) VALUES ('Word Processor', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */