/* System Action Table */

CREATE TABLE system_action(
	system_action_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	system_action_name VARCHAR(100) NOT NULL,
	system_action_description VARCHAR(200) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX system_action_index_system_action_id ON system_action(system_action_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */