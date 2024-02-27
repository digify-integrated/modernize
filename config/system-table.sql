/* Users Table */

CREATE TABLE users (
    user_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    file_as VARCHAR(300) NOT NULL,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_picture VARCHAR(500) NULL,
    locked TINYINT(1) NOT NULL DEFAULT 0,
    active TINYINT(1) NOT NULL DEFAULT 0,
    last_failed_login_attempt DATETIME,
    failed_login_attempts INT NOT NULL DEFAULT 0,
    last_connection_date DATETIME,
    password_expiry_date DATE NOT NULL,
    reset_token VARCHAR(255),
    reset_token_expiry_date DATETIME,
    receive_notification TINYINT(1) NOT NULL DEFAULT 1,
    two_factor_auth TINYINT(1) NOT NULL DEFAULT 1,
    otp VARCHAR(255),
    otp_expiry_date DATETIME,
    failed_otp_attempts INT NOT NULL DEFAULT 0,
    last_password_change DATETIME,
    account_lock_duration INT NOT NULL DEFAULT 0,
    last_password_reset DATETIME,
    remember_me TINYINT(1) NOT NULL DEFAULT 0,
    remember_token VARCHAR(255),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES users(user_id)
);

CREATE INDEX users_index_user_id ON users(user_id);
CREATE INDEX users_index_email ON users(email);

INSERT INTO users (file_as, username, email, password, locked, active, password_expiry_date, two_factor_auth, last_log_by) VALUES ('CGMI Bot', 'CGMIBOT', 'cgmids@christianmotors.ph', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', '0', '1', '2025-12-30', '0', '1');
INSERT INTO users (file_as, username, email, password, locked, active, password_expiry_date, two_factor_auth, last_log_by) VALUES ('Administrator', 'LDAGULTO', 'lawrenceagulto.317@gmail.com', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', '0', '1', '2025-12-30', '0', '1');