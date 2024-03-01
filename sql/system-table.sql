/* Users Table */

CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    file_as VARCHAR(300) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(500) NULL,
    locked VARCHAR(5) NOT NULL DEFAULT 'No',
    active VARCHAR(5) NOT NULL DEFAULT 'No',
    last_failed_login_attempt DATETIME,
    failed_login_attempts INT NOT NULL DEFAULT 0,
    last_connection_date DATETIME,
    password_expiry_date DATE NOT NULL,
    reset_token VARCHAR(255),
    reset_token_expiry_date DATETIME,
    receive_notification VARCHAR(5) NOT NULL DEFAULT 'Yes',
    two_factor_auth VARCHAR(5) NOT NULL DEFAULT 'Yes',
    otp VARCHAR(255),
    otp_expiry_date DATETIME,
    failed_otp_attempts INT NOT NULL DEFAULT 0,
    last_password_change DATETIME,
    account_lock_duration INT NOT NULL DEFAULT 0,
    last_password_reset DATETIME,
    remember_me VARCHAR(5) NOT NULL DEFAULT 'Yes',
    remember_token VARCHAR(255),
    multiple_session VARCHAR(5) DEFAULT 'Yes',
    session_token VARCHAR(255),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX users_index_user_id ON users(user_id);
CREATE INDEX users_index_email ON users(email);

INSERT INTO users (file_as, email, password, locked, active, password_expiry_date, two_factor_auth, last_log_by) VALUES ('CGMI Bot', 'cgmids@christianmotors.ph', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', 'No', 'Yes', '2025-12-30', '0', '1');
INSERT INTO users (file_as, email, password, locked, active, password_expiry_date, two_factor_auth, last_log_by) VALUES ('Administrator', 'lawrenceagulto.317@gmail.com', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', 'No', 'Yes', '2025-12-30', 'Yes', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Password History Table */

CREATE TABLE password_history (
    password_history_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    user_id INT UNSIGNED NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    password_change_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE INDEX password_history_index_password_history_id ON password_history(password_history_id);
CREATE INDEX password_history_index_user_id ON password_history(user_id);
CREATE INDEX password_history_index_email ON password_history(email);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Audit Log Table */

CREATE TABLE audit_log (
    audit_log_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    table_name VARCHAR(255) NOT NULL,
    reference_id INT NOT NULL,
    log TEXT NOT NULL,
    changed_by INT UNSIGNED NOT NULL,
    changed_at DATETIME NOT NULL,
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

CREATE INDEX audit_log_index_audit_log_id ON audit_log(audit_log_id);
CREATE INDEX audit_log_index_table_name ON audit_log(table_name);
CREATE INDEX audit_log_index_reference_id ON audit_log(reference_id);
CREATE INDEX audit_log_index_changed_by ON audit_log(changed_by);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Security Setting Table */

CREATE TABLE security_setting(
	security_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	security_setting_name VARCHAR(100) NOT NULL,
	security_setting_description VARCHAR(200) NOT NULL,
	value VARCHAR(1000) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX security_setting_index_security_setting_id ON security_setting(security_setting_id);

INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Max Failed Login Attempt', 'This sets the maximum failed login attempt before the user is locked-out.', 5, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Max Failed OTP Attempt', 'This sets the maximum failed OTP attempt before the user is needs a new OTP code.', 5, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Default Forgot Password Link', 'This sets the default forgot password link.', 'http://localhost/modernize/password-reset.php?id=', '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Password Expiry Duration', 'The duration after which user passwords expire (in days).', 180, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Session Timeout Duration', 'The duration after which a user is automatically logged out (in minutes).', 240, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('OTP Duration', 'The time window during which a one-time password (OTP) is valid for user authentication (in minutes).', 5, '1');
INSERT INTO security_setting (security_setting_name, security_setting_description, value, last_log_by) VALUES ('Reset Password Token Duration', 'The time window during which a reset password token remains valid for user account recovery (in minutes).', 10, '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Security Setting Table */

CREATE TABLE system_setting(
	system_setting_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
	system_setting_name VARCHAR(100) NOT NULL,
	system_setting_description VARCHAR(200) NOT NULL,
	value VARCHAR(1000) NOT NULL,
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX system_setting_index_system_setting_id ON system_setting(system_setting_id);

INSERT INTO system_setting (system_setting_name, system_setting_description, value, last_log_by) VALUES ('File As Arrangement', 'This sets the arrangement of the file as.', '{last_name}, {first_name} {suffix} {middle_name}', '1');

/* ----------------------------------------------------------------------------------------------------------------------------- */